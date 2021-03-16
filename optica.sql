DROP DATABASE IF EXISTS optica;
CREATE DATABASE optica CHARACTER SET utf8mb4;
USE optica;

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
  `proveidor_ciutat` VARCHAR(45) NOT NULL,
  `proveidor_codi_postal` VARCHAR(20) NOT NULL,
  `proveidor_pais` VARCHAR(45) NOT NULL,
  `proveidor_telefon` VARCHAR(20) NOT NULL,
  `proveidor_fax` VARCHAR(20) NULL,
  `proveidor_NIF` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`proveidor_id`))
;


-- -----------------------------------------------------
-- Table `marca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `marca` (
  `marca_id` INT NOT NULL AUTO_INCREMENT,
  `marca_nom` VARCHAR(45) NOT NULL,
  `proveidor_id` INT NOT NULL,
  PRIMARY KEY (`marca_id`),
  FOREIGN KEY (`proveidor_id`)
    REFERENCES `proveidor` (`proveidor_id`)
    );


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
  `client_ciutat` VARCHAR(45) NOT NULL,
  `client_codi_postal` VARCHAR(20) NOT NULL,
  `client_pais` VARCHAR(45) NOT NULL,
  `client_telefon` VARCHAR(20) NOT NULL,
  `client_email` VARCHAR(45) NULL,
  `client_data_registre` DATE NOT NULL,
  `client_recomana_id` INT NULL DEFAULT NULL COMMENT 'Indica el client que li ha recomanat',
  PRIMARY KEY (`client_id`),
  FOREIGN KEY (`client_recomana_id`)
    REFERENCES `client` (`client_id`)
    );


-- -----------------------------------------------------
-- Table `factura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `factura` (
  `factura_id` INT NOT NULL AUTO_INCREMENT,
  `factura_data` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `factura_total` FLOAT NOT NULL,
  `client_id` INT NOT NULL,
  PRIMARY KEY (`factura_id`, `client_id`),
  FOREIGN KEY (`client_id`)
    REFERENCES `client` (`client_id`)
    );


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
  `ulleres_data` DATE NOT NULL,
  `marca_id` INT NOT NULL,
  `proveidor_id` INT NOT NULL,
  `empleat_venedor_id` INT NOT NULL COMMENT 'Empleat que ha venut les ulleres',
  `factura_id` INT NOT NULL,
  PRIMARY KEY (`ulleres_id`, `factura_id`),
  FOREIGN KEY (`marca_id`)
    REFERENCES `marca` (`marca_id`),
  FOREIGN KEY (`empleat_venedor_id`)
    REFERENCES `empleat` (`empleat_id`),
  FOREIGN KEY (`factura_id`)
    REFERENCES `factura` (`factura_id`)
    );

-- -----------------------
--    Carga proveidor
-- -----------------------
INSERT INTO proveidor VALUES
	(1,'Ulleres +', 'c/Sol','43',NULL,NULL,'Sitges','08870','Espanya',123123123132,NULL,'123123123123J'),
	(2,'Masgafas', 'Plaza Mayor','2',NULL,NULL,'Barcelona','08008','Espanya',934567890,NULL,'9898989898K'),
	(3,'Cristalitos +', 'c/Lluna','13','bajos','A','Sitges','08870','Espanya',9898988898,NULL,'436567567H'),
	(4,'Rompetechos', 'Avda Luz','1',NULL,NULL,'Barcelona','08013','Espanya',9312345676,NULL,'8989898989I');
    
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
	(1,'John', 'Smith',NULL,'c/PereII','45','casa 3',NULL,'Sitges','08870','Espanya',609090909,'johnie@gmail.com','2021-03-01',NULL),
	(2,'Jacinta', 'Grande','Lobo','c/Flors','27','3r','A','Sitges','08870','Espanya',938949494,'jacinta@gmail.com','2018-02-02',1),
	(3,'Nil', 'Martí','Roca','Avda Foix','s/n',NULL,NULL,'Barcelona','08008','Espanya',6344567,'nilmar@gmail.com','2020-12-02',1);
    
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
	(1,1.25,1.50,'pasta','blau',NULL,NULL,150.15,'2019-01-01',2,1,1,1),
	(2,0,0,'flotant','or','verd','verd',100.00,'2020-03-01',1,1,1,1),
	(3,3.25,4.50,'pasta','gris',NULL,NULL,140.15,'2019-02-01',3,2,2,2),
	(4,4,1,'flotant','negre',NULL,NULL,200.20,'2020-03-01',1,1,2,3);


-- Llista el total de factures d'un client en un període determinat

SELECT SUM(factura_total) from factura
WHERE client_id = 2 AND factura_data between '2021-01-01 00:00:00' AND '2021-03-15';

-- Llista els diferents models d'ulleres que ha venut un empleat durant un any

SELECT * FROM ulleres 
INNER JOIN factura ON factura.factura_id = ulleres.factura_id
WHERE client_id = 2;

-- Llista els diferents proveïdors que han subministrat ulleres venudes amb èxit per l'òptica

SELECT proveidor_nom, COUNT(ulleres_id) FROM proveidor 
INNER JOIN ulleres WHERE ulleres.proveidor_id = proveidor.proveidor_id
GROUP BY proveidor_nom;