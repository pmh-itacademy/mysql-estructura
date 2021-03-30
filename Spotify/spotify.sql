DROP DATABASE IF EXISTS spotify;
CREATE DATABASE spotify CHARACTER SET utf8mb4;
USE spotify;

-- -----------------------------------------------------
-- Schema Spotify
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `usuari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuari` (
  `usuari_id` INT NOT NULL AUTO_INCREMENT,
  `usuari_email` VARCHAR(45) NOT NULL,
  `usuari_pwd` VARCHAR(45) NOT NULL,
  `usuari_nom` VARCHAR(45) NOT NULL,
  `usuari_maixement` DATE NOT NULL,
  `usuari_sexe` ENUM("H", "D") /* 'H: home   D: dona' */,
  `usuari_pais` VARCHAR(45) NOT NULL,
  `usuari_codpostal` VARCHAR(15) NOT NULL,
  `usuari_tipus` ENUM("F", "P") NOT NULL/*'F: free P: premium' */,
  PRIMARY KEY (`usuari_id`));


-- -----------------------------------------------------
-- Table `suscripcio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `suscripcio` (
  `usuari_usuario_id` INT NOT NULL,
  `suscripcio_data_inici` DATE NOT NULL,
  `suscripcio_dara_renov` VARCHAR(45) NOT NULL,
  `suscripcio_pagament` ENUM('C', 'P') NOT NULL /* 'C: credit card, P: PayPal'*/,
  PRIMARY KEY (`usuari_usuario_id`, `suscripcio_data_inici`),
  INDEX `fk_suscripcio_usuari_idx` (`usuari_usuario_id` ASC) VISIBLE,
  FOREIGN KEY (`usuari_usuario_id`)
    REFERENCES `usuari` (`usuari_id`)
);


-- -----------------------------------------------------
-- Table `targeta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `targeta` (
  `targeta_num` VARCHAR(16) NOT NULL,
  `targeta_mes` VARCHAR(2) NOT NULL,
  `targeta_any` VARCHAR(4) NOT NULL,
  `targeta_codi` VARCHAR(3) NOT NULL,
  `suscripcio_usuari_usuario_id` INT NOT NULL,
  `suscripcio_suscripcio_data_inici` DATE NOT NULL,
  PRIMARY KEY (`targeta_num`),
  INDEX `fk_targeta_suscripcio1_idx` (`suscripcio_usuari_usuario_id` ASC, `suscripcio_suscripcio_data_inici` ASC) VISIBLE,
  FOREIGN KEY (`suscripcio_usuari_usuario_id` , `suscripcio_suscripcio_data_inici`)
    REFERENCES `suscripcio` (`usuari_usuario_id` , `suscripcio_data_inici`)
);


-- -----------------------------------------------------
-- Table `paypal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paypal` (
  `paypal_nom` VARCHAR(45) NOT NULL,
  `suscripcio_usuari_usuario_id` INT NOT NULL,
  `suscripcio_suscripcio_data_inici` DATE NOT NULL,
  PRIMARY KEY (`paypal_nom`),
  INDEX `fk_paypal_suscripcio1_idx` (`suscripcio_usuari_usuario_id` ASC, `suscripcio_suscripcio_data_inici` ASC) VISIBLE,
  FOREIGN KEY (`suscripcio_usuari_usuario_id` , `suscripcio_suscripcio_data_inici`)
    REFERENCES `suscripcio` (`usuari_usuario_id` , `suscripcio_data_inici`)
);


-- -----------------------------------------------------
-- Table `playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `playlist` (
  `playlist_id` INT NOT NULL AUTO_INCREMENT,
  `playlist_nom` VARCHAR(45) NOT NULL,
  `playlist_num` INT NOT NULL,
  `playlist_data_creació` DATE NOT NULL,
  `playlist_estat` ENUM('A', 'M') NOT NULL /* 'A: activa    M: morta' */,
  `playlist_borrada` DATE NULL,
  `usuari_usuari_id` INT NOT NULL,
  PRIMARY KEY (`playlist_id`),
  INDEX `fk_playlist_usuari1_idx` (`usuari_usuari_id` ASC) VISIBLE,
  FOREIGN KEY (`usuari_usuari_id`)
    REFERENCES `usuari` (`usuari_id`)
);


-- -----------------------------------------------------
-- Table `artista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `artista` (
  `artista_id` INT NOT NULL AUTO_INCREMENT,
  `artista_nom` VARCHAR(45) NOT NULL,
  `artista_imatge` BLOB,
  PRIMARY KEY (`artista_id`)
);


