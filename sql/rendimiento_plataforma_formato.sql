-- Consulta: Top formatos por plataforma con DENSE_RANK
-- Objetivo: identificar los formatos con mayor engagement promedio dentro de cada plataforma
-- Lógica: se calcula el promedio de interacciones por formato y se asigna un ranking relativo con DENSE_RANK() PARTITION BY plataforma
-- Nota técnica: se usa AVG() sobre likes+comentarios+compartidos y COUNT DISTINCT para publicaciones; DENSE_RANK evita saltos en la numeración
-- Limitación: no contempla la calidad de interacción ni la temporalidad de las publicaciones; el engagement puede variar según campañas específicas

-- 11. Top formatos por plataforma con DENSE_RANK
WITH rendimiento_formatos AS (
    SELECT 
        p.plataforma,
        p.formato,
        ROUND(AVG(mp.likes + mp.comentarios + mp.compartidos), 2) AS engagement_promedio,
        COUNT(DISTINCT p.publicacion_id) AS total_publicaciones
    FROM publicaciones p
    JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    GROUP BY p.plataforma, p.formato
)
SELECT 
    plataforma,
    formato,
    engagement_promedio,
    total_publicaciones,
    -- Ranking dentro de cada plataforma (ej: Instagram: 1.Reel, 2.Video, 3.Imagen)
    DENSE_RANK() OVER (PARTITION BY plataforma ORDER BY engagement_promedio DESC) AS rank_en_plataforma
FROM rendimiento_formatos
ORDER BY plataforma, rank_en_plataforma;
