-- Consulta: Frecuencia Óptima (Análisis de saturación)
-- Objetivo: identificar el rango de publicaciones semanales que maximiza el engagement sin saturar a la audiencia
-- Lógica: se agrupan publicaciones por semana e influencer, se calcula el engagement promedio y se clasifican rangos de frecuencia (1-2, 3-4, 5+)
-- Nota técnica: YEARWEEK organiza cronológicamente; AVG() calcula engagement promedio; CASE asigna categorías de frecuencia
-- Limitación: no contempla calidad del contenido ni factores externos (algoritmo de plataforma, estacionalidad); el análisis depende de la precisión de métricas registradas

-- REFACTORIZADA #9: Frecuencia Óptima (Análisis de saturación)
WITH frecuencia_semanal AS (
    SELECT 
        i.influencer_id,
        i.nombre,
        YEARWEEK(p.fecha_publicacion, 1) AS semana,
        COUNT(p.publicacion_id) AS publicaciones_semana,
        ROUND(AVG(mp.likes + mp.comentarios + mp.compartidos), 2) AS engagement_promedio_semana
    FROM influencers i
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    JOIN publicaciones p ON c.colab_id = p.colab_id
    JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    WHERE i.estado = 'activo'
    GROUP BY i.influencer_id, i.nombre, YEARWEEK(p.fecha_publicacion, 1)
),
rango_frecuencia AS (
    SELECT 
        nombre,
        semana,
        publicaciones_semana,
        engagement_promedio_semana,
        CASE 
            WHEN publicaciones_semana BETWEEN 1 AND 2 THEN '1-2 (Baja)'
            WHEN publicaciones_semana BETWEEN 3 AND 4 THEN '3-4 (Media)'
            ELSE '5+ (Alta/Saturación)'
        END AS rango_frecuencia
    FROM frecuencia_semanal
)
SELECT 
    rango_frecuencia,
    ROUND(AVG(engagement_promedio_semana), 2) AS engagement_promedio_por_rango,
    COUNT(*) AS total_semanas_analizadas
FROM rango_frecuencia
GROUP BY rango_frecuencia
ORDER BY engagement_promedio_por_rango DESC;
