-- ---------------------------------------------------
-- 9. Consulta: Optimización de frecuencia - Publicaciones óptimas por semana
-- Objetivo: analizar la relación entre cantidad de publicaciones semanales y engagement promedio
-- Lógica: se cuentan las publicaciones por semana y se calcula el engagement promedio por publicación
-- Nota técnica: uso de NULLIF para evitar división por cero; YEARWEEK para agrupar por semana ISO
-- Limitación: no contempla variaciones por tipo de contenido ni estacionalidad; se centra en influencers activos
-- ---------------------------------------------------

-- CTE para calcular publicaciones e interacciones por semana
WITH publicaciones_por_semana AS (
    SELECT 
        c.influencer_id,
        YEARWEEK(p.fecha_publicacion, 1) AS semana, -- agrupación por semana ISO
        COUNT(p.publicacion_id) AS total_publicaciones, -- número de publicaciones en la semana
        SUM(mp.likes + mp.comentarios + mp.compartidos) AS total_engagement -- total de interacciones
    FROM publicaciones p
    JOIN metricas_publicacion mp 
        ON p.publicacion_id = mp.publicacion_id
    JOIN colaboraciones c 
        ON p.colab_id = c.colab_id
    GROUP BY c.influencer_id, YEARWEEK(p.fecha_publicacion, 1)
),

-- CTE para calcular engagement promedio por publicación
engagement_promedio AS (
    SELECT 
        influencer_id,
        semana,
        total_publicaciones,
        total_engagement / NULLIF(total_publicaciones,0) AS engagement_promedio -- promedio de interacciones por publicación
    FROM publicaciones_por_semana
)

-- Consulta final: engagement promedio por semana e influencer
SELECT 
    i.influencer_id,
    i.nombre,
    e.semana,
    e.total_publicaciones,
    e.engagement_promedio
FROM influencers i
JOIN engagement_promedio e 
    ON i.influencer_id = e.influencer_id
WHERE i.estado = 'activo'
ORDER BY i.influencer_id, e.semana;
