-- Consulta: Evolución mensual con LAG
-- Objetivo: analizar el crecimiento mensual del engagement por influencer
-- Lógica: se agrupan interacciones por mes y se compara con el mes anterior usando LAG(); se calcula el % de crecimiento
-- Nota técnica: DATE_FORMAT normaliza las fechas al primer día del mes; LAG() permite traer el valor previo sin subconsultas; NULLIF evita división por cero y ROUND limita decimales
-- Limitación: no contempla factores externos (tipo de contenido, estacionalidad, cambios de algoritmo); depende de la calidad y consistencia de los registros de métricas

-- REFACTORIZADA 6: Evolución mensual con LAG (crecimiento)
WITH evolucion_mensual AS (
    SELECT 
        i.influencer_id,
        i.nombre,
        DATE_FORMAT(p.fecha_publicacion, '%Y-%m-01') AS mes,
        SUM(mp.likes + mp.comentarios + mp.compartidos) AS engagement_mes
    FROM influencers i
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    JOIN publicaciones p ON c.colab_id = p.colab_id
    JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    WHERE i.estado = 'activo'
    GROUP BY i.influencer_id, i.nombre, DATE_FORMAT(p.fecha_publicacion, '%Y-%m-01')
)
SELECT 
    nombre,
    mes,
    engagement_mes,
    -- Trae el valor del mes anterior para esta misma fila
    LAG(engagement_mes, 1) OVER (PARTITION BY influencer_id ORDER BY mes) AS mes_anterior,
    -- Calcula el % de crecimiento
    ROUND(
        (engagement_mes - LAG(engagement_mes, 1) OVER (PARTITION BY influencer_id ORDER BY mes)) 
        / NULLIF(LAG(engagement_mes, 1) OVER (PARTITION BY influencer_id ORDER BY mes), 0) * 100, 2
    ) AS crecimiento_porcentual
FROM evolucion_mensual
ORDER BY nombre, mes;
