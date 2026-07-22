-- Consulta: ROI en Clicks con Ranking Global
-- Objetivo: medir el retorno de inversión en términos de clics generados por cada influencer activo
-- Lógica: se suman los clics y se dividen por la inversión total; se aplica RANK() para asignar posición global según ROI
-- Nota técnica: se usa NULLIF para evitar división por cero y ROUND para limitar decimales; la ventana RANK() ordena influencers por ingresos
-- Limitación: no contempla calidad de los clics ni conversiones posteriores; depende de la precisión de pago_estimado y métricas de clics

-- REFACTORIZADA #7: Tasa de Conversión con Ranking por Ingresos
WITH conversion_detalle AS (
    SELECT 
        i.nombre AS influencer,
        cd.codigo_descuento,
        COUNT(v.venta_id) AS ventas_generadas,
        ROUND(SUM(v.monto_total), 2) AS ingresos_generados,
        SUM(mp.clicks) AS clicks_totales,
        ROUND(COUNT(v.venta_id) / NULLIF(SUM(mp.clicks), 0), 4) AS tasa_conversion
    FROM influencers i
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    JOIN codigos_descuento cd ON c.colab_id = cd.colab_id
    LEFT JOIN ventas v ON cd.codigo_descuento = v.codigo_descuento
    LEFT JOIN publicaciones p ON c.colab_id = p.colab_id
    LEFT JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    WHERE i.estado = 'activo'
    GROUP BY i.nombre, cd.codigo_descuento
)
SELECT 
    influencer,
    codigo_descuento,
    ingresos_generados,
    tasa_conversion,
    RANK() OVER (ORDER BY ingresos_generados DESC) AS ranking_ingresos
FROM conversion_detalle
ORDER BY ingresos_generados DESC;
