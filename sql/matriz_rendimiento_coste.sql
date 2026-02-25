-- ---------------------------------------------------
-- 8. Consulta: Segmentación estratégica - Matriz de rendimiento y coste
-- Objetivo: clasificar influencers en cuadrantes estratégicos según su ROI en ventas y coste total
-- Lógica: se calculan umbrales globales de ROI y coste promedio; luego se compara cada influencer contra esos valores
-- Nota técnica: uso de NULLIF para evitar división por cero; CASE para asignar cuadrantes; DECLARE y SELECT INTO para calcular umbrales dinámicos
-- Limitación: depende de la correcta asociación entre ventas y colaboraciones; no contempla influencers sin métricas registradas
-- ---------------------------------------------------

DELIMITER $$

-- Procedimiento almacenado para generar matriz de rendimiento/coste
CREATE PROCEDURE sp_matriz_rendimiento_coste ()
BEGIN
    -- Calcular umbrales globales de ROI y coste
    DECLARE avg_roi DECIMAL(10,2);
    DECLARE avg_coste DECIMAL(10,2);

    SELECT AVG(roi_ventas), AVG(coste_total)
    INTO avg_roi, avg_coste
    FROM (
        SELECT i.influencer_id,
               SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0) AS roi_ventas, -- ROI por influencer
               SUM(c.pago_estimado) AS coste_total -- coste total invertido
        FROM influencers i
        JOIN colaboraciones c ON i.influencer_id = c.influencer_id
        LEFT JOIN codigos_descuento cd ON c.colab_id = cd.colab_id
        LEFT JOIN ventas v ON cd.codigo_descuento = v.codigo_descuento
        WHERE i.estado = 'activo'
        GROUP BY i.influencer_id
    ) sub;

    -- Clasificación en cuadrantes según ROI y coste
    SELECT i.influencer_id,
           i.nombre,
           SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0) AS roi_ventas,
           SUM(c.pago_estimado) AS coste_total,
           CASE
               WHEN (SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0)) >= avg_roi
                    AND SUM(c.pago_estimado) < avg_coste
               THEN 'Alto rendimiento / Bajo coste → Máxima prioridad'
               
               WHEN (SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0)) >= avg_roi
                    AND SUM(c.pago_estimado) >= avg_coste
               THEN 'Alto rendimiento / Alto coste → Evaluar presupuesto'
               
               WHEN (SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0)) < avg_roi
                    AND SUM(c.pago_estimado) < avg_coste
               THEN 'Bajo rendimiento / Bajo coste → Campañas de bajo riesgo'
               
               ELSE 'Bajo rendimiento / Alto coste → Descartar o renegociar'
           END AS cuadrante
    FROM influencers i
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    LEFT JOIN codigos_descuento cd ON c.colab_id = cd.colab_id
    LEFT JOIN ventas v ON cd.codigo_descuento = v.codigo_descuento
    WHERE i.estado = 'activo'
    GROUP BY i.influencer_id, i.nombre;
END$$

DELIMITER ;

-- Ejemplo de ejecución
CALL sp_matriz_rendimiento_coste();
