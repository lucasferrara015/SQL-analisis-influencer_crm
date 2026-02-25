-- ---------------------------------------------------
-- 2 Consulta: ROI en Clicks
-- Objetivo: calcular el retorno de inversión en términos de clics generados por publicaciones
-- Lógica: se suman los clics y se dividen por la inversión total (pago_estimado)
-- Nota técnica: se usa NULLIF para evitar división por cero
-- Limitación: no contempla campañas sin publicaciones asociadas
-- ---------------------------------------------------

-- Consulta directa
SELECT i.nombre,
       SUM(mp.clicks) AS clicks_totales,
       SUM(c.pago_estimado) AS inversion_total,
       SUM(mp.clicks) / SUM(c.pago_estimado) AS roi_clicks
FROM influencers i
JOIN colaboraciones c ON i.influencer_id = c.influencer_id
JOIN publicaciones p ON c.colab_id = p.colab_id
JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
GROUP BY i.nombre
ORDER BY roi_clicks DESC;

-- ---------------------------------------------------
-- Creación de vista para reutilización
-- ---------------------------------------------------
CREATE VIEW vw_roi_clicks AS
SELECT i.nombre,
       SUM(mp.clicks) AS clicks_totales,
       SUM(c.pago_estimado) AS inversion_total,
       SUM(mp.clicks) / NULLIF(SUM(c.pago_estimado),0) AS roi_clicks
FROM influencers i
JOIN colaboraciones c ON i.influencer_id = c.influencer_id
JOIN publicaciones p ON c.colab_id = p.colab_id
JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
GROUP BY i.nombre;

-- ---------------------------------------------------
-- Consulta de resultados ordenados
-- ---------------------------------------------------
SELECT * 
FROM vw_roi_clicks
ORDER BY roi_clicks DESC;
