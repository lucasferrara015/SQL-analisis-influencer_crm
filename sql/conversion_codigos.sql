-- ---------------------------------------------------
-- 7. Consulta: Medición de ventas (ROI) - Tasa de conversión de códigos de descuento
-- Objetivo: evaluar la efectividad de los códigos de descuento en términos de ventas generadas, ingresos y ROI
-- Lógica: se cuentan las ventas asociadas a cada código, se suman los ingresos y los clics, y se calculan métricas de conversión y ROI
-- Nota técnica: uso de NULLIF para evitar división por cero; LEFT JOIN en ventas y publicaciones para incluir influencers aunque no tengan ventas o métricas recientes
-- Limitación: depende de la correcta asociación entre códigos de descuento y ventas; no contempla conversiones indirectas sin código
-- ---------------------------------------------------

-- Creación de vista para reutilización
CREATE VIEW vw_conversion_codigos AS
SELECT i.influencer_id,
       i.nombre,
       cd.codigo_descuento,
       COUNT(v.venta_id) AS ventas_generadas, -- cantidad de ventas con el código
       SUM(v.monto_total) AS ingresos_generados, -- ingresos totales por ventas
       SUM(mp.clicks) AS clicks_totales, -- total de clics en publicaciones
       COUNT(v.venta_id) / NULLIF(SUM(mp.clicks),0) AS tasa_conversion, -- ratio ventas/clics
       SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0) AS roi_ventas -- ingresos sobre inversión
FROM influencers i
JOIN colaboraciones c ON i.influencer_id = c.influencer_id
JOIN codigos_descuento cd ON c.colab_id = cd.colab_id
LEFT JOIN ventas v ON cd.codigo_descuento = v.codigo_descuento
LEFT JOIN publicaciones p ON c.colab_id = p.colab_id
LEFT JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
WHERE i.estado = 'activo'
GROUP BY i.influencer_id, i.nombre, cd.codigo_descuento;

-- Consulta de resultados ordenados (mejor ROI y tasa de conversión primero)
SELECT * 
FROM vw_conversion_codigos
ORDER BY roi_ventas DESC, tasa_conversion DESC;
