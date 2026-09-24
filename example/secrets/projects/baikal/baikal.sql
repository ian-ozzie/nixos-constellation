/*M!999999\- enable the sandbox mode */
-- MariaDB dump 10.19-11.4.12-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: baikal
-- ------------------------------------------------------
-- Server version	11.4.12-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `addressbookchanges`
--

DROP TABLE IF EXISTS `addressbookchanges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `addressbookchanges` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uri` varbinary(200) NOT NULL,
  `synctoken` int(11) unsigned NOT NULL,
  `addressbookid` int(11) unsigned NOT NULL,
  `operation` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `addressbookid_synctoken` (`addressbookid`,`synctoken`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbookchanges`
--

LOCK TABLES `addressbookchanges` WRITE;
/*!40000 ALTER TABLE `addressbookchanges` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbookchanges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbooks`
--

DROP TABLE IF EXISTS `addressbooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `addressbooks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `principaluri` varbinary(255) DEFAULT NULL,
  `displayname` varchar(255) DEFAULT NULL,
  `uri` varbinary(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `synctoken` int(11) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `principaluri` (`principaluri`(100),`uri`(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbooks`
--

LOCK TABLES `addressbooks` WRITE;
/*!40000 ALTER TABLE `addressbooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendarchanges`
--

DROP TABLE IF EXISTS `calendarchanges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `calendarchanges` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uri` varbinary(200) NOT NULL,
  `synctoken` int(11) unsigned NOT NULL,
  `calendarid` int(11) unsigned NOT NULL,
  `operation` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `calendarid_synctoken` (`calendarid`,`synctoken`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendarchanges`
--

LOCK TABLES `calendarchanges` WRITE;
/*!40000 ALTER TABLE `calendarchanges` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendarchanges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendarinstances`
--

DROP TABLE IF EXISTS `calendarinstances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `calendarinstances` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `calendarid` int(10) unsigned NOT NULL,
  `principaluri` varbinary(100) DEFAULT NULL,
  `access` tinyint(1) NOT NULL DEFAULT 1,
  `displayname` varchar(100) DEFAULT NULL,
  `uri` varbinary(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `calendarorder` int(11) unsigned NOT NULL DEFAULT 0,
  `calendarcolor` varbinary(10) DEFAULT NULL,
  `timezone` text DEFAULT NULL,
  `transparent` tinyint(1) NOT NULL DEFAULT 0,
  `share_href` varbinary(100) DEFAULT NULL,
  `share_displayname` varchar(100) DEFAULT NULL,
  `share_invitestatus` tinyint(1) NOT NULL DEFAULT 2,
  PRIMARY KEY (`id`),
  UNIQUE KEY `principaluri` (`principaluri`,`uri`),
  UNIQUE KEY `calendarid` (`calendarid`,`principaluri`),
  UNIQUE KEY `calendarid_2` (`calendarid`,`share_href`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendarinstances`
--

LOCK TABLES `calendarinstances` WRITE;
/*!40000 ALTER TABLE `calendarinstances` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendarinstances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendarobjects`
--

DROP TABLE IF EXISTS `calendarobjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `calendarobjects` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `calendardata` mediumblob DEFAULT NULL,
  `uri` varbinary(200) DEFAULT NULL,
  `calendarid` int(10) unsigned NOT NULL,
  `lastmodified` int(11) unsigned DEFAULT NULL,
  `etag` varbinary(32) DEFAULT NULL,
  `size` int(11) unsigned NOT NULL,
  `componenttype` varbinary(8) DEFAULT NULL,
  `firstoccurence` int(11) unsigned DEFAULT NULL,
  `lastoccurence` int(11) unsigned DEFAULT NULL,
  `uid` varbinary(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `calendarid` (`calendarid`,`uri`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendarobjects`
--

LOCK TABLES `calendarobjects` WRITE;
/*!40000 ALTER TABLE `calendarobjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendarobjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendars`
--

DROP TABLE IF EXISTS `calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `calendars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `synctoken` int(10) unsigned NOT NULL DEFAULT 1,
  `components` varbinary(21) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendars`
--

LOCK TABLES `calendars` WRITE;
/*!40000 ALTER TABLE `calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendarsubscriptions`
--

DROP TABLE IF EXISTS `calendarsubscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `calendarsubscriptions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uri` varbinary(200) NOT NULL,
  `principaluri` varbinary(100) NOT NULL,
  `source` text DEFAULT NULL,
  `displayname` varchar(100) DEFAULT NULL,
  `refreshrate` varchar(10) DEFAULT NULL,
  `calendarorder` int(11) unsigned NOT NULL DEFAULT 0,
  `calendarcolor` varbinary(10) DEFAULT NULL,
  `striptodos` tinyint(1) DEFAULT NULL,
  `stripalarms` tinyint(1) DEFAULT NULL,
  `stripattachments` tinyint(1) DEFAULT NULL,
  `lastmodified` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `principaluri` (`principaluri`,`uri`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendarsubscriptions`
--

LOCK TABLES `calendarsubscriptions` WRITE;
/*!40000 ALTER TABLE `calendarsubscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendarsubscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cards`
--

DROP TABLE IF EXISTS `cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cards` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `addressbookid` int(11) unsigned NOT NULL,
  `carddata` mediumblob DEFAULT NULL,
  `uri` varbinary(200) DEFAULT NULL,
  `lastmodified` int(11) unsigned DEFAULT NULL,
  `etag` varbinary(32) DEFAULT NULL,
  `size` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards`
--

LOCK TABLES `cards` WRITE;
/*!40000 ALTER TABLE `cards` DISABLE KEYS */;
/*!40000 ALTER TABLE `cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupmembers`
--

DROP TABLE IF EXISTS `groupmembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `groupmembers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `principal_id` int(10) unsigned NOT NULL,
  `member_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `principal_id` (`principal_id`,`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupmembers`
--

LOCK TABLES `groupmembers` WRITE;
/*!40000 ALTER TABLE `groupmembers` DISABLE KEYS */;
/*!40000 ALTER TABLE `groupmembers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locks`
--

DROP TABLE IF EXISTS `locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `locks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(100) DEFAULT NULL,
  `timeout` int(10) unsigned DEFAULT NULL,
  `created` int(11) DEFAULT NULL,
  `token` varbinary(100) DEFAULT NULL,
  `scope` tinyint(4) DEFAULT NULL,
  `depth` tinyint(4) DEFAULT NULL,
  `uri` varbinary(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `token` (`token`),
  KEY `uri` (`uri`(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locks`
--

LOCK TABLES `locks` WRITE;
/*!40000 ALTER TABLE `locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `principals`
--

DROP TABLE IF EXISTS `principals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `principals` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uri` varbinary(200) NOT NULL,
  `email` varbinary(80) DEFAULT NULL,
  `displayname` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uri` (`uri`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `principals`
--

LOCK TABLES `principals` WRITE;
/*!40000 ALTER TABLE `principals` DISABLE KEYS */;
/*!40000 ALTER TABLE `principals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propertystorage`
--

DROP TABLE IF EXISTS `propertystorage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `propertystorage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `path` varbinary(1024) NOT NULL,
  `name` varbinary(100) NOT NULL,
  `valuetype` int(10) unsigned DEFAULT NULL,
  `value` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `path_property` (`path`(600),`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propertystorage`
--

LOCK TABLES `propertystorage` WRITE;
/*!40000 ALTER TABLE `propertystorage` DISABLE KEYS */;
/*!40000 ALTER TABLE `propertystorage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedulingobjects`
--

DROP TABLE IF EXISTS `schedulingobjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedulingobjects` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `principaluri` varbinary(255) DEFAULT NULL,
  `calendardata` mediumblob DEFAULT NULL,
  `uri` varbinary(200) DEFAULT NULL,
  `lastmodified` int(11) unsigned DEFAULT NULL,
  `etag` varbinary(32) DEFAULT NULL,
  `size` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedulingobjects`
--

LOCK TABLES `schedulingobjects` WRITE;
/*!40000 ALTER TABLE `schedulingobjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedulingobjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varbinary(50) DEFAULT NULL,
  `digesta1` varbinary(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-09-24  8:23:11
