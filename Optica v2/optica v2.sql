
DROP DATABASE IF EXISTS optica;
CREATE DATABASE optica CHARACTER SET utf8mb4;
USE optica;

-- -----------------------------------------------------
-- Table `provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `provincia` (
  `provincia_id` INT NOT NULL,
  `provincia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`provincia_id`));

-- -----------------------------------------------------
-- Table `localidad`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `localidad` (
  `localidad_id` INT NOT NULL,
  `localidad` VARCHAR(45) NOT NULL,
  `provincia_id` INT NOT NULL,
  PRIMARY KEY (`provincia_id`, `localidad_id`),
  INDEX `fk_localidad_provincia1_idx` (`provincia_id` ASC) VISIBLE,
  FOREIGN KEY (`provincia_id`)
    REFERENCES `provincia` (`provincia_id`));

-- -----------------------------------------------------
-- Table `proveidor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `proveidor` (
  `proveidor_id` INT NOT NULL AUTO_INCREMENT,
  `proveidor_nom` VARCHAR(45) NOT NULL,
  `proveidor_carrer` VARCHAR(45) NOT NULL,
  `proveidor_num_carrer` VARCHAR(20) NULL,
  `proveidor_pis` VARCHAR(10) NULL,
  `proveidor_porta` VARCHAR(10) NULL,
  `proveidor_codi_postal` VARCHAR(20) NOT NULL,
  `proveidor_pais` VARCHAR(45) NOT NULL,
  `proveidor_telefon` VARCHAR(20) NOT NULL,
  `proveidor_fax` VARCHAR(20) NULL,
  `proveidor_NIF` VARCHAR(20) NOT NULL,
  `localidad_provincia_id` INT NOT NULL,
  `localidad_localidad_id` INT NOT NULL,
  PRIMARY KEY (`proveidor_id`),
  INDEX `fk_proveidor_localidad1_idx` (`localidad_provincia_id` ASC, `localidad_localidad_id` ASC) VISIBLE,
  FOREIGN KEY (`localidad_provincia_id` , `localidad_localidad_id`)
    REFERENCES `localidad` (`provincia_id` , `localidad_id`));

-- -----------------------------------------------------
-- Table `marca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `marca` (
  `marca_id` INT NOT NULL AUTO_INCREMENT,
  `marca_nom` VARCHAR(45) NOT NULL,
  `proveidor_id` INT NOT NULL,
  PRIMARY KEY (`marca_id`),
  INDEX `fk_marca_proveidor1_idx` (`proveidor_id` ASC) VISIBLE,
  FOREIGN KEY (`proveidor_id`)
    REFERENCES `proveidor` (`proveidor_id`));

-- -----------------------------------------------------
-- Table `ulleres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ulleres` (
  `ulleres_id` INT NOT NULL AUTO_INCREMENT,
  `ulleres_graduacio_esq` FLOAT NOT NULL,
  `ulleres_graduacio_dret` FLOAT NOT NULL,
  `ulleres_tipus_muntura` ENUM('Flotant', 'Pasta', 'Metàl·lica') NOT NULL COMMENT 'Valors possibles: Flotant, Pasta, Metàl·lica',
  `ulleres_color_muntura` VARCHAR(20) NOT NULL,
  `ulleres_color_esq` VARCHAR(20) NULL,
  `ulleres_color_dre` VARCHAR(20) NULL,
  `ulleres_preu` FLOAT UNSIGNED NOT NULL,
  `marca_id` INT NOT NULL,
  `proveidor_id` INT NOT NULL,
  PRIMARY KEY (`ulleres_id`),
  INDEX `fk_ulleres_marca1_idx` (`marca_id` ASC) VISIBLE,
  FOREIGN KEY (`marca_id`)
    REFERENCES `marca` (`marca_id`));

