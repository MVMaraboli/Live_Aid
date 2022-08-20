-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema live_aid
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema live_aid
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `live_aid` DEFAULT CHARACTER SET utf8 ;
USE `live_aid` ;

-- -----------------------------------------------------
-- Table `live_aid`.`cuotas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`cuotas` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`cuotas` (
  `cuotas_id` INT NOT NULL AUTO_INCREMENT,
  `cuotas_plan` VARCHAR(45) NOT NULL,
  `cuotas_valor` INT NOT NULL,
  PRIMARY KEY (`cuotas_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `live_aid`.`pais`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`pais` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`pais` (
  `pais_id` INT NOT NULL AUTO_INCREMENT,
  `pais_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`pais_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `live_aid`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`city` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`city` (
  `city_id` INT NOT NULL AUTO_INCREMENT,
  `city_name` VARCHAR(45) NOT NULL,
  `city_idpais` VARCHAR(45) NOT NULL,
  `pais_pais_id` INT NOT NULL,
  PRIMARY KEY (`city_id`, `city_idpais`),
  CONSTRAINT `fk_city_pais`
    FOREIGN KEY (`pais_pais_id`)
    REFERENCES `live_aid`.`pais` (`pais_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_city_pais_idx` ON `live_aid`.`city` (`pais_pais_id` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`socios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`socios` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`socios` (
  `socio_id` INT NOT NULL AUTO_INCREMENT,
  `socio_dni` VARCHAR(45) NOT NULL,
  `socio_name` VARCHAR(100) NOT NULL,
  `socio_address` VARCHAR(100) NOT NULL,
  `socio_city` VARCHAR(45) NOT NULL,
  `socio_nctab` VARCHAR(45) NOT NULL,
  `socio_bancosid` INT NOT NULL,
  `socio_tcuota` INT NOT NULL,
  `cuotas_cuotas_id` INT NOT NULL,
  `socio_fechapago` DATE NOT NULL,
  `city_city_id` INT NOT NULL,
  `city_city_idpais` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`socio_id`, `socio_dni`, `socio_bancosid`, `socio_tcuota`, `socio_nctab`, `socio_fechapago`),
  CONSTRAINT `fk_socios_cuotas1`
    FOREIGN KEY (`cuotas_cuotas_id`)
    REFERENCES `live_aid`.`cuotas` (`cuotas_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_socios_city1`
    FOREIGN KEY (`city_city_id` , `city_city_idpais`)
    REFERENCES `live_aid`.`city` (`city_id` , `city_idpais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_socios_cuotas1_idx` ON `live_aid`.`socios` (`cuotas_cuotas_id` ASC) ;

CREATE INDEX `fk_socios_city1_idx` ON `live_aid`.`socios` (`city_city_id` ASC, `city_city_idpais` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`sedes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`sedes` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`sedes` (
  `sedes_id` INT NOT NULL AUTO_INCREMENT,
  `sedes_idcity` INT NOT NULL,
  `sedes_address` VARCHAR(60) NOT NULL,
  `sede_director` VARCHAR(60) NOT NULL,
  `city_city_id` INT NOT NULL,
  `city_city_idpais` VARCHAR(45) NOT NULL,
  `socios_socio_id` INT NOT NULL,
  `socios_socio_dni` VARCHAR(45) NOT NULL,
  `socios_socio_bancoid` INT NOT NULL,
  `socios_socio_tcuota` INT NOT NULL,
  PRIMARY KEY (`sedes_id`, `sedes_idcity`),
  CONSTRAINT `fk_sedes_city1`
    FOREIGN KEY (`city_city_id` , `city_city_idpais`)
    REFERENCES `live_aid`.`city` (`city_id` , `city_idpais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sedes_socios1`
    FOREIGN KEY (`socios_socio_id` , `socios_socio_dni` , `socios_socio_bancoid` , `socios_socio_tcuota`)
    REFERENCES `live_aid`.`socios` (`socio_id` , `socio_dni` , `socio_bancosid` , `socio_tcuota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_sedes_city1_idx` ON `live_aid`.`sedes` (`city_city_id` ASC, `city_city_idpais` ASC) ;

CREATE INDEX `fk_sedes_socios1_idx` ON `live_aid`.`sedes` (`socios_socio_id` ASC, `socios_socio_dni` ASC, `socios_socio_bancoid` ASC, `socios_socio_tcuota` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`bancos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`bancos` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`bancos` (
  `bancos_id` INT NOT NULL AUTO_INCREMENT,
  `banco_name` VARCHAR(45) NOT NULL,
  `socios_socio_id` INT NOT NULL,
  `socios_socio_dni` VARCHAR(45) NOT NULL,
  `socios_socio_bancosid` INT NOT NULL,
  `socios_socio_tcuota` INT NOT NULL,
  PRIMARY KEY (`bancos_id`),
  CONSTRAINT `fk_bancos_socios1`
    FOREIGN KEY (`socios_socio_id` , `socios_socio_dni` , `socios_socio_bancosid` , `socios_socio_tcuota`)
    REFERENCES `live_aid`.`socios` (`socio_id` , `socio_dni` , `socio_bancosid` , `socio_tcuota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_bancos_socios1_idx` ON `live_aid`.`bancos` (`socios_socio_id` ASC, `socios_socio_dni` ASC, `socios_socio_bancosid` ASC, `socios_socio_tcuota` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`cobro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`cobro` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`cobro` (
  `cobro_id` INT NOT NULL AUTO_INCREMENT,
  `cobro_socioid` INT NOT NULL,
  `cobro_banco` INT NOT NULL,
  `cobro_ctab` INT NOT NULL,
  `cobro_sede` INT NOT NULL,
  `cobro_idcuota` INT NOT NULL,
  `cobro_fechasocio` DATE NOT NULL,
  PRIMARY KEY (`cobro_id`, `cobro_socioid`, `cobro_banco`, `cobro_ctab`, `cobro_sede`, `cobro_idcuota`, `cobro_fechasocio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `live_aid`.`cobro_has_cuotas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`cobro_has_cuotas` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`cobro_has_cuotas` (
  `cobro_cobro_id` INT NOT NULL,
  `cobro_cobro_socioid` INT NOT NULL,
  `cobro_cobro_banco` INT NOT NULL,
  `cobro_cobro_ctab` INT NOT NULL,
  `cobro_cobro_sede` INT NOT NULL,
  `cobro_cobro_idcuota` INT NOT NULL,
  `cuotas_cuotas_id` INT NOT NULL,
  PRIMARY KEY (`cobro_cobro_id`, `cobro_cobro_socioid`, `cobro_cobro_banco`, `cobro_cobro_ctab`, `cobro_cobro_sede`, `cobro_cobro_idcuota`, `cuotas_cuotas_id`),
  CONSTRAINT `fk_cobro_has_cuotas_cobro1`
    FOREIGN KEY (`cobro_cobro_id` , `cobro_cobro_socioid` , `cobro_cobro_banco` , `cobro_cobro_ctab` , `cobro_cobro_sede` , `cobro_cobro_idcuota`)
    REFERENCES `live_aid`.`cobro` (`cobro_id` , `cobro_socioid` , `cobro_banco` , `cobro_ctab` , `cobro_sede` , `cobro_idcuota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cobro_has_cuotas_cuotas1`
    FOREIGN KEY (`cuotas_cuotas_id`)
    REFERENCES `live_aid`.`cuotas` (`cuotas_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_cobro_has_cuotas_cuotas1_idx` ON `live_aid`.`cobro_has_cuotas` (`cuotas_cuotas_id` ASC) ;

CREATE INDEX `fk_cobro_has_cuotas_cobro1_idx` ON `live_aid`.`cobro_has_cuotas` (`cobro_cobro_id` ASC, `cobro_cobro_socioid` ASC, `cobro_cobro_banco` ASC, `cobro_cobro_ctab` ASC, `cobro_cobro_sede` ASC, `cobro_cobro_idcuota` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`cobro_has_bancos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`cobro_has_bancos` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`cobro_has_bancos` (
  `cobro_cobro_id` INT NOT NULL,
  `cobro_cobro_socioid` INT NOT NULL,
  `cobro_cobro_banco` INT NOT NULL,
  `cobro_cobro_ctab` INT NOT NULL,
  `cobro_cobro_sede` INT NOT NULL,
  `cobro_cobro_idcuota` INT NOT NULL,
  `bancos_bancos_id` INT NOT NULL,
  PRIMARY KEY (`cobro_cobro_id`, `cobro_cobro_socioid`, `cobro_cobro_banco`, `cobro_cobro_ctab`, `cobro_cobro_sede`, `cobro_cobro_idcuota`, `bancos_bancos_id`),
  CONSTRAINT `fk_cobro_has_bancos_cobro1`
    FOREIGN KEY (`cobro_cobro_id` , `cobro_cobro_socioid` , `cobro_cobro_banco` , `cobro_cobro_ctab` , `cobro_cobro_sede` , `cobro_cobro_idcuota`)
    REFERENCES `live_aid`.`cobro` (`cobro_id` , `cobro_socioid` , `cobro_banco` , `cobro_ctab` , `cobro_sede` , `cobro_idcuota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cobro_has_bancos_bancos1`
    FOREIGN KEY (`bancos_bancos_id`)
    REFERENCES `live_aid`.`bancos` (`bancos_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_cobro_has_bancos_bancos1_idx` ON `live_aid`.`cobro_has_bancos` (`bancos_bancos_id` ASC) ;

CREATE INDEX `fk_cobro_has_bancos_cobro1_idx` ON `live_aid`.`cobro_has_bancos` (`cobro_cobro_id` ASC, `cobro_cobro_socioid` ASC, `cobro_cobro_banco` ASC, `cobro_cobro_ctab` ASC, `cobro_cobro_sede` ASC, `cobro_cobro_idcuota` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`sedes_has_cobro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`sedes_has_cobro` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`sedes_has_cobro` (
  `sedes_sedes_id` INT NOT NULL,
  `sedes_sedes_idcity` INT NOT NULL,
  `cobro_cobro_id` INT NOT NULL,
  `cobro_cobro_socioid` INT NOT NULL,
  `cobro_cobro_banco` INT NOT NULL,
  `cobro_cobro_ctab` INT NOT NULL,
  `cobro_cobro_sede` INT NOT NULL,
  `cobro_cobro_idcuota` INT NOT NULL,
  PRIMARY KEY (`sedes_sedes_id`, `sedes_sedes_idcity`, `cobro_cobro_id`, `cobro_cobro_socioid`, `cobro_cobro_banco`, `cobro_cobro_ctab`, `cobro_cobro_sede`, `cobro_cobro_idcuota`),
  CONSTRAINT `fk_sedes_has_cobro_sedes1`
    FOREIGN KEY (`sedes_sedes_id` , `sedes_sedes_idcity`)
    REFERENCES `live_aid`.`sedes` (`sedes_id` , `sedes_idcity`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sedes_has_cobro_cobro1`
    FOREIGN KEY (`cobro_cobro_id` , `cobro_cobro_socioid` , `cobro_cobro_banco` , `cobro_cobro_ctab` , `cobro_cobro_sede` , `cobro_cobro_idcuota`)
    REFERENCES `live_aid`.`cobro` (`cobro_id` , `cobro_socioid` , `cobro_banco` , `cobro_ctab` , `cobro_sede` , `cobro_idcuota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_sedes_has_cobro_cobro1_idx` ON `live_aid`.`sedes_has_cobro` (`cobro_cobro_id` ASC, `cobro_cobro_socioid` ASC, `cobro_cobro_banco` ASC, `cobro_cobro_ctab` ASC, `cobro_cobro_sede` ASC, `cobro_cobro_idcuota` ASC) ;

CREATE INDEX `fk_sedes_has_cobro_sedes1_idx` ON `live_aid`.`sedes_has_cobro` (`sedes_sedes_id` ASC, `sedes_sedes_idcity` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`cobro_has_socios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`cobro_has_socios` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`cobro_has_socios` (
  `cobro_cobro_id` INT NOT NULL,
  `cobro_cobro_socioid` INT NOT NULL,
  `cobro_cobro_banco` INT NOT NULL,
  `cobro_cobro_ctab` INT NOT NULL,
  `cobro_cobro_sede` INT NOT NULL,
  `cobro_cobro_idcuota` INT NOT NULL,
  `cobro_cobro_fechasocio` DATE NOT NULL,
  `socios_socio_id` INT NOT NULL,
  `socios_socio_dni` VARCHAR(45) NOT NULL,
  `socios_socio_bancosid` INT NOT NULL,
  `socios_socio_tcuota` INT NOT NULL,
  `socios_socio_nctab` VARCHAR(45) NOT NULL,
  `socios_socio_fechapago` DATE NOT NULL,
  PRIMARY KEY (`cobro_cobro_id`, `cobro_cobro_socioid`, `cobro_cobro_banco`, `cobro_cobro_ctab`, `cobro_cobro_sede`, `cobro_cobro_idcuota`, `cobro_cobro_fechasocio`, `socios_socio_id`, `socios_socio_dni`, `socios_socio_bancosid`, `socios_socio_tcuota`, `socios_socio_nctab`, `socios_socio_fechapago`),
  CONSTRAINT `fk_cobro_has_socios_cobro1`
    FOREIGN KEY (`cobro_cobro_id` , `cobro_cobro_socioid` , `cobro_cobro_banco` , `cobro_cobro_ctab` , `cobro_cobro_sede` , `cobro_cobro_idcuota` , `cobro_cobro_fechasocio`)
    REFERENCES `live_aid`.`cobro` (`cobro_id` , `cobro_socioid` , `cobro_banco` , `cobro_ctab` , `cobro_sede` , `cobro_idcuota` , `cobro_fechasocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cobro_has_socios_socios1`
    FOREIGN KEY (`socios_socio_id` , `socios_socio_dni` , `socios_socio_bancosid` , `socios_socio_tcuota` , `socios_socio_nctab` , `socios_socio_fechapago`)
    REFERENCES `live_aid`.`socios` (`socio_id` , `socio_dni` , `socio_bancosid` , `socio_tcuota` , `socio_nctab` , `socio_fechapago`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_cobro_has_socios_socios1_idx` ON `live_aid`.`cobro_has_socios` (`socios_socio_id` ASC, `socios_socio_dni` ASC, `socios_socio_bancosid` ASC, `socios_socio_tcuota` ASC, `socios_socio_nctab` ASC, `socios_socio_fechapago` ASC) ;

CREATE INDEX `fk_cobro_has_socios_cobro1_idx` ON `live_aid`.`cobro_has_socios` (`cobro_cobro_id` ASC, `cobro_cobro_socioid` ASC, `cobro_cobro_banco` ASC, `cobro_cobro_ctab` ASC, `cobro_cobro_sede` ASC, `cobro_cobro_idcuota` ASC, `cobro_cobro_fechasocio` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`voluntarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`voluntarios` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`voluntarios` (
  `v_id` INT NOT NULL AUTO_INCREMENT,
  `v_dni` VARCHAR(45) NOT NULL,
  `v_name` VARCHAR(80) NOT NULL,
  `v_address` VARCHAR(45) NOT NULL,
  `v_idcity` VARCHAR(45) NOT NULL,
  `v_titulo` VARCHAR(45) NOT NULL,
  `v_trabajos` INT NOT NULL,
  `v_tipo` VARCHAR(30) NOT NULL,
  `v_diponible` BIT(1) NOT NULL,
  `sedes_sedes_id` INT NOT NULL,
  `sedes_sedes_idcity` INT NOT NULL,
  PRIMARY KEY (`v_id`, `v_dni`, `v_name`, `v_idcity`, `v_titulo`, `v_tipo`),
  CONSTRAINT `fk_voluntarios_sedes1`
    FOREIGN KEY (`sedes_sedes_id` , `sedes_sedes_idcity`)
    REFERENCES `live_aid`.`sedes` (`sedes_id` , `sedes_idcity`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_voluntarios_sedes1_idx` ON `live_aid`.`voluntarios` (`sedes_sedes_id` ASC, `sedes_sedes_idcity` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`help_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`help_type` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`help_type` (
  `help_id` INT NOT NULL AUTO_INCREMENT,
  `help_desc` VARCHAR(45) NOT NULL,
  `help_stock` INT NOT NULL,
  PRIMARY KEY (`help_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `live_aid`.`send_help`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`send_help` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`send_help` (
  `send_id` INT NOT NULL AUTO_INCREMENT,
  `send_destino` VARCHAR(45) NOT NULL,
  `send_fecha` VARCHAR(45) NOT NULL,
  `send_lider` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`send_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `live_aid`.`detail_send`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`detail_send` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`detail_send` (
  `d_id` INT NOT NULL AUTO_INCREMENT,
  `d_sendid` INT NOT NULL,
  `d_vid` INT NOT NULL,
  `d_vtipo` VARCHAR(45) NOT NULL,
  `d_helpid` INT NOT NULL,
  `d_desc` VARCHAR(45) NOT NULL,
  `d_cantidad` INT NOT NULL,
  `d_um` VARCHAR(45) NOT NULL,
  `send_help_send_id` INT NOT NULL,
  PRIMARY KEY (`d_id`, `d_sendid`, `d_vid`, `d_vtipo`, `d_helpid`),
  CONSTRAINT `fk_detail_send_send_help1`
    FOREIGN KEY (`send_help_send_id`)
    REFERENCES `live_aid`.`send_help` (`send_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_detail_send_send_help1_idx` ON `live_aid`.`detail_send` (`send_help_send_id` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`voluntarios_has_help_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`voluntarios_has_help_type` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`voluntarios_has_help_type` (
  `voluntarios_v_id` INT NOT NULL,
  `voluntarios_v_dni` VARCHAR(45) NOT NULL,
  `voluntarios_v_name` VARCHAR(80) NOT NULL,
  `voluntarios_v_idcity` VARCHAR(45) NOT NULL,
  `voluntarios_v_titulo` VARCHAR(45) NOT NULL,
  `voluntarios_v_tipo` VARCHAR(30) NOT NULL,
  `help_type_help_id` INT NOT NULL,
  PRIMARY KEY (`voluntarios_v_id`, `voluntarios_v_dni`, `voluntarios_v_name`, `voluntarios_v_idcity`, `voluntarios_v_titulo`, `voluntarios_v_tipo`, `help_type_help_id`),
  CONSTRAINT `fk_voluntarios_has_help_type_voluntarios1`
    FOREIGN KEY (`voluntarios_v_id` , `voluntarios_v_dni` , `voluntarios_v_name` , `voluntarios_v_idcity` , `voluntarios_v_titulo` , `voluntarios_v_tipo`)
    REFERENCES `live_aid`.`voluntarios` (`v_id` , `v_dni` , `v_name` , `v_idcity` , `v_titulo` , `v_tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_voluntarios_has_help_type_help_type1`
    FOREIGN KEY (`help_type_help_id`)
    REFERENCES `live_aid`.`help_type` (`help_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_voluntarios_has_help_type_help_type1_idx` ON `live_aid`.`voluntarios_has_help_type` (`help_type_help_id` ASC) ;

CREATE INDEX `fk_voluntarios_has_help_type_voluntarios1_idx` ON `live_aid`.`voluntarios_has_help_type` (`voluntarios_v_id` ASC, `voluntarios_v_dni` ASC, `voluntarios_v_name` ASC, `voluntarios_v_idcity` ASC, `voluntarios_v_titulo` ASC, `voluntarios_v_tipo` ASC) ;


-- -----------------------------------------------------
-- Table `live_aid`.`help_type_has_detail_send`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `live_aid`.`help_type_has_detail_send` ;

CREATE TABLE IF NOT EXISTS `live_aid`.`help_type_has_detail_send` (
  `help_type_help_id` INT NOT NULL,
  `detail_send_d_id` INT NOT NULL,
  `detail_send_d_sendid` INT NOT NULL,
  `detail_send_d_vid` INT NOT NULL,
  `detail_send_d_vtipo` VARCHAR(45) NOT NULL,
  `detail_send_d_helpid` INT NOT NULL,
  PRIMARY KEY (`help_type_help_id`, `detail_send_d_id`, `detail_send_d_sendid`, `detail_send_d_vid`, `detail_send_d_vtipo`, `detail_send_d_helpid`),
  CONSTRAINT `fk_help_type_has_detail_send_help_type1`
    FOREIGN KEY (`help_type_help_id`)
    REFERENCES `live_aid`.`help_type` (`help_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_help_type_has_detail_send_detail_send1`
    FOREIGN KEY (`detail_send_d_id` , `detail_send_d_sendid` , `detail_send_d_vid` , `detail_send_d_vtipo` , `detail_send_d_helpid`)
    REFERENCES `live_aid`.`detail_send` (`d_id` , `d_sendid` , `d_vid` , `d_vtipo` , `d_helpid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_help_type_has_detail_send_detail_send1_idx` ON `live_aid`.`help_type_has_detail_send` (`detail_send_d_id` ASC, `detail_send_d_sendid` ASC, `detail_send_d_vid` ASC, `detail_send_d_vtipo` ASC, `detail_send_d_helpid` ASC) ;

CREATE INDEX `fk_help_type_has_detail_send_help_type1_idx` ON `live_aid`.`help_type_has_detail_send` (`help_type_help_id` ASC) ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
