-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema influencer_crm
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema influencer_crm
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `influencer_crm` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `influencer_crm` ;

-- -----------------------------------------------------
-- Table `influencer_crm`.`marcas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`marcas` (
  `marca_id` INT NOT NULL AUTO_INCREMENT,
  `nombre_marca` VARCHAR(100) NOT NULL,
  `industria` VARCHAR(50) NULL DEFAULT NULL,
  `contacto_comercial` VARCHAR(100) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`marca_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`campanas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`campanas` (
  `campania_id` INT NOT NULL AUTO_INCREMENT,
  `nombre_campania` VARCHAR(100) NOT NULL,
  `marca_id` INT NOT NULL,
  `fecha_inicio` DATE NULL DEFAULT NULL,
  `fecha_fin` DATE NULL DEFAULT NULL,
  `presupuesto` DECIMAL(10,2) NULL DEFAULT NULL,
  `objetivo` VARCHAR(100) NULL DEFAULT NULL,
  `estado` ENUM('planificada', 'activa', 'finalizada') NULL DEFAULT 'planificada',
  PRIMARY KEY (`campania_id`),
  INDEX `marca_id` (`marca_id` ASC) VISIBLE,
  CONSTRAINT `campanas_ibfk_1`
    FOREIGN KEY (`marca_id`)
    REFERENCES `influencer_crm`.`marcas` (`marca_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 110
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`influencers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`influencers` (
  `influencer_id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `plataforma` ENUM('Instagram', 'TikTok', 'YouTube', 'Twitter') NOT NULL,
  `seguidores` INT NULL DEFAULT NULL,
  `engagement_rate` DECIMAL(5,2) NULL DEFAULT NULL,
  `pais` VARCHAR(50) NULL DEFAULT NULL,
  `ciudad` VARCHAR(50) NULL DEFAULT NULL,
  `tipo_influencer` ENUM('nano', 'micro', 'macro', 'celebridad') NULL DEFAULT NULL,
  `contacto` VARCHAR(100) NULL DEFAULT NULL,
  `estado` ENUM('activo', 'inactivo') NULL DEFAULT 'activo',
  `observaciones` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`influencer_id`),
  UNIQUE INDEX `username` (`username` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`colaboraciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`colaboraciones` (
  `colab_id` INT NOT NULL AUTO_INCREMENT,
  `influencer_id` INT NOT NULL,
  `campania_id` INT NOT NULL,
  `fecha_inicio` DATE NULL DEFAULT NULL,
  `fecha_fin` DATE NULL DEFAULT NULL,
  `tipo_colab` ENUM('post', 'video', 'historia', 'reel') NOT NULL,
  `estado` ENUM('pendiente', 'activa', 'finalizada') NULL DEFAULT 'pendiente',
  `pago_estimado` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`colab_id`),
  INDEX `fk_colab_influencer` (`influencer_id` ASC) VISIBLE,
  INDEX `fk_colab_campania` (`campania_id` ASC) VISIBLE,
  CONSTRAINT `fk_colab_campania`
    FOREIGN KEY (`campania_id`)
    REFERENCES `influencer_crm`.`campanas` (`campania_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_colab_influencer`
    FOREIGN KEY (`influencer_id`)
    REFERENCES `influencer_crm`.`influencers` (`influencer_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 310
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`codigos_descuento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`codigos_descuento` (
  `codigo_id` INT NOT NULL AUTO_INCREMENT,
  `colab_id` INT NOT NULL,
  `codigo_descuento` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`codigo_id`),
  UNIQUE INDEX `codigo_descuento` (`codigo_descuento` ASC) VISIBLE,
  INDEX `colab_id` (`colab_id` ASC) VISIBLE,
  CONSTRAINT `codigos_descuento_ibfk_1`
    FOREIGN KEY (`colab_id`)
    REFERENCES `influencer_crm`.`colaboraciones` (`colab_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 62
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`evaluaciones_influencer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`evaluaciones_influencer` (
  `evaluacion_id` INT NOT NULL AUTO_INCREMENT,
  `influencer_id` INT NOT NULL,
  `campania_id` INT NOT NULL,
  `score_desempeÃ±o` DECIMAL(3,2) NULL DEFAULT NULL,
  `costo_efectividad` DECIMAL(10,2) NULL DEFAULT NULL,
  `recomendado` TINYINT(1) NULL DEFAULT '0',
  `observaciones` TEXT NULL DEFAULT NULL,
  `fecha_evaluacion` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`evaluacion_id`),
  UNIQUE INDEX `unique_eval` (`influencer_id` ASC, `campania_id` ASC) VISIBLE,
  INDEX `campania_id` (`campania_id` ASC) VISIBLE,
  CONSTRAINT `evaluaciones_influencer_ibfk_1`
    FOREIGN KEY (`influencer_id`)
    REFERENCES `influencer_crm`.`influencers` (`influencer_id`),
  CONSTRAINT `evaluaciones_influencer_ibfk_2`
    FOREIGN KEY (`campania_id`)
    REFERENCES `influencer_crm`.`campanas` (`campania_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`tematicas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`tematicas` (
  `tematica_id` INT NOT NULL AUTO_INCREMENT,
  `nombre_tematica` VARCHAR(50) NOT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`tematica_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`influencer_tematica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`influencer_tematica` (
  `influencer_id` INT NOT NULL,
  `tematica_id` INT NOT NULL,
  `nivel_afinidad` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`influencer_id`, `tematica_id`),
  INDEX `tematica_id` (`tematica_id` ASC) VISIBLE,
  CONSTRAINT `influencer_tematica_ibfk_1`
    FOREIGN KEY (`influencer_id`)
    REFERENCES `influencer_crm`.`influencers` (`influencer_id`)
    ON DELETE CASCADE,
  CONSTRAINT `influencer_tematica_ibfk_2`
    FOREIGN KEY (`tematica_id`)
    REFERENCES `influencer_crm`.`tematicas` (`tematica_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`publicaciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`publicaciones` (
  `publicacion_id` INT NOT NULL AUTO_INCREMENT,
  `colab_id` INT NOT NULL,
  `plataforma` ENUM('Instagram', 'TikTok', 'YouTube', 'Twitter', 'Facebook') NOT NULL,
  `fecha_publicacion` DATE NULL DEFAULT NULL,
  `formato` VARCHAR(10) NULL DEFAULT NULL,
  `link` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`publicacion_id`),
  INDEX `colab_id` (`colab_id` ASC) VISIBLE,
  CONSTRAINT `publicaciones_ibfk_1`
    FOREIGN KEY (`colab_id`)
    REFERENCES `influencer_crm`.`colaboraciones` (`colab_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 6013
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`metricas_publicacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`metricas_publicacion` (
  `metrica_id` INT NOT NULL AUTO_INCREMENT,
  `publicacion_id` INT NOT NULL,
  `fecha_medicion` DATE NOT NULL,
  `impresiones` INT NULL DEFAULT '0',
  `likes` INT NULL DEFAULT '0',
  `comentarios` INT NULL DEFAULT '0',
  `compartidos` INT NULL DEFAULT '0',
  `clicks` INT NULL DEFAULT '0',
  PRIMARY KEY (`metrica_id`),
  INDEX `publicacion_id` (`publicacion_id` ASC) VISIBLE,
  CONSTRAINT `metricas_publicacion_ibfk_1`
    FOREIGN KEY (`publicacion_id`)
    REFERENCES `influencer_crm`.`publicaciones` (`publicacion_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 80
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`seguidores_influencer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`seguidores_influencer` (
  `registro_id` INT NOT NULL AUTO_INCREMENT,
  `influencer_id` INT NOT NULL,
  `fecha_registro` DATE NOT NULL,
  `seguidores` INT NOT NULL,
  PRIMARY KEY (`registro_id`),
  INDEX `influencer_id` (`influencer_id` ASC) VISIBLE,
  CONSTRAINT `seguidores_influencer_ibfk_1`
    FOREIGN KEY (`influencer_id`)
    REFERENCES `influencer_crm`.`influencers` (`influencer_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `influencer_crm`.`ventas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `influencer_crm`.`ventas` (
  `venta_id` INT NOT NULL AUTO_INCREMENT,
  `codigo_descuento` VARCHAR(50) NOT NULL,
  `monto_total` DECIMAL(10,2) NOT NULL,
  `fecha_venta` DATE NOT NULL,
  PRIMARY KEY (`venta_id`),
  INDEX `codigo_descuento` (`codigo_descuento` ASC) VISIBLE,
  CONSTRAINT `ventas_ibfk_1`
    FOREIGN KEY (`codigo_descuento`)
    REFERENCES `influencer_crm`.`codigos_descuento` (`codigo_descuento`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `influencer_crm` ;

-- -----------------------------------------------------
-- procedure sp_evolucion_engagement
-- -----------------------------------------------------

DELIMITER $$
USE `influencer_crm`$$
CREATE PROCEDURE `sp_evolucion_engagement`(
    IN p_influencer_id INT,
    IN p_periodo VARCHAR(10) -- valores: 'diario', 'semanal', 'mensual'
)
BEGIN
    SELECT 
        CASE 
            WHEN p_periodo = 'diario' THEN DATE(p.fecha_publicacion)
            WHEN p_periodo = 'semanal' THEN YEARWEEK(p.fecha_publicacion, 1)
            WHEN p_periodo = 'mensual' THEN DATE_FORMAT(p.fecha_publicacion, '%Y-%m')
        END AS periodo,
        AVG(mp.likes + mp.comentarios + mp.compartidos) AS engagement_promedio
    FROM publicaciones p
    JOIN metricas_publicacion mp ON p.publicacion_id = mp.publicacion_id
    JOIN colaboraciones c ON p.colab_id = c.colab_id
    WHERE c.influencer_id = p_influencer_id
    GROUP BY periodo
    ORDER BY periodo;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_influencers_recomendados
-- -----------------------------------------------------

DELIMITER $$
USE `influencer_crm`$$
CREATE PROCEDURE `sp_influencers_recomendados`(
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

-- -----------------------------------------------------
-- procedure sp_matriz_rendimiento_coste
-- -----------------------------------------------------

DELIMITER $$
USE `influencer_crm`$$
CREATE PROCEDURE `sp_matriz_rendimiento_coste`()
BEGIN
    -- Calcular umbrales globales de ROI y coste
    DECLARE avg_roi DECIMAL(10,2);
    DECLARE avg_coste DECIMAL(10,2);

    SELECT AVG(roi_ventas), AVG(coste_total)
    INTO avg_roi, avg_coste
    FROM (
        SELECT i.influencer_id,
               SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0) AS roi_ventas,
               SUM(c.pago_estimado) AS coste_total
        FROM influencers i
        JOIN colaboraciones c ON i.influencer_id = c.influencer_id
        LEFT JOIN codigos_descuento cd ON c.colab_id = cd.colab_id
        LEFT JOIN ventas v ON cd.codigo_descuento = v.codigo_descuento
        WHERE i.estado = 'activo'
        GROUP BY i.influencer_id
    ) sub;

    -- ClasificaciÃ³n en cuadrantes
    SELECT i.influencer_id,
           i.nombre,
           SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0) AS roi_ventas,
           SUM(c.pago_estimado) AS coste_total,
           CASE
               WHEN (SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0)) >= avg_roi
                    AND SUM(c.pago_estimado) < avg_coste
               THEN 'Alto rendimiento / Bajo coste â MÃ¡xima prioridad'
               
               WHEN (SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0)) >= avg_roi
                    AND SUM(c.pago_estimado) >= avg_coste
               THEN 'Alto rendimiento / Alto coste â Evaluar presupuesto'
               
               WHEN (SUM(v.monto_total) / NULLIF(SUM(c.pago_estimado),0)) < avg_roi
                    AND SUM(c.pago_estimado) < avg_coste
               THEN 'Bajo rendimiento / Bajo coste â CampaÃ±as de bajo riesgo'
               
               ELSE 'Bajo rendimiento / Alto coste â Descartar o renegociar'
           END AS cuadrante
    FROM influencers i
    JOIN colaboraciones c ON i.influencer_id = c.influencer_id
    LEFT JOIN codigos_descuento cd ON c.colab_id = cd.colab_id
    LEFT JOIN ventas v ON cd.codigo_descuento = v.codigo_descuento
    WHERE i.estado = 'activo'
    GROUP BY i.influencer_id, i.nombre;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `influencer_crm`.`vw_conversion_codigos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `influencer_crm`.`vw_conversion_codigos`;
USE `influencer_crm`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED 
SQL SECURITY DEFINER VIEW `influencer_crm`.`vw_conversion_codigos` AS select `i`.`influencer_id` AS `influencer_id`,`i`.`nombre` AS `nombre`,`cd`.`codigo_descuento` AS `codigo_descuento`,count(`v`.`venta_id`) AS `ventas_generadas`,sum(`v`.`monto_total`) AS `ingresos_generados`,sum(`mp`.`clicks`) AS `clicks_totales`,(count(`v`.`venta_id`) / nullif(sum(`mp`.`clicks`),0)) AS `tasa_conversion`,(sum(`v`.`monto_total`) / nullif(sum(`c`.`pago_estimado`),0)) AS `roi_ventas` from (((((`influencer_crm`.`influencers` `i` join `influencer_crm`.`colaboraciones` `c` on((`i`.`influencer_id` = `c`.`influencer_id`))) join `influencer_crm`.`codigos_descuento` `cd` on((`c`.`colab_id` = `cd`.`colab_id`))) left join `influencer_crm`.`ventas` `v` on((`cd`.`codigo_descuento` = `v`.`codigo_descuento`))) left join `influencer_crm`.`publicaciones` `p` on((`c`.`colab_id` = `p`.`colab_id`))) left join `influencer_crm`.`metricas_publicacion` `mp` on((`p`.`publicacion_id` = `mp`.`publicacion_id`))) where (`i`.`estado` = 'activo') group by `i`.`influencer_id`,`i`.`nombre`,`cd`.`codigo_descuento`;

-- -----------------------------------------------------
-- View `influencer_crm`.`vw_costo_por_interaccion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `influencer_crm`.`vw_costo_por_interaccion`;
USE `influencer_crm`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED 
SQL SECURITY DEFINER VIEW `influencer_crm`.`vw_costo_por_interaccion` AS select `c`.`campania_id` AS `campania_id`,sum(`c`.`pago_estimado`) AS `coste_total`,sum(((`mp`.`likes` + `mp`.`comentarios`) + `mp`.`compartidos`)) AS `interacciones_totales`,(sum(`c`.`pago_estimado`) / nullif(sum(((`mp`.`likes` + `mp`.`comentarios`) + `mp`.`compartidos`)),0)) AS `costo_por_interaccion` from ((`influencer_crm`.`colaboraciones` `c` join `influencer_crm`.`publicaciones` `p` on((`c`.`colab_id` = `p`.`colab_id`))) join `influencer_crm`.`metricas_publicacion` `mp` on((`p`.`publicacion_id` = `mp`.`publicacion_id`))) group by `c`.`campania_id`;

-- -----------------------------------------------------
-- View `influencer_crm`.`vw_engagement_tematica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `influencer_crm`.`vw_engagement_tematica`;
USE `influencer_crm`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED 
SQL SECURITY DEFINER VIEW `influencer_crm`.`vw_engagement_tematica` AS select `t`.`nombre_tematica` AS `nombre_tematica`,sum(((`mp`.`likes` + `mp`.`comentarios`) + `mp`.`compartidos`)) AS `interacciones_totales`,count(distinct `p`.`publicacion_id`) AS `publicaciones_totales`,(sum(((`mp`.`likes` + `mp`.`comentarios`) + `mp`.`compartidos`)) / nullif(count(distinct `p`.`publicacion_id`),0)) AS `engagement_promedio` from (((((`influencer_crm`.`tematicas` `t` join `influencer_crm`.`influencer_tematica` `it` on((`t`.`tematica_id` = `it`.`tematica_id`))) join `influencer_crm`.`influencers` `i` on((`it`.`influencer_id` = `i`.`influencer_id`))) join `influencer_crm`.`colaboraciones` `c` on((`i`.`influencer_id` = `c`.`influencer_id`))) join `influencer_crm`.`publicaciones` `p` on((`c`.`colab_id` = `p`.`colab_id`))) join `influencer_crm`.`metricas_publicacion` `mp` on((`p`.`publicacion_id` = `mp`.`publicacion_id`))) where (`i`.`estado` = 'activo') group by `t`.`nombre_tematica`;

-- -----------------------------------------------------
-- View `influencer_crm`.`vw_influencers_recomendados`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `influencer_crm`.`vw_influencers_recomendados`;
USE `influencer_crm`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED 
SQL SECURITY DEFINER VIEW `influencer_crm`.`vw_influencers_recomendados` AS select `i`.`influencer_id` AS `influencer_id`,`i`.`nombre` AS `nombre`,`i`.`plataforma` AS `plataforma`,`i`.`tipo_influencer` AS `tipo_influencer`,`t`.`nombre_tematica` AS `tematica`,avg((((`mp`.`likes` + `mp`.`comentarios`) + `mp`.`compartidos`) / nullif(`mp`.`impresiones`,0))) AS `engagement_real`,max(`c`.`fecha_fin`) AS `ultima_colaboracion`,`c`.`estado` AS `estado_colaboracion`,avg(((`mp`.`likes` + `mp`.`comentarios`) + `mp`.`compartidos`)) AS `promedio_interacciones` from (((((`influencer_crm`.`influencers` `i` join `influencer_crm`.`influencer_tematica` `it` on((`i`.`influencer_id` = `it`.`influencer_id`))) join `influencer_crm`.`tematicas` `t` on((`it`.`tematica_id` = `t`.`tematica_id`))) left join `influencer_crm`.`colaboraciones` `c` on((`i`.`influencer_id` = `c`.`influencer_id`))) left join `influencer_crm`.`publicaciones` `p` on((`c`.`colab_id` = `p`.`colab_id`))) left join `influencer_crm`.`metricas_publicacion` `mp` on((`p`.`publicacion_id` = `mp`.`publicacion_id`))) where (`i`.`estado` = 'activo')group by `i`.`influencer_id`,`i`.`nombre`,`i`.`plataforma`,`i`.`tipo_influencer`,`t`.`nombre_tematica`,`c`.`estado` having ((avg((((`mp`.`likes` + `mp`.`comentarios`) + `mp`.`compartidos`) / nullif(`mp`.`impresiones`,0))) >= 0.01) and (`c`.`estado` in ('finalizada','pendiente','activa')));

-- -----------------------------------------------------
-- View `influencer_crm`.`vw_roi_clicks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `influencer_crm`.`vw_roi_clicks`;
USE `influencer_crm`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED  
SQL SECURITY DEFINER VIEW `influencer_crm`.`vw_roi_clicks` AS select `i`.`nombre` AS `nombre`,sum(`mp`.`clicks`) AS `clicks_totales`,sum(`c`.`pago_estimado`) AS `inversion_total`,(sum(`mp`.`clicks`) / nullif(sum(`c`.`pago_estimado`),0)) AS `roi_clicks` from (((`influencer_crm`.`influencers` `i` join `influencer_crm`.`colaboraciones` `c` on((`i`.`influencer_id` = `c`.`influencer_id`))) join `influencer_crm`.`publicaciones` `p` on((`c`.`colab_id` = `p`.`colab_id`))) join `influencer_crm`.`metricas_publicacion` `mp` on((`p`.`publicacion_id` = `mp`.`publicacion_id`))) group by `i`.`nombre`;

-- -----------------------------------------------------
-- View `influencer_crm`.`vw_roi_engagement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `influencer_crm`.`vw_roi_engagement`;
USE `influencer_crm`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED 
SQL SECURITY DEFINER VIEW `influencer_crm`.`vw_roi_engagement` AS select `i`.`nombre` AS `nombre`,sum(((`mp`.`likes` + `mp`.`comentarios`) + `mp`.`compartidos`)) AS `interacciones_totales`,sum(`c`.`pago_estimado`) AS `inversion_total`,(sum(((`mp`.`likes` + `mp`.`comentarios`) + `mp`.`compartidos`)) / nullif(sum(`c`.`pago_estimado`),0)) AS `roi_engagement` from (((`influencer_crm`.`influencers` `i` join `influencer_crm`.`colaboraciones` `c` on((`i`.`influencer_id` = `c`.`influencer_id`))) join `influencer_crm`.`publicaciones` `p` on((`c`.`colab_id` = `p`.`colab_id`))) join `influencer_crm`.`metricas_publicacion` `mp` on((`p`.`publicacion_id` = `mp`.`publicacion_id`))) group by `i`.`nombre`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- =====================================================
-- Índices para consultas analíticas
-- =====================================================

CREATE INDEX idx_colab_fechas ON colaboraciones(fecha_inicio, fecha_fin);
CREATE INDEX idx_metricas_fecha ON metricas_publicacion(fecha_medicion);
CREATE INDEX idx_campanas_estado_fechas ON campanas(estado, fecha_inicio, fecha_fin);
CREATE INDEX idx_influencers_pais_tipo ON influencers(pais, tipo_influencer);
CREATE INDEX idx_publicaciones_plataforma ON publicaciones(plataforma);
