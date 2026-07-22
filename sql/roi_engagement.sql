-- Consulta: ROI en Engagement
-- Objetivo: calcular el retorno de inversión en términos de interacciones (likes, comentarios, compartidos)
-- Lógica: se suman las interacciones y se dividen por la inversión total (pago_estimado)
-- Nota técnica: el ROI se calcula como la suma de interacciones (likes, comentarios, compartidos) dividida por la inversión total registrada en pago_estimado.
-- Limitación: no diferencia la calidad de cada interacción ni incluye métricas adicionales como impresiones o clics, por lo que ofrece una visión parcial del rendimiento.
 

-- Consulta directa
SELECT i.nombre,
       SUM(mp.likes + mp.comentarios + mp.compartidos) AS interacciones_totales,
       SUM(c.pago_estimado) AS inversion_total,
       SUM(mp.likes + mp.comentarios + mp.compartidos) / SUM(c.pago_estimado) AS roi_engagement
FROM influencers i
JOIN colaboraciones c ON i.influencer_id = c.influencer_id
JOIN publicaciones p ON c.colab_id = p.colab_id
JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
GROUP BY i.nombre
ORDER BY roi_engagement DESC;

-- REFACTORIZADA: ROI Engagement con Ranking Global
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
