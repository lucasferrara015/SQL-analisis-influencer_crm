-- Consulta: Tasa de Conversión con Ranking por Ingresos
-- Objetivo: medir la eficiencia de cada código de descuento en términos de ventas y conversiones
-- Lógica: se cuentan las ventas y se suman los ingresos por código; se calcula la tasa de conversión (ventas/clicks) y se ordena con RANK() según ingresos
-- Nota técnica: se emplea NULLIF para evitar división por cero y ROUND para limitar decimales; RANK() asigna posiciones globales por ingresos
-- Limitación: no contempla calidad de los clics ni factores externos (tipo de campaña, estacionalidad); depende de la precisión de métricas registradas

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
