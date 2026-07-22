-- Consulta: Trayectoria de rendimiento (Mejora / Declina)
-- Objetivo: analizar la evolución del engagement por colaboraciones finalizadas de cada influencer
-- Lógica: se calcula el engagement promedio por colaboración y se compara con la colaboración anterior usando LAG()
-- Nota técnica: se emplea ROW_NUMBER() para ordenar colaboraciones cronológicamente y LAG() para detectar variaciones; ROUND y NULLIF evitan decimales excesivos y división por cero
-- Limitación: no contempla factores externos (tipo de campaña, estacionalidad, cambios de algoritmo) que pueden influir en la tendencia; el análisis depende de la calidad de los datos de métricas

-- Trayectoria de rendimiento (Mejora / Declina)
WITH colaboraciones_ordenadas AS (
    SELECT 
        i.influencer_id,
        i.nombre,
        c.campania_id,
        c.fecha_fin,
        -- Calculo el engagement de CADA colaboración
        ROUND(AVG(mp.likes + mp.comentarios + mp.compartidos), 2) AS engagement_colab,
        -- Asigno número de orden a las colaboraciones de cada influencer
        ROW_NUMBER() OVER (PARTITION BY i.influencer_id ORDER BY c.fecha_fin ASC) AS num_colaboracion
    FROM influencers i
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    JOIN publicaciones p ON c.colab_id = p.colab_id
    JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    WHERE c.estado = 'finalizada'
    GROUP BY i.influencer_id, i.nombre, c.campania_id, c.fecha_fin
)
SELECT 
    nombre,
    num_colaboracion,
    engagement_colab,
    LAG(engagement_colab, 1) OVER (PARTITION BY influencer_id ORDER BY num_colaboracion) AS engagement_anterior,
    CASE 
        WHEN engagement_colab > LAG(engagement_colab, 1) OVER (PARTITION BY influencer_id ORDER BY num_colaboracion) 
        THEN '📈 Mejora'
        WHEN engagement_colab < LAG(engagement_colab, 1) OVER (PARTITION BY influencer_id ORDER BY num_colaboracion) 
        THEN '📉 Declina'
        ELSE '➖ Estable'
    END AS tendencia
FROM colaboraciones_ordenadas
ORDER BY nombre, num_colaboracion;
