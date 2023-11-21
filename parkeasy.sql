-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.0.32 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para parkeasy
CREATE DATABASE IF NOT EXISTS `parkeasy` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `parkeasy`;

-- Volcando estructura para tabla parkeasy.tariff_type
CREATE TABLE IF NOT EXISTS `tariff_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `rate` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla parkeasy.tariff_type: ~3 rows (aproximadamente)
INSERT INTO `tariff_type` (`id`, `name`, `rate`) VALUES
	(1, 'Mensualidad', 580),
	(2, 'Hora', 5500),
	(3, 'prueba_1', 165165);

-- Volcando estructura para tabla parkeasy.transaction
CREATE TABLE IF NOT EXISTS `transaction` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vehicle_id` int NOT NULL,
  `entry_time` datetime NOT NULL,
  `exit_time` datetime DEFAULT NULL,
  `tariff_id` int DEFAULT NULL,
  `total_amount` float DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  PRIMARY KEY (`id`),
  KEY `vehicle_id` (`vehicle_id`),
  KEY `tariff_id` (`tariff_id`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicle` (`id`),
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`tariff_id`) REFERENCES `tariff_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla parkeasy.transaction: ~6 rows (aproximadamente)
INSERT INTO `transaction` (`id`, `vehicle_id`, `entry_time`, `exit_time`, `tariff_id`, `total_amount`, `status`) VALUES
	(1, 1, '2023-11-20 20:56:02', '2023-11-20 20:59:27', 1, 853.59, 'PENDING'),
	(2, 2, '2023-11-20 21:00:21', '2023-11-20 21:00:27', 2, 9.09, 'PENDING'),
	(3, 3, '2023-11-20 21:04:41', NULL, 3, NULL, 'PENDING'),
	(4, 4, '2023-11-20 21:09:22', NULL, 2, NULL, 'PENDING'),
	(5, 5, '2023-11-20 21:34:27', NULL, 2, NULL, 'PENDING'),
	(6, 6, '2023-11-20 21:47:25', NULL, 2, NULL, 'PENDING');

-- Volcando estructura para tabla parkeasy.vehicle
CREATE TABLE IF NOT EXISTS `vehicle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `license_plate` varchar(20) NOT NULL,
  `vehicle_type` enum('car','motorcycle') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla parkeasy.vehicle: ~6 rows (aproximadamente)
INSERT INTO `vehicle` (`id`, `license_plate`, `vehicle_type`) VALUES
	(1, 'SXE208', 'car'),
	(2, 'RKQ02D', 'motorcycle'),
	(3, 'WHH280', 'car'),
	(4, 'SSH125', 'motorcycle'),
	(5, 'JTM069', 'motorcycle'),
	(6, 'ATS098', 'car');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
