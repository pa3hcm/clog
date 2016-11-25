-- SQL-script to create the CLog 1.0 database

CREATE DATABASE clog;
USE clog;

CREATE TABLE `settings` (
  `setting_name` varchar(64) NOT NULL,
  `setting_value` varchar(255) NOT NULL
);
INSERT INTO `settings` (`setting_name`, `setting_value`) VALUES ('clog_database_version', '1.0');

CREATE TABLE `qsos` (
  `id` bigint(20) NOT NULL auto_increment,
  `mycall` varchar(32) NOT NULL,
  `callsign` varchar(32) NOT NULL,
  `qso_date` date NOT NULL default '0000-00-00',
  `qso_time` time NOT NULL default '00:00:00',
  `freq` varchar(10) NOT NULL default '',
  `mode` varchar(10) NOT NULL default '',
  `rst_tx` varchar(5) NOT NULL default '',
  `rst_rx` varchar(5) NOT NULL default '',
  `locator` varchar(6) NOT NULL default '',
  `serial_tx` int NOT NULL default '0',
  `serial_rx` int NOT NULL default '0',
  `data_tx` varchar(12) NOT NULL default '',
  `data_rx` varchar(12) NOT NULL default '',
  `comments` text NOT NULL,
  `qsl_tx` enum('Y','N') NOT NULL default 'N',
  `qsl_rx` enum('Y','N') NOT NULL default 'N',
  PRIMARY KEY (`id`)
);

CREATE TABLE `dxccs` (
  `dxcc` varchar(6) NOT NULL,
  `country` varchar(26) NOT NULL,
  `cqzone` varchar(5) NOT NULL,
  `ituzone` varchar(5) NOT NULL,
  `continent` varchar(2) NOT NULL,
  `latitude` varchar(10) NOT NULL,
  `longitude` varchar(10) NOT NULL,
  `gmt_offset` varchar(5) NOT NULL,
  `german_dxcc` enum('Y','N') NOT NULL default 'N',
  PRIMARY KEY (`dxcc`)
);

CREATE TABLE `prefixes` (
  `prefix` varchar(26) NOT NULL,
  `dxcc` varchar(6) NOT NULL,
  PRIMARY KEY (`prefix`)
);

GRANT ALL PRIVILEGES ON `clog`.* TO 'cloguser'@'localhost' IDENTIFIED BY 'clogpass';

FLUSH PRIVILEGES;

