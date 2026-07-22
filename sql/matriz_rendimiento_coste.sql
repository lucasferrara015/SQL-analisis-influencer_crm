-- Consulta: Matriz de Cuadrantes con AVG() OVER()
-- Objetivo: clasificar influencers según ROI en ventas y coste total
-- Lógica: se calculan ROI y coste por influencer; luego se comparan con los promedios globales usando funciones ventana
-- Nota técnica: se emplea AVG() OVER() para obtener umbrales sin subconsultas adicionales; ROUND y NULLIF evitan decimales excesivos y división por cero
-- Limitación: no contempla factores cualitativos (tipo de producto, duración de campaña) ni métricas externas; ROI puede distorsionarse si los pagos o ventas están incompletos

-- REFACTORIZADA 8: Matriz de Cuadrantes usando AVG() OVER()
WITH base_rendimiento AS (
    SELECT 
        i.influencer_id,
        i.nombre,
        ROUND(SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado), 0), 2) AS roi_ventas,
        SUM(c.pago_estimado) AS coste_total
    FROM influencers i
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    LEFT JOIN codigos_descuento cd ON c.colab_id = cd.colab_id
    LEFT JOIN ventas v ON cd.codigo_descuento = v.codigo_descuento
    WHERE i.estado = 'activo'
    GROUP BY i.influencer_id, i.nombre
),
matriz_con_umbrales AS (
    SELECT 
        *,
        -- Calculo los promedios globales una sola vez con ventana (sin subconsulta)
        AVG(roi_ventas) OVER () AS avg_roi_global,
        AVG(coste_total) OVER () AS avg_coste_global
    FROM base_rendimiento
)
SELECT 
    nombre,
    roi_ventas,
    coste_total,
    CASE 
        WHEN roi_ventas >= avg_roi_global AND coste_total < avg_coste_global THEN '🚀 Máxima prioridad'
        WHEN roi_ventas >= avg_roi_global AND coste_total >= avg_coste_global THEN '⚖️ Evaluar presupuesto'
        WHEN roi_ventas < avg_roi_global AND coste_total < avg_coste_global THEN '🛡️ Bajo riesgo'
        ELSE '🔴 Descartar o renegociar'
    END AS cuadrante_estrategico
FROM matriz_con_umbrales
ORDER BY roi_ventas DESC;
