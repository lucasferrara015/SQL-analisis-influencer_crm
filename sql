-- 1 Consulta: ROI en Engagement
-- Objetivo: calcular el retorno de inversión en términos de interacciones (likes, comentarios, compartidos)
-- Lógica: se suman las interacciones y se dividen por la inversión total (pago_estimado)
-- Nota técnica: se usa NULLIF para evitar división por cero
-- Limitación: no contempla campañas sin publicaciones asociadas

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

-- Creación de vista para reutilización
CREATE VIEW vw_roi_engagement AS
SELECT i.nombre,
       SUM(mp.likes + mp.comentarios + mp.compartidos) AS interacciones_totales,
       SUM(c.pago_estimado) AS inversion_total,
       SUM(mp.likes + mp.comentarios + mp.compartidos) / NULLIF(SUM(c.pago_estimado),0) AS roi_engagement
FROM influencers i
JOIN colaboraciones c ON i.influencer_id = c.influencer_id
JOIN publicaciones p ON c.colab_id = p.colab_id
JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
GROUP BY i.nombre;

-- Consulta de resultados ordenados
SELECT * 
FROM vw_roi_engagement
ORDER BY roi_engagement DESC;

-- ---------------------------------------------------
-- 2 Consulta: ROI en Clicks
-- Objetivo: calcular el retorno de inversión en términos de clics generados por publicaciones
-- Lógica: se suman los clics y se dividen por la inversión total (pago_estimado)
-- Nota técnica: se usa NULLIF para evitar división por cero
-- Limitación: no contempla campañas sin publicaciones asociadas
-- ---------------------------------------------------

-- Consulta directa
SELECT i.nombre,
       SUM(mp.clicks) AS clicks_totales,
       SUM(c.pago_estimado) AS inversion_total,
       SUM(mp.clicks) / SUM(c.pago_estimado) AS roi_clicks
FROM influencers i
JOIN colaboraciones c ON i.influencer_id = c.influencer_id
JOIN publicaciones p ON c.colab_id = p.colab_id
JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
GROUP BY i.nombre
ORDER BY roi_clicks DESC;

-- ---------------------------------------------------
-- Creación de vista para reutilización
-- ---------------------------------------------------
CREATE VIEW vw_roi_clicks AS
SELECT i.nombre,
       SUM(mp.clicks) AS clicks_totales,
       SUM(c.pago_estimado) AS inversion_total,
       SUM(mp.clicks) / NULLIF(SUM(c.pago_estimado),0) AS roi_clicks
FROM influencers i
JOIN colaboraciones c ON i.influencer_id = c.influencer_id
JOIN publicaciones p ON c.colab_id = p.colab_id
JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
GROUP BY i.nombre;

-- ---------------------------------------------------
-- Consulta de resultados ordenados
-- ---------------------------------------------------
SELECT * 
FROM vw_roi_clicks
ORDER BY roi_clicks DESC;

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

-- ---------------------------------------------------
-- 5. Consulta: Mejores temáticas por engagement real
-- Objetivo: identificar qué temáticas generan mayor interacción promedio en publicaciones
-- Lógica: se suman las interacciones (likes, comentarios, compartidos) y se dividen por el número de publicaciones
-- Nota técnica: uso de NULLIF para evitar división por cero; COUNT(DISTINCT) asegura que no se dupliquen publicaciones
-- Limitación: no contempla publicaciones sin métricas registradas ni influencers inactivos
-- ---------------------------------------------------

-- Creación de vista para reutilización
CREATE VIEW vw_engagement_tematica AS
SELECT t.nombre_tematica,
       SUM(mp.likes + mp.comentarios + mp.compartidos) AS interacciones_totales, -- total de interacciones por temática
       COUNT(DISTINCT p.publicacion_id) AS publicaciones_totales, -- cantidad de publicaciones únicas
       SUM(mp.likes + mp.comentarios + mp.compartidos) / NULLIF(COUNT(DISTINCT p.publicacion_id),0) AS engagement_promedio -- promedio de interacciones por publicación
FROM tematicas t
JOIN influencer_tematica it ON t.tematica_id = it.tematica_id
JOIN influencers i ON it.influencer_id = i.influencer_id
JOIN colaboraciones c ON i.influencer_id = c.influencer_id
JOIN publicaciones p ON c.colab_id = p.colab_id
JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
WHERE i.estado = 'activo'
GROUP BY t.nombre_tematica;

-- Consulta de resultados ordenados (temáticas con mayor engagement primero)
SELECT * 
FROM vw_engagement_tematica
ORDER BY engagement_promedio DESC;

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

-- ---------------------------------------------------
-- 9. Consulta: Optimización de frecuencia - Publicaciones óptimas por semana
-- Objetivo: analizar la relación entre cantidad de publicaciones semanales y engagement promedio
-- Lógica: se cuentan las publicaciones por semana y se calcula el engagement promedio por publicación
-- Nota técnica: uso de NULLIF para evitar división por cero; YEARWEEK para agrupar por semana ISO
-- Limitación: no contempla variaciones por tipo de contenido ni estacionalidad; se centra en influencers activos
-- ---------------------------------------------------

-- CTE para calcular publicaciones e interacciones por semana
WITH publicaciones_por_semana AS (
    SELECT 
        c.influencer_id,
        YEARWEEK(p.fecha_publicacion, 1) AS semana, -- agrupación por semana ISO
        COUNT(p.publicacion_id) AS total_publicaciones, -- número de publicaciones en la semana
        SUM(mp.likes + mp.comentarios + mp.compartidos) AS total_engagement -- total de interacciones
    FROM publicaciones p
    JOIN metricas_publicacion mp 
        ON p.publicacion_id = mp.publicacion_id
    JOIN colaboraciones c 
        ON p.colab_id = c.colab_id
    GROUP BY c.influencer_id, YEARWEEK(p.fecha_publicacion, 1)
),

