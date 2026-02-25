-- ---------------------------------------------------
-- 5. Consulta: Mejores temáticas por engagement real
-- Objetivo: identificar qué temáticas generan mayor interacción promedio en publicaciones
-- Lógica: se suman las interacciones (likes, comentarios, compartidos) y se dividen por el número de publicaciones
-- Nota técnica: uso de NULLIF para evitar división por cero; COUNT(DISTINCT) asegura que no se dupliquen publicaciones
-- Limitación: no contempla publicaciones sin métricas registradas ni influencers inactivos
-- ---------------------------------------------------

-- Creación de vista para reutilización
CREATE VIEW vw_engagement_tematica AS
SELECT t.nombre_tematica,
       SUM(mp.likes + mp.comentarios + mp.compartidos) AS interacciones_totales, -- total de interacciones por temática
       COUNT(DISTINCT p.publicacion_id) AS publicaciones_totales, -- cantidad de publicaciones únicas
       SUM(mp.likes + mp.comentarios + mp.compartidos) / NULLIF(COUNT(DISTINCT p.publicacion_id),0) AS engagement_promedio -- promedio de interacciones por publicación
FROM tematicas t
JOIN influencer_tematica it ON t.tematica_id = it.tematica_id
JOIN influencers i ON it.influencer_id = i.influencer_id
JOIN colaboraciones c ON i.influencer_id = c.influencer_id
JOIN publicaciones p ON c.colab_id = p.colab_id
JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
WHERE i.estado = 'activo'
GROUP BY t.nombre_tematica;

-- Consulta de resultados ordenados (temáticas con mayor engagement primero)
SELECT * 
FROM vw_engagement_tematica
ORDER BY engagement_promedio DESC;
