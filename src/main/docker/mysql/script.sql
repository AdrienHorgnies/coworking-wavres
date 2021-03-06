CREATE TABLE `user` (
    `id`            SERIAL          NOT NULL AUTO_INCREMENT COMMENT 'identify a user unequivocally',
    `email`         VARCHAR(255)    NOT NULL COMMENT 'contact user, send private information or reset password',
    `password_hash` CHAR(60) BINARY NOT NULL COMMENT 'cryptographic hash of user password',
    `last_name`     VARCHAR(100)    NOT NULL COMMENT 'family name used to address user in communication',
    `first_name`    VARCHAR(100)    NOT NULL COMMENT 'first name used to address user in communication',
    PRIMARY KEY (`id`),
    UNIQUE (`email`)
)
    ENGINE = InnoDB;

CREATE TABLE `authority` (
    `name` VARCHAR(50) NOT NULL COMMENT 'identify an access level recognized by the application code',
    PRIMARY KEY (`name`)
)
    ENGINE = InnoDB;

CREATE TABLE `user_authority` (
    `user_id`        BIGINT UNSIGNED NOT NULL,
    `authority_name` VARCHAR(50)     NOT NULL,
    PRIMARY KEY (`user_id`, `authority_name`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
    FOREIGN KEY (`authority_name`) REFERENCES `authority`(`name`)
)
    ENGINE = InnoDB;

CREATE TABLE `city` (
    `id`       SERIAL       NOT NULL AUTO_INCREMENT,
    `name`     VARCHAR(100) NOT NULL,
    `zip_code` INTEGER      NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE (`name`, `zip_code`)
)
    ENGINE = InnoDB;

CREATE TABLE `building` (
    `id`      SERIAL          NOT NULL AUTO_INCREMENT,
    `name`    VARCHAR(25)     NOT NULL,
    `address` VARCHAR(255)    NOT NULL,
    `city_id` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`city_id`) REFERENCES `city`(`id`)
)
    ENGINE = InnoDB;

CREATE TABLE `space` (
    `id`              SERIAL                             NOT NULL AUTO_INCREMENT,
    `name`            VARCHAR(25)                        NOT NULL,
    `type`            ENUM ('PRIVATE', 'OPEN', 'BUBBLE') NOT NULL,
    `people_capacity` INTEGER                            NOT NULL,
    `area`            INTEGER                            NOT NULL,
    `building_id`     BIGINT UNSIGNED                    NOT NULL,
    `price`           FLOAT                              NOT NULL,
    `description`     TEXT,
    `image_url`       VARCHAR(255),
    `image_credit`    VARCHAR(255),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`building_id`) REFERENCES `building`(`id`)
)
    ENGINE = InnoDB;

CREATE TABLE `equipment_type` (
    `id`    SERIAL      NOT NULL AUTO_INCREMENT,
    `name`  VARCHAR(25) NOT NULL,
    `price` FLOAT       NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;

CREATE TABLE `service_type` (
    `id`    SERIAL      NOT NULL AUTO_INCREMENT,
    `name`  VARCHAR(25) NOT NULL,
    `price` FLOAT       NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;

CREATE TABLE `space_equipment_type` (
    `spaces_id`          BIGINT UNSIGNED NOT NULL,
    `equipment_types_id` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`spaces_id`, `equipment_types_id`),
    FOREIGN KEY (`spaces_id`) REFERENCES `space`(`id`),
    FOREIGN KEY (`equipment_types_id`) REFERENCES `equipment_type`(`id`)
)
    ENGINE = InnoDB;

CREATE TABLE `building_service_type` (
    `buildings_id`     BIGINT UNSIGNED NOT NULL,
    `service_types_id` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`buildings_id`, `service_types_id`),
    FOREIGN KEY (`buildings_id`) REFERENCES `building`(`id`),
    FOREIGN KEY (`service_types_id`) REFERENCES `service_type`(`id`)
)
    ENGINE = InnoDB;