-- CTE para calcular engagement promedio por publicación
engagement_promedio AS (
    SELECT 
        influencer_id,
        semana,
        total_publicaciones,
        total_engagement / NULLIF(total_publicaciones,0) AS engagement_promedio -- promedio de interacciones por publicación
    FROM publicaciones_por_semana
)

-- Consulta final: engagement promedio por semana e influencer
SELECT 
    i.influencer_id,
    i.nombre,
    e.semana,
    e.total_publicaciones,
    e.engagement_promedio
FROM influencers i
JOIN engagement_promedio e 
    ON i.influencer_id = e.influencer_id
WHERE i.estado = 'activo'
ORDER BY i.influencer_id, e.semana;

-- ---------------------------------------------------
-- 10. Consulta: Lealtad del influencer - Repetibilidad y mejora en el tiempo
-- Objetivo: evaluar si los influencers mejoran, mantienen o declinan su engagement en colaboraciones sucesivas
-- Lógica: se calcula el engagement promedio por colaboración, se ordenan cronológicamente y se compara el inicial con los posteriores
-- Nota técnica: uso de NULLIF para evitar división por cero; ROW_NUMBER() para ordenar colaboraciones por fecha; CASE para clasificar la tendencia
-- Limitación: depende de la cantidad de colaboraciones registradas; influencers con pocas colaboraciones pueden tener resultados poco representativos
-- ---------------------------------------------------

-- CTE para calcular engagement promedio por colaboración
WITH engagement_por_colaboracion AS (
    SELECT 
        c.influencer_id,
        c.campania_id,
        MIN(p.fecha_publicacion) AS fecha_inicio_colab, -- fecha inicial de la colaboración
        SUM(mp.likes + mp.comentarios + mp.compartidos) / NULLIF(COUNT(p.publicacion_id),0) AS engagement_promedio -- promedio de interacciones por publicación
    FROM colaboraciones c
    JOIN publicaciones p 
        ON c.colab_id = p.colab_id
    JOIN metricas_publicacion mp 
        ON p.publicacion_id = mp.publicacion_id
    GROUP BY c.influencer_id, c.campania_id
),

-- CTE para ordenar colaboraciones cronológicamente
ordenadas AS (
    SELECT 
        influencer_id,
        campania_id,
        engagement_promedio,
        ROW_NUMBER() OVER (PARTITION BY influencer_id ORDER BY fecha_inicio_colab ASC) AS orden_colab -- orden de la colaboración
    FROM engagement_por_colaboracion
)

-- Consulta final: comparación entre engagement inicial y posterior
SELECT 
    i.influencer_id,
    i.nombre,
    MAX(CASE WHEN o.orden_colab = 1 THEN o.engagement_promedio END) AS engagement_inicial, -- primer colaboración
    AVG(CASE WHEN o.orden_colab > 1 THEN o.engagement_promedio END) AS engagement_posterior, -- promedio de colaboraciones posteriores
    CASE
        WHEN AVG(CASE WHEN o.orden_colab > 1 THEN o.engagement_promedio END) > MAX(CASE WHEN o.orden_colab = 1 THEN o.engagement_promedio END)
        THEN 'Mejora en el tiempo'
        WHEN AVG(CASE WHEN o.orden_colab > 1 THEN o.engagement_promedio END) = MAX(CASE WHEN o.orden_colab = 1 THEN o.engagement_promedio END)
        THEN 'Se mantiene'
        ELSE 'Declina'
    END AS tendencia -- clasificación de la evolución
FROM ordenadas o
JOIN influencers i 
    ON o.influencer_id = i.influencer_id
WHERE i.estado = 'activo'
GROUP BY i.influencer_id, i.nombre
ORDER BY tendencia DESC;

-- ---------------------------------------------------
-- 11. Consulta: Rendimiento por plataforma y formato
-- Objetivo: identificar qué plataformas y formatos generan mayor engagement promedio
-- Lógica: se cuentan las publicaciones y se suman las interacciones (likes, comentarios, compartidos) para calcular el engagement promedio
-- Nota técnica: uso de NULLIF para evitar división por cero; CTE para organizar el cálculo previo de publicaciones y engagement
-- Limitación: no contempla variaciones por temática ni segmentación de audiencia; se centra en métricas agregadas
-- ---------------------------------------------------

-- CTE para calcular publicaciones e interacciones por plataforma y formato
WITH engagement_por_formato AS (
    SELECT 
        p.plataforma, -- plataforma de publicación (ej. Instagram, TikTok)
        p.formato, -- formato de contenido (ej. reel, post, story)
        COUNT(p.publicacion_id) AS total_publicaciones, -- número de publicaciones
        SUM(mp.likes + mp.comentarios + mp.compartidos) AS total_engagement -- total de interacciones
    FROM publicaciones p
    JOIN metricas_publicacion mp 
        ON p.publicacion_id = mp.publicacion_id
    GROUP BY p.plataforma, p.formato
)

-- Consulta final: engagement promedio por plataforma y formato
SELECT 
    plataforma,
    formato,
    total_publicaciones,
    total_engagement / NULLIF(total_publicaciones,0) AS engagement_promedio -- promedio de interacciones por publicación
FROM engagement_por_formato
ORDER BY engagement_promedio DESC; -- ordena por mayor rendimiento

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



