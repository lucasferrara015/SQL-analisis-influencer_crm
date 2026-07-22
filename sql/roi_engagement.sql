-- Consulta: ROI Engagement con Ranking Global
-- Objetivo: calcular el retorno de inversión en interacciones (likes, comentarios, compartidos) por influencer activo
-- Lógica: se suman las interacciones y se dividen por la inversión total; se aplica RANK() para asignar posición global
-- Nota técnica: se usa NULLIF para evitar división por cero y ROUND para limitar decimales
-- Limitación: no diferencia calidad de interacción ni contempla métricas adicionales como impresiones o clics

-- REFACTORIZADA 1: ROI Engagement con Ranking Global
WITH roi_engagement AS (
    SELECT 
        i.influencer_id,
        i.nombre,
        -- Cálculo del ROI (interacciones / inversión)
        ROUND(SUM(mp.likes + mp.comentarios + mp.compartidos) / NULLIF(SUM(c.pago_estimado), 0), 2) AS roi,
        -- Datos de contexto para el insight
        SUM(mp.likes + mp.comentarios + mp.compartidos) AS total_interacciones,
        SUM(c.pago_estimado) AS total_inversion
    FROM influencers i
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    JOIN publicaciones p ON c.colab_id = p.colab_id
    JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    WHERE i.estado = 'activo'
    GROUP BY i.influencer_id, i.nombre
)
SELECT 
    nombre,
    roi,
    total_interacciones,
    total_inversion,
    -- Ventana: Asigna el puesto #1, #2, #3...
    RANK() OVER (ORDER BY roi DESC) AS ranking_global
FROM roi_engagement
ORDER BY roi DESC;
