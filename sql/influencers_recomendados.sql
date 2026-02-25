-- ---------------------------------------------------
-- 3 Consulta: Influencers recomendados para próxima campaña
-- Objetivo: identificar influencers activos con buen engagement real en una temática específica
-- Lógica: se calcula el promedio de interacciones sobre impresiones, se filtra por estado de colaboración y se ordena por métricas clave
-- Nota técnica: uso de NULLIF para evitar división por cero; LEFT JOIN para incluir influencers aunque no tengan publicaciones recientes
-- Limitación: centrado en una sola temática (ejemplo: 'fitness'), puede requerir ajuste para múltiples segmentos
-- ---------------------------------------------------

-- Consulta directa
SELECT i.influencer_id,
       i.nombre,
       i.plataforma,
       i.tipo_influencer,
       t.nombre_tematica AS tematica,
       AVG((mp.likes + mp.comentarios + mp.compartidos) / NULLIF(mp.impresiones,0)) AS engagement_real,
       MAX(c.fecha_fin) AS ultima_colaboracion,
       c.estado AS estado_colaboracion,
       AVG(mp.likes + mp.comentarios + mp.compartidos) AS promedio_interacciones
FROM influencers i
JOIN influencer_tematica it ON i.influencer_id = it.influencer_id
JOIN tematicas t ON it.tematica_id = t.tematica_id
LEFT JOIN colaboraciones c ON i.influencer_id = c.influencer_id
LEFT JOIN publicaciones p ON c.colab_id = p.colab_id
LEFT JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
WHERE i.estado = 'activo'
  AND t.nombre_tematica = 'fitness'
GROUP BY i.influencer_id, i.nombre, i.plataforma, i.tipo_influencer, t.nombre_tematica, c.estado
HAVING AVG((mp.likes + mp.comentarios + mp.compartidos) / NULLIF(mp.impresiones,0)) >= 0.01
   AND (c.estado IN ('finalizada','pendiente','activa'))
ORDER BY engagement_real DESC, promedio_interacciones DESC, ultima_colaboracion DESC;

-- ---------------------------------------------------
-- Creación de vista para reutilización
-- ---------------------------------------------------
CREATE VIEW vw_influencers_recomendados AS
SELECT i.influencer_id,
       i.nombre,
       i.plataforma,
       i.tipo_influencer,
       t.nombre_tematica AS tematica,
       AVG((mp.likes + mp.comentarios + mp.compartidos) / NULLIF(mp.impresiones,0)) AS engagement_real,
       MAX(c.fecha_fin) AS ultima_colaboracion,
       c.estado AS estado_colaboracion,
       AVG(mp.likes + mp.comentarios + mp.compartidos) AS promedio_interacciones
FROM influencers i
JOIN influencer_tematica it ON i.influencer_id = it.influencer_id
JOIN tematicas t ON it.tematica_id = t.tematica_id
LEFT JOIN colaboraciones c ON i.influencer_id = c.influencer_id
LEFT JOIN publicaciones p ON c.colab_id = p.colab_id
LEFT JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
WHERE i.estado = 'activo'
  AND t.nombre_tematica = 'fitness'
GROUP BY i.influencer_id, i.nombre, i.plataforma, i.tipo_influencer, t.nombre_tematica, c.estado
HAVING AVG((mp.likes + mp.comentarios + mp.compartidos) / NULLIF(mp.impresiones,0)) >= 0.01
   AND (c.estado IN ('finalizada','pendiente','activa'));

SELECT * 
FROM vw_influencers_recomendados
ORDER BY engagement_real DESC, promedio_interacciones DESC, ultima_colaboracion DESC;

-- ---------------------------------------------------
-- Procedimiento almacenado con parámetros dinámicos
-- ---------------------------------------------------
DELIMITER $$

CREATE PROCEDURE sp_influencers_recomendados (
    IN p_tematica VARCHAR(50),
    IN p_engagement_min DECIMAL(5,2),
    IN p_estado VARCHAR(20)
)
BEGIN
    SELECT i.influencer_id,
           i.nombre,
           i.plataforma,
           i.tipo_influencer,
           t.nombre_tematica AS tematica,
           AVG((mp.likes + mp.comentarios + mp.compartidos) / NULLIF(mp.impresiones,0)) AS engagement_real,
           MAX(c.fecha_fin) AS ultima_colaboracion,
           c.estado AS estado_colaboracion,
           AVG(mp.likes + mp.comentarios + mp.compartidos) AS promedio_interacciones
    FROM influencers i
    JOIN influencer_tematica it ON i.influencer_id = it.influencer_id
    JOIN tematicas t ON it.tematica_id = t.tematica_id
    LEFT JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    LEFT JOIN publicaciones p ON c.colab_id = p.colab_id
    LEFT JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    WHERE i.estado = 'activo'
      AND t.nombre_tematica = p_tematica
    GROUP BY i.influencer_id, i.nombre, i.plataforma, i.tipo_influencer, t.nombre_tematica, c.estado
    HAVING AVG((mp.likes + mp.comentarios + mp.compartidos) / NULLIF(mp.impresiones,0)) >= p_engagement_min
       AND (c.estado = p_estado OR p_estado = 'todos')
    ORDER BY engagement_real DESC, promedio_interacciones DESC, ultima_colaboracion DESC;
END$$

DELIMITER ;

-- Ejemplo de ejecución
CALL sp_influencers_recomendados('moda', 0.02, 'todos');
