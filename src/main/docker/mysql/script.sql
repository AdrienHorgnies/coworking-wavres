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
    PRIMARY KEY (`id`),
    FOREIGN KEY (`building_id`) REFERENCES `building`(`id`)
)
    ENGINE = InnoDB;

CREATE TABLE `equipment_type` (
    `id`   SERIAL      NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(25) NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;

CREATE TABLE `service_type` (
    `id`   SERIAL      NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(25) NOT NULL,
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

CREATE TABLE `space_service_type` (
    `spaces_id`        BIGINT UNSIGNED NOT NULL,
    `service_types_id` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`spaces_id`, `service_types_id`),
    FOREIGN KEY (`spaces_id`) REFERENCES `space`(`id`),
    FOREIGN KEY (`service_types_id`) REFERENCES `service_type`(`id`)
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

INSERT INTO `space` (`id`, `name`, `type`, `people_capacity`, `area`, `building_id`)
VALUES (1, 'Salon', 'PRIVATE', 4, 20, 5),
    (2, 'Véranda', 'BUBBLE', 2, 16, 5),
    (3, 'All Start Nest', 'OPEN', 12, 25, 6),
    (4, 'Salle 1', 'OPEN', 60, 100, 8),
    (5, 'Salle 2', 'OPEN', 80, 120, 8),
    (6, 'L104', 'PRIVATE', 20, 40, 1),
    (7, 'L108', 'PRIVATE', 20, 45, 1),
    (8, 'Chambre d\'Adrien', 'BUBBLE', 2, 20, 5),
    (9, 'Nid Douillet', 'BUBBLE', 3, 12, 15),
    (10, 'B-Rocket Launch Pad', 'OPEN', 20, 60, 6),
    (11, 'Lieu d\'aisance', 'BUBBLE', 1, 2, 7),
    (12, 'Aile de Paillettes', 'PRIVATE', 6, 14, 10),
    (13, 'QG', 'PRIVATE', 6, 18, 12),
    (14, 'War Room', 'PRIVATE', 10, 20, 2),
    (15, 'Salle des tatamis', 'OPEN', 40, 60, 1),
    (16, 'Concentration', 'BUBBLE', 1, 3, 6),
    (17, 'La Tonte', 'OPEN', 10, 28, 9),
    (18, 'L\'enjambée', 'OPEN', 16, 34, 7),
    (19, 'Les guichets', 'PRIVATE', 4, 8, 8),
    (20, 'L\'ossature', 'OPEN', 8, 20, 4),
    (21, 'Le massage', 'OPEN', 8, 20, 4),
    (22, 'Le hamam', 'OPEN', 4, 10, 4),
    (23, 'Le sauna', 'OPEN', 10, 20, 4),
    (24, 'L\'aquarium A', 'PRIVATE', 8, 22, 6),
    (25, 'L\'aquarium B', 'PRIVATE', 8, 22, 6),
    (26, 'Le bureau de Nicobo', 'BUBBLE', 1, 20, 6);
