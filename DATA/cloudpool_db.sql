-- MySQL dump 10.13  Distrib 8.0.11, for Win64 (x86_64)
--
-- Host: localhost    Database: cloudpool
-- ------------------------------------------------------
-- Server version	8.0.11

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `box_connect_tb`
--

DROP TABLE IF EXISTS `box_connect_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `box_connect_tb` (
  `boxConnectID` int(11) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `userID` int(10) unsigned zerofill NOT NULL,
  `accessToken_b` varchar(255) NOT NULL,
  `refreshToken_b` varchar(255) NOT NULL,
  `registerTime_b` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `recentRefreshTime_b` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`boxConnectID`),
  UNIQUE KEY `boxConnectID_UNIQUE` (`boxConnectID`),
  KEY `fk_box_connect_info_user_info_userID_idx` (`userID`),
  CONSTRAINT `fk_box_connect_info_user_info_userID` FOREIGN KEY (`userID`) REFERENCES `user_info_tb` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `box_connect_tb`
--

LOCK TABLES `box_connect_tb` WRITE;
/*!40000 ALTER TABLE `box_connect_tb` DISABLE KEYS */;
/*!40000 ALTER TABLE `box_connect_tb` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BOX_CONNECT_TB_AFTER_INSERT` AFTER INSERT ON `box_connect_tb` FOR EACH ROW BEGIN
	UPDATE DRIVE_STATE_TB 
    SET boxCount = boxCount + 1
    WHERE DRIVE_STATE_TB.userID = NEW.userID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BOX_CONNECT_TB_AFTER_DELETE` AFTER DELETE ON `box_connect_tb` FOR EACH ROW BEGIN
	UPDATE DRIVE_STATE_TB 
    SET boxCount = boxCount - 1
    WHERE DRIVE_STATE_TB.userID = OLD.userID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `drive_info_tb`
--

DROP TABLE IF EXISTS `drive_info_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `drive_info_tb` (
  `driveID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `driveName` varchar(45) NOT NULL,
  PRIMARY KEY (`driveID`),
  UNIQUE KEY `driveID_UNIQUE` (`driveID`),
  UNIQUE KEY `driveName_UNIQUE` (`driveName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drive_info_tb`
--

LOCK TABLES `drive_info_tb` WRITE;
/*!40000 ALTER TABLE `drive_info_tb` DISABLE KEYS */;
/*!40000 ALTER TABLE `drive_info_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drive_state_tb`
--

DROP TABLE IF EXISTS `drive_state_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `drive_state_tb` (
  `userID` int(10) unsigned zerofill NOT NULL,
  `grossCount` tinyint(2) GENERATED ALWAYS AS (((`googleCount` + `dropboxCount`) + `boxCount`)) VIRTUAL COMMENT 'This column is calculated by trigger from each drive register events.',
  `googleCount` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `dropboxCount` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `boxCount` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`userID`),
  KEY `fk_DRIVE_STATE_TB_USER_INFO_TB1_idx` (`userID`),
  CONSTRAINT `fk_DRIVE_STATE_TB_USER_INFO_TB1` FOREIGN KEY (`userID`) REFERENCES `user_info_tb` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drive_state_tb`
--

LOCK TABLES `drive_state_tb` WRITE;
/*!40000 ALTER TABLE `drive_state_tb` DISABLE KEYS */;
INSERT INTO `drive_state_tb` (`userID`, `googleCount`, `dropboxCount`, `boxCount`) VALUES (0000000001,0,0,0),(0000000002,0,0,0);
/*!40000 ALTER TABLE `drive_state_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dropbox_connect_tb`
--

DROP TABLE IF EXISTS `dropbox_connect_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `dropbox_connect_tb` (
  `dropboxConnectID` int(11) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `userID` int(10) unsigned zerofill NOT NULL,
  `accessToken_d` varchar(255) NOT NULL,
  `registerTime_d` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`dropboxConnectID`),
  UNIQUE KEY `dropboxConnectID_UNIQUE` (`dropboxConnectID`),
  KEY `fk_dropbox_connect_user_info_userID_idx` (`userID`),
  CONSTRAINT `fk_dropbox_connect_user_info_userID` FOREIGN KEY (`userID`) REFERENCES `user_info_tb` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dropbox_connect_tb`
--

LOCK TABLES `dropbox_connect_tb` WRITE;
/*!40000 ALTER TABLE `dropbox_connect_tb` DISABLE KEYS */;
/*!40000 ALTER TABLE `dropbox_connect_tb` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DROPBOX_CONNECT_TB_AFTER_INSERT` AFTER INSERT ON `dropbox_connect_tb` FOR EACH ROW BEGIN
	UPDATE DRIVE_STATE_TB 
    SET dropboxCount = dropboxCount + 1
    WHERE DRIVE_STATE_TB.userID = NEW.userID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DROPBOX_CONNECT_TB_AFTER_DELETE` AFTER DELETE ON `dropbox_connect_tb` FOR EACH ROW BEGIN
	UPDATE DRIVE_STATE_TB 
    SET dropboxCount = dropboxCount - 1
    WHERE DRIVE_STATE_TB.userID = OLD.userID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `google_connect_tb`
--

DROP TABLE IF EXISTS `google_connect_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `google_connect_tb` (
  `googleConnectID` int(11) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `userID` int(10) unsigned zerofill NOT NULL,
  `accessToken_g` varchar(255) NOT NULL,
  `refreshToken_g` varchar(255) NOT NULL,
  `registerTime_g` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `recentRefreshTime_g` timestamp NOT NULL,
  PRIMARY KEY (`googleConnectID`),
  UNIQUE KEY `googleConnectID_UNIQUE` (`googleConnectID`),
  KEY `fk_google_connect_user_info_userID_idx` (`userID`),
  CONSTRAINT `fk_google_connect_user_info_userID` FOREIGN KEY (`userID`) REFERENCES `user_info_tb` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `google_connect_tb`
--

LOCK TABLES `google_connect_tb` WRITE;
/*!40000 ALTER TABLE `google_connect_tb` DISABLE KEYS */;
/*!40000 ALTER TABLE `google_connect_tb` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `GOOGLE_CONNECT_TB_AFTER_INSERT` AFTER INSERT ON `google_connect_tb` FOR EACH ROW BEGIN
	UPDATE DRIVE_STATE_TB 
    SET googleCount = googleCount + 1
    WHERE DRIVE_STATE_TB.userID = NEW.userID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `GOOGLE_CONNECT_TB_AFTER_DELETE` AFTER DELETE ON `google_connect_tb` FOR EACH ROW BEGIN
	UPDATE DRIVE_STATE_TB 
    SET googleCount = googleCount - 1
    WHERE DRIVE_STATE_TB.userID = OLD.userID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `login_log_tb`
--

DROP TABLE IF EXISTS `login_log_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `login_log_tb` (
  `loginID` int(15) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `userID` int(10) unsigned zerofill NOT NULL,
  `loginTime` varchar(45) NOT NULL,
  `local` varchar(45) NOT NULL,
  `ipAddress` varchar(45) NOT NULL,
  `loginOS` varchar(45) NOT NULL,
  PRIMARY KEY (`loginID`),
  UNIQUE KEY `loginID_UNIQUE` (`loginID`),
  KEY `fk_login_log_user_info_userID_idx` (`userID`),
  CONSTRAINT `fk_login_log_user_info_userID` FOREIGN KEY (`userID`) REFERENCES `user_info_tb` (`userid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_log_tb`
--

LOCK TABLES `login_log_tb` WRITE;
/*!40000 ALTER TABLE `login_log_tb` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_log_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_info_tb`
--

DROP TABLE IF EXISTS `user_info_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `user_info_tb` (
  `userID` int(10) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `userName` varchar(64) NOT NULL,
  `email` varchar(320) NOT NULL,
  `salt` varchar(256) NOT NULL,
  `password` varchar(256) NOT NULL,
  `registerTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `userID_UNIQUE` (`userID`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `salt_UNIQUE` (`salt`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_info_tb`
--

LOCK TABLES `user_info_tb` WRITE;
/*!40000 ALTER TABLE `user_info_tb` DISABLE KEYS */;
INSERT INTO `user_info_tb` VALUES (0000000001,'leehangbok','leehangbok2009@gmail.com','zL/pS2b/C+REPY/GXpO52JuxqZTICHbaPn5Sn47ltD3Aq0Rf/gfmVZ0nmnuoCmt35yNwH3f5iz4xAXVSw25jtw==','IZCPgQh/iDfo7T5kTl4XTqru2mTrMaoYbZ8vr2l2S+k7WySdONyVEsdKFo5BlRM6q/saXIYSxTibuX9pKlypdGWQqIx870tW58Ys/Y9Nv4hxa16qi9y6sgn+rLTYLIEA7ld6AYuiqJpptY+rP8aErjXYNa75LNVmq/H/38zDcVs=','2018-07-06 13:53:58'),(0000000002,'ikhwan','ikhwan@gmail.com','TknXwl2t06WrNBqgVmbGuULeaE/qy2ruAhMj+L9ovmP3Vzp4xWKlIkHZWbsSlg7UOFnbkQhHKnflRsXG2q7IQw==','ThAJin7bcpXsC+4R+cM/C/Ppm1yDGgaxqgDb9GncUou22+Gi5gL/KOKkn3prB0tp5zVP1VdZb7pBzG+XHwjgqDGbBkGCVUYS7Zs4STCDV46YHlTkmqvC6V6pkD2HTsQiUM4XLXs4/hom1n6wHTLJ4V42vrRz1/7Yp9D0hsI4jHM=','2018-07-09 02:27:40');
/*!40000 ALTER TABLE `user_info_tb` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `USER_INFO_TB_AFTER_INSERT` AFTER INSERT ON `user_info_tb` FOR EACH ROW BEGIN
	INSERT INTO DRIVE_STATE_TB
    SET userID = NEW.userID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-07-09 16:16:25
