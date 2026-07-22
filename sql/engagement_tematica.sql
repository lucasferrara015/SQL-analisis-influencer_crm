-- Consulta: Clasificación de Temáticas por NTILE
-- Objetivo: segmentar las temáticas según su nivel de engagement promedio
-- Lógica: se calcula el engagement promedio por temática y se aplica NTILE(3) para dividir en terciles (Alto, Medio, Bajo)
-- Nota técnica: NTILE() distribuye las filas en grupos iguales; se usa AVG() sobre interacciones y COUNT DISTINCT para publicaciones
-- Limitación: no contempla calidad de interacción ni factores externos (tipo de campaña, temporalidad); depende de la precisión de métricas registradas

-- #5: Clasificación de Temáticas por NTILE (Alto/Medio/Bajo)
WITH engagement_tematicas AS (
    SELECT 
        t.nombre_tematica,
        ROUND(AVG(mp.likes + mp.comentarios + mp.compartidos), 2) AS engagement_promedio,
        COUNT(DISTINCT p.publicacion_id) AS total_publicaciones
    FROM tematicas t
    JOIN influencer_tematica it ON t.tematica_id = it.tematica_id
    JOIN influencers i ON it.influencer_id = i.influencer_id
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    JOIN publicaciones p ON c.colab_id = p.colab_id
    JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    WHERE i.estado = 'activo'
    GROUP BY t.nombre_tematica
)
SELECT 
    nombre_tematica,
    engagement_promedio,
    total_publicaciones,
    NTILE(3) OVER (ORDER BY engagement_promedio DESC) AS nivel_engagement,
    CASE NTILE(3) OVER (ORDER BY engagement_promedio DESC)
        WHEN 1 THEN '🔴 Alto Engagement'
        WHEN 2 THEN '🟡 Medio Engagement'
        WHEN 3 THEN '🟢 Bajo Engagement'
    END AS categoria
FROM engagement_tematicas
ORDER BY engagement_promedio DESC;
