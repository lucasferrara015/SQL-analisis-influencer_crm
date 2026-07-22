-- Consulta: Costo por interacción vs Promedio Global
-- Objetivo: evaluar la eficiencia de campañas comparando el costo por interacción con el promedio global
-- Lógica: se calcula el costo por interacción por campaña y se usa AVG() OVER() para obtener el promedio global en una sola pasada
-- Nota técnica: ROUND limita decimales; NULLIF evita división por cero; la ventana OVER() replica el promedio en cada fila
-- Limitación: no contempla calidad de interacción ni factores externos (tipo de campaña, duración, contexto); depende de la precisión de pagos e interacciones registradas

-- #4: Costo por interacción vs Promedio Global
WITH costos_campana AS (
    SELECT 
        campania_id,
        ROUND(SUM(c.pago_estimado), 2) AS coste_total,
        SUM(mp.likes + mp.comentarios + mp.compartidos) AS interacciones,
        ROUND(SUM(c.pago_estimado) / NULLIF(SUM(mp.likes + mp.comentarios + mp.compartidos), 0), 2) AS costo_por_interaccion
    FROM colaboraciones c
    JOIN publicaciones p ON c.colab_id = p.colab_id
    JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    GROUP BY campania_id
)
SELECT 
    campania_id,
    costo_por_interaccion,
    interacciones,
    -- Ventana que calcula el promedio de TODAS las filas y lo repite en cada fila
    ROUND(AVG(costo_por_interaccion) OVER (), 2) AS promedio_global,
    ROUND(costo_por_interaccion - AVG(costo_por_interaccion) OVER (), 2) AS diferencia_con_promedio
FROM costos_campana
ORDER BY costo_por_interaccion ASC;