-- -----------------------------------------------------
-- Table `client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `client` (
  `client_id` INT NOT NULL AUTO_INCREMENT,
  `client_nom` VARCHAR(45) NOT NULL,
  `client_cognom1` VARCHAR(45) NOT NULL,
  `client_cognom2` VARCHAR(45) NULL,
  `client_carrer` VARCHAR(45) NOT NULL,
  `client_num_carrer` VARCHAR(20) NULL,
  `client_pis` VARCHAR(10) NULL,
  `client_porta` VARCHAR(10) NULL,
  `client_codi_postal` VARCHAR(20) NOT NULL,
  `client_pais` VARCHAR(45) NOT NULL,
  `client_telefon` VARCHAR(20) NOT NULL,
  `client_email` VARCHAR(45) NULL,
  `client_data_registre` DATE NOT NULL,
  `client_recomana_id` INT NULL DEFAULT NULL COMMENT 'Indica el client que li ha recomanat',
  `localidad_provincia_id` INT NOT NULL,
  `localidad_localidad_id` INT NOT NULL,
  PRIMARY KEY (`client_id`),
  INDEX `fk_client_client_idx` (`client_recomana_id` ASC) VISIBLE,
  INDEX `fk_client_localidad1_idx` (`localidad_provincia_id` ASC, `localidad_localidad_id` ASC) VISIBLE,
  FOREIGN KEY (`client_recomana_id`)
    REFERENCES `client` (`client_id`),
  FOREIGN KEY (`localidad_provincia_id` , `localidad_localidad_id`)
    REFERENCES `localidad` (`provincia_id` , `localidad_id`));

-- -----------------------------------------------------
-- Table `empleat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `empleat` (
  `empleat_id` INT NOT NULL AUTO_INCREMENT,
  `empleat_nom` VARCHAR(45) NOT NULL,
  `empleat_cognom1` VARCHAR(45) NOT NULL,
  `empleat_cognom2` VARCHAR(45) NULL,
  `empleat_NIF` VARCHAR(20) NOT NULL,
  `empleat_data_alta` DATE NOT NULL,
  PRIMARY KEY (`empleat_id`));

-- -----------------------------------------------------
-- Table `factura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `factura` (
  `factura_id` INT NOT NULL AUTO_INCREMENT,
  `factura_data` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `factura_total` FLOAT NOT NULL,
  `client_id` INT NOT NULL,
  PRIMARY KEY (`factura_id`, `client_id`),
  INDEX `fk_factura_client1_idx` (`client_id` ASC) VISIBLE,
  FOREIGN KEY (`client_id`)
    REFERENCES `client` (`client_id`));

-- -----------------------------------------------------
-- Table `linia_factura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `linia_factura` (
  `linia_factura_id` INT NOT NULL AUTO_INCREMENT,
  `factura_factura_id` INT NOT NULL,
  `linia_factura_preu` INT NOT NULL,
  `factura_client_id` INT NOT NULL,
  `ulleres_ulleres_id` INT NOT NULL,
  `empleat_empleat_id` INT NOT NULL,
  PRIMARY KEY (`linia_factura_id`, `factura_factura_id`),
  INDEX `fk_linia_factura_factura1_idx` (`factura_factura_id` ASC, `factura_client_id` ASC) VISIBLE,
  INDEX `fk_linia_factura_ulleres1_idx` (`ulleres_ulleres_id` ASC) VISIBLE,
  INDEX `fk_linia_factura_empleat1_idx` (`empleat_empleat_id` ASC) VISIBLE,
  FOREIGN KEY (`factura_factura_id` , `factura_client_id`)
    REFERENCES `factura` (`factura_id` , `client_id`),
  FOREIGN KEY (`ulleres_ulleres_id`)
    REFERENCES `ulleres` (`ulleres_id`),
  FOREIGN KEY (`empleat_empleat_id`)
    REFERENCES `empleat` (`empleat_id`));

-- ----------------------------
-- Carga provincia
-- ----------------------------
INSERT INTO `provincia` 
VALUES	
	(8,'Barcelona'),
	(17,'Girona');
    
-- ----------------------------
-- Carga localitat
-- -----------------------------
INSERT INTO localidad VALUES	(1, 'Sitges', 8);
INSERT INTO localidad VALUES	(2, 'Barcelona', 8);
INSERT INTO localidad VALUES	(3, 'Mataró', 8);
INSERT INTO localidad VALUES	(4, 'Figueres', 17);
INSERT INTO localidad VALUES	(5, 'Girona', 17);

