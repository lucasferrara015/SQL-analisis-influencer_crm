-- ---------------------------------------------------
-- 11. Consulta: Rendimiento por plataforma y formato
-- Objetivo: identificar qué plataformas y formatos generan mayor engagement promedio
-- Lógica: se cuentan las publicaciones y se suman las interacciones (likes, comentarios, compartidos) para calcular el engagement promedio
-- Nota técnica: uso de NULLIF para evitar división por cero; CTE para organizar el cálculo previo de publicaciones y engagement
-- Limitación: no contempla variaciones por temática ni segmentación de audiencia; se centra en métricas agregadas
-- ---------------------------------------------------

-- CTE para calcular publicaciones e interacciones por plataforma y formato
WITH engagement_por_formato AS (
    SELECT 
        p.plataforma, -- plataforma de publicación (ej. Instagram, TikTok)
        p.formato, -- formato de contenido (ej. reel, post, story)
        COUNT(p.publicacion_id) AS total_publicaciones, -- número de publicaciones
        SUM(mp.likes + mp.comentarios + mp.compartidos) AS total_engagement -- total de interacciones
    FROM publicaciones p
    JOIN metricas_publicacion mp 
        ON p.publicacion_id = mp.publicacion_id
    GROUP BY p.plataforma, p.formato
)

-- Consulta final: engagement promedio por plataforma y formato
SELECT 
    plataforma,
    formato,
    total_publicaciones,
    total_engagement / NULLIF(total_publicaciones,0) AS engagement_promedio -- promedio de interacciones por publicación
FROM engagement_por_formato
ORDER BY engagement_promedio DESC; -- ordena por mayor rendimiento
