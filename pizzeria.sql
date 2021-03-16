DROP DATABASE IF EXISTS pizzeria;
CREATE DATABASE pizzeria CHARACTER SET utf8mb4;
USE pizzeria;

-- -----------------------------------------------------
-- Table `pizzeria`.`provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`provincia` (
  `provincia_id` INT(2) NOT NULL,
  `provincia_nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`provincia_id`));

-- -----------------------------------------------------
-- Table `pizzeria`.`localitat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`localitat` (
  `localitat_id` INT NOT NULL AUTO_INCREMENT,
  `localitat_nom` VARCHAR(45) NOT NULL,
  `provincia_provincia_id` INT(2) NOT NULL,
  PRIMARY KEY (`localitat_id`),
  FOREIGN KEY (`provincia_provincia_id`)
    REFERENCES `pizzeria`.`provincia` (`provincia_id`));


-- -----------------------------------------------------
-- Table `pizzeria`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`client` (
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
  `localitat_localitat_id` INT NOT NULL,
  PRIMARY KEY (`client_id`),
  FOREIGN KEY (`localitat_localitat_id`)
    REFERENCES `pizzeria`.`localitat` (`localitat_id`));


-- -----------------------------------------------------
-- Table `pizzeria`.`botiga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`botiga` (
  `botiga_id` INT NOT NULL AUTO_INCREMENT,
  `botiga_nom` VARCHAR(45) NOT NULL,
  `botiga_carrer` VARCHAR(45) NOT NULL,
  `botiga_num` VARCHAR(20) NULL,
  `botiga_pis` VARCHAR(10) NULL,
  `botiga_porta` VARCHAR(10) NULL,
  `botiga_cod_postal` VARCHAR(5) NOT NULL,
  `botiga_telefon` INT(9) NOT NULL,
  `localitat_localitat_id` INT NOT NULL,
  PRIMARY KEY (`botiga_id`),
  FOREIGN KEY (`localitat_localitat_id`)
    REFERENCES `pizzeria`.`localitat` (`localitat_id`));


