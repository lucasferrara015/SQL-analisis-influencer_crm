-- Consulta: Crecimiento Neto de Seguidores por Campaña
-- Objetivo: medir la evolución de seguidores durante cada campaña de un influencer
-- Lógica: se obtiene el primer y último registro de seguidores en el rango de fechas de la campaña usando FIRST_VALUE y LAST_VALUE; se calcula crecimiento neto y tasa de crecimiento porcentual
-- Nota técnica: las funciones ventana permiten capturar valores iniciales y finales sin subconsultas; NULLIF evita división por cero y ROUND limita decimales
-- Limitación: no contempla factores externos (algoritmos de plataforma, viralidad, estacionalidad); depende de la calidad y frecuencia de los registros de seguidores

-- 12 Crecimiento Audiencia
WITH crecimiento_global AS (
    SELECT 
        i.influencer_id,
        i.nombre,
        -- Primer valor de seguidores (el más antiguo)
        FIRST_VALUE(si.seguidores) OVER (
            PARTITION BY si.influencer_id 
            ORDER BY si.fecha_registro 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS seguidores_inicio,
        -- Último valor de seguidores (el más reciente)
        LAST_VALUE(si.seguidores) OVER (
            PARTITION BY si.influencer_id 
            ORDER BY si.fecha_registro 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS seguidores_fin
    FROM seguidores_influencer si
    JOIN influencers i ON si.influencer_id = i.influencer_id
),
crecimiento_por_influencer AS (
    SELECT DISTINCT
        influencer_id,
        nombre,
        seguidores_inicio,
        seguidores_fin,
        (seguidores_fin - seguidores_inicio) AS crecimiento_neto,
        ROUND((seguidores_fin - seguidores_inicio) / NULLIF(seguidores_inicio, 0) * 100, 2) AS tasa_crecimiento
    FROM crecimiento_global
)
SELECT 
    c.influencer_id,
    c.nombre,
    ca.campania_id,
    c.seguidores_inicio,
    c.seguidores_fin,
    c.tasa_crecimiento
FROM crecimiento_por_influencer c
JOIN colaboraciones ca ON c.influencer_id = ca.influencer_id
WHERE c.influencer_id IN (1, 3, 9)  -- Opcional: filtra los que aparecen en tu captura
ORDER BY c.tasa_crecimiento DESC, ca.campania_id;
