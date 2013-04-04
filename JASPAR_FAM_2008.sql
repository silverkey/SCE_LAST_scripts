-- MySQL dump 10.11
--
-- Host: hal9000    Database: rs9_JASPAR_FAM_2008
-- ------------------------------------------------------
-- Server version	5.0.72

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `MATRIX_ANNOTATION`
--

DROP TABLE IF EXISTS `MATRIX_ANNOTATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MATRIX_ANNOTATION` (
  `ID` varchar(16) NOT NULL default '',
  `tag` varchar(255) NOT NULL default '',
  `val` text,
  PRIMARY KEY  (`ID`,`tag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MATRIX_ANNOTATION`
--

LOCK TABLES `MATRIX_ANNOTATION` WRITE;
/*!40000 ALTER TABLE `MATRIX_ANNOTATION` DISABLE KEYS */;
INSERT INTO `MATRIX_ANNOTATION` VALUES ('MF0001','included_models','MA0026,MA0028,MA0062,MA0076,MA0080,MA0081,MA0098'),('MF0001','type','METAMODEL'),('MF0001','medline','15066426'),('MF0001','class','ETS'),('MF0001','name','ETS class'),('MF0002','medline','15066426'),('MF0002','name','bZIP CREB/G-box-like subclass'),('MF0002','class','bZIP'),('MF0002','type','METAMODEL'),('MF0002','included_models','MA0018,MA0089,MA0096,MA0097'),('MF0003','medline','15066426'),('MF0003','class','REL'),('MF0003','included_models','MA0022,MA0023,MA0061,MA0101,MA0105,MA0107'),('MF0003','type','METAMODEL'),('MF0003','name','REL class'),('MF0004','included_models','MA0007,MA0016,MA0017,MA0065,MA0066,MA0071,MA0072,MA0074'),('MF0004','name','Nuclear Receptor class'),('MF0004','medline','15066426'),('MF0004','type','METAMODEL'),('MF0004','class','Nuclear receptor'),('MF0005','type','METAMODEL'),('MF0005','name','Forkhead class'),('MF0005','class','Forkhead'),('MF0005','medline','15066426'),('MF0005','included_models','MA0030,MA0031,MA0032,MA0033,MA0040,MA0041,MA0042,MA0047'),('MF0006','type','METAMODEL'),('MF0006','medline','15066426'),('MF0006','included_models','MA0019,MA0025,MA0043,MA0102'),('MF0006','class','bZIP'),('MF0006','name','bZIP cEBP-like subclass'),('MF0007','type','METAMODEL'),('MF0007','medline','15066426'),('MF0007','included_models','MA0004,MA0006,MA0048,MA0055,MA0058, MA0059,MA0091,MA0092,MA0093,MA0104'),('MF0007','name','bHLH(zip) class'),('MF0007','class','bHLH(zip)'),('MF0008','name','MADS class'),('MF0008','class','MADS'),('MF0008','included_models','MA0001,MA0005,MA0052,MA0082,MA0083'),('MF0008','medline','15066426'),('MF0008','type','METAMODEL'),('MF0009','type','METAMODEL'),('MF0009','name','TRP(MYB) class'),('MF0009','class','TRP'),('MF0009','included_models',' MA0034,MA0050,MA0051,MA0054,MA0100'),('MF0009','medline','15066426'),('MF0010','type','METAMODEL'),('MF0010','included_models','MA0008,MA0027,MA0046,MA0063,MA0068,MA0070,MA0075,MA0094'),('MF0010','class','Homeo'),('MF0010','name','Homeobox class'),('MF0010','medline','15066426'),('MF0011','class','HMG'),('MF0011','name','HMG class'),('MF0011','included_models','MA0044,MA0045,MA0077,MA0078,MA0084,MA0087'),('MF0011','medline','15066426'),('MF0011','type','METAMODEL');
/*!40000 ALTER TABLE `MATRIX_ANNOTATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MATRIX_DATA`
--

DROP TABLE IF EXISTS `MATRIX_DATA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MATRIX_DATA` (
  `ID` varchar(16) NOT NULL default '',
  `row` varchar(1) NOT NULL,
  `col` tinyint(3) unsigned NOT NULL,
  `val` float default NULL,
  PRIMARY KEY  (`ID`,`row`,`col`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MATRIX_DATA`
--

LOCK TABLES `MATRIX_DATA` WRITE;
/*!40000 ALTER TABLE `MATRIX_DATA` DISABLE KEYS */;
INSERT INTO `MATRIX_DATA` VALUES ('MF0001','T',7,10.77),('MF0001','C',6,0.25),('MF0001','G',7,0),('MF0001','C',5,0.35),('MF0001','C',4,0.5),('MF0001','C',3,65.25),('MF0001','C',2,68.2),('MF0001','C',1,8.49),('MF0001','A',8,23.49),('MF0001','A',7,86.66),('MF0001','A',6,98.6),('MF0001','A',5,1.55),('MF0001','A',4,1.92),('MF0001','A',3,22.86),('MF0001','A',2,10.41),('MF0001','A',1,61.75),('MF0001','C',7,2.57),('MF0001','C',8,8.71),('MF0001','T',8,3.8),('MF0001','T',6,0.28),('MF0001','T',5,0.78),('MF0001','T',4,2.81),('MF0001','T',3,3.59),('MF0001','T',2,4.13),('MF0001','T',1,14.58),('MF0001','G',8,64),('MF0001','G',6,0.87),('MF0001','G',5,97.32),('MF0001','G',4,94.77),('MF0001','G',3,8.3),('MF0001','G',2,17.27),('MF0001','G',1,15.18),('MF0002','A',5,0),('MF0002','T',3,0),('MF0002','C',6,10.32),('MF0002','A',3,100),('MF0002','A',2,0.74),('MF0002','A',1,0),('MF0002','G',5,100),('MF0002','T',2,2.29),('MF0002','G',6,0),('MF0002','T',1,100),('MF0002','T',4,4.46),('MF0002','T',5,0),('MF0002','A',4,0),('MF0002','A',6,2.06),('MF0002','C',1,0),('MF0002','G',3,0),('MF0002','G',2,96.97),('MF0002','G',1,0),('MF0002','G',4,1.48),('MF0002','C',4,94.06),('MF0002','C',5,0),('MF0002','C',3,0),('MF0002','C',2,0),('MF0002','T',6,87.61),('MF0003','G',2,90.85),('MF0003','T',3,4.82),('MF0003','T',10,3.44),('MF0003','C',7,5.5),('MF0003','G',6,4.15),('MF0003','G',5,15.2),('MF0003','G',4,54.49),('MF0003','G',3,93.76),('MF0003','G',1,79.71),('MF0003','C',10,91.17),('MF0003','C',9,90.67),('MF0003','G',7,2.73),('MF0003','G',8,0),('MF0003','G',9,0),('MF0003','T',9,7.17),('MF0003','T',8,70.12),('MF0003','T',6,73.14),('MF0003','T',5,26.29),('MF0003','T',4,14.06),('MF0003','T',2,6.89),('MF0003','T',1,9.83),('MF0003','G',10,1.28),('MF0003','C',8,27.04),('MF0003','C',2,2.26),('MF0003','T',7,90.35),('MF0003','C',5,16.16),('MF0003','C',4,2.26),('MF0003','A',10,4.11),('MF0003','C',3,0),('MF0003','C',1,10.46),('MF0003','A',9,2.16),('MF0003','A',8,2.84),('MF0003','A',7,1.42),('MF0003','A',1,0),('MF0003','C',6,3.27),('MF0003','A',2,0),('MF0003','A',3,1.42),('MF0003','A',4,29.19),('MF0003','A',5,42.35),('MF0003','A',6,19.44),('MF0004','T',6,1.63),('MF0004','T',5,5.04),('MF0004','T',4,73.94),('MF0004','T',3,11.99),('MF0004','C',3,2.36),('MF0004','C',5,77.72),('MF0004','C',6,17.39),('MF0004','G',1,37.1),('MF0004','G',2,86.63),('MF0004','C',2,0.69),('MF0004','G',3,80.06),('MF0004','C',1,3.5),('MF0004','A',6,74.36),('MF0004','A',5,13.16),('MF0004','A',4,14.55),('MF0004','G',5,4.08),('MF0004','G',6,6.62),('MF0004','A',3,5.58),('MF0004','T',1,10.53),('MF0004','T',2,9.52),('MF0004','A',2,3.16),('MF0004','A',1,48.87),('MF0004','G',4,6.77),('MF0004','C',4,4.74),('MF0005','C',2,0),('MF0005','C',4,1.03),('MF0005','C',3,1.79),('MF0005','C',6,0),('MF0005','C',7,40.68),('MF0005','C',8,10.32),('MF0005','G',9,11.58),('MF0005','C',9,20.28),('MF0005','G',1,0),('MF0005','G',2,74.29),('MF0005','G',3,0.77),('MF0005','G',4,0),('MF0005','G',5,8.65),('MF0005','G',6,20.65),('MF0005','G',7,6.37),('MF0005','G',8,22.62),('MF0005','C',1,2.42),('MF0005','A',9,6.65),('MF0005','A',1,3.06),('MF0005','A',2,24.6),('MF0005','A',3,0),('MF0005','A',4,0.35),('MF0005','A',5,1.35),('MF0005','T',9,61.49),('MF0005','T',8,50.14),('MF0005','T',7,50.73),('MF0005','T',6,3.25),('MF0005','T',5,90),('MF0005','T',4,98.63),('MF0005','T',3,97.44),('MF0005','T',2,1.11),('MF0005','T',1,94.52),('MF0005','A',6,76.1),('MF0005','A',7,2.22),('MF0005','A',8,16.92),('MF0005','C',5,0),('MF0006','A',2,2.71),('MF0006','T',9,15.49),('MF0006','A',1,60.01),('MF0006','C',6,4.21),('MF0006','C',5,77.62),('MF0006','C',4,0),('MF0006','C',3,1.35),('MF0006','C',2,3.09),('MF0006','C',1,8.66),('MF0006','A',9,72.66),('MF0006','A',8,65.18),('MF0006','A',7,15.68),('MF0006','T',8,8.29),('MF0006','A',6,50.27),('MF0006','A',5,3.48),('MF0006','A',4,40.48),('MF0006','A',3,0),('MF0006','C',7,20.62),('MF0006','T',7,59.04),('MF0006','G',7,4.65),('MF0006','G',8,5.8),('MF0006','G',9,4.37),('MF0006','T',1,2.71),('MF0006','T',2,92.95),('MF0006','T',3,92.61),('MF0006','T',4,5.35),('MF0006','T',5,16.05),('MF0006','G',2,1.25),('MF0006','G',6,42.67),('MF0006','G',1,28.62),('MF0006','G',4,54.17),('MF0006','G',3,6.03),('MF0006','G',5,2.85),('MF0006','T',6,2.85),('MF0006','C',9,7.49),('MF0006','C',8,20.73),('MF0007','A',5,4.03),('MF0007','T',3,3.82),('MF0007','A',6,5.81),('MF0007','A',1,61.35),('MF0007','A',4,83.86),('MF0007','A',3,3.74),('MF0007','A',2,21.78),('MF0007','T',8,2.19),('MF0007','A',7,5.06),('MF0007','A',8,2.85),('MF0007','G',5,21.07),('MF0007','G',6,67.79),('MF0007','G',7,0.18),('MF0007','G',8,94.96),('MF0007','T',1,3.56),('MF0007','T',2,16.6),('MF0007','T',4,6.33),('MF0007','T',5,9.75),('MF0007','T',6,0.67),('MF0007','G',3,1.48),('MF0007','G',2,26.55),('MF0007','C',1,12.12),('MF0007','C',2,35.06),('MF0007','C',3,90.95),('MF0007','C',4,1.16),('MF0007','C',5,65.16),('MF0007','C',6,25.73),('MF0007','C',7,4.13),('MF0007','C',8,0),('MF0007','G',1,22.97),('MF0007','T',7,90.63),('MF0007','G',4,8.64),('MF0008','T',2,48.17),('MF0008','G',9,70.37),('MF0008','G',8,3.29),('MF0008','G',7,3.58),('MF0008','G',6,0.44),('MF0008','G',5,1.1),('MF0008','G',4,5.34),('MF0008','G',3,3.75),('MF0008','G',10,84.55),('MF0008','T',1,4.02),('MF0008','T',3,18.75),('MF0008','T',10,8.3),('MF0008','T',9,1.51),('MF0008','T',8,73.78),('MF0008','T',7,41.39),('MF0008','C',6,0.44),('MF0008','T',6,82.72),('MF0008','T',5,45.28),('MF0008','T',4,71.75),('MF0008','G',2,1.34),('MF0008','G',1,1.76),('MF0008','A',1,3.18),('MF0008','A',2,1.11),('MF0008','A',3,70.03),('MF0008','A',4,17.72),('MF0008','C',10,1.78),('MF0008','A',5,52.73),('MF0008','A',6,16.4),('MF0008','A',7,53.03),('MF0008','A',9,28.12),('MF0008','A',10,5.37),('MF0008','C',9,0),('MF0008','C',8,4.99),('MF0008','C',7,2),('MF0008','C',5,0.89),('MF0008','C',4,5.19),('MF0008','C',3,7.46),('MF0008','C',2,49.38),('MF0008','C',1,91.04),('MF0008','A',8,17.94),('MF0009','T',8,95.48),('MF0009','G',3,20.98),('MF0009','G',4,5.33),('MF0009','G',5,47.12),('MF0009','G',6,71.64),('MF0009','G',7,0),('MF0009','G',8,1.2),('MF0009','T',1,57.03),('MF0009','A',5,26.4),('MF0009','T',2,33.28),('MF0009','T',3,41.02),('MF0009','T',4,18.06),('MF0009','T',5,6.57),('MF0009','T',6,6.3),('MF0009','T',7,96.67),('MF0009','G',2,36.62),('MF0009','G',1,6.35),('MF0009','A',1,33.73),('MF0009','A',2,25.74),('MF0009','A',3,34.15),('MF0009','A',4,5.83),('MF0009','A',6,1.5),('MF0009','A',7,2.33),('MF0009','A',8,1.8),('MF0009','C',1,2.9),('MF0009','C',7,1),('MF0009','C',2,4.35),('MF0009','C',3,3.85),('MF0009','C',4,70.79),('MF0009','C',5,19.91),('MF0009','C',6,20.56),('MF0009','C',8,1.52),('MF0010','T',1,10.19),('MF0010','G',7,8.04),('MF0010','G',6,7.17),('MF0010','T',3,86.67),('MF0010','T',2,22.17),('MF0010','T',4,11.32),('MF0010','T',5,6.49),('MF0010','T',6,83.94),('MF0010','T',7,71.35),('MF0010','C',1,8.16),('MF0010','G',5,10.82),('MF0010','G',4,21.19),('MF0010','A',1,75.21),('MF0010','A',2,60.1),('MF0010','A',3,5.25),('MF0010','A',4,65.22),('MF0010','A',5,80.83),('MF0010','A',6,7.91),('MF0010','A',7,12.7),('MF0010','C',2,3.43),('MF0010','C',3,4.65),('MF0010','G',3,3.44),('MF0010','G',2,14.29),('MF0010','G',1,6.44),('MF0010','C',7,7.91),('MF0010','C',6,0.98),('MF0010','C',5,1.86),('MF0010','C',4,2.27),('MF0011','A',2,1.68),('MF0011','A',3,1.61),('MF0011','A',4,11.29),('MF0011','A',5,12.28),('MF0011','A',6,10.05),('MF0011','C',1,9),('MF0011','C',2,6.34),('MF0011','C',3,4.96),('MF0011','C',4,6.65),('MF0011','C',5,8.38),('MF0011','G',1,0),('MF0011','A',1,60.43),('MF0011','C',6,17.54),('MF0011','T',5,76.2),('MF0011','T',4,7.53),('MF0011','T',3,92.51),('MF0011','T',2,77.94),('MF0011','T',1,30.58),('MF0011','G',6,10.7),('MF0011','G',5,3.14),('MF0011','G',4,74.53),('MF0011','G',3,0.92),('MF0011','G',2,14.03),('MF0011','T',6,61.71);
/*!40000 ALTER TABLE `MATRIX_DATA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MATRIX_INFO`
--

DROP TABLE IF EXISTS `MATRIX_INFO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MATRIX_INFO` (
  `ID` varchar(16) NOT NULL default '',
  `type` enum('PFM','ICM','PWM') NOT NULL default 'PFM',
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MATRIX_INFO`
--

LOCK TABLES `MATRIX_INFO` WRITE;
/*!40000 ALTER TABLE `MATRIX_INFO` DISABLE KEYS */;
INSERT INTO `MATRIX_INFO` VALUES ('MF0001','PFM'),('MF0002','PFM'),('MF0003','PFM'),('MF0004','PFM'),('MF0005','PFM'),('MF0006','PFM'),('MF0007','PFM'),('MF0008','PFM'),('MF0009','PFM'),('MF0010','PFM'),('MF0011','PFM');
/*!40000 ALTER TABLE `MATRIX_INFO` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-11-13 18:29:55
