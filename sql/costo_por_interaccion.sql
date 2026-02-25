-- ---------------------------------------------------
-- 4. Consulta: Evaluación de campañas - Costo por interacción
-- Objetivo: calcular la rentabilidad de cada campaña en términos de costo por interacción
-- Lógica: se suman los pagos estimados de las colaboraciones y se dividen por el total de interacciones (likes, comentarios, compartidos)
-- Nota técnica: uso de NULLIF para evitar división por cero; agrupación por campania_id para obtener métricas por campaña
-- Limitación: no contempla campañas sin publicaciones o métricas registradas
-- ---------------------------------------------------

-- Creación de vista para reutilización
CREATE VIEW vw_costo_por_interaccion AS
SELECT c.campania_id,
       SUM(c.pago_estimado) AS coste_total, -- inversión total de la campaña
       SUM(mp.likes + mp.comentarios + mp.compartidos) AS interacciones_totales, -- total de interacciones
       SUM(c.pago_estimado) / NULLIF(SUM(mp.likes + mp.comentarios + mp.compartidos),0) AS costo_por_interaccion -- costo promedio por interacción
FROM colaboraciones c
JOIN publicaciones p ON c.colab_id = p.colab_id
JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
GROUP BY c.campania_id;

-- Consulta de resultados ordenados (campañas más rentables primero)
SELECT * 
FROM vw_costo_por_interaccion
ORDER BY costo_por_interaccion ASC;