-- -----------------------
--    Carga proveidor
-- -----------------------
INSERT INTO proveidor VALUES
	(1,'Ulleres +', 'c/Sol','43',NULL,NULL,'08870','Espanya',123123123132,NULL,'123123123123J',8,1),
	(2,'Masgafas', 'Plaza Mayor','2',NULL,NULL,'08008','Espanya',934567890,NULL,'9898989898K',8,2),
	(3,'Cristalitos +', 'c/Lluna','13','bajos','A','08870','Espanya',9898988898,NULL,'436567567H',17,4),
	(4,'Rompetechos', 'Avda Luz','1',NULL,NULL,'08013','Espanya',9312345676,NULL,'8989898989I',17,5);
    
-- -----------------------
--    Carga marca
-- -----------------------
INSERT INTO marca VALUES
	(1,'Raypan',1),
	(2,'Voga',1),
	(3,'Vision',2),
	(4,'Guchi',2);

-- -----------------------
--    Carga empleat
-- -----------------------
INSERT INTO empleat VALUES
	(1,'Paco', 'Perez',NULL,'X123412345','2020-01-02' ),
	(2,'Lola', 'Garse','Garse','12345678K','2019-01-02' ),
	(3,'Paco', 'Perez',NULL,'X123412345','2020-01-02' );  

-- -----------------------
--    Carga client
-- -----------------------
INSERT INTO client VALUES
	(1,'John', 'Smith',NULL,'c/PereII','45','casa 3',NULL,'08870','Espanya',609090909,'johnie@gmail.com','2021-03-01',NULL,8,1),
	(2,'Jacinta', 'Grande','Lobo','c/Flors','27','3r','A','08870','Espanya',938949494,'jacinta@gmail.com','2018-02-02',1,8,2),
	(3,'Nil', 'Martí','Roca','Avda Foix','s/n',NULL,NULL,'08008','Espanya',6344567,'nilmar@gmail.com','2020-12-02',1,8,3);
    
-- -----------------------
--    Carga factura
-- -----------------------
INSERT INTO factura VALUES
	(1,'2020-10-28',200.15,2),
	(2,'2020-11-03',140.15,3),
	(3,'2021-01-15',200.2,2);
    
-- -----------------------
--    Carga ulleres
-- -----------------------
INSERT INTO ulleres VALUES
	(1,1.25,1.50,'pasta','blau',NULL,NULL,150.15,2,1),
	(2,0,0,'flotant','or','verd','verd',100.00,1,1),
	(3,3.25,4.50,'pasta','gris',NULL,NULL,140.15,3,2),
	(4,4,1,'flotant','negre',NULL,NULL,200.20,1,1);

-- -----------------------
--    Carga linia_factura
-- -----------------------
INSERT INTO linia_factura VALUES
	(1,1,150.15,2,1,3),
	(2,1,100.00,2,2,3),
	(1,2,140.15,3,3,1),
	(1,3,200.20,2,2,1);



-- Llista el total de factures d'un client en un període determinat

SELECT SUM(factura_total) from factura
WHERE client_id = 2 AND factura_data between '2021-01-01 00:00:00' AND '2021-03-15';

-- Llista els diferents models d'ulleres que ha venut un empleat durant un any

SELECT * FROM ulleres 
INNER JOIN linia_factura ON linia_factura.ulleres_ulleres_id = ulleres.ulleres_id
INNER JOIN factura ON factura.factura_id = linia_factura.factura_factura_id
WHERE empleat_empleat_id = 1 and factura_data between '2020-01-01 00:00:00' AND '2021-01-01 00:00:00 ';

-- Llista els diferents proveïdors que han subministrat ulleres venudes amb èxit per l'òptica

SELECT proveidor_nom, COUNT(ulleres_id) FROM proveidor 
INNER JOIN ulleres WHERE ulleres.proveidor_id = proveidor.proveidor_id
GROUP BY proveidor_nom;