-- Consulta: Crecimiento Neto de Seguidores por Campaña
-- Objetivo: medir la evolución de seguidores durante cada campaña de un influencer
-- Lógica: se obtiene el primer y último registro de seguidores en el rango de fechas de la campaña usando FIRST_VALUE y LAST_VALUE; se calcula crecimiento neto y tasa de crecimiento porcentual
-- Nota técnica: las funciones ventana permiten capturar valores iniciales y finales sin subconsultas; NULLIF evita división por cero y ROUND limita decimales
-- Limitación: no contempla factores externos (algoritmos de plataforma, viralidad, estacionalidad); depende de la calidad y frecuencia de los registros de seguidores

-- REFACTORIZADA #12: Crecimiento Neto de Seguidores por Campaña
WITH crecimiento_campana AS (
    SELECT 
        i.nombre AS influencer,
        c.campania_id,
        MIN(si.fecha_registro) AS fecha_inicio_registro,
        MAX(si.fecha_registro) AS fecha_fin_registro,
        -- Primer valor de seguidores registrado en esa campaña
        FIRST_VALUE(si.seguidores) OVER (
            PARTITION BY i.influencer_id, c.campania_id 
            ORDER BY si.fecha_registro 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS seguidores_inicio,
        -- Último valor de seguidores registrado en esa campaña
        LAST_VALUE(si.seguidores) OVER (
            PARTITION BY i.influencer_id, c.campania_id 
            ORDER BY si.fecha_registro 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS seguidores_fin
    FROM seguidores_influencer si
    JOIN influencers i ON si.influencer_id = i.influencer_id
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    WHERE si.fecha_registro BETWEEN c.fecha_inicio AND c.fecha_fin
)
SELECT DISTINCT
    influencer,
    campania_id,
    seguidores_inicio,
    seguidores_fin,
    (seguidores_fin - seguidores_inicio) AS crecimiento_neto,
    ROUND((seguidores_fin - seguidores_inicio) / NULLIF(seguidores_inicio, 0) * 100, 2) AS tasa_crecimiento
FROM crecimiento_campana
ORDER BY tasa_crecimiento DESC;