CREATE TABLE `reservation` (
    `id`                  SERIAL          NOT NULL AUTO_INCREMENT,
    `title`               VARCHAR(25),
    `order_date`          DATETIME        NOT NULL,
    `start_date`          DATETIME        NOT NULL,
    `end_date`            DATETIME        NOT NULL,
    `people_number`       INTEGER         NOT NULL,
    `space_price_per_day` FLOAT           NOT NULL,
    `grand_total_price`   FLOAT           NOT NULL,
    `confirmed`           BOOLEAN         NOT NULL,
    `space_id`            BIGINT UNSIGNED NOT NULL,
    `user_id`             BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`space_id`) REFERENCES `space`(`id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
)
    ENGINE = InnoDB;

CREATE TABLE `equipment_order` (
    `id`                 SERIAL          NOT NULL AUTO_INCREMENT,
    `quantity`           INTEGER         NOT NULL,
    `unit_price_per_day` FLOAT           NOT NULL,
    `equipment_type_id`  BIGINT UNSIGNED NOT NULL,
    `reservation_id`     BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`equipment_type_id`) REFERENCES `equipment_type`(`id`),
    FOREIGN KEY (`reservation_id`) REFERENCES `reservation`(`id`)
)
    ENGINE = InnoDB;

CREATE TABLE `service_order` (
    `id`                 SERIAL          NOT NULL AUTO_INCREMENT,
    `quantity`           INTEGER         NOT NULL,
    `unit_price_per_day` FLOAT           NOT NULL,
    `service_type_id`    BIGINT UNSIGNED NOT NULL,
    `reservation_id`     BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`service_type_id`) REFERENCES `service_type`(`id`),
    FOREIGN KEY (`reservation_id`) REFERENCES `reservation`(`id`)
)
    ENGINE = InnoDB;

INSERT INTO `user`(`id`, `email`, `password_hash`, `last_name`, `first_name`)
VALUES (1, 'system@localhost', '$2a$10$t9A4RrSdlcAUCCPmYd.8xOfBq39sNev4oQRdUWfQnumlMmCpVdNZm', 'System', 'System'),
(2,
 'admin@localhost',
 '$2a$10$wMeLcX1dCoPajBV9MpbZRu4PsMR1AWVO2CE6s/bfey7/h5bgLALi.',
 'Administrator',
 'Administrator'),
(3, 'user@localhost', '$2a$10$.Vt5BdgeuqXd2rsqA.UlIOfLNYMO2Hse4BOI5UIn5.KZUcjRWW5di', 'User', 'User'),
(4, 'anonymous@localhost', '$2a$10$C9nfAndBnWq9WRSDiVOQj.RJEbq6lwwaT1QUupAwrZfF2gsevTrOm', 'User', 'Anonymous');

INSERT INTO `authority`(`name`)
VALUES ('ROLE_ADMIN'),
    ('ROLE_USER'),
    ('ROLE_ANONYMOUS');

INSERT INTO `user_authority`(`user_id`, `authority_name`)
VALUES (1, 'ROLE_ADMIN'),
    (1, 'ROLE_USER'),
    (2, 'ROLE_ADMIN'),
    (2, 'ROLE_USER'),
    (3, 'ROLE_USER');

INSERT INTO `city` (`id`, `name`, `zip_code`)
VALUES (1, 'Archennes', 1390),
    (2, 'Autre-Eglise', 1367),
    (3, 'Baisy-Thy', 1470),
    (4, 'Baulers', 1401),
    (5, 'Beauvechain', 1320),
    (6, 'Bierges', 1301),
    (7, 'Bierghes', 1430),
    (8, 'Biez', 1390),
    (9, 'Bomal', 1367),
    (10, 'Bonlez', 1325),
    (11, 'Bornival', 1404),
    (12, 'Bossut-Gottechain', 1390),
    (13, 'Bousval', 1470),
    (14, 'Braine-l\'Alleud', 1420),
    (15, 'Braine-le-Château', 1440),
    (16, 'Céroux-Mousty', 1341),
    (17, 'Chastre', 1450),
    (18, 'Chastre-Villeroux-Blanmont', 1450),
    (19, 'Chaumont-Gistoux', 1325),
    (20, 'Clabecq', 1480),
    (21, 'Corbais', 1435),
    (22, 'Corroy-le-Grand', 1325),
    (23, 'Cortil-Noirmont', 1450),
    (24, 'Court-Saint-Etienne', 1490),
    (25, 'Couture-Saint-Germain', 1380),
    (26, 'Dion-Valmont', 1325),
    (27, 'Dongelberg', 1370),
    (28, 'Enines', 1350),
    (29, 'Folx-les-Caves', 1350),
    (30, 'Geest-Gérompont-Petit-Rosière', 1367),
    (31, 'Genappe', 1470),
    (32, 'Gentinnes', 1450),
    (33, 'Genval', 1332),
    (34, 'Gérompont', 1367),
    (35, 'Glabais', 1473),
    (36, 'Glimes', 1315),
    (37, 'Grand-Rosière-Hottomont', 1367),
    (38, 'Grez-Doiceau', 1390),
    (39, 'Hamme-Mille', 1320),
    (40, 'Haut-Ittre', 1461),
    (41, 'Hélécine', 1357),
    (42, 'Hévillers', 1435),
    (43, 'Houtain-le-Val', 1476),
    (44, 'Huppaye', 1367),
    (45, 'Incourt', 1315),
    (46, 'Ittre', 1460),
    (47, 'Jandrain-Jandrenouille', 1350),
    (48, 'Jauche', 1350),
    (49, 'Jauchelette', 1370),
    (50, 'Jodoigne', 1370),
    (51, 'Jodoigne-Souveraine', 1370),
    (52, 'La Hulpe', 1310),
    (53, 'Lasne', 1380),
    (54, 'Lasne-Chapelle-Saint-Lambert', 1380),
    (55, 'Lathuy', 1370),
    (56, 'l\'Ecluse', 1320),
    (57, 'Lillois-Witterzée', 1428),
    (58, 'Limal', 1300),
    (59, 'Limelette', 1342),
    (60, 'Linsmeau', 1357),
    (61, 'Longueville', 1325),
    (62, 'Loupoigne', 1471),
    (63, 'Louvain-la-Neuve', 1348),
    (64, 'Malèves-Sainte-Marie-Wastines', 1360),
    (65, 'Maransart', 1380),
    (66, 'Marbais', 1495),
    (67, 'Marilles', 1350),
    (68, 'Mélin', 1370),
    (69, 'Mellery', 1495),
    (70, 'Monstreux', 1400),
    (71, 'Mont-Saint-André', 1367),
    (72, 'Mont-Saint-Guibert', 1435),
    (73, 'Neerheylissem', 1357),
    (74, 'Nethen', 1390),
    (75, 'Nil-Saint-Vincent-Saint-Martin', 1457),
    (76, 'Nivelles', 1400),
    (77, 'Nodebais', 1320),
    (78, 'Noduwez', 1350),
    (79, 'Ohain', 1380),
    (80, 'Oisquercq', 1480),
    (81, 'Ophain-Bois-Seigneur-Isaac', 1421),
    (82, 'Opheylissem', 1357),
    (83, 'Opprebais', 1315),
    (84, 'Orbais', 1360),
    (85, 'Orp-Jauche', 1350),
    (86, 'Orp-le-Grand', 1350),
    (87, 'Ottignies', 1340),
    (88, 'Ottignies-Louvain-la-Neuve', 1340),
    (89, 'Perwez', 1360),
    (90, 'Piétrain', 1370),
    (91, 'Piètrebais', 1315),
    (92, 'Plancenoit', 1380),
    (93, 'Promo-Control', 1414),
    (94, 'Quenast', 1430),
    (95, 'Ramillies', 1367),
    (96, 'Rebecq', 1430),
    (97, 'Rebecq-Rognon', 1430),
    (98, 'Rixensart', 1330),
    (99, 'Rosières', 1331),
    (100, 'Roux-Miroir', 1315),
    (101, 'Saintes', 1480),
    (102, 'Saint-Géry', 1450),
    (103, 'Saint-Jean-Geest', 1370),
    (104, 'Saint-Remy-Geest', 1370),
    (105, 'Sart-Dames-Avelines', 1495),
    (106, 'Thines', 1402),
    (107, 'Thorembais-les-Béguines', 1360),
    (108, 'Thorembais-Saint-Trond', 1360),
    (109, 'Tilly', 1495),
    (110, 'Tourinnes-la-Grosse', 1320),
    (111, 'Tourinnes-Saint-Lambert', 1457),
    (112, 'Tubize', 1480),
    (113, 'Vieux-Genappe', 1472),
    (114, 'Villers-la-Ville', 1495),
    (115, 'Virginal-Samme', 1460),
    (116, 'Walhain', 1457),
    (117, 'Walhain-Saint-Paul', 1457),
    (118, 'Waterloo', 1410),
    (119, 'Wauthier-Braine', 1440),
    (120, 'Wavre', 1300),
    (121, 'Ways', 1474),
    (122, 'Zétrud-Lumay', 1370);

INSERT INTO `building` (`id`, `name`, `address`, `city_id`)
VALUES (1, 'IFOSUP', 'Rue de la limite 16', 120),
    (2, 'Le bureau des anges', 'Rue du Paradis 3', 120),
    (3, 'The Office', 'Avenue de la cité 123', 120),
    (4, 'Martins Hotel', 'Rue de l\'Hocaille 1', 63),
    (5, 'La résidence d\'Adrien', 'Rue Génistroit 131A', 63),
    (6, 'Altissia', 'Place de l\'Université 16', 63),
    (7, 'Quimeo', 'Place de l\'Université 16', 63),
    (8, 'Cinéscope', 'Grand-Place 55', 63),
    (9, 'La mouture', 'Rue du travailleur 426', 63),
    (10, 'Le Papillon', 'Boulevard du matin 62', 100),
    (11, 'L\'antagoniste', 'Boulevard du soir 41', 99),
    (12, 'Le protagoniste', 'Rue de la lassitude 19', 50),
    (13, 'Le coup du collier', 'Rue de la quiétude 14', 33),
    (14, 'L\'animal', 'Rue de la protéïne 10', 20),
    (15, 'Le bonheur', 'Rue de la Tourbe 113', 76),
    (16, 'Le bouclier du café', 'Avenue des dieux 1', 67),
    (17, 'Les dès du pile ou face', 'Rue du chat 35', 59),
    (18, 'L\'effort', 'Rue des Satinés 8', 26),
    (19, 'Pierre-Curie', 'Place des Wallons 2', 63),
    (20, 'La boule', 'Place des trapézistes 41', 15),
    (21, 'La hauteur', 'Chemin des angles droits 2', 49),
    (22, 'Le nom de Dieu', 'Chemin de l\'Éveil 1000', 1),
    (23, 'Le Dauphin', 'Rue du clavier 98', 64),
    (24, 'Le Bloc Rouge', 'Avenue de la Mésopotamie 2', 47),
    (25, 'Le Berceau', 'Rue de l\'Encyclopédie', 48);

INSERT INTO `space` (`id`, `name`, `type`, `people_capacity`, `area`, `price`, `description`, `image_url`,
                     `image_credit`,
                     `building_id`)
VALUES (1, 'Salon', 'PRIVATE', 4, 20, 100.0,
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
        '/coworking-spaces/1.jpg',
        'Droits d\'auteur: Coworkoffice', 5),
(2, 'Aile de Paillettes', 'PRIVATE', 6, 14, 90.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/2.jpg',
 'Droits d\'auteur: Asnieres Sur Seine', 10),
(3, 'War Room', 'PRIVATE', 10, 20, 120.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/3.jpg',
 'Droits d\'auteur: La Maison de l''Afrique', 2),
(4, 'Le QG', 'PRIVATE', 6, 18, 100.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/4.jpg',
 'Droits d\'auteur: Bird Office', 12),
(5, 'L104', 'PRIVATE', 20, 40, 150.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/5.jpg',
 'Droits d\'auteur: atoffice.lu', 1),
(6, 'L108', 'PRIVATE', 20, 45, 160.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/6.jpg',
 'Droits d\'auteur: atoffice.lu', 1),
(7, 'Les guichets', 'PRIVATE', 4, 8, 70.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/7.jpg',
 'Droits d\'auteur: Moucron Coworking', 8),
(8, 'L\'aquarium A', 'PRIVATE', 8, 22, 140.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/8.jpg',
 'Droits d\'auteur: atoffice.lu', 6),
(9, 'L\'aquarium B', 'PRIVATE', 8, 22, 140.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/9.jpg',
 'Droits d\'auteur: Le 114', 6),
(10, 'All Start Nest', 'OPEN', 12, 25, 20.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/10.jpg',
 'Droits d\'auteur: Officedropin.com', 6),
(11, 'Salle 1', 'OPEN', 60, 100, 15.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/11.jpg',
 'Droits d\'auteur: trilux.com', 8),
(12, 'Salle 2', 'OPEN', 80, 120, 15.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/12.jpg',
 'Droits d\'auteur: SmartWork Brussels', 8),
(13, 'B-Rocket Launch Pad', 'OPEN', 20, 60, 20.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/13.jpg',
 'Droits d\'auteur: Skylab Factory', 6),
(14, 'Salle des tatamis', 'OPEN', 40, 60, 15.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/14.jpg',
 'Droits d\'auteur: Skylab Factory', 1),
(15, 'La Tonte', 'OPEN', 10, 28, 20.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/15.jpg',
 'Droits d\'auteur: Skylab Factory', 9),
(16, 'L\'enjambée', 'OPEN', 16, 34, 20.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/16.jpg',
 'Droits d\'auteur: Skylab Factory', 7),
(17, 'L\'ossature', 'OPEN', 8, 20, 25.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/17.jpg',
 'Droits d\'auteur: Skylab Factory', 4),
(18, 'Le massage', 'OPEN', 8, 20, 25.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/18.jpg',
 'Droits d\'auteur: cityplug.be', 4),
(19, 'Le hamam', 'OPEN', 4, 10, 30.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/19.jpg',
 'Droits d\'auteur: Axis Parc', 4),
(20, 'Le sauna', 'OPEN', 10, 20, 20.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/20.jpg',
 'Droits d\'auteur: Officedropin.com', 4),
(21, 'Véranda', 'BUBBLE', 2, 16, 30.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/21.jpg',
 'Droits d\'auteur: Sweetspot', 5),
(22, 'Chambre d\'Adrien', 'BUBBLE', 2, 20, 25.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/22.jpg',
 'Droits d\'auteur: Smartwork Monnaie', 5),
(23, 'Nid Douillet', 'BUBBLE', 3, 12, 20.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/23.jpg',
 'Droits d\'auteur: Smartwork Amsterdam', 15),
(24, 'Lieu d\'aisance', 'BUBBLE', 1, 2, 35.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/24.jpg',
 'Droits d\'auteur: Steelcase.com', 7),
(25, 'Concentration', 'BUBBLE', 1, 3, 35.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/25.jpg',
 'Droits d\'auteur: Belgian Workspace Association', 6),
(26, 'Le bureau de Nicobo', 'BUBBLE', 1, 20, 37.0,
 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate facilisis justo ac malesuada. Quisque bibendum molestie interdum. Etiam quis eros euismod, tristique mauris ac, congue arcu.',
 '/coworking-spaces/bremen-coworking-lounge.jpg',
 'Droits d\'auteur: Officedropin.com', 6);

INSERT INTO `equipment_type` (`id`, `name`, `price`)
VALUES (1, 'Ordinateur', 5.0),
    (2, 'Imprimante', 2.0),
    (3, 'Téléphone', 1.0),
    (4, 'Scanner', 1.0),
    (5, 'Armoire', 0.5),
    (6, 'Casier', 0.5);

INSERT INTO `service_type` (`id`, `name`, `price`)
VALUES (1, 'Accueil', 1.0),
    (2, 'Courrier', 0.5),
    (3, 'Secrétariat', 7.0),
    (4, 'Catering', 10.0),
    (5, 'Café', 1.0),
    (6, 'Salle de réunion', 20.0),
    (7, 'Domiciliation virtuelle', 0.5);

INSERT INTO `space_equipment_type` (`spaces_id`, `equipment_types_id`)
VALUES (1, 5),
    (1, 3),
    (2, 2),
    (2, 4),
    (2, 5),
    (2, 6),
    (2, 1),
    (3, 5),
    (3, 4),
    (3, 1),
    (3, 2),
    (4, 6),
    (4, 3),
    (4, 2),
    (5, 6),
    (5, 4),
    (5, 3),
    (5, 5),
    (6, 6),
    (7, 1),
    (7, 4),
    (7, 6),
    (7, 3),
    (8, 1),
    (8, 2),
    (8, 6),
    (9, 6),
    (9, 2),
    (9, 4),
    (10, 2),
    (10, 6),
    (10, 1),
    (11, 4),
    (11, 2),
    (12, 1),
    (12, 6),
    (12, 2),
    (12, 3),
    (13, 1),
    (14, 2),
    (14, 4),
    (14, 1),
    (15, 4),
    (15, 6),
    (15, 2),
    (15, 1),
    (16, 4),
    (16, 1),
    (16, 6),
    (16, 2),
    (17, 2),
    (17, 4),
    (17, 6),
    (18, 4),
    (19, 4),
    (19, 2),
    (19, 3),
    (19, 6),
    (20, 2),
    (20, 6),
    (20, 1),
    (20, 4),
    (21, 6),
    (22, 6),
    (23, 6),
    (24, 6),
    (26, 6);

INSERT INTO `building_service_type` (`buildings_id`, `service_types_id`)
VALUES (1, 7),
    (1, 1),
    (2, 1),
    (2, 3),
    (2, 6),
    (2, 2),
    (3, 4),
    (3, 2),
    (4, 5),
    (5, 5),
    (5, 1),
    (6, 7),
    (7, 7),
    (7, 5),
    (7, 4),
    (7, 2),
    (8, 6),
    (8, 5),
    (8, 4),
    (9, 5),
    (9, 3),
    (9, 1),
    (9, 2),
    (10, 6),
    (10, 7),
    (11, 3),
    (11, 6),
    (11, 7),
    (11, 1),
    (11, 2),
    (12, 7),
    (13, 6),
    (13, 5),
    (13, 1),
    (13, 7),
    (13, 2),
    (13, 4),
    (14, 3),
    (14, 7),
    (14, 2),
    (14, 5),
    (14, 6),
    (15, 5),
    (16, 7),
    (17, 1),
    (17, 2),
    (17, 5),
    (17, 4),
    (17, 3),
    (17, 6),
    (18, 3),
    (18, 2),
    (18, 5),
    (18, 7),
    (18, 6),
    (19, 7),
    (20, 1),
    (20, 4),
    (20, 6),
    (20, 7),
    (20, 3),
    (20, 2),
    (21, 2),
    (21, 1),
    (21, 4),
    (22, 5),
    (22, 6),
    (22, 1),
    (22, 2),
    (23, 2),
    (23, 6),
    (23, 1),
    (23, 5),
    (23, 7),
    (24, 2),
    (24, 5),
    (24, 6),
    (25, 7),
    (25, 3);
