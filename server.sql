-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.27-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;



-- Dumping structure for table fivem_economy.users
CREATE TABLE `users` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`cash` INT(11) NOT NULL DEFAULT '0',
	`bank` INT(11) NOT NULL DEFAULT '0',
	`dirty_money` INT(11) NOT NULL DEFAULT '0',
	`job` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`position` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`salary` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE,
	CONSTRAINT `position` CHECK (json_valid(`position`))
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=4
;

CREATE TABLE `player_inventory` (
	`identifier` VARCHAR(40) NOT NULL COLLATE 'utf8mb4_general_ci',
	`item` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`count` INT(11) NOT NULL,
	PRIMARY KEY (`identifier`, `item`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;



/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
