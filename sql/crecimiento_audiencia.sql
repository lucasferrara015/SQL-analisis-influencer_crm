-- ---------------------------------------------------
-- 12. Consulta: Crecimiento de audiencia - Ganancia de seguidores durante la campaña
-- Objetivo: medir la variación de seguidores de cada influencer a lo largo de una campaña
-- Lógica: se toma el mínimo y máximo de seguidores registrados en el periodo de la campaña y se calcula la tasa de crecimiento relativa
-- Nota técnica: uso de NULLIF para evitar división por cero; MIN y MAX para capturar valores iniciales y finales de seguidores
-- Limitación: depende de la frecuencia de registros en la tabla seguidores_influencer; campañas con pocos registros pueden dar resultados poco precisos
-- ---------------------------------------------------

-- CTE para calcular seguidores al inicio y fin de cada campaña
WITH seguidores_por_campania AS (
    SELECT 
        c.influencer_id,
        c.campania_id,
        MIN(fs.fecha_registro) AS fecha_inicio, -- primera fecha registrada
        MAX(fs.fecha_registro) AS fecha_fin, -- última fecha registrada
        MIN(fs.seguidores) AS seguidores_inicio, -- seguidores al inicio
        MAX(fs.seguidores) AS seguidores_fin -- seguidores al final
    FROM colaboraciones c
    JOIN seguidores_influencer fs 
        ON c.influencer_id = fs.influencer_id
    GROUP BY c.influencer_id, c.campania_id
)

-- Consulta final: tasa de crecimiento de seguidores por campaña
SELECT 
    i.influencer_id,
    i.nombre,
    s.campania_id,
    s.seguidores_inicio,
    s.seguidores_fin,
    (s.seguidores_fin - s.seguidores_inicio) / NULLIF(s.seguidores_inicio,0) AS tasa_crecimiento -- variación relativa
FROM seguidores_por_campania s
JOIN influencers i 
    ON s.influencer_id = i.influencer_id
WHERE i.estado = 'activo'
ORDER BY tasa_crecimiento DESC; -- ordena por mayor crecimiento