-- -----------------------------------------------------
-- Table `album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `album` (
  `album_id` INT NOT NULL AUTO_INCREMENT,
  `album_nom` VARCHAR(45) NOT NULL,
  `album_imatge` BLOB NULL,
  `artista_artista_id1` INT NOT NULL,
  PRIMARY KEY (`album_id`),
  INDEX `fk_album_artista1_idx` (`artista_artista_id1` ASC) VISIBLE,
  FOREIGN KEY (`artista_artista_id1`)
    REFERENCES `artista` (`artista_id`)
);


-- -----------------------------------------------------
-- Table `canço`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canço` (
  `canço_id` INT NOT NULL,
  `canço_nom` VARCHAR(45) NOT NULL,
  `canço_durada` VARCHAR(45) NOT NULL,
  `canço_reproduccions` INT NULL,
  `album_album_id` INT NOT NULL,
  PRIMARY KEY (`canço_id`),
  INDEX `fk_canço_album1_idx` (`album_album_id` ASC) VISIBLE,
  FOREIGN KEY (`album_album_id`)
    REFERENCES `album` (`album_id`)
);


-- -----------------------------------------------------
-- Table `canço_playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canço_playlist` (
  `playlist_playlist_id` INT NOT NULL,
  `canço_canço_id` INT NOT NULL,
  `usuari_usuario_id` INT NOT NULL,
  `canço_playlist_afegida` DATE NULL,
  PRIMARY KEY (`playlist_playlist_id`, `canço_canço_id`, `usuari_usuario_id`),
  INDEX `fk_canço_playlist_playlist1_idx` (`playlist_playlist_id` ASC) VISIBLE,
  INDEX `fk_canço_playlist_canço1_idx` (`canço_canço_id` ASC) VISIBLE,
  INDEX `fk_canço_playlist_usuari1_idx` (`usuari_usuario_id` ASC) VISIBLE,
  FOREIGN KEY (`playlist_playlist_id`)
    REFERENCES `playlist` (`playlist_id`),
  FOREIGN KEY (`canço_canço_id`)
    REFERENCES `canço` (`canço_id`),
  FOREIGN KEY (`usuari_usuario_id`)
    REFERENCES `usuari` (`usuari_id`)
);


-- -----------------------------------------------------
-- Table `artista_relacionat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `artista_relacionat` (
  `artista_artista_id` INT NOT NULL,
  `artista_artista_id1` INT NOT NULL,
  PRIMARY KEY (`artista_artista_id`, `artista_artista_id1`),
  INDEX `fk_artista_relacionat_artista2_idx` (`artista_artista_id1` ASC) VISIBLE,
  FOREIGN KEY (`artista_artista_id`)
    REFERENCES `artista` (`artista_id`),
  FOREIGN KEY (`artista_artista_id1`)
    REFERENCES `artista` (`artista_id`)
);


-- -----------------------------------------------------
-- Table `canço_favorita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canço_favorita` (
  `usuari_usuario_id` INT NOT NULL,
  `canço_canço_id` INT NOT NULL,
  PRIMARY KEY (`usuari_usuario_id`, `canço_canço_id`),
  INDEX `fk_canço_favorita_usuari1_idx` (`usuari_usuario_id` ASC) VISIBLE,
  INDEX `fk_canço_favorita_canço1_idx` (`canço_canço_id` ASC) VISIBLE,
  FOREIGN KEY (`usuari_usuario_id`)
    REFERENCES `usuari` (`usuari_id`),
  FOREIGN KEY (`canço_canço_id`)
    REFERENCES `canço` (`canço_id`)
);


-- -----------------------------------------------------
-- Table `album_favorit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `album_favorit` (
  `album_album_id` INT NOT NULL,
  `usuari_usuario_id` INT NOT NULL,
  PRIMARY KEY (`album_album_id`, `usuari_usuario_id`),
  INDEX `fk_album_favorit_album1_idx` (`album_album_id` ASC) VISIBLE,
  INDEX `fk_album_favorit_usuari1_idx` (`usuari_usuario_id` ASC) VISIBLE,
  FOREIGN KEY (`album_album_id`)
    REFERENCES `album` (`album_id`),
  FOREIGN KEY (`usuari_usuario_id`)
    REFERENCES `usuari` (`usuari_id`)
);


-- -----------------------------------------------------
-- Table `pagament`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pagament` (
  `pagament_id` INT NOT NULL,
  `pagament_data` VARCHAR(45) NOT NULL,
  `pagament_total` FLOAT NOT NULL,
  `usuari_usuario_id` INT NOT NULL,
  PRIMARY KEY (`pagament_id`),
  INDEX `fk_pagament_usuari1_idx` (`usuari_usuario_id` ASC) VISIBLE,
  FOREIGN KEY (`usuari_usuario_id`)
    REFERENCES `usuari` (`usuari_id`)
);


-- -----------------------------------------------------
-- Table `artista_seguidor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `artista_seguidor` (
  `usuari_usuari_id` INT NOT NULL,
  `artista_artista_id` INT NOT NULL,
  PRIMARY KEY (`usuari_usuari_id`, `artista_artista_id`),
  INDEX `fk_artista_seguidor_usuari1_idx` (`usuari_usuari_id` ASC) VISIBLE,
  INDEX `fk_artista_seguidor_artista1_idx` (`artista_artista_id` ASC) VISIBLE,
  FOREIGN KEY (`usuari_usuari_id`)
    REFERENCES `usuari` (`usuari_id`),
  FOREIGN KEY (`artista_artista_id`)
    REFERENCES `artista` (`artista_id`)
);


