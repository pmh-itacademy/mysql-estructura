DROP DATABASE IF EXISTS youtube;
CREATE DATABASE youtube CHARACTER SET utf8mb4;
USE youtube;

-- -----------------------------------------------------
-- Table `usuari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuari` (
  `Usuari_id` INT NOT NULL AUTO_INCREMENT,
  `Usuari_email` VARCHAR(256) NOT NULL,
  `Usuari_pwd` VARCHAR(20) NOT NULL,
  `Usuari_data_naixement` DATE NOT NULL,
  `Usuari_sexe` ENUM('F', 'M') NULL,
  `Usuari_pais` INT NOT NULL,
  `Usuari_cod_postal` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Usuari_id`));

-- -----------------------------------------------------
-- Table `playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `playlist` (
  `playlist_id` INT NOT NULL,
  `playlist_nom` VARCHAR(45) NOT NULL,
  `playlist_data_creacio` DATE NOT NULL,
  `playlist_tipus` ENUM('PU', 'PR') NOT NULL,
  `usuari_Usuari_id` INT NOT NULL,
  PRIMARY KEY (`playlist_id`),
  INDEX `fk_playlist_usuari1_idx` (`usuari_Usuari_id` ASC) VISIBLE,
  FOREIGN KEY (`usuari_Usuari_id`)
    REFERENCES `usuari` (`Usuari_id`));

-- -----------------------------------------------------
-- Table `estat_video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estat_video` (
  `estat_video_id` TINYINT NOT NULL,
  `estat_video_desc` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`estat_video_id`));

