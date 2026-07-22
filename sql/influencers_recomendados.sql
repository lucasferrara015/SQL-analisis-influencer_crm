-- Consulta: Selección de Talento con CTE
-- Objetivo: identificar influencers activos con engagement real y experiencia previa en colaboraciones
-- Lógica: se calcula el engagement promedio por impresiones usando AVG() y NULLIF; se obtiene última colaboración y total de colaboraciones
-- Nota técnica: se usa CTE modular en lugar de VIEW fija para mayor flexibilidad; ROUND limita decimales y COUNT DISTINCT evita duplicados
-- Limitación: no contempla factores cualitativos (tipo de campaña, duración, contexto de la temática); depende de la calidad de métricas registradas

-- Selección de Talento (CTE modular en lugar de VIEW fija)
WITH talento_crudo AS (
    SELECT 
        i.influencer_id,
        i.nombre,
        i.plataforma,
        i.tipo_influencer,
        t.nombre_tematica,
        -- Cálculo de engagement real sin necesidad de HAVING complejo
        ROUND(AVG((mp.likes + mp.comentarios + mp.compartidos) / NULLIF(mp.impresiones, 0)), 4) AS engagement_real,
        MAX(c.fecha_fin) AS ultima_colaboracion,
        COUNT(DISTINCT c.colab_id) AS total_colaboraciones
    FROM influencers i
    JOIN influencer_tematica it ON i.influencer_id = it.influencer_id
    JOIN tematicas t ON it.tematica_id = t.tematica_id
    LEFT JOIN colaboraciones c ON i.influencer_id = c.influencer_id AND c.estado = 'finalizada'
    LEFT JOIN publicaciones p ON c.colab_id = p.colab_id
    LEFT JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    WHERE i.estado = 'activo'
    GROUP BY i.influencer_id, i.nombre, i.plataforma, i.tipo_influencer, t.nombre_tematica
)
SELECT *
FROM talento_crudo
WHERE nombre_tematica = 'Moda'          -- 🔥 CAMBIA la temática que necesites
  AND engagement_real >= 0.01           -- 🔥 CAMBIA el engagement mínimo
  AND ultima_colaboracion IS NOT NULL   -- Que haya trabajado antes
ORDER BY engagement_real DESC;
