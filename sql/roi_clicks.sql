-- Consulta: ROI en Clicks con Ranking Global
-- Objetivo: medir el retorno de inversión en términos de clics generados por cada influencer activo
-- Lógica: se suman los clics y se dividen por la inversión total; se aplica RANK() para asignar posición global
-- Nota técnica: se usa NULLIF para evitar división por cero y ROUND para limitar decimales; la ventana RANK() ordena influencers según ROI
-- Limitación: no contempla calidad de los clics ni conversiones posteriores; depende de la precisión de pago_estimado y métricas de clics

-- ROI en Clicks con Ranking Global
WITH roi_clicks AS (
    SELECT 
        i.influencer_id,
        i.nombre,
        SUM(mp.clicks) AS total_clicks,
        ROUND(SUM(c.pago_estimado), 2) AS inversion_total,
        ROUND(SUM(mp.clicks) / NULLIF(SUM(c.pago_estimado), 0), 2) AS roi_clicks
    FROM influencers i
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    JOIN publicaciones p ON c.colab_id = p.colab_id
    JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    WHERE i.estado = 'activo'
    GROUP BY i.influencer_id, i.nombre
)
SELECT 
    nombre,
    roi_clicks,
    total_clicks,
    inversion_total,
    RANK() OVER (ORDER BY roi_clicks DESC) AS ranking_global
FROM roi_clicks
ORDER BY roi_clicks DESC;