-- -----------------------------------------------------
-- Table `video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `video` (
  `video_id` INT NOT NULL AUTO_INCREMENT,
  `video_titol` VARCHAR(45) NOT NULL,
  `video_descripcio` VARCHAR(300) NOT NULL,
  `video_grandaria` INT NOT NULL,
  `video_nom_arxui` VARCHAR(45) NOT NULL,
  `video_durada` INT NOT NULL,
  `video_thumbnail` BLOB NULL,
  `video_num_reproduccions` INT NOT NULL,
  `video_num_likes` INT NOT NULL,
  `video_num_dislikes` INT NOT NULL,
  `video_hora_publ` TIME NULL,
  `usuari_Usuari_id` INT NOT NULL,
  `estat_video_id` TINYINT NOT NULL,
  PRIMARY KEY (`video_id`),
  INDEX `fk_video_usuari1_idx` (`usuari_Usuari_id` ASC) VISIBLE,
  INDEX `fk_video_estat_video1_idx` (`estat_video_id` ASC) VISIBLE,
  FOREIGN KEY (`usuari_Usuari_id`)
    REFERENCES `usuari` (`Usuari_id`),
  FOREIGN KEY (`estat_video_id`)
    REFERENCES `estat_video` (`estat_video_id`));

-- -----------------------------------------------------
-- Table `etiqueta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `etiqueta` (
  `etiqueta_id` INT NOT NULL AUTO_INCREMENT,
  `etiqueta_nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`etiqueta_id`));

-- -----------------------------------------------------
-- Table `canal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canal` (
  `canal_id` INT NOT NULL AUTO_INCREMENT,
  `canal_nom` VARCHAR(30) NOT NULL,
  `canal_descripcio` VARCHAR(400) NULL,
  `canal_data_creacio` DATE NOT NULL,
  `usuari_crea_id` INT NOT NULL,
  PRIMARY KEY (`canal_id`),
  INDEX `fk_canal_usuari1_idx` (`usuari_crea_id` ASC) VISIBLE,
  FOREIGN KEY (`usuari_crea_id`)
    REFERENCES `usuari` (`Usuari_id`));

-- -----------------------------------------------------
-- Table `canal_usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canal_usuario` (
  `canal_canal_id` INT NOT NULL,
  `usuari_suscrit_id` INT NOT NULL,
  PRIMARY KEY (`canal_canal_id`, `usuari_suscrit_id`),
  INDEX `fk_canal_usuario_usuari1_idx` (`usuari_suscrit_id` ASC) INVISIBLE,
  INDEX `fk_canal_canal_id` (`canal_canal_id` ASC) VISIBLE,
  FOREIGN KEY (`canal_canal_id`)
    REFERENCES `canal` (`canal_id`),
  FOREIGN KEY (`usuari_suscrit_id`)
    REFERENCES `usuari` (`Usuari_id`));

-- -----------------------------------------------------
-- Table `video_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `video_like` (
  `video_video_id` INT NOT NULL,
  `usuari_Usuari_id` INT NOT NULL,
  `video_like_tipus` TINYINT NOT NULL,
  `video_like_data` DATETIME NOT NULL,
  PRIMARY KEY (`video_video_id`, `usuari_Usuari_id`),
  INDEX `fk_video_like_video1_idx` (`video_video_id` ASC) VISIBLE,
  INDEX `fk_video_like_usuari1_idx` (`usuari_Usuari_id` ASC) VISIBLE,
  FOREIGN KEY (`video_video_id`)
    REFERENCES `video` (`video_id`),
  FOREIGN KEY (`usuari_Usuari_id`)
    REFERENCES `usuari` (`Usuari_id`));

-- -----------------------------------------------------
-- Table `comentari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `comentari` (
  `comentari_id` INT NOT NULL,
  `comentari_text` VARCHAR(400) NOT NULL,
  `usuari_Usuari_id` INT NOT NULL,
  `video_video_id` INT NOT NULL,
  PRIMARY KEY (`comentari_id`),
  INDEX `fk_comentari_usuari1_idx` (`usuari_Usuari_id` ASC) VISIBLE,
  INDEX `fk_comentari_video1_idx` (`video_video_id` ASC) VISIBLE,
  FOREIGN KEY (`usuari_Usuari_id`)
    REFERENCES `usuari` (`Usuari_id`),
  FOREIGN KEY (`video_video_id`)
    REFERENCES `video` (`video_id`));

-- -----------------------------------------------------
-- Table `comentari_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `comentari_like` (
  `usuari_Usuari_id` INT NOT NULL,
  `comentari_comentari_id` INT NOT NULL,
  PRIMARY KEY (`usuari_Usuari_id`, `comentari_comentari_id`),
  INDEX `fk_comentari_like_usuari1_idx` (`usuari_Usuari_id` ASC) VISIBLE,
  INDEX `fk_comentari_like_comentari1_idx` (`comentari_comentari_id` ASC) VISIBLE,
  FOREIGN KEY (`usuari_Usuari_id`)
    REFERENCES `usuari` (`Usuari_id`),
  FOREIGN KEY (`comentari_comentari_id`)
    REFERENCES `comentari` (`comentari_id`));

-- -----------------------------------------------------
-- Table `video_etiqueta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `video_etiqueta` (
  `video_video_id1` INT NOT NULL,
  `etiqueta_etiqueta_id1` INT NOT NULL,
  PRIMARY KEY (`video_video_id1`, `etiqueta_etiqueta_id1`),
  INDEX `fk_video_etiqueta_video1_idx` (`video_video_id1` ASC) VISIBLE,
  INDEX `fk_video_etiqueta_etiqueta1_idx` (`etiqueta_etiqueta_id1` ASC) VISIBLE,
  FOREIGN KEY (`video_video_id1`)
    REFERENCES `video` (`video_id`),
  FOREIGN KEY (`etiqueta_etiqueta_id1`)
    REFERENCES `etiqueta` (`etiqueta_id`));

-- -----------------------------------------------------
-- Table `video_playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `video_playlist` (
  `playlist_playlist_id` INT NOT NULL,
  `video_video_id` INT NOT NULL,
  PRIMARY KEY (`playlist_playlist_id`, `video_video_id`),
  INDEX `fk_video_playlist_playlist1_idx` (`playlist_playlist_id` ASC) VISIBLE,
  INDEX `fk_video_playlist_video1_idx` (`video_video_id` ASC) VISIBLE,
  FOREIGN KEY (`playlist_playlist_id`)
    REFERENCES `playlist` (`playlist_id`),
  FOREIGN KEY (`video_video_id`)
    REFERENCES `video` (`video_id`));

-- -----------------------------------------------------
-- Carga `usuari`
-- -----------------------------------------------------
INSERT INTO `usuari` VALUES ('1', 'mimail@yahoo.com', 'mimail09', '1990-12-31', NULL,'73', '08090');
INSERT INTO `usuari` VALUES ('2', 'pepito@gmail.com', 'pepito00', '2014-01-04', 'F', '73', '08008');
INSERT INTO `usuari` VALUES ('3', 'juan@gmail.es', 'juanitoito', '2021-02-02', 'M', '05', 'KTM9833');
INSERT INTO `usuari` VALUES ('4', 'pepa@hotmail.com', 'pepapepa', '2014-10-28', NULL,'71', 'jujujuj');
 
-- -----------------------------------------------------
-- Carga `estat_video`
-- ----------------------------------------------------- 
INSERT INTO `estat_video` VALUES ('1', 'Públic');
INSERT INTO `estat_video` VALUES ('2', 'Ocult');
INSERT INTO `estat_video` VALUES ('3', 'Privat');

-- -----------------------------------------------------
-- Carga `video`
-- ----------------------------------------------------- 
INSERT INTO `video` VALUES ('1', 'Gatitos en acción', 'Muchos gatitos haciendo cosas de gatos', '3', 'gatos.mp4', '3021', NULL,'2', '1', '0', '2020-12-23 00:00:07', '1','1');
INSERT INTO `video` VALUES ('2', 'Perritos en acción', 'Muchos perritos haciendo cosas de perros', '37', 'perros.mp4', '4444', NULL,'37', '1', '1', '2021-01-23 12:00:07', '1','2');

-- -----------------------------------------------------
-- Carga `video_like`
-- ----------------------------------------------------- 
INSERT INTO `video_like` VALUES ('1', '2', '1', '2021-03-20 14:14:00');
INSERT INTO `video_like` VALUES ('2', '2', '0', '2021-03-20 15:14:00');

-- -----------------------------------------------------
-- Carga `etiqueta`
-- ----------------------------------------------------- 
INSERT INTO `etiqueta` VALUES ('1', '#animales');
INSERT INTO `etiqueta` VALUES ('2', '#gatos');

-- -----------------------------------------------------
-- Carga `video etiqueta`
-- ----------------------------------------------------- 
INSERT INTO `video_etiqueta` VALUES ('1', '1');
INSERT INTO `video_etiqueta` VALUES ('1', '2');

-- -----------------------------------------------------
-- Carga `playlist`
-- ----------------------------------------------------- 
INSERT INTO `playlist` VALUES ('1', 'una playlist', '2020-02-02', '1', '1');

-- -----------------------------------------------------
-- Carga `video_playlist`
-- ----------------------------------------------------- 
INSERT INTO `video_playlist` VALUES ('1', '1');
INSERT INTO `video_playlist` VALUES ('1', '2');

-- -----------------------------------------------------
-- Carga `canal`
-- ----------------------------------------------------- 
INSERT INTO `canal` VALUES ('1', 'mi canal', 'mi canal de videos', '2019-01-01', '1');
INSERT INTO `canal` VALUES ('2', 'otro canal', 'mi otro canal', '2020-01-01', '1');
INSERT INTO `canal` VALUES ('3', 'otro nuevo', 'nuevo canal', '2021-01-01', '2');

-- -----------------------------------------------------
-- Carga `canal_usuario`
-- ----------------------------------------------------- 
INSERT INTO `canal_usuario` VALUES ('1', '1');
INSERT INTO `canal_usuario` VALUES ('1', '2');
INSERT INTO `canal_usuario` VALUES ('2', '1');
INSERT INTO `canal_usuario` VALUES ('2', '2');

-- -----------------------------------------------------
-- Carga `comentari`
-- ----------------------------------------------------- 
INSERT INTO `comentari` VALUES ('1', 'vaya video más bonito', '1', '1');
INSERT INTO `comentari` VALUES ('2', 'fatal', '1', '2');

-- -----------------------------------------------------
-- Carga `comentari_like`
-- ----------------------------------------------------- 
INSERT INTO `comentari_like` VALUES ('1', '2');
INSERT INTO `comentari_like` VALUES ('2', '1');