-- -----------------------------------------------------
-- Data for table `usuari`
-- -----------------------------------------------------
INSERT INTO `usuari` VALUES (1, 'pepito@gmail.com', 'pepitototo', 'Pepe Perez', '2000-01-01 01:00:00', NULL, 'UK', 'KT109PL', 'P');
INSERT INTO `usuari` VALUES (2, 'juana@hotmail.com', 'juanita2', 'Juana Garcia', '2000-12-12 12:01:02', 'D', 'Spain', '08080', 'P');
INSERT INTO `usuari` VALUES (3, 'lola@gmail.com', 'lolita00', 'Lola Garse', '2001-03-01 05:08:01', NULL, 'Spain', '41018', 'F');


-- -----------------------------------------------------
-- Data for table `suscripcio`
-- -----------------------------------------------------
INSERT INTO `suscripcio` VALUES (1, '2020-01-02', '2021-01-02', 'C');
INSERT INTO `suscripcio` VALUES (2, '2020-01-02', '2022-01-02', 'P');


-- -----------------------------------------------------
-- Data for table `targeta`
-- -----------------------------------------------------
INSERT INTO `targeta` VALUES (1234567890123456, 03, 2022, 178, 1, '2020-01-02');


-- -----------------------------------------------------
-- Data for table `paypal`
-- -----------------------------------------------------
INSERT INTO `paypal` VALUES ('juana@hotmail.com', 2, '2020-01-02');


-- -----------------------------------------------------
-- Data for table `playlist`
-- -----------------------------------------------------
INSERT INTO `playlist` VALUES (1, 'Mi musica', 2, '2021-01-01', 'M', '2021-01-02', 1);
INSERT INTO `playlist` VALUES (2, 'Mola', 3, '2021-02-01', 'A', NULL, 1);


-- -----------------------------------------------------
-- Data for table `artista`
-- -----------------------------------------------------
INSERT INTO `artista` VALUES (1, 'Los Bitels', NULL);
INSERT INTO `artista` VALUES (2, 'The Beatles', NULL);


-- -----------------------------------------------------
-- Data for table `album`
-- -----------------------------------------------------
INSERT INTO `album` VALUES (1, 'Super Album', NULL, 1);
INSERT INTO `album` VALUES (2, 'Greatest Hits', NULL, 2);


-- -----------------------------------------------------
-- Data for table `canço`
-- -----------------------------------------------------
INSERT INTO `canço` VALUES (1, 'Let it bee', '256', 34, 1);
INSERT INTO `canço` VALUES (2, 'Iesterdei', '311', 32, 1);
INSERT INTO `canço` VALUES (3, 'Camps de maduixes', '123', 33, 1);


-- -----------------------------------------------------
-- Data for table `canço_playlist`
-- -----------------------------------------------------
INSERT INTO `canço_playlist` VALUES (1, 1, 2, '2021-02-03');
INSERT INTO `canço_playlist` VALUES (1, 2, 1, '2021-02-04');
INSERT INTO `canço_playlist` VALUES (2, 1, 1, '2021-02-01');
INSERT INTO `canço_playlist` VALUES (2, 2, 1, '2021-02-03');
INSERT INTO `canço_playlist` VALUES (2, 3, 1, '2021-03-02');


-- -----------------------------------------------------
-- Data for table `artista_relacionat`
-- -----------------------------------------------------
INSERT INTO `artista_relacionat` VALUES (1, 2);
INSERT INTO `artista_relacionat` VALUES (2, 1);


-- -----------------------------------------------------
-- Data for table `canço_favorita`
-- -----------------------------------------------------
INSERT INTO `canço_favorita` VALUES (1, 1);
INSERT INTO `canço_favorita` VALUES (1, 2);
INSERT INTO `canço_favorita` VALUES (2, 2);
INSERT INTO `canço_favorita` VALUES (2, 3);


-- -----------------------------------------------------
-- Data for table `album_favorit`
-- -----------------------------------------------------
INSERT INTO `album_favorit` VALUES (1, 1);
INSERT INTO `album_favorit` VALUES (2, 1);
INSERT INTO `album_favorit` VALUES (1, 2);


-- -----------------------------------------------------
-- Data for table `pagament`
-- -----------------------------------------------------
INSERT INTO `pagament` VALUES (1, '2020-01-02', 44.33, 1);
INSERT INTO `pagament` VALUES (2, '2021-01-02', 45.76, 1);
INSERT INTO `pagament` VALUES (3, '2020-12-12', 33.45, 2);


-- -----------------------------------------------------
-- Data for table `artista_seguidor`
-- -----------------------------------------------------
INSERT INTO `artista_seguidor` VALUES (1, 1);
