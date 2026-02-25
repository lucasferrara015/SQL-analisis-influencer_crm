-- ---------------------------------------------------
-- 10. Consulta: Lealtad del influencer - Repetibilidad y mejora en el tiempo
-- Objetivo: evaluar si los influencers mejoran, mantienen o declinan su engagement en colaboraciones sucesivas
-- Lógica: se calcula el engagement promedio por colaboración, se ordenan cronológicamente y se compara el inicial con los posteriores
-- Nota técnica: uso de NULLIF para evitar división por cero; ROW_NUMBER() para ordenar colaboraciones por fecha; CASE para clasificar la tendencia
-- Limitación: depende de la cantidad de colaboraciones registradas; influencers con pocas colaboraciones pueden tener resultados poco representativos
-- ---------------------------------------------------

-- CTE para calcular engagement promedio por colaboración
WITH engagement_por_colaboracion AS (
    SELECT 
        c.influencer_id,
        c.campania_id,
        MIN(p.fecha_publicacion) AS fecha_inicio_colab, -- fecha inicial de la colaboración
        SUM(mp.likes + mp.comentarios + mp.compartidos) / NULLIF(COUNT(p.publicacion_id),0) AS engagement_promedio -- promedio de interacciones por publicación
    FROM colaboraciones c
    JOIN publicaciones p 
        ON c.colab_id = p.colab_id
    JOIN metricas_publicacion mp 
        ON p.publicacion_id = mp.publicacion_id
    GROUP BY c.influencer_id, c.campania_id
),

-- CTE para ordenar colaboraciones cronológicamente
ordenadas AS (
    SELECT 
        influencer_id,
        campania_id,
        engagement_promedio,
        ROW_NUMBER() OVER (PARTITION BY influencer_id ORDER BY fecha_inicio_colab ASC) AS orden_colab -- orden de la colaboración
    FROM engagement_por_colaboracion
)

-- Consulta final: comparación entre engagement inicial y posterior
SELECT 
    i.influencer_id,
    i.nombre,
    MAX(CASE WHEN o.orden_colab = 1 THEN o.engagement_promedio END) AS engagement_inicial, -- primer colaboración
    AVG(CASE WHEN o.orden_colab > 1 THEN o.engagement_promedio END) AS engagement_posterior, -- promedio de colaboraciones posteriores
    CASE
        WHEN AVG(CASE WHEN o.orden_colab > 1 THEN o.engagement_promedio END) > MAX(CASE WHEN o.orden_colab = 1 THEN o.engagement_promedio END)
        THEN 'Mejora en el tiempo'
        WHEN AVG(CASE WHEN o.orden_colab > 1 THEN o.engagement_promedio END) = MAX(CASE WHEN o.orden_colab = 1 THEN o.engagement_promedio END)
        THEN 'Se mantiene'
        ELSE 'Declina'
    END AS tendencia -- clasificación de la evolución
FROM ordenadas o
JOIN influencers i 
    ON o.influencer_id = i.influencer_id
WHERE i.estado = 'activo'
GROUP BY i.influencer_id, i.nombre
ORDER BY tendencia DESC;