-- -----------------------------------------------------
-- Table `pizzeria`.`empleat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`empleat` (
  `empleat_id` INT NOT NULL AUTO_INCREMENT,
  `empleat_nom` VARCHAR(45) NOT NULL,
  `empleat_cognom1` VARCHAR(45) NOT NULL,
  `empleat_cognom2` VARCHAR(45) NULL,
  `empleat_NIF` VARCHAR(10) NOT NULL,
  `empleat_telefon` VARCHAR(20) NOT NULL,
  `empleat_cat` ENUM('R', 'C') NOT NULL,
  `botiga_id` INT NOT NULL,
  PRIMARY KEY (`empleat_id`),
  FOREIGN KEY (`botiga_id`)
    REFERENCES `pizzeria`.`botiga` (`botiga_id`));


-- -----------------------------------------------------
-- Table `pizzeria`.`comanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`comanda` (
  `comanda_id` INT NOT NULL AUTO_INCREMENT,
  `comanda_data` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comanda_total` FLOAT NOT NULL,
  `comanda_tipus` ENUM('R', 'B') NOT NULL COMMENT 'R: repartiment a domicili\nB: botiga',
  `comanda_num_hamb` TINYINT NULL,
  `comanda_num_pizzas` TINYINT NULL,
  `comanda_num_begudes` TINYINT NULL,
  `empleat_id` INT NULL,
  `client_client_id` INT NOT NULL,
  `botiga_botiga_id` INT NOT NULL,
  PRIMARY KEY (`comanda_id`),
  FOREIGN KEY (`empleat_id`)
    REFERENCES `pizzeria`.`empleat` (`empleat_id`)
,
FOREIGN KEY (`botiga_botiga_id`)
    REFERENCES `pizzeria`.`botiga` (`botiga_id`)
,
  FOREIGN KEY (`client_client_id`)
    REFERENCES `pizzeria`.`client` (`client_id`));


-- -----------------------------------------------------
-- Table `pizzeria`.`categoria_pizza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`categoria_pizza` (
  `categoria_id` INT NOT NULL AUTO_INCREMENT,
  `categoria_nom` VARCHAR(45) NOT NULL COMMENT 'Categoria de pizzas',
  PRIMARY KEY (`categoria_id`))
;


-- -----------------------------------------------------
-- Table `pizzeria`.`producte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`producte` (
  `producte_id` INT NOT NULL AUTO_INCREMENT,
  `producte_nom` VARCHAR(45) NOT NULL,
  `producte_descripcio` VARCHAR(100) NOT NULL,
  `producte_imatge` BLOB NULL,
  `producte_preu` FLOAT NOT NULL DEFAULT 0,
  `producte_tipus` ENUM('pizza', 'hamburguesa', 'beguda') NOT NULL,
  `categoria_id` INT NULL,
  PRIMARY KEY (`producte_id`),
  FOREIGN KEY (`categoria_id`)
    REFERENCES `pizzeria`.`categoria_pizza` (`categoria_id`));


-- -----------------------------------------------------
-- Table `pizzeria`.`linia_comanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`linia_comanda` (
  `linia_comanda_id` INT NOT NULL,
  `linia_comanda_tipus` CHAR(1) NOT NULL,
  `linia_comanda_qty` INT NOT NULL,
  `linia_comanda_preu` FLOAT NOT NULL,
  `producte_id` INT NOT NULL,
  `comanda_comanda_id` INT NOT NULL,
  PRIMARY KEY (`linia_comanda_id`, `comanda_comanda_id`),
  FOREIGN KEY (`producte_id`)
    REFERENCES `pizzeria`.`producte` (`producte_id`)
,
  FOREIGN KEY (`comanda_comanda_id`)
    REFERENCES `pizzeria`.`comanda` (`comanda_id`));

-- ----------------------------
-- Carga provincia
-- ----------------------------
INSERT INTO `provincia` (`provincia_id`, `provincia_nom`)
VALUES	
	(8,'Barcelona'),
	(17,'Girona');
    
-- ----------------------------
-- Carga localitat
-- -----------------------------
INSERT INTO localitat VALUES
	(1, 'Sitges', 8),
	(2, 'Barcelona', 8),
	(3, 'Mataró', 8),
	(4, 'Figueres', 17),
	(5, 'Girona', 8);
    
-- ----------------------------
-- Carga botiga
-- -----------------------------
INSERT INTO botiga VALUES
	(1,'Francesco', 'Avda Sort','45',NULL,NULL,'08870',123123123,1),
	(2,'Mamma mia', 'C/ Pecat','13','local 3',NULL,'08870',123123123,1),
	(3,'Pappa', 'Avda Llum','10',NULL,'4','08008',123123123,2);

-- ----------------------------
-- Carga client
-- -----------------------------
INSERT INTO client VALUES
	(1,'Pepe', 'Pérez',NULL,'C/Aire','bajos','4',NULL,'08870','Espanya',123123123,'pepepe@gmail.com','2010-03-01',1),
	(2,'Lola', 'García','Almirall','C/Lluna','33','4','A','08870','Espanya',123123123,'lolalo@gmail.com','2020-03-01',1),
	(3,'Juan', 'López','López','C/Sol','S/N',NULL,NULL,'08008','Espanya',123123123,'juanju@gmail.com','2015-03-01',2);

-- ----------------------------
-- Carga empleat
-- -----------------------------
INSERT INTO empleat VALUES
	(1,'Julia', 'Martínez','Alba','X123123123',88888888888,'R',1),
	(2,'Pere', 'Casull','Pino','33123123F',912133313,'R',1),
	(3,'Laura', 'Garces','Garces','41324433H',9123123399,'C',1);

-- ----------------------------
-- Carga comanda
-- -----------------------------
INSERT INTO comanda VALUES
	(1,'2021-03-10', 43.00,'R',1,2,2,1,1,1),
	(2,'2021-03-12', 34.00,'B',1,1,1,NULL,2,2);

-- -----------------------------
-- Carga categoria pizzas
-- -----------------------------
INSERT INTO categoria_pizza VALUES
	(10,'vegetariana'),
	(20,'barbacoa'),
   	(30,'light');

-- -----------------------------
-- Carga producte
-- -----------------------------
INSERT INTO producte VALUES
	(1,'pizza del huerto', 'pizza con muchas verduras',NULL, 12,'pizza',10),
 	(2,'pizza carnivora', 'pizza con mucha carne',NULL, 15,'pizza',20),
	(3,'hamburguesa america', 'hanmburguesa con queso',NULL, 16,'hamburguesa',NULL),
	(4,'coca cola', 'lata de coca cola',NULL, 3,'beguda',NULL);

-- -----------------------------
-- Carga categoria linia_comanda
-- -----------------------------
INSERT INTO linia_comanda VALUES
	(1,'H',1,16,3,1),
	(2,'P',2,24,1,1),
	(3,'B',1,3,4,1),
	(4,'H',1,16,3,2),
	(5,'P',1,15,2,2),
   	(6,'B',1,3,4,2);

-- Llista quants productes de categoria 'Begudas' s'han venut en una determinada localitat

SELECT COUNT(linia_comanda_id) from linia_comanda  
INNER JOIN comanda ON comanda_id = comanda_comanda_id
INNER JOIN botiga ON botiga_id = botiga_botiga_id
where linia_comanda_tipus = 'B' AND localitat_localitat_id = 1;

-- Llista quantes comandes ha efectuat un determinat empleat

SELECT COUNT(comanda_id) FROM comanda 
WHERE empleat_id = 2;