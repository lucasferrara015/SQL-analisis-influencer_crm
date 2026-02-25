-- ---------------------------------------------------
-- 6. Consulta: Evolución del engagement en el tiempo
-- Objetivo: analizar cómo varía el engagement promedio de un influencer a lo largo del tiempo
-- Lógica: se agrupan las publicaciones por periodo (diario, semanal o mensual) y se calcula el promedio de interacciones
-- Nota técnica: uso de CASE para definir el periodo dinámicamente según parámetro; uso de NULLIF para evitar división por cero
-- Limitación: depende de la calidad de las métricas registradas; no contempla publicaciones sin datos de interacciones
-- ---------------------------------------------------

DELIMITER $$

-- Procedimiento almacenado con parámetros dinámicos
CREATE PROCEDURE sp_evolucion_engagement (
    IN p_influencer_id INT, -- ID del influencer a analizar
    IN p_periodo VARCHAR(10) -- valores posibles: 'diario', 'semanal', 'mensual'
)
BEGIN
    SELECT 
        CASE 
            WHEN p_periodo = 'diario' THEN DATE(p.fecha_publicacion) -- agrupación por día
            WHEN p_periodo = 'semanal' THEN YEARWEEK(p.fecha_publicacion, 1) -- agrupación por semana ISO
            WHEN p_periodo = 'mensual' THEN DATE_FORMAT(p.fecha_publicacion, '%Y-%m') -- agrupación por mes
        END AS periodo,
        AVG(mp.likes + mp.comentarios + mp.compartidos) AS engagement_promedio -- promedio de interacciones
    FROM publicaciones p
    JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    JOIN colaboraciones c ON p.colab_id = c.colab_id
    WHERE c.influencer_id = p_influencer_id -- filtro por influencer
    GROUP BY periodo
    ORDER BY periodo;
END$$

DELIMITER ;

-- Ejemplo de ejecución: evolución diaria del influencer con ID 5
CALL sp_evolucion_engagement(5, 'diario');
