/*
SQLyog Community v9.63 
MySQL - 5.1.63-log : Database - aeses
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`aeses` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `aeses`;

/* Procedure structure for procedure `caiso_historical` */

/*!50003 DROP PROCEDURE IF EXISTS  `caiso_historical` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `caiso_historical`()
BEGIN
/********CAISO Non-Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='NR') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='NR') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='NR') AS previous_year_clearing_price,
        d.clearing_price AS volume
FROM (SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_raw WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3000)) AND anc_type='NR') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3000))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_volume WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3000)) AND anc_type='NR')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Non-Spinning Reserve') c;
/********CAISO Regulation Down****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS previous_year_clearing_price,
        d.clearing_price AS volume
FROM (SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_raw WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=4001)) AND anc_type='RD') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=4001))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_volume WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=4001)) AND anc_type='RD')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Down') c;
/********CAISO Regulation Up****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS previous_year_clearing_price,
        d.clearing_price AS volume
FROM (SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_raw WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3001)) AND anc_type='RU') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3001))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_volume WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3001)) AND anc_type='RU')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Up') c;
/********CAISO Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='SR') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='SR') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='SR') AS previous_year_clearing_price,
        d.clearing_price AS volume
FROM (SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_raw WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3003)) AND anc_type='SR') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3003))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_volume WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3003)) AND anc_type='SR')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Spinning Reserve') c;
/********CAISO Regulation****/
REPLACE INTO bi_fact_markets_part
SELECT dn.bi_dim_date_id AS bi_dim_date_id,
	3030 AS bi_dim_market_id,
	dn.clearing_price+up.clearing_price AS clearing_price,
	dn.thirty_day_avg+up.thirty_day_avg AS thirty_day_avg,
	dn.ninety_day_avg+up.ninety_day_avg AS ninety_day_avg,
	dn.previous_year_clearing_price+up.previous_year_clearing_price AS previous_year_clearing_price,
	dn.volume + up.volume AS volume
FROM
(SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS previous_year_clearing_price,
        d.clearing_price AS volume
FROM (SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_raw WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3001)) AND anc_type='RD') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3001))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_volume WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3001)) AND anc_type='RD')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Down') c) dn
JOIN
(SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS previous_year_clearing_price,
        d.clearing_price AS volume
FROM (SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_raw WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3002)) AND anc_type='RU') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3002))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(datetime,'US/Central','GMT') AS datetime,clearing_price from caiso_dam_ancillary_volume WHERE DATETIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3002)) AND anc_type='RU')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Up') c) up
ON dn.bi_dim_date_id=up.bi_dim_date_id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `caiso_missing_data` */

/*!50003 DROP PROCEDURE IF EXISTS  `caiso_missing_data` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `caiso_missing_data`()
BEGIN
/********CAISO Non-Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='NR') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='NR') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='NR') AS previous_year_clearing_price,
        d.clearing_price AS volume,
    /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='NR') AS one_year_avg,
	 NULL AS "capacity"
     /******************************/
FROM (SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='NR') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00') b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='NR')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Non-Spinning Reserve') c;
/********CAISO Regulation Down****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS previous_year_clearing_price,
        d.clearing_price AS volume,
     /*** 12 month rolling avg ****/
    (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS one_year_avg,
	 NULL AS "capacity"
    /*****************************/
FROM (SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='RD') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00') b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='RD')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Down') c;
/********CAISO Regulation Up****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS previous_year_clearing_price,
        d.clearing_price AS volume,
     /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS one_year_avg,
	 NULL AS "capacity"
     /******************************/
FROM (SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='RU') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00') b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='RU')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Up') c;
/********CAISO Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='SR') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='SR') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='SR') AS previous_year_clearing_price,
        d.clearing_price AS volume,
    /**** 12 month rolling avg ***/
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='SR') AS one_year_avg,
	 NULL AS "capacity"
     /****************************/
FROM (SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='SR') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00') b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='SR')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Spinning Reserve') c;
/********CAISO Regulation****/
REPLACE INTO bi_fact_markets_part
SELECT dn.bi_dim_date_id AS bi_dim_date_id,
	3030 AS bi_dim_market_id,
	dn.clearing_price+up.clearing_price AS clearing_price,
	dn.thirty_day_avg+up.thirty_day_avg AS thirty_day_avg,
	dn.ninety_day_avg+up.ninety_day_avg AS ninety_day_avg,
	dn.previous_year_clearing_price+up.previous_year_clearing_price AS previous_year_clearing_price,
	dn.volume + up.volume AS volume,
     dn.one_year_avg+up.one_year_avg AS one_year_avg,
      NULL AS "capacity"
FROM
(SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS ninety_day_avg,
     /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS one_year_avg,
     /*******************************/
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS previous_year_clearing_price,
        d.clearing_price AS volume
FROM (SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='RD') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00') b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='RD')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Down') c) dn
JOIN
(SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS ninety_day_avg,
     /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS one_year_avg,
     /*******************************/
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS previous_year_clearing_price,
        d.clearing_price AS volume
FROM (SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='RU') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00') b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME BETWEEN '2012-09-22 23:00:00' AND '2012-09-25 23:00:00' AND anc_type='RU')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Up') c) up
ON dn.bi_dim_date_id=up.bi_dim_date_id;
 END */$$
DELIMITER ;

/* Procedure structure for procedure `d` */

/*!50003 DROP PROCEDURE IF EXISTS  `d` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `d`()
begin
INSERT IGNORE INTO bi_fact_markets_part
select  b.id as bi_dim_date_id, c.id as bi_dim_market_id, a.cp as clearing_price
from (select East_10_Min_Spinning_Reserve as cp,time_stamp
from nyiso_ancillary_service_prices_dayahead_raw where time_stamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') a
join
(select * from bi_dim_date where timestamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') b
on a.time_stamp=b.timestamp
join
(select * from bi_dim_market where zone = 'East'AND service_orig = 'Spinning Reserve' and id=502) c ;
INSERT IGNORE INTO bi_fact_markets_part
select  b.id as bi_dim_date_id, c.id as bi_dim_market_id, a.cp as clearing_price
from (select East_10_Min_Non_Synchronous_Reserve as cp,time_stamp
from nyiso_ancillary_service_prices_dayahead_raw where time_stamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') a
join
(select * from bi_dim_date where timestamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') b
on a.time_stamp=b.timestamp
join
(select * from bi_dim_market where zone = 'East'AND service_orig = 'Non Synchronous Reserve' and id=501) c ;
INSERT IGNORE INTO bi_fact_markets_part
select  b.id as bi_dim_date_id, c.id as bi_dim_market_id, a.cp as clearing_price
from (select East_Regulation as cp,time_stamp
from nyiso_ancillary_service_prices_dayahead_raw where time_stamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') a
join
(select * from bi_dim_date where timestamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') b
on a.time_stamp=b.timestamp
join
(select * from bi_dim_market where zone = 'East' AND service_orig = 'Regulation' and id=500) c ;
INSERT IGNORE INTO bi_fact_markets_part
select  b.id as bi_dim_date_id, c.id as bi_dim_market_id, a.cp as clearing_price
from (select East_30_Min_Operating_Reserve as cp,time_stamp
from nyiso_ancillary_service_prices_dayahead_raw where time_stamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') a
join
(select * from bi_dim_date where timestamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') b
on a.time_stamp=b.timestamp
join
(select * from bi_dim_market where zone = 'East' AND service_orig = 'Operating Reserve' and id=503) c ;
INSERT IGNORE INTO bi_fact_markets_part
select  b.id as bi_dim_date_id, c.id as bi_dim_market_id, a.cp as clearing_price
from (select West_10_Min_Spinning_Reserve as cp,time_stamp
from nyiso_ancillary_service_prices_dayahead_raw where time_stamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') a
join
(select * from bi_dim_date where timestamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') b
on a.time_stamp=b.timestamp
join
(select * from bi_dim_market where zone = 'West' AND service_orig = 'Spinning Reserve' and id=506) c ;
INSERT IGNORE INTO bi_fact_markets_part
select  b.id as bi_dim_date_id, c.id as bi_dim_market_id, a.cp as clearing_price
from (select West_10_Min_Non_Synchronous_Reserve as cp,time_stamp
from nyiso_ancillary_service_prices_dayahead_raw where time_stamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') a
join
(select * from bi_dim_date where timestamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') b
on a.time_stamp=b.timestamp
join
(select * from bi_dim_market where zone = 'West' AND service_orig = 'Non Synchronous Reserve' and id=505) c ;
INSERT IGNORE INTO bi_fact_markets_part
select  b.id as bi_dim_date_id, c.id as bi_dim_market_id, a.cp as clearing_price
from (select West_Regulation as cp,time_stamp
from nyiso_ancillary_service_prices_dayahead_raw where time_stamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') a
join
(select * from bi_dim_date where timestamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') b
on a.time_stamp=b.timestamp
join
(select * from bi_dim_market where zone = 'West' AND service_orig = 'Regulation' and id=508) c ;
INSERT IGNORE INTO bi_fact_markets_part
select  b.id as bi_dim_date_id, c.id as bi_dim_market_id, a.cp as clearing_price
from (select West_30_Min_Operating_Reserve as cp,time_stamp
from nyiso_ancillary_service_prices_dayahead_raw where time_stamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') a
join
(select * from bi_dim_date where timestamp between '2009-01-01 00:00:00' and '2011-03-10 23:00:00') b
on a.time_stamp=b.timestamp
join
(select * from bi_dim_market where zone = 'West' AND service_orig = 'Operating Reserve' and id=507) c ;

end */$$
DELIMITER ;

/* Procedure structure for procedure `ercot_missing_data` */

/*!50003 DROP PROCEDURE IF EXISTS  `ercot_missing_data` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `ercot_missing_data`()
BEGIN
REPLACE `bi_fact_markets_part`
SELECT  b.id AS bi_dim_date_id,
        2001 AS bi_dim_market_id,
        a.cp AS clearing_price,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('MCPCNS','NSPIN') )
	AS thirty_day_avg,
	(SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('MCPCNS','NSPIN'))
	AS ninety_day_avg,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
	AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('MCPCNS','NSPIN')) AS previous_year_clearing_price,
	(SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('MCPCNS','NSPIN'))
	AS one_year_avg,	
	c.quantity AS volume,
	NULL AS capacity
FROM (SELECT CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,zone,cp FROM ercot_dam_ancillary_raw
WHERE time_stamp BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59'
AND zone IN ('MCPCNS','NSPIN')) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date 
WHERE timestamp_gmt 
BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59' ) b ON b.timestamp_gmt =a.time_stamp
LEFT JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS date_time,quantity,ancillarytype 
FROM ercot_dam_ancillary_plan_raw 
WHERE date_time BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59' AND 
ancillarytype = "NSPIN")c ON c.date_time = b.timestamp_gmt;
REPLACE `bi_fact_markets_part`
SELECT  b.id AS bi_dim_date_id,
        2002 AS bi_dim_market_id,
        a.cp AS clearing_price,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('MCPCRS','RRS'))
    AS thirty_day_avg,
    (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('MCPCRS','RRS'))
    AS ninety_day_avg,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('MCPCRS','RRS')) AS previous_year_clearing_price,
c.quantity AS volume,
 /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('MCPCRS','RRS'))
    AS one_year_avg,
    NULL AS "capacity"
    /* d.mcpc AS "capacity"*/
    /*******************************/
FROM (SELECT CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,zone,cp FROM ercot_dam_ancillary_raw 
WHERE time_stamp BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59'  AND zone IN ('MCPCRS','RRS')) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt 
BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59' ) b ON b.timestamp_gmt =a.time_stamp
LEFT JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS date_time,quantity,ancillarytype 
FROM ercot_dam_ancillary_plan_raw WHERE date_time
 BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59' AND 
ancillarytype = "RRS")c ON c.date_time = b.timestamp_gmt;
REPLACE `bi_fact_markets_part`
SELECT  b.id AS bi_dim_date_id,
        2005 AS bi_dim_market_id,
        a.cp AS clearing_price,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') )
	AS thirty_day_avg,
	(SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') )
	AS ninety_day_avg,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
	AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') ) AS previous_year_clearing_price,
        c.quantity AS volume,
     /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') )
	AS one_year_avg,
	NULL AS "capacity"
	/*d.mcpc AS "capacity"*/
    /*****************************/
FROM (SELECT CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,zone,cp FROM ercot_dam_ancillary_raw 
WHERE time_stamp BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59' AND zone IN ('REGDN','MCPCRD') ) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59') b ON b.timestamp_gmt =a.time_stamp 
LEFT JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS date_time,quantity,ancillarytype FROM ercot_dam_ancillary_plan_raw WHERE date_time BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59'
AND ancillarytype = "REGDN")c ON c.date_time = b.timestamp_gmt;
REPLACE `bi_fact_markets_part`
SELECT  b.id AS bi_dim_date_id,
        2006 AS bi_dim_market_id,
        a.cp AS clearing_price,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU') )
    AS thirty_day_avg,
    (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU'))
    AS ninety_day_avg,
    (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
    AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU')) AS previous_year_clearing_price,
    c.quantity AS volume,
 /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU'))
    AS one_year_avg,
    NULL AS "capacity"
     /*d.mcpc AS "capacity"*/
    /******************************/
 FROM (SELECT CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,zone,cp FROM ercot_dam_ancillary_raw 
WHERE time_stamp BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59' AND zone IN ('REGUP','MCPCRU')) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59') b ON b.timestamp_gmt =a.time_stamp 
LEFT JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS date_time,quantity,ancillarytype FROM ercot_dam_ancillary_plan_raw WHERE date_time BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59'
AND ancillarytype = "REGUP")c ON c.date_time = b.timestamp_gmt;
REPLACE INTO bi_fact_markets_part
SELECT dn.bi_dim_date_id AS bi_dim_date_id,
	2004 AS bi_dim_market_id,
	dn.clearing_price+up.clearing_price AS clearing_price,
	dn.thirty_day_avg+up.thirty_day_avg AS thirty_day_avg,
	dn.ninety_day_avg+up.ninety_day_avg AS ninety_day_avg,
	dn.previous_year_clearing_price+up.previous_year_clearing_price AS previous_year_clearing_price ,
	NULL AS volume,
    dn.one_year_avg+up.one_year_avg AS one_year_avg,
     NULL AS "capacity"
FROM
(SELECT  b.id AS bi_dim_date_id,
        2005 AS bi_dim_market_id,
        a.cp AS clearing_price,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') )
	AS thirty_day_avg,
	(SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') )
	AS ninety_day_avg,
     /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') )
	AS one_year_avg,
     /******************************/
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
	AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') ) AS previous_year_clearing_price,
	0 AS volume
FROM (SELECT CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,zone,cp FROM ercot_dam_ancillary_raw 
WHERE time_stamp BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59' AND zone IN ('REGDN','MCPCRD') ) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59') b ON b.timestamp_gmt =a.time_stamp) dn
JOIN
(SELECT  b.id AS bi_dim_date_id,
        2006 AS bi_dim_market_id,
        a.cp AS clearing_price,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU') )
    AS thirty_day_avg,
    (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU'))
    AS ninety_day_avg,
    /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU'))
    AS one_year_avg,
    /******************************/
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU')) AS previous_year_clearing_price
FROM (SELECT CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,zone,cp FROM ercot_dam_ancillary_raw 
WHERE time_stamp BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59' AND zone IN ('REGUP','MCPCRU')) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt BETWEEN '2012-09-25 00:00:00' AND '2012-09-26 23:59:59') b ON b.timestamp_gmt =a.time_stamp) up
ON dn.bi_dim_date_id=up.bi_dim_date_id;
  
  
END */$$
DELIMITER ;

/* Procedure structure for procedure `iso_missing_data` */

/*!50003 DROP PROCEDURE IF EXISTS  `iso_missing_data` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `iso_missing_data`()
BEGIN
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
       7000 AS bi_dim_market_id,
       a.clearing_price AS clearing_price,
       (SELECT ROUND(AVG(clearing_price),2) FROM neiso_ancillary_prices_raw WHERE datefinal BETWEEN DATE_SUB(a.datefinal,INTERVAL 29 DAY) AND
	a.datefinal AND HOUR(a.datefinal)=HOUR(datefinal) ) AS thirty_day_avg,          
       (SELECT ROUND(AVG(clearing_price),2) FROM neiso_ancillary_prices_raw WHERE datefinal BETWEEN DATE_SUB(a.datefinal,INTERVAL 89 DAY) AND
	a.datefinal AND HOUR(a.datefinal)=HOUR(datefinal) ) AS ninety_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM neiso_ancillary_prices_raw WHERE datefinal = DATE_SUB(a.datefinal,INTERVAL 1 YEAR)
	AND HOUR(a.datefinal)=HOUR(datefinal) ) AS previous_year_clearing_price,
	NULL AS volume,
      /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(clearing_price),2) FROM neiso_ancillary_prices_raw WHERE datefinal BETWEEN DATE_SUB(a.datefinal,INTERVAL 1 YEAR) AND
	a.datefinal AND HOUR(a.datefinal)=HOUR(datefinal) ) AS one_year_avg,
	 NULL AS "capacity"
    /*******************************/
FROM (SELECT * FROM neiso_ancillary_prices_raw WHERE datefinal BETWEEN '2009-01-01 00:00:00' AND '2009-12-31 23:59:59' ) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2009-01-01 00:00:00' AND '2009-12-31 23:59:59') b ON b.timestamp =a.datefinal ;
 END */$$
DELIMITER ;

/* Procedure structure for procedure `Market` */

/*!50003 DROP PROCEDURE IF EXISTS  `Market` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `Market`(Year_ID int)
begin
DECLARE v_Price int;

IF Year_ID = 2009
THEN
select A.TIMESTAMP, A.Price from
(SELECT
YEAR(f.timestamp)AS 'YEAR',
date_format(f.timestamp, '%Y:%H') AS 'TIMESTAMP',
ROUND(AVG(f.clearing_price),2) AS Price
from
(select * from
(SELECT * FROM bi_fact_markets_part WHERE bi_dim_market_id = 500 )a  INNER JOIN (SELECT * FROM bi_dim_date WHERE YEAR in
(2009,2010,2011,2012) and month =1 and day_of_month =1)b ON a.bi_dim_date_id = b.id
)f
join
(select ROUND(AVG(clearing_price),2) AS clearing_price
 from
(SELECT * FROM bi_fact_markets_part WHERE bi_dim_market_id = 500)a  INNER JOIN (SELECT * FROM bi_dim_date WHERE YEAR in
(2009,2010,2011,2012) and month =1 and day_of_month =1)b ON a.bi_dim_date_id = b.id
GROUP BY hour, year)s
GROUP BY f.hour, f.year order by TIMESTAMP) A where A.YEAR = 2009;

ELSEIF Year_ID = 2010
THEN
select A.TIMESTAMP, A.Price from
(SELECT
YEAR(f.timestamp)AS 'YEAR',
date_format(f.timestamp, '%Y:%H') AS 'TIMESTAMP',
ROUND(AVG(f.clearing_price),2) AS Price
from
(select * from
(SELECT * FROM bi_fact_markets_part WHERE bi_dim_market_id = 500 )a  INNER JOIN (SELECT * FROM bi_dim_date WHERE YEAR in
(2009,2010,2011,2012) and month =1 and day_of_month =1)b ON a.bi_dim_date_id = b.id
)f
join
(select ROUND(AVG(clearing_price),2) AS clearing_price
 from
(SELECT * FROM bi_fact_markets_part WHERE bi_dim_market_id = 500)a  INNER JOIN (SELECT * FROM bi_dim_date WHERE YEAR in
(2009,2010,2011,2012) and month =1 and day_of_month =1)b ON a.bi_dim_date_id = b.id
GROUP BY hour, year)s
GROUP BY f.hour, f.year order by TIMESTAMP) A where A.YEAR = 2010;

ELSEIF Year_ID = 2011
THEN
select A.TIMESTAMP, A.Price from
(SELECT
YEAR(f.timestamp)AS 'YEAR',
date_format(f.timestamp, '%Y:%H') AS 'TIMESTAMP',
ROUND(AVG(f.clearing_price),2) AS Price
from
(select * from
(SELECT * FROM bi_fact_markets_part WHERE bi_dim_market_id = 500 )a  INNER JOIN (SELECT * FROM bi_dim_date WHERE YEAR in
(2009,2010,2011,2012) and month =1 and day_of_month =1)b ON a.bi_dim_date_id = b.id
)f
join
(select ROUND(AVG(clearing_price),2) AS clearing_price
 from
(SELECT * FROM bi_fact_markets_part WHERE bi_dim_market_id = 500)a  INNER JOIN (SELECT * FROM bi_dim_date WHERE YEAR in
(2009,2010,2011,2012) and month =1 and day_of_month =1)b ON a.bi_dim_date_id = b.id
GROUP BY hour, year)s
GROUP BY f.hour, f.year order by TIMESTAMP) A where A.YEAR = 2011;

ELSEIF Year_ID = 2012
THEN
select A.TIMESTAMP, A.Price from
(SELECT
YEAR(f.timestamp)AS 'YEAR',
date_format(f.timestamp, '%Y:%H') AS 'TIMESTAMP',
ROUND(AVG(f.clearing_price),2) AS Price
from
(select * from
(SELECT * FROM bi_fact_markets_part WHERE bi_dim_market_id = 500 )a  INNER JOIN (SELECT * FROM bi_dim_date WHERE YEAR in
(2009,2010,2011,2012) and month =1 and day_of_month =1)b ON a.bi_dim_date_id = b.id
)f
join
(select ROUND(AVG(clearing_price),2) AS clearing_price
 from
(SELECT * FROM bi_fact_markets_part WHERE bi_dim_market_id = 500)a  INNER JOIN (SELECT * FROM bi_dim_date WHERE YEAR in
(2009,2010,2011,2012) and month =1 and day_of_month =1)b ON a.bi_dim_date_id = b.id
GROUP BY hour, year)s
GROUP BY f.hour, f.year order by TIMESTAMP) A where A.YEAR = 2012;

END IF;


END */$$
DELIMITER ;

/* Procedure structure for procedure `miso_missing_data` */

/*!50003 DROP PROCEDURE IF EXISTS  `miso_missing_data` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `miso_missing_data`()
BEGIN
/********MISO Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 29 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 89 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP = DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR)
	AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS previous_year_clearing_price,
        NULL AS volume,
     /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS one_year_avg,
	 NULL AS "capacity"
    /*******************************/
FROM (SELECT * FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN '2009-01-07 00:00:00' AND '2012-08-14 23:59:59' AND service='Spinning Reserve') a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2009-01-07 00:00:00' AND '2012-08-14 23:59:59') b ON b.timestamp =a.TIMESTAMP
JOIN
(SELECT * FROM bi_dim_market WHERE iso='MISO' AND market='Day-Ahead Regulation' AND service='Spinning Reserve') c ;
 
END */$$
DELIMITER ;

/* Procedure structure for procedure `missing_data` */

/*!50003 DROP PROCEDURE IF EXISTS  `missing_data` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `missing_data`()
BEGIN
/********MISO Non-Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 29 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Non-Spinning Reserve') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 89 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Non-Spinning Reserve') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP = DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR)
	AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Non-Spinning Reserve') AS previous_year_clearing_price,
        NULL AS volume,
      /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Non-Spinning Reserve') AS one_year_avg,
	 NULL AS "capacity"
     /******************************/
FROM (SELECT * FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN  '2009-04-01 00:00:00' AND '2009-04-31 23:59:59' AND service='Non-Spinning Reserve') a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2009-04-01 00:00:00' AND '2009-04-31 23:59:59') b ON b.timestamp =a.TIMESTAMP
JOIN
(SELECT * FROM bi_dim_market WHERE iso='MISO' AND market='Day-Ahead Regulation' AND service='Non-Spinning Reserve') c;
/********MISO Regulation****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 29 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Regulation') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 89 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Regulation') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP = DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR)
	AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Regulation') AS previous_year_clearing_price,
        NULL AS volume,
     /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Regulation') AS one_year_avg,
	 NULL AS "capacity"
    /*******************************/
FROM (SELECT * FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN '2009-04-01 00:00:00' AND '2009-04-31 23:59:59' AND service='Regulation') a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2009-04-01 00:00:00' AND '2009-04-31 23:59:59') b ON b.timestamp =a.TIMESTAMP
JOIN
(SELECT * FROM bi_dim_market WHERE iso='MISO' AND market='Day-Ahead Regulation' AND service='Regulation') c;
/********MISO Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 29 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 89 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP = DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR)
	AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS previous_year_clearing_price,
        NULL AS volume,
     /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS one_year_avg,
	 NULL AS "capacity"
    /*******************************/
FROM (SELECT * FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN '2009-04-01 00:00:00' AND '2009-04-31 23:59:59' AND service='Spinning Reserve') a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2009-04-01 00:00:00' AND '2009-04-31 23:59:59') b ON b.timestamp =a.TIMESTAMP
JOIN
(SELECT * FROM bi_dim_market WHERE iso='MISO' AND market='Day-Ahead Regulation' AND service='Spinning Reserve') c ;
/***proc daily cont ****/
/* ERCOT RT-Settlement prices(Energy)*/
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
    c.id AS bi_dim_market_id,
    a.settlementpointprice AS clearing_price,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time=DATE_SUB(a.date_time,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    0 AS volume,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
    NULL AS capacity
FROM
(SELECT date_time,settlementpointprice  FROM ercot_realtime_energy_prices WHERE SettlementPointName="ALL" AND date_time>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2009))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2009))) b
ON a.date_time=b.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='ERCOT' AND market='Real-Time Energy' AND service='Energy' AND zone='All') c;
/* ERCOT DAM-Settlement prices(Energy)*/
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
    c.id AS bi_dim_market_id,
    a.settlementpointprice AS clearing_price,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time=DATE_SUB(a.date_time,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    0 AS volume,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
    NULL AS capacity
FROM
(SELECT date_time,settlementpointprice  FROM ercot_dayahead_energy_prices WHERE date_time>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2008))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2008))) b
ON a.date_time=b.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='ERCOT' AND market='Day-Ahead Energy' AND service='Energy') c;
/* ERCOT RT-Settlement prices(Energy) for HB_HOUSTON*/
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
    c.id AS bi_dim_market_id,
    a.settlementpointprice AS clearing_price,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time=DATE_SUB(a.date_time,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    0 AS volume,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
    NULL AS capacity
FROM
(SELECT date_time,settlementpointprice  FROM ercot_realtime_energy_prices WHERE SettlementPointName="HB_HOUSTON" AND  date_time>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2010))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2010))) b
ON a.date_time=b.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='ERCOT' AND market='Real-Time Energy' AND service='Energy' AND zone='HB_HOUSTON') c;
/* ISO-NE energy dam and RT */
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7005 AS bi_dim_market_id,
        a.energy_component AS clearing_price,
        (SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT energy_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7005))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7005))) b ON b.timestamp =a.date_time ;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7006 AS bi_dim_market_id,
        a.marginal_loss_component AS clearing_price,
        (SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT marginal_loss_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7006))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7006))) b ON b.timestamp =a.date_time ;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7007 AS bi_dim_market_id,
        a.congestion_component AS clearing_price,
        (SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT congestion_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7007))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7007))) b ON b.timestamp =a.date_time;
/*RT */
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7008 AS bi_dim_market_id,
        a.rt_congestion_component AS clearing_price,
        (SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT rt_congestion_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7008))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7008))) b ON b.timestamp =a.date_time;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7009 AS bi_dim_market_id,
        a.RT_Marginal_Loss_Component AS clearing_price,
        (SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT RT_Marginal_Loss_Component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7009))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7009))) b ON b.timestamp =a.date_time;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7010 AS bi_dim_market_id,
        a.RT_Energy_Component AS clearing_price,
        (SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT RT_Energy_Component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7010))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7010))) b ON b.timestamp =a.date_time;
END */$$
DELIMITER ;

/* Procedure structure for procedure `temp` */

/*!50003 DROP PROCEDURE IF EXISTS  `temp` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `temp`()
BEGIN
  
  
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_all_markets` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_all_markets` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `update_all_markets`()
BEGIN
/********NYISO DAY-Ahesd Regulation zone(EAST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.East_Regulation AS clearing_price,
        (SELECT ROUND(AVG(East_Regulation),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(East_Regulation),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(East_Regulation),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ***/
        (SELECT ROUND(AVG(East_Regulation),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL as "capacity",
        b.id AS bi_dim_date_id_local
        /*****************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp > 
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =500)))a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =500)) ) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=500) c;
/********NYISO DAY-Ahesd Non-Spinning Reserve zone(EAST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
        (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
        (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
         NULL AS "capacity",
         b.id AS bi_dim_date_id_local
        /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =501)) ) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP > 
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =501))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=501) c;
/********NYISO DAY-Ahesd Spinning Reserve zone(EAST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.East_10_Min_Spinning_Reserve AS clearing_price,
        (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
        (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
         NULL AS "capacity",    
         b.id AS bi_dim_date_id_local
        /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =502))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =502))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=502) c;
/********NYISO DAY-Ahesd Operating Reserve zone(EAST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.East_30_Min_Operating_Reserve AS clearing_price,
        (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
        (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
         NULL AS "capacity",
         b.id AS bi_dim_date_id_local
        /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =503))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =503))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=503) c;
/********NYISO DAY-Ahesd Non-Spinning Reserve zone(WEST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
        (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
        (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
         NULL AS "capacity",
         b.id AS bi_dim_date_id_local
        /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =505))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =505))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=505) c;
/********NYISO DAY-Ahesd Spinning Reserve zone(WEST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.West_10_Min_Spinning_Reserve AS clearing_price,
        (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
        (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
         NULL AS "capacity",
         b.id AS bi_dim_date_id_local
        /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =506))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =506))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=506) c;
/********NYISO DAY-Ahesd Operating Reserve zone(WEST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.West_30_Min_Operating_Reserve AS clearing_price,
        (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
        (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
         NULL AS "capacity",
         b.id AS bi_dim_date_id_local
        /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =507))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =507))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id=507) c;
/********NYISO DAY-Ahesd Regulation zone(WEST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.West_Regulation AS clearing_price,
        (SELECT ROUND(AVG(West_Regulation),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(West_Regulation),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(West_Regulation),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
        (SELECT ROUND(AVG(West_Regulation),2)
        FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
         NULL AS "capacity",
         b.id AS bi_dim_date_id_local
        /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_dayahead_raw WHERE time_stamp >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =508))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =508))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Regulation' AND id=508) c;
/********NYISO Hour-Ahesd Regulation zone(EAST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity",
        b.id AS bi_dim_date_id_local
       /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1149))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1149))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c;
/********NYISO Hour-Ahesd Spinning Reserve zone(EAST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity",
        b.id AS bi_dim_date_id_local
       /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1150)) ) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1150))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c;
/********NYISO Hour-Ahesd Non-Spinning Reserve zone(EAST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity",
        b.id AS bi_dim_date_id_local
       /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1151)) ) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1151))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c;
/********NYISO Hour-Ahesd Operating Reserve zone(EAST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity",
        b.id AS bi_dim_date_id_local
       /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1152))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1152))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c;
/********NYISO Hour-Ahesd Spinning Reserve zone(WEST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity",
        b.id AS bi_dim_date_id_local
       /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1153))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1153))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c;
/********NYISO Hour-Ahesd Non-Spinning Reserve zone(WEST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity",
        b.id AS bi_dim_date_id_local
       /****************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1154))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1154))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c;
/********NYISO Hour-Ahesd Regulation zone(WEST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity",
        b.id AS bi_dim_date_id_local
       /*******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1155))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1155))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Regulation' AND id = 1155) c;
/********NYISO Hour-Ahesd Operating Reserve zone(WEST)****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity",
        b.id AS bi_dim_date_id_local
       /******************************/
FROM (SELECT *  FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1156)) ) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1156))) b
ON b.timestamp=a.time_stamp
JOIN
(SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c;
/********NYISO Real-Time Spinning Reserve zone(EAST)****/
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,c.id AS bi_dim_market_id, a.East_10_Min_Spinning_Reserve AS clearing_price,
    (SELECT AVG(East_10_Min_Spinning_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
      (SELECT AVG(East_10_Min_Spinning_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS ninety_day_avg,
      (SELECT AVG(East_10_Min_Spinning_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS previous_year_clearing_price,
    NULL AS volume,
     /**** 12 month rolling avg ****/
      (SELECT AVG(East_10_Min_Spinning_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS one_year_avg,
       NULL AS "capacity",
       b.id AS bi_dim_date_id_local
      /******************************/
FROM (SELECT * FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1142)) ) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1142)) ) b
ON a.time_stamp=b.timestamp
JOIN
(SELECT id FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Regulation' AND service='Spinning Reserve' AND zone='East') c;
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,c.id AS bi_dim_market_id, a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
    (SELECT AVG(East_10_Min_Non_Synchronous_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
      (SELECT AVG(East_10_Min_Non_Synchronous_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS ninety_day_avg,
      (SELECT AVG(East_10_Min_Non_Synchronous_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS previous_year_clearing_price,
    NULL AS volume,
    /**** 12 month rolling avg ****/
      (SELECT AVG(East_10_Min_Non_Synchronous_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS one_year_avg,
       NULL AS "capacity",
       b.id AS bi_dim_date_id_local
      /******************************/
FROM (SELECT * FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
WHERE time_stamp >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1143)) ) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1143))) b
ON a.time_stamp=b.timestamp
JOIN
(SELECT id FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Regulation' AND service='Non-Spinning Reserve' AND zone='East') c;
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,c.id AS bi_dim_market_id, a.East_30_Min_Operating_Reserve AS clearing_price,
    (SELECT AVG(East_30_Min_Operating_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
      (SELECT AVG(East_30_Min_Operating_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS ninety_day_avg,
      (SELECT AVG(East_30_Min_Operating_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS previous_year_clearing_price,
    NULL AS volume,
      /**** 12 month rolling avg ****/
      (SELECT AVG(East_30_Min_Operating_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS one_year_avg,
       NULL AS "capacity",
       b.id AS bi_dim_date_id_local
      /*******************************/
FROM (SELECT * FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1144))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1144))) b
ON a.time_stamp=b.timestamp
JOIN
(SELECT id FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Regulation' AND service='Operating Reserve' AND zone='East') c;
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,c.id AS bi_dim_market_id, a.east_regulation AS clearing_price,
    (SELECT AVG(east_regulation) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
      (SELECT AVG(east_regulation) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS ninety_day_avg,
      (SELECT AVG(east_regulation) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS previous_year_clearing_price,
    NULL AS volume,
     /**** 12 month rolling avg ****/
      (SELECT AVG(east_regulation) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS one_year_avg,
       NULL AS "capacity",
       b.id AS bi_dim_date_id_local
      /*******************************/
FROM (SELECT * FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1141))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1141))) b
ON a.time_stamp=b.timestamp
JOIN
(SELECT id FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Regulation' AND service='Regulation' AND zone='east') c;
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,c.id AS bi_dim_market_id, a.West_10_Min_Spinning_Reserve AS clearing_price,
    (SELECT AVG(West_10_Min_Spinning_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
      (SELECT AVG(West_10_Min_Spinning_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS ninety_day_avg,
      (SELECT AVG(West_10_Min_Spinning_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS previous_year_clearing_price,
    NULL AS volume,
     /**** 12 month rolling avg ****/
      (SELECT AVG(West_10_Min_Spinning_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
     DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS one_year_avg,
       NULL AS "capacity",
       b.id AS bi_dim_date_id_local
      /******************************/
FROM (SELECT * FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1145))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1145))) b
ON a.time_stamp=b.timestamp
JOIN
(SELECT id FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Regulation' AND service='Spinning Reserve' AND zone='West') c;
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,c.id AS bi_dim_market_id, a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
    (SELECT AVG(West_10_Min_Non_Synchronous_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
      (SELECT AVG(West_10_Min_Non_Synchronous_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS ninety_day_avg,
      (SELECT AVG(West_10_Min_Non_Synchronous_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    NULL AS volume,
     /**** 12 month rolling avg ****/
      (SELECT AVG(West_10_Min_Non_Synchronous_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS one_year_avg,
       NULL AS "capacity",
       b.id AS bi_dim_date_id_local
      /*******************************/
FROM (SELECT * FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1146))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1146))) b
ON a.time_stamp=b.timestamp
JOIN
(SELECT id FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Regulation' AND service='Non-Spinning Reserve' AND zone='West') c;
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,c.id AS bi_dim_market_id, a.west_regulation AS clearing_price,
    (SELECT AVG(west_regulation) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
      (SELECT AVG(west_regulation) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS ninety_day_avg,
      (SELECT AVG(west_regulation) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS previous_year_clearing_price,
    NULL AS volume,
    /**** 12 month rolling avg ****/
      (SELECT AVG(west_regulation) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS one_year_avg,
       NULL AS "capacity",
       b.id AS bi_dim_date_id_local
      /*******************************/
FROM (SELECT * FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1147))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1147))) b
ON a.time_stamp=b.timestamp
JOIN
(SELECT id FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Regulation' AND service='Regulation' AND zone='West') c;
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,c.id AS bi_dim_market_id, a.West_30_Min_Operating_Reserve AS clearing_price,
    (SELECT AVG(West_30_Min_Operating_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
      (SELECT AVG(West_30_Min_Operating_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS ninety_day_avg,
      (SELECT AVG(West_30_Min_Operating_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS previous_year_clearing_price,
    NULL AS volume,
    /**** 12 month rolling avg ****/
      (SELECT AVG(West_30_Min_Operating_Reserve) FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
    WHERE time_stamp  BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS one_year_avg,
       NULL AS "capacity",
       b.id AS bi_dim_date_id_local
      /******************************/
FROM (SELECT * FROM nyiso_ancillary_service_prices_realtime_raw_15_min_interval
WHERE time_stamp > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1148))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1148))) b
ON a.time_stamp=b.timestamp
JOIN
(SELECT id FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Regulation' AND service='Operating Reserve' AND zone='West') c;
/********PJM Ancillary****/
REPLACE INTO bi_fact_markets_part
SELECT a.id AS bi_dim_date_id,
market_id AS bi_dim_market_id,
cp AS clearing_price,
30_day_avg AS thirty_day_avg,
90_day_avg AS ninety_day_avg,
1_year_avg AS previous_year_clearing_price,
NULL AS volume,
12_month_avg AS one_year_avg,
 NULL AS "capacity",
  d.id AS bi_dim_date_id_local
 -- id-16 AS bi_dim_date_id_local
 FROM
      (SELECT id,TIMESTAMP_gmt FROM bi_dim_date WHERE TIMESTAMP_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id = 
           (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1)
	  ))a
     JOIN
       (SELECT CONVERT_TZ(b.time_stamp,'US/Eastern','GMT') AS time_stamp,1 AS market_id,b.time_stamp AS local_timestamp,
         ((`RTO Regulation Performance`+`RTO Regulation Capability`)*`RTO Marginal Benefits Factor`) AS cp,
       -- rmcp AS cp,
(SELECT 
ROUND(AVG(((`RTO Regulation Performance`+`RTO Regulation Capability`)*`RTO Marginal Benefits Factor`)),2)
FROM pjm_ancillary_dam_raw
WHERE CONVERT_TZ(time_stamp,'US/Eastern','GMT') 
BETWEEN DATE_SUB(CONVERT_TZ(b.time_stamp,'US/Eastern','GMT'),INTERVAL 29 DAY) AND
CONVERT_TZ(b.time_stamp,'US/Eastern','GMT') 
AND HOUR(CONVERT_TZ(b.time_stamp,'US/Eastern','GMT'))=HOUR(CONVERT_TZ(time_stamp,'US/Eastern','GMT'))) AS 30_day_avg,
(SELECT 
ROUND(AVG(((`RTO Regulation Performance`+`RTO Regulation Capability`)*`RTO Marginal Benefits Factor`)),2)
FROM pjm_ancillary_dam_raw
WHERE CONVERT_TZ(time_stamp,'US/Eastern','GMT') BETWEEN DATE_SUB(CONVERT_TZ(b.time_stamp,'US/Eastern','GMT'),INTERVAL 89 DAY) AND
CONVERT_TZ(b.time_stamp,'US/Eastern','GMT') AND HOUR(CONVERT_TZ(b.time_stamp,'US/Eastern','GMT'))=HOUR(CONVERT_TZ(time_stamp,'US/Eastern','GMT'))) AS 90_day_avg,
/**** 12 month rolling avg ****/
(SELECT 
ROUND(AVG(((`RTO Regulation Performance`+`RTO Regulation Capability`)*`RTO Marginal Benefits Factor`)),2)
FROM pjm_ancillary_dam_raw
WHERE CONVERT_TZ(time_stamp,'US/Eastern','GMT') BETWEEN DATE_SUB(CONVERT_TZ(b.time_stamp,'US/Eastern','GMT'),INTERVAL 1 YEAR) AND
CONVERT_TZ(b.time_stamp,'US/Eastern','GMT') AND HOUR(CONVERT_TZ(b.time_stamp,'US/Eastern','GMT'))=HOUR(CONVERT_TZ(time_stamp,'US/Eastern','GMT'))) AS 12_month_avg,
/*******************************/
(SELECT 
ROUND(AVG(rmcp),2) 
FROM pjm_ancillary_dam_raw_jan2009_Oct2012
WHERE CONVERT_TZ(market_datehour,'US/Eastern','GMT') = DATE_SUB(CONVERT_TZ(b.time_stamp,'US/Eastern','GMT'),INTERVAL 1 YEAR) 
AND HOUR(CONVERT_TZ(market_datehour,'US/Eastern','GMT'))=HOUR(CONVERT_TZ(b.time_stamp,'US/Eastern','GMT'))) AS 1_year_avg
FROM pjm_ancillary_dam_raw b
WHERE CONVERT_TZ(time_stamp,'US/Eastern','GMT') > (SELECT timestamp_gmt FROM bi_dim_date WHERE id = 
 (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1)
) ) c
ON a.TIMESTAMP_gmt=CONVERT_TZ(c.time_stamp,'US/Eastern','GMT')
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = 
 (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =1)
)) d
ON d.timestamp = c.local_timestamp
;
/********PJM Ancillary RTO Regulation Performance ****/
REPLACE INTO bi_fact_markets_part
SELECT a.id AS bi_dim_date_id,
market_id AS bi_dim_market_id,
RMP AS clearing_price,
30_day_avg AS thirty_day_avg,
90_day_avg AS ninety_day_avg,
1_year_avg AS previous_year_clearing_price,
NULL AS volume,
12_month_avg AS one_year_avg,
 NULL AS "capacity",
 d.id AS bi_dim_date_id_local
 FROM
      (SELECT id,TIMESTAMP_gmt FROM bi_dim_date WHERE TIMESTAMP_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id = 
           (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =11)
	  ))a
     JOIN
       (SELECT CONVERT_TZ(b.time_stamp,'US/Eastern','GMT') AS time_stamp,11 AS market_id,b.time_stamp AS local_timestamp,
         `RTO Regulation Performance` AS RMP,
       -- rmcp AS cp,
NULL AS 30_day_avg,
NULL AS 90_day_avg,
NULL AS 12_month_avg,
NULL AS 1_year_avg
FROM pjm_ancillary_dam_raw b
WHERE CONVERT_TZ(time_stamp,'US/Eastern','GMT') > (SELECT timestamp_gmt FROM bi_dim_date WHERE id = 
 (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =11)
) ) c
ON a.TIMESTAMP_gmt=CONVERT_TZ(c.time_stamp,'US/Eastern','GMT')
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = 
 (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =11)
)) d
ON d.timestamp = c.local_timestamp
;
/*********PJM Ancillary RTO Regulation Performance END *********/
/*********PJM Ancillary RTO Regulation Capability *********/
REPLACE INTO bi_fact_markets_part
SELECT a.id AS bi_dim_date_id,
market_id AS bi_dim_market_id,
RMC AS clearing_price,
30_day_avg AS thirty_day_avg,
90_day_avg AS ninety_day_avg,
1_year_avg AS previous_year_clearing_price,
NULL AS volume,
12_month_avg AS one_year_avg,
 NULL AS "capacity",
 d.id as bi_dim_date_id_local
 
 FROM
      (SELECT id,TIMESTAMP_gmt FROM bi_dim_date WHERE TIMESTAMP_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id = 
           (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =12)
	  ))a
     JOIN
       (SELECT CONVERT_TZ(b.time_stamp,'US/Eastern','GMT') AS time_stamp,12 AS market_id,b.time_stamp AS local_timestamp,
         `RTO Regulation Capability` AS RMC,
       -- rmcp AS cp,
NULL AS 30_day_avg,
NULL AS 90_day_avg,
NULL AS 12_month_avg,
NULL AS 1_year_avg
FROM pjm_ancillary_dam_raw b
WHERE CONVERT_TZ(time_stamp,'US/Eastern','GMT') > (SELECT timestamp_gmt FROM bi_dim_date WHERE id = 
 (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =12)
) ) c
ON a.TIMESTAMP_gmt=CONVERT_TZ(c.time_stamp,'US/Eastern','GMT')
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = 
 (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =12)
)) d
ON d.timestamp = c.local_timestamp
;
/*********PJM Ancillary RTO Regulation Capability END *********/
/*********PJM Ancillary RTO Marginal Benefits Factor *********/
REPLACE INTO bi_fact_markets_part
SELECT a.id AS bi_dim_date_id,
market_id AS bi_dim_market_id,
BenefitsFactor AS clearing_price,
30_day_avg AS thirty_day_avg,
90_day_avg AS ninety_day_avg,
1_year_avg AS previous_year_clearing_price,
NULL AS volume,
12_month_avg AS one_year_avg,
 NULL AS "capacity",
d.id AS bi_dim_date_id_local
 FROM
      (SELECT id,TIMESTAMP_gmt FROM bi_dim_date WHERE TIMESTAMP_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id = 
           (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =13)
	  ))a
     JOIN
       (SELECT CONVERT_TZ(b.time_stamp,'US/Eastern','GMT') AS time_stamp,13 AS market_id,b.time_stamp AS local_timestamp,
         `RTO Marginal Benefits Factor` AS BenefitsFactor,
       -- rmcp AS cp,
NULL AS 30_day_avg,
NULL AS 90_day_avg,
NULL AS 12_month_avg,
NULL AS 1_year_avg
FROM pjm_ancillary_dam_raw b
WHERE CONVERT_TZ(time_stamp,'US/Eastern','GMT') > (SELECT timestamp_gmt FROM bi_dim_date WHERE id = 
 (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =13)
) ) c
ON a.TIMESTAMP_gmt=CONVERT_TZ(c.time_stamp,'US/Eastern','GMT')
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id = 
 (SELECT MAX(bi_dim_date_id)FROM bi_fact_markets_part WHERE bi_dim_market_id =13)
)) d
ON d.timestamp = c.local_timestamp
;
/*********PJM Ancillary RTO Marginal Benefits Factor END *********/
/********MISO Non-Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 29 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Non-Spinning Reserve') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 89 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Non-Spinning Reserve') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP = DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR)
	AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Non-Spinning Reserve') AS previous_year_clearing_price,
        NULL AS volume,
      /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Non-Spinning Reserve') AS one_year_avg,
	 NULL AS "capacity",
	 b.id AS bi_dim_date_id_local
     /******************************/
FROM (SELECT * FROM miso_ancillary_dam_raw WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=4002)) AND service='Non-Spinning Reserve') a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=4002))) b ON b.timestamp =a.TIMESTAMP
JOIN
(SELECT * FROM bi_dim_market WHERE iso='MISO' AND market='Day-Ahead Regulation' AND service='Non-Spinning Reserve') c;
/********MISO Regulation****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 29 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Regulation') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 89 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Regulation') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP = DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR)
	AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Regulation') AS previous_year_clearing_price,
        NULL AS volume,
     /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Regulation') AS one_year_avg,
	 NULL AS "capacity",
	 b.id AS bi_dim_date_id_local
    /*******************************/
FROM (SELECT * FROM miso_ancillary_dam_raw WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=4000)) AND service='Regulation') a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=4000))) b ON b.timestamp =a.TIMESTAMP
JOIN
(SELECT * FROM bi_dim_market WHERE iso='MISO' AND market='Day-Ahead Regulation' AND service='Regulation') c;
/********MISO Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 29 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 89 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP = DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR)
	AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS previous_year_clearing_price,
        NULL AS volume,
     /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(clearing_price),2) FROM miso_ancillary_dam_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP) AND service='Spinning Reserve') AS one_year_avg,
	 NULL AS "capacity",
	 b.id AS bi_dim_date_id_local
    /*******************************/
FROM (SELECT * FROM miso_ancillary_dam_raw WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=4001)) AND service='Spinning Reserve') a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=4001))) b ON b.timestamp =a.TIMESTAMP
JOIN
(SELECT * FROM bi_dim_market WHERE iso='MISO' AND market='Day-Ahead Regulation' AND service='Spinning Reserve') c ;
/*iso ne scripts*/
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
       7000 AS bi_dim_market_id,
       a.clearing_price AS clearing_price,
       (SELECT ROUND(AVG(clearing_price),2) FROM neiso_ancillary_prices_raw WHERE datefinal BETWEEN DATE_SUB(a.datefinal,INTERVAL 29 DAY) AND
	a.datefinal AND HOUR(a.datefinal)=HOUR(datefinal) ) AS thirty_day_avg,          
       (SELECT ROUND(AVG(clearing_price),2) FROM neiso_ancillary_prices_raw WHERE datefinal BETWEEN DATE_SUB(a.datefinal,INTERVAL 89 DAY) AND
	a.datefinal AND HOUR(a.datefinal)=HOUR(datefinal) ) AS ninety_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM neiso_ancillary_prices_raw WHERE datefinal = DATE_SUB(a.datefinal,INTERVAL 1 YEAR)
	AND HOUR(a.datefinal)=HOUR(datefinal) ) AS previous_year_clearing_price,
	NULL AS volume,
      /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(clearing_price),2) FROM neiso_ancillary_prices_raw WHERE datefinal BETWEEN DATE_SUB(a.datefinal,INTERVAL 1 YEAR) AND
	a.datefinal AND HOUR(a.datefinal)=HOUR(datefinal) ) AS one_year_avg,
	 NULL AS "capacity",
	 b.id AS bi_dim_date_id_local
    /*******************************/
FROM (SELECT * FROM neiso_ancillary_prices_raw WHERE datefinal > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=7000)) ) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=7000))) b ON b.timestamp =a.datefinal ;
/********ERCOT NON Spinning Reserve****/	
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        2001 AS bi_dim_market_id,
        -- a.cp AS clearing_price,
        a.MCPC AS clearing_price,
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('MCPCNS','NSPIN') )
	AS thirty_day_avg,
	(SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('MCPCNS','NSPIN'))
	AS ninety_day_avg,
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
	AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('MCPCNS','NSPIN')) AS previous_year_clearing_price,
	c.quantity AS volume,
     /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('MCPCNS','NSPIN'))
	AS one_year_avg,
	 NULL AS "capacity",
	 d.id AS bi_dim_date_id_local
    /*******************************/
FROM (SELECT time_stamp AS local_timestamp,CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,AncillaryType,MCPC 
FROM ercot_dam_ancillary_raw
WHERE time_stamp >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2001)) AND AncillaryType IN ('MCPCNS','NSPIN')) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2001))) b 
ON b.timestamp_gmt =a.time_stamp
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2001))) AS d 
ON d.TIMESTAMP =a.local_timestamp
LEFT JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS date_time,quantity,ancillarytype FROM ercot_dam_ancillary_plan_raw WHERE date_time >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2001)) AND 
ancillarytype = "NSPIN")c ON c.date_time = b.timestamp_gmt 
/**JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS time_stamp, mcpc FROM ercot_dam_capacity
WHERE date_time >= '2012-01-02 01:00:00' AND ancillarytype IN ('MCPCNS','NSPIN'))d ON d.time_stamp = c.date_time**/
;
/********ERCOT Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        2002 AS bi_dim_market_id,
        a.MCPC AS clearing_price,
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('MCPCRS','RRS'))
    AS thirty_day_avg,
    (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('MCPCRS','RRS'))
    AS ninety_day_avg,
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('MCPCRS','RRS')) AS previous_year_clearing_price,
c.quantity AS volume,
 /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('MCPCRS','RRS'))
    AS one_year_avg,
     NULL AS "capacity",
     d.id AS bi_dim_date_id_local
    /*******************************/
FROM (SELECT time_stamp AS local_timestamp,CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,AncillaryType,MCPC 
FROM ercot_dam_ancillary_raw 
WHERE time_stamp >=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2002)) AND AncillaryType IN ('MCPCRS','RRS')) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >= 
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2002))) b 
ON b.timestamp_gmt =a.time_stamp
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2002))) AS d 
ON d.TIMESTAMP =a.local_timestamp
LEFT JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS date_time,quantity,ancillarytype FROM ercot_dam_ancillary_plan_raw WHERE date_time >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2002)) AND 
ancillarytype = "RRS")c ON c.date_time = b.timestamp_gmt
/**JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS time_stamp, mcpc FROM ercot_dam_capacity
WHERE date_time >= '2012-01-02 01:00:00' AND ancillarytype IN ('MCPCRS','RRS'))d ON d.time_stamp = c.date_time**/
 ;
/********ERCOT Regulation down****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        2005 AS bi_dim_market_id,
        a.MCPC AS clearing_price,
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGDN','MCPCRD') )
	AS thirty_day_avg,
	(SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGDN','MCPCRD') )
	AS ninety_day_avg,
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
	AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGDN','MCPCRD') ) AS previous_year_clearing_price,
        c.quantity AS volume,
     /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGDN','MCPCRD') )
	AS one_year_avg,
	NULL AS "capacity",
	d.id AS bi_dim_date_id_local
    /*****************************/
	
FROM (SELECT time_stamp AS local_timestamp,CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,AncillaryType,MCPC FROM ercot_dam_ancillary_raw 
WHERE time_stamp >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2005)) AND AncillaryType IN ('REGDN','MCPCRD') ) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2005))) b 
ON b.timestamp_gmt =a.time_stamp 
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2005))) AS d 
ON d.TIMESTAMP =a.local_timestamp
LEFT JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS date_time,quantity,ancillarytype FROM ercot_dam_ancillary_plan_raw WHERE date_time >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2005)) AND 
ancillarytype = "REGDN")c ON c.date_time = b.timestamp_gmt
/**JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS time_stamp, mcpc FROM ercot_dam_capacity
WHERE date_time >= '2012-01-02 01:00:00' AND ancillarytype = "REGDN")d ON d.time_stamp = c.date_time**/
 ;
/********ERCOT Regulation up****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        2006 AS bi_dim_market_id,
        a.MCPC AS clearing_price,
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGUP','MCPCRU') )
    AS thirty_day_avg,
    (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGUP','MCPCRU'))
    AS ninety_day_avg,
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGUP','MCPCRU')) AS previous_year_clearing_price,
 c.quantity AS volume,
 /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGUP','MCPCRU'))
    AS one_year_avg,
     NULL AS "capacity",
     d.id AS bi_dim_date_id_local
    /******************************/
 
FROM (SELECT time_stamp AS local_timestamp,CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,AncillaryType,MCPC FROM ercot_dam_ancillary_raw 
WHERE time_stamp >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2006)) AND AncillaryType IN ('REGUP','MCPCRU')) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2006))) b 
ON b.timestamp_gmt =a.time_stamp 
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2006))) AS d 
ON d.TIMESTAMP =a.local_timestamp
LEFT JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS date_time,quantity,ancillarytype FROM ercot_dam_ancillary_plan_raw WHERE date_time >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2006)) AND 
ancillarytype = "REGUP")c ON c.date_time = b.timestamp_gmt 
/**JOIN
(SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS time_stamp, mcpc FROM ercot_dam_capacity
WHERE date_time >= '2012-01-02 01:00:00' AND ancillarytype = "REGUP")d ON d.time_stamp = c.date_time**/
;
/********ERCOT Regulation****/
REPLACE INTO bi_fact_markets_part
SELECT  dn.bi_dim_date_id AS bi_dim_date_id,
	2004 AS bi_dim_market_id,
	dn.clearing_price+up.clearing_price AS clearing_price,
	dn.thirty_day_avg+up.thirty_day_avg AS thirty_day_avg,
	dn.ninety_day_avg+up.ninety_day_avg AS ninety_day_avg,
	dn.previous_year_clearing_price+up.previous_year_clearing_price AS previous_year_clearing_price ,
	NULL AS volume,
        dn.one_year_avg+up.one_year_avg AS one_year_avg,
        NULL AS "capacity",
        dn.bi_dim_date_id_local AS bi_dim_date_id_local
FROM
(SELECT  b.id AS bi_dim_date_id,b.timestamp,
        2005 AS bi_dim_market_id,
        a.MCPC AS clearing_price,
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGDN','MCPCRD') )
	AS thirty_day_avg,
	(SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGDN','MCPCRD') )
	AS ninety_day_avg,
     /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGDN','MCPCRD') )
	AS one_year_avg,
     /******************************/
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
	AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGDN','MCPCRD') ) AS previous_year_clearing_price,
	0 AS volume,
	f.id AS bi_dim_date_id_local
FROM (SELECT time_stamp AS local_timestamp,CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,AncillaryType,MCPC FROM ercot_dam_ancillary_raw 
WHERE time_stamp>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2004)) AND AncillaryType IN ('REGDN','MCPCRD') ) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2004))) b 
ON b.timestamp_gmt =a.time_stamp
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2004))) AS f 
ON f.TIMESTAMP =a.local_timestamp
) dn
JOIN
(SELECT  b.id AS bi_dim_date_id,
        2006 AS bi_dim_market_id,
        a.MCPC AS clearing_price,
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGUP','MCPCRU') )
    AS thirty_day_avg,
    (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGUP','MCPCRU'))
    AS ninety_day_avg,
    /**** 12 month rolling avg ****/
    (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGUP','MCPCRU'))
    AS one_year_avg,
    /******************************/
        (SELECT ROUND(AVG(MCPC),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND AncillaryType IN ('REGUP','MCPCRU')) AS previous_year_clearing_price,
f.id AS bi_dim_date_id_local
FROM (SELECT time_stamp AS local_timestamp,CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,AncillaryType,MCPC FROM ercot_dam_ancillary_raw 
WHERE time_stamp>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2004)) AND AncillaryType IN ('REGUP','MCPCRU')) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2004))) b 
ON b.timestamp_gmt =a.time_stamp
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=2004))) AS f 
ON f.TIMESTAMP =a.local_timestamp
) up
ON dn.bi_dim_date_id=up.bi_dim_date_id;
/********ERCOT Regulation****/
/****
REPLACE INTO bi_fact_markets_part
SELECT dn.bi_dim_date_id AS bi_dim_date_id,
	2004 AS bi_dim_market_id,
	dn.clearing_price+up.clearing_price AS clearing_price,
	dn.thirty_day_avg+up.thirty_day_avg AS thirty_day_avg,
	dn.ninety_day_avg+up.ninety_day_avg AS ninety_day_avg,
	dn.previous_year_clearing_price+up.previous_year_clearing_price AS previous_year_clearing_price ,
	NULL AS volume,
    dn.one_year_avg+up.one_year_avg AS one_year_avg,
     NULL AS "capacity"
FROM
(SELECT  b.id AS bi_dim_date_id,
        2005 AS bi_dim_market_id,
        a.cp AS clearing_price,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') )
	AS thirty_day_avg,
	(SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') )
	AS ninety_day_avg,
     -- 12 month rolling avg begin
     (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
	a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') )
	AS one_year_avg,
     -- 12 month rolling avg  end 
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
	AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGDN','MCPCRD') ) AS previous_year_clearing_price,
	0 AS volume
FROM (SELECT CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,zone,cp FROM ercot_dam_ancillary_raw 
WHERE time_stamp>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2004)) AND zone IN ('REGDN','MCPCRD') ) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2004))) b ON b.timestamp_gmt =a.time_stamp) dn
JOIN
(SELECT  b.id AS bi_dim_date_id,
        2006 AS bi_dim_market_id,
        a.cp AS clearing_price,
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU') )
    AS thirty_day_avg,
    (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU'))
    AS ninety_day_avg,
    -- 12 month rolling avg begin 
    (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
     a.time_stamp AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU'))
    AS one_year_avg,
    -- 12 month rolling avg end
        (SELECT ROUND(AVG(cp),2) FROM ercot_dam_ancillary_raw WHERE CONVERT_TZ(time_stamp,'US/Central','GMT') = DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) 
AND HOUR(a.time_stamp)=HOUR(CONVERT_TZ(time_stamp,'US/Central','GMT')) AND zone IN ('REGUP','MCPCRU')) AS previous_year_clearing_price
FROM (SELECT CONVERT_TZ(time_stamp,'US/Central','GMT') AS time_stamp,zone,cp FROM ercot_dam_ancillary_raw 
WHERE time_stamp>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2004)) AND zone IN ('REGUP','MCPCRU')) a
JOIN
(SELECT id,TIMESTAMP,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2004))) b ON b.timestamp_gmt =a.time_stamp) up
ON dn.bi_dim_date_id=up.bi_dim_date_id;
****/
/********CAISO Non-Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='NR') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='NR') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='NR') AS previous_year_clearing_price,
        d.clearing_price AS volume,
    /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='NR') AS one_year_avg,
	 NULL AS "capacity",
	 e.id AS bi_dim_date_id_local
     /******************************/
FROM (SELECT datetime AS local_timestamp,CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3000)) AND anc_type='NR') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >= (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3000))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >= (SELECT timestamp FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3000))) AS e ON e.TIMESTAMP =a.local_timestamp	
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3000)) AND anc_type='NR')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Non-Spinning Reserve') c;
/********CAISO Regulation Down****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RD') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RD') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RD') AS previous_year_clearing_price,
        d.clearing_price AS volume,
     /*** 12 month rolling avg ****/
    (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RD') AS one_year_avg,
	 NULL AS "capacity",
	 e.id AS bi_dim_date_id_local
    /*****************************/
FROM (SELECT DATETIME AS local_timestamp,CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3001)) AND anc_type='RD') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >= (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3001))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3001))) AS e ON e.TIMESTAMP =a.local_timestamp		
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3001)) AND anc_type='RD')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Down') c;
/********CAISO Regulation Up****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RU') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RU') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RU') AS previous_year_clearing_price,
        d.clearing_price AS volume,
     /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RU') AS one_year_avg,
	 NULL AS "capacity",
	 e.id AS bi_dim_date_id_local
     /******************************/
FROM (SELECT DATETIME AS local_timestamp,CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3002)) AND anc_type='RU') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >= (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3002))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=(SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3002))) AS e ON e.TIMESTAMP =a.local_timestamp		
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3002)) AND anc_type='RU')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Up') c;
/********CAISO Spinning Reserve****/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='SR') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='SR') AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='SR') AS previous_year_clearing_price,
        d.clearing_price AS volume,
    /**** 12 month rolling avg ***/
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='SR') AS one_year_avg,
	 NULL AS "capacity",
	 e.id AS bi_dim_date_id_local
     /****************************/
FROM (SELECT DATETIME AS local_timestamp,CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3003)) AND anc_type='SR') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >= (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3003))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3003))) AS e ON e.TIMESTAMP =a.local_timestamp		
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3003)) AND anc_type='SR')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Spinning Reserve') c;
/********CAISO Regulation****/
REPLACE INTO bi_fact_markets_part
SELECT dn.bi_dim_date_id AS bi_dim_date_id,
	3030 AS bi_dim_market_id,
	dn.clearing_price+up.clearing_price AS clearing_price,
	dn.thirty_day_avg+up.thirty_day_avg AS thirty_day_avg,
	dn.ninety_day_avg+up.ninety_day_avg AS ninety_day_avg,
	dn.previous_year_clearing_price+up.previous_year_clearing_price AS previous_year_clearing_price,
	dn.volume + up.volume AS volume,
     dn.one_year_avg+up.one_year_avg AS one_year_avg,
      NULL AS "capacity",
      dn.bi_dim_date_id_local as bi_dim_date_id_local
FROM
(SELECT  b.id AS bi_dim_date_id,b.timestamp,b.timestamp_gmt,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RD') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RD') AS ninety_day_avg,
     /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RD') AS one_year_avg,
     /*******************************/
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RD') AS previous_year_clearing_price,
        d.clearing_price AS volume,
        e.id AS bi_dim_date_id_local
FROM (SELECT DATETIME AS local_timestamp,CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE
 DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030)) AND anc_type='RD') a
JOIN
(SELECT id,timestamp_gmt,TIMESTAMP FROM bi_dim_date WHERE timestamp_gmt >= (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030))) AS e ON e.TIMESTAMP =a.local_timestamp		
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030)) AND anc_type='RD')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Down') c) dn
JOIN
(SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RU') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RU') AS ninety_day_avg,
     /**** 12 month rolling avg ****/
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RU') AS one_year_avg,
     /*******************************/
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE CONVERT_TZ(DATETIME,'US/Central','GMT') = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(DATETIME,'US/Central','GMT')) AND anc_type='RU') AS previous_year_clearing_price,
        d.clearing_price AS volume,
        e.id AS bi_dim_date_id_local
FROM (SELECT DATETIME AS local_timestamp,CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030)) AND anc_type='RU') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >= (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >= (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030))) AS e ON e.TIMESTAMP =a.local_timestamp		
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME >= (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030)) AND anc_type='RU')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Up') c) up
ON dn.bi_dim_date_id=up.bi_dim_date_id;
/********CAISO Regulation
REPLACE INTO bi_fact_markets_part
SELECT dn.bi_dim_date_id AS bi_dim_date_id,
	3030 AS bi_dim_market_id,
	dn.clearing_price+up.clearing_price AS clearing_price,
	dn.thirty_day_avg+up.thirty_day_avg AS thirty_day_avg,
	dn.ninety_day_avg+up.ninety_day_avg AS ninety_day_avg,
	dn.previous_year_clearing_price+up.previous_year_clearing_price AS previous_year_clearing_price,
	dn.volume + up.volume AS volume,
     dn.one_year_avg+up.one_year_avg AS one_year_avg,
      NULL AS "capacity"
FROM
(SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS ninety_day_avg,
     -- 12 month rolling avg begins
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS one_year_avg,
     -- 12 month rolling avg ends
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RD') AS previous_year_clearing_price,
        d.clearing_price AS volume
FROM (SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME > (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030)) AND anc_type='RD') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME > (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030)) AND anc_type='RD')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Down') c) dn
JOIN
(SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS ninety_day_avg,
     -- 12 month rolling avg begin
     (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS one_year_avg,
     -- 12 month rolling avg ends
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dam_ancillary_raw WHERE DATETIME = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATETIME) AND anc_type='RU') AS previous_year_clearing_price,
        d.clearing_price AS volume
FROM (SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_raw WHERE DATETIME > (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030)) AND anc_type='RU') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt > (SELECT timestamp_gmt FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT CONVERT_TZ(DATETIME,'US/Central','GMT') AS DATETIME,clearing_price FROM caiso_dam_ancillary_volume WHERE DATETIME > (SELECT DATE_FORMAT(DATE(TIMESTAMP),'%Y-%m-%d 00:00:00') AS TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3030)) AND anc_type='RU')d
ON a.datetime=d.datetime
JOIN
(SELECT * FROM bi_dim_market WHERE iso='caiso' AND market='Day-Ahead Regulation' AND service='Regulation Up') c) up
ON dn.bi_dim_date_id=up.bi_dim_date_id;
/*TAB1: EA_Market_Schedule_Quantities_raw (1st)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        662 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.schedule_mw AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EA_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 662))
AND r.participant_resource_name IN ('PT_400021 GU_400020') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB1: EA_Market_Schedule_Quantities_raw (2nd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        663 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.schedule_mw AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EA_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 663))
AND r.participant_resource_name IN ('PT_400021 GU_400021') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB1: EA_Market_Schedule_Quantities_raw (3rd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        664 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.schedule_mw AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EA_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 664))
AND r.participant_resource_name IN ('PT_400021 GU_400030') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB2: EA_System_Marginal_Price_raw */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        661 AS bi_dim_market_id,
        r.SMP AS clearing_price,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_System_Marginal_Price_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EA_System_Marginal_Price_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 661))
  ORDER BY  r.trading_period ; 
  
  
  /*TAB3: EP2_Actual_Availabilities_raw (1st)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        775 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.MAX_AVAIL_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Actual_Availabilities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 775))
AND r.participant_resource_name IN ('PT_400021 GU_400020') ORDER BY r.participant_resource_name, r.trading_period;
/*TAB3: EP2_Actual_Availabilities_raw (2nd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        776 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.MAX_AVAIL_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Actual_Availabilities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 776))
AND r.participant_resource_name IN ('PT_400021 GU_400021') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB3: EP2_Actual_Availabilities_raw (3rd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        777 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.MAX_AVAIL_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Actual_Availabilities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 777))
AND r.participant_resource_name IN ('PT_400021 GU_400030') ORDER BY r.participant_resource_name, r.trading_period ; 
/*TAB4: EP2_Daily_Actual_Load_raw (1st)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7780 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.ACT_LOAD_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Daily_Actual_Load_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7780))
AND r.JURISDICTION IN ('NI') ORDER BY r.JURISDICTION, r.trading_period; 
/*TAB4: EP2_Daily_Actual_Load_raw (2nd)*/ 
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7781 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.ACT_LOAD_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Daily_Actual_Load_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7781))
AND r.JURISDICTION IN ('ROI') ORDER BY r.JURISDICTION, r.trading_period; 
/*TAB5: EP2_Dispatch_Quantities_raw (1st)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7700 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.DISPATCH_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Dispatch_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7700))
AND r.participant_resource_name IN ('PT_400021 GU_400020') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB5: EP2_Dispatch_Quantities_raw (2nd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7701 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.DISPATCH_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Dispatch_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7701))
AND r.participant_resource_name IN ('PT_400021 GU_400021') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB5: EP2_Dispatch_Quantities_raw (3rd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7702 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.DISPATCH_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Dispatch_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7702))
AND r.participant_resource_name IN ('PT_400021 GU_400030') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB6: EP2_Market_Schedule_Quantities_raw (1st)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7703 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.quantity AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7703))
AND r.participant_resource_name IN ('PT_400021 GU_400020') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB6: EP2_Market_Schedule_Quantities_raw (2nd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7704 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.quantity AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7704))
AND r.participant_resource_name IN ('PT_400021 GU_400021') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB6: EP2_Market_Schedule_Quantities_raw (3rd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7705 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.quantity AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7705))
AND r.participant_resource_name IN ('PT_400021 GU_400030') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB7: EP2_System_Marginal_Price_raw */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        779 AS bi_dim_market_id,
        r.SMP AS clearing_price,
         (SELECT ROUND(AVG(SMP),2)
        FROM EP2_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_System_Marginal_Price_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_System_Marginal_Price_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 779))
  ORDER BY  r.trading_period ; 
  
  /*TAB8: EA_raw: SYSTEM_LOAD */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        885 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.system_load AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 885))
        ORDER BY  r.trading_period ; 
  
/*TAB8: EA_raw: NON_WIND_GEN */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        886 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.non_wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 886))
        ORDER BY  r.trading_period ; */
  
    /*TAB8: EA_raw: WIND_GEN */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        887 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 887))
        ORDER BY  r.trading_period ; */
  
  /*TAB8: EA_raw: TOTAL_GEN_COST */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        888 AS bi_dim_market_id,
        r.TOTAL_GEN_COST AS clearing_price,
         (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))   AS ninety_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EA_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 888))
  ORDER BY  r.trading_period ; */
  
  /*TAB8: EA_raw: energy(smp) */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        881 AS bi_dim_market_id,
        r.smp AS clearing_price,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 881))
  ORDER BY  r.trading_period ; 
        
        
        /*TAB8: EA_raw: LAMBDA */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        889 AS bi_dim_market_id,
        r.lambda AS clearing_price,
        (SELECT ROUND(AVG(lambda),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EA_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(lambda),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 889))
  ORDER BY  r.trading_period ; 
        
        /*TAB8: EA_raw: INTER_LAMBDA */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        890 AS bi_dim_market_id,
        r.INTER_LAMBDA AS clearing_price,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EA_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 890))
  ORDER BY  r.trading_period ; */
        
        /*TAB8: EA_raw: INTERCONNECTOR */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        891 AS bi_dim_market_id,
        r.INTERCONNECTOR AS clearing_price,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EA_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 891))
  ORDER BY  r.trading_period ; */
  
 /*TAB9: EP1_raw: SYSTEM_LOAD */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        222 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.system_load AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 222))
        ORDER BY  r.trading_period ; 
  
/*TAB9: EP1_raw: NON_WIND_GEN */
/* EPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        223 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.non_wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 223))
        ORDER BY  r.trading_period ; */
  
    /*TAB9: EP1_raw: WIND_GEN */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        224 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 224))
        ORDER BY  r.trading_period ; */
  
  /*TAB9: EP1_raw: TOTAL_GEN_COST */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        225 AS bi_dim_market_id,
        r.TOTAL_GEN_COST AS clearing_price,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP1_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 225))
  ORDER BY  r.trading_period ; */
  
  
  /*TAB9: EP1_raw: energy(smp) */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        221 AS bi_dim_market_id,
        r.smp AS clearing_price,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP1_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 221))
  ORDER BY  r.trading_period ; 
  
        
        /*TAB9: EP1_raw: LAMBDA */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        226 AS bi_dim_market_id,
        r.lambda AS clearing_price,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP1_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
         (SELECT ROUND(AVG(lambda),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 226))
  ORDER BY  r.trading_period ; 
        
        /*TAB9: EP1_raw: INTER_LAMBDA */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        227 AS bi_dim_market_id,
        r.INTER_LAMBDA AS clearing_price,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP1_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 227))
  ORDER BY  r.trading_period ; */
        
        /*TAB9: EP1_raw: INTERCONNECTOR */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        228 AS bi_dim_market_id,
        r.INTERCONNECTOR AS clearing_price,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
         (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP1_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 228))
  ORDER BY  r.trading_period ; */
        
        /*TAB10: EP2_raw: SYSTEM_LOAD */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        332 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.system_load AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 332))
        ORDER BY  r.trading_period ; 
  
/*TAB10: EP2_raw: NON_WIND_GEN */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        333 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.non_wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 333))
        ORDER BY  r.trading_period ; */
  
    /*TAB10: EP2_raw: WIND_GEN */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        334 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 334))
        ORDER BY  r.trading_period ; */
  
  /*TAB10: EP2_raw: TOTAL_GEN_COST */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        335 AS bi_dim_market_id,
        r.TOTAL_GEN_COST AS clearing_price,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP2_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 335))
  ORDER BY  r.trading_period ; */
  
  /*TAB10: EP2_raw: energy(smp) */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        331 AS bi_dim_market_id,
        r.smp AS clearing_price,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 331))
  ORDER BY  r.trading_period ; 
        
        /*TAB10: EP2_raw: LAMBDA */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        336 AS bi_dim_market_id,
        r.lambda AS clearing_price,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP2_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 336))
  ORDER BY  r.trading_period ; 
        
        /*TAB10: EP2_raw: INTER_LAMBDA */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        337 AS bi_dim_market_id,
        r.INTER_LAMBDA AS clearing_price,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))   AS ninety_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP2_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
         (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 337))
  ORDER BY  r.trading_period ; */
        
        /*TAB10: EP2_raw: INTERCONNECTOR */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        338 AS bi_dim_market_id,
        r.INTERCONNECTOR AS clearing_price,
         (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP2_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 338))
  ORDER BY  r.trading_period ; */
  
  
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_all_markets_Energy` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_all_markets_Energy` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `update_all_markets_Energy`()
BEGIN
/* CAISO Energy */
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        3050 AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dayahead_energy WHERE CONVERT_TZ(date_time,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(date_time,'US/Central','GMT')) ) AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dayahead_energy WHERE CONVERT_TZ(date_time,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(date_time,'US/Central','GMT')) ) AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dayahead_energy WHERE CONVERT_TZ(date_time,'US/Central','GMT') = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(date_time,'US/Central','GMT')) ) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dayahead_energy WHERE CONVERT_TZ(date_time,'US/Central','GMT') BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(CONVERT_TZ(date_time,'US/Central','GMT')) ) AS one_year_avg,
	 NULL AS "capacity",
	 e.id AS bi_dim_date_id_local
   
FROM (SELECT date_time AS local_timestamp,CONVERT_TZ(date_time,'US/Central','GMT') AS DATETIME ,clearing_price FROM caiso_dayahead_energy WHERE DATE_TIME > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3050))) a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3050))) b ON b.timestamp_gmt =a.datetime
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP > (SELECT TIMESTAMP FROM bi_dim_date WHERE id=
	(SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id=3050))) AS e ON e.TIMESTAMP =a.local_timestamp	
;
/*PJM ENERGY DAM  lbmp*/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.lbmp AS clearing_price,
        (SELECT ROUND(AVG(lbmp),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.timestamp,INTERVAL 29 DAY) AND
	a.timestamp AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(lbmp),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.timestamp,INTERVAL 89 DAY) AND
	a.timestamp AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP = DATE_SUB(a.timestamp,INTERVAL 1 YEAR)
	AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 as volume,
        (SELECT ROUND(AVG(lbmp),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.timestamp,INTERVAL 1 YEAR) AND
	a.timestamp AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL as capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT * FROM pjm_energy_dam_raw  WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7))) b ON b.timestamp =a.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='PJM' AND market='Day-Ahead Energy' AND service='Energy') c;
/*PJM ENERGY DAM  CongestionPrice*/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.CongestionPrice AS clearing_price,
        (SELECT ROUND(AVG(CongestionPrice),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.timestamp,INTERVAL 29 DAY) AND
	a.timestamp AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(CongestionPrice),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.timestamp,INTERVAL 89 DAY) AND
	a.timestamp AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(CongestionPrice),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP = DATE_SUB(a.timestamp,INTERVAL 1 YEAR)
	AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 as volume,
        (SELECT ROUND(AVG(CongestionPrice),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.timestamp,INTERVAL 1 YEAR) AND
	a.timestamp AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL as capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT * FROM pjm_energy_dam_raw  WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=5))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=5))) b ON b.timestamp =a.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='PJM' AND market='Day-Ahead Energy' AND service='Congestion') c;
/*PJM ENERGY DAM  MarginalLossPrice*/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.MarginalLossPrice AS clearing_price,
        (SELECT ROUND(AVG(MarginalLossPrice),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.timestamp,INTERVAL 29 DAY) AND
	a.timestamp AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(MarginalLossPrice),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.timestamp,INTERVAL 89 DAY) AND
	a.timestamp AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(MarginalLossPrice),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP = DATE_SUB(a.timestamp,INTERVAL 1 YEAR) 
	AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 as volume,
        (SELECT ROUND(AVG(MarginalLossPrice),2) FROM pjm_energy_dam_raw  WHERE TIMESTAMP BETWEEN DATE_SUB(a.timestamp,INTERVAL 1 YEAR) AND
	a.timestamp AND HOUR(a.timestamp)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL as capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT * FROM pjm_energy_dam_raw  WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=6))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=6))) b ON b.timestamp =a.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='PJM' AND market='Day-Ahead Energy' AND service='Losses') c;
/*PJM ENERGY RT lbmp*/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.lbmp AS clearing_price,
        (SELECT ROUND(AVG(lbmp),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 29 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(lbmp),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 89 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP = DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR)
	AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 as volume,
        (SELECT ROUND(AVG(lbmp),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL as capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT * FROM pjm_energy_rt_raw WHERE TIMESTAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=10))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=10))) b ON b.timestamp =a.TIMESTAMP
JOIN
(SELECT * FROM bi_dim_market WHERE iso='PJM' AND market='Real-Time Energy' AND service='Energy') c;
/*PJM ENERGY RT CongestionPrice*/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.CongestionPrice AS clearing_price,
        (SELECT ROUND(AVG(CongestionPrice),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 29 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(CongestionPrice),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 89 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(CongestionPrice),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP = DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) 
	AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 as volume,
        (SELECT ROUND(AVG(CongestionPrice),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL as capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT * FROM pjm_energy_rt_raw WHERE TIMESTAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=8))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=8))) b ON b.timestamp =a.TIMESTAMP
JOIN
(SELECT * FROM bi_dim_market WHERE iso='PJM' AND market='Real-Time Energy' AND service='Congestion') c;
/*PJM ENERGY RT MarginalLossPrice*/
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        c.id AS bi_dim_market_id,
        a.MarginalLossPrice AS clearing_price,
        (SELECT ROUND(AVG(MarginalLossPrice),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 29 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(MarginalLossPrice),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 89 DAY) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(MarginalLossPrice),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP = DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR)
	AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 as volume,
        (SELECT ROUND(AVG(MarginalLossPrice),2) FROM pjm_energy_rt_raw WHERE TIMESTAMP BETWEEN DATE_SUB(a.TIMESTAMP,INTERVAL 1 YEAR) AND
	a.TIMESTAMP AND HOUR(a.TIMESTAMP)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL as capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT * FROM pjm_energy_rt_raw WHERE TIMESTAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=9))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=9))) b ON b.timestamp =a.TIMESTAMP
JOIN
(SELECT * FROM bi_dim_market WHERE iso='PJM' AND market='Real-Time Energy' AND service='Losses') c;
/*NYISO ENERGY DAM  lbmp*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 As volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL as capacity,
        c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020)))) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE iso='NYISO' AND market='Day-Ahead Energy' AND service_orig='LBMP') b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020)))) c
ON c.timestamp=a.time_stamp;
/*NYISO ENERGY DAM  marginal_cost_congestion*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 as volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL as capacity,
        c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035)))) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE iso='NYISO' AND market='Day-Ahead Energy' AND service_orig='Marginal Cost Congestion') b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035)))) c
ON c.timestamp=a.time_stamp;
/*NYISO ENERGY DAM  marginal_cost_losses*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 as volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL as capacity,
        c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050)))) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE iso='NYISO' AND market='Day-Ahead Energy' AND service_orig='Marginal Cost Losses') b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050)))) c
ON c.timestamp=a.time_stamp;
/*NYISO ENERGY RT  lbmp**/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 as volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110)))) a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Energy' AND service='Energy') b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110)))) c
ON c.timestamp=a.time_stamp;
/*NYISO ENERGY RT  marginal_cost_congestion*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 as volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125)))) a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Energy' AND service='Congestion') b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125)))) c
ON c.timestamp=a.time_stamp;
/*NYISO ENERGY RT  marginal_cost_losses*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 as volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140)))) a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Real-Time Energy' AND service='Losses') b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140)))) c
ON c.timestamp=a.time_stamp;
/* ERCOT RT-Settlement prices(Energy)*/
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
    c.id AS bi_dim_market_id,
    a.settlementpointprice AS clearing_price,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time=DATE_SUB(a.date_time,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    0 AS volume,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
    NULL as capacity,
    b.id AS bi_dim_date_id_local
FROM
(SELECT date_time,settlementpointprice  FROM ercot_realtime_energy_prices WHERE SettlementPointName="ALL" and date_time>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2009))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2009))) b
ON a.date_time=b.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='ERCOT' AND market='Real-Time Energy' AND service='Energy' AND zone='All') c;
/* ERCOT DAM-Settlement prices(Energy)*/
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
    c.id AS bi_dim_market_id,
    a.settlementpointprice AS clearing_price,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time=DATE_SUB(a.date_time,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    0 AS volume,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
    NULL as capacity,
    b.id AS bi_dim_date_id_local
FROM
(SELECT date_time,settlementpointprice  FROM ercot_dayahead_energy_prices WHERE date_time>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2008))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2008))) b
ON a.date_time=b.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='ERCOT' AND market='Day-Ahead Energy' AND service='Energy') c;
/* ERCOT RT-Settlement prices(Energy) for HB_HOUSTON*/
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
    c.id AS bi_dim_market_id,
    a.settlementpointprice AS clearing_price,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time=DATE_SUB(a.date_time,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    0 AS volume,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
    NULL as capacity,
    b.id AS bi_dim_date_id_local
FROM
(SELECT date_time,settlementpointprice  FROM ercot_realtime_energy_prices WHERE SettlementPointName="HB_HOUSTON" and  date_time>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2010))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2010))) b
ON a.date_time=b.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='ERCOT' AND market='Real-Time Energy' AND service='Energy' AND zone='HB_HOUSTON') c;
/* ISO-NE energy dam and RT */
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7005 AS bi_dim_market_id,
        a.energy_component AS clearing_price,
        (SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
	(SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
        (SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(date_time)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
        NULL AS capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT energy_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7005))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7005))) b ON b.timestamp =a.date_time ;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7006 AS bi_dim_market_id,
        a.marginal_loss_component AS clearing_price,
        (SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
	(SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(date_time)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
        NULL AS capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT marginal_loss_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7006))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7006))) b ON b.timestamp =a.date_time ;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7007 AS bi_dim_market_id,
        a.congestion_component AS clearing_price,
        (SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
	(SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
        (SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(date_time)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
        NULL AS capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT congestion_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7007))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7007))) b ON b.timestamp =a.date_time;
/*RT */
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7008 AS bi_dim_market_id,
        a.rt_congestion_component AS clearing_price,
        (SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
	(SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
        (SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(date_time)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
        NULL AS capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT rt_congestion_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7008))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7008))) b ON b.timestamp =a.date_time;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7009 AS bi_dim_market_id,
        a.RT_Marginal_Loss_Component AS clearing_price,
        (SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
	(SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
        (SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(date_time)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
        NULL AS capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT RT_Marginal_Loss_Component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7009))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7009))) b ON b.timestamp =a.date_time;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7010 AS bi_dim_market_id,
        a.RT_Energy_Component AS clearing_price,
        (SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
	(SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
        (SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(date_time)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
        NULL AS capacity,
        b.id AS bi_dim_date_id_local
FROM (SELECT RT_Energy_Component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7010))) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=7010))) b ON b.timestamp =a.date_time;
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_all_markets_test1` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_all_markets_test1` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `update_all_markets_test1`()
BEGIN
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        662 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.schedule_mw AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EA_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 662))
AND r.participant_resource_name IN ('PT_400021 GU_400020') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB1: EA_Market_Schedule_Quantities_raw (2nd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        663 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.schedule_mw AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EA_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 663))
AND r.participant_resource_name IN ('PT_400021 GU_400021') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB1: EA_Market_Schedule_Quantities_raw (3rd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        664 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.schedule_mw AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EA_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 664))
AND r.participant_resource_name IN ('PT_400021 GU_400030') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB2: EA_System_Marginal_Price_raw */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        661 AS bi_dim_market_id,
        r.SMP AS clearing_price,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_System_Marginal_Price_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EA_System_Marginal_Price_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 661))
  ORDER BY  r.trading_period ; 
  
  
  /*TAB3: EP2_Actual_Availabilities_raw (1st)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        775 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.MAX_AVAIL_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Actual_Availabilities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 775))
AND r.participant_resource_name IN ('PT_400021 GU_400020') ORDER BY r.participant_resource_name, r.trading_period;
/*TAB3: EP2_Actual_Availabilities_raw (2nd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        776 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.MAX_AVAIL_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Actual_Availabilities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 776))
AND r.participant_resource_name IN ('PT_400021 GU_400021') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB3: EP2_Actual_Availabilities_raw (3rd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        777 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.MAX_AVAIL_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Actual_Availabilities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 777))
AND r.participant_resource_name IN ('PT_400021 GU_400030') ORDER BY r.participant_resource_name, r.trading_period ; 
/*TAB4: EP2_Daily_Actual_Load_raw (1st)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7780 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.ACT_LOAD_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Daily_Actual_Load_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7780))
AND r.JURISDICTION IN ('NI') ORDER BY r.JURISDICTION, r.trading_period; 
/*TAB4: EP2_Daily_Actual_Load_raw (2nd)*/ 
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7781 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.ACT_LOAD_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Daily_Actual_Load_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7781))
AND r.JURISDICTION IN ('ROI') ORDER BY r.JURISDICTION, r.trading_period; 
/*TAB5: EP2_Dispatch_Quantities_raw (1st)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7700 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.DISPATCH_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Dispatch_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7700))
AND r.participant_resource_name IN ('PT_400021 GU_400020') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB5: EP2_Dispatch_Quantities_raw (2nd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7701 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.DISPATCH_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Dispatch_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7701))
AND r.participant_resource_name IN ('PT_400021 GU_400021') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB5: EP2_Dispatch_Quantities_raw (3rd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7702 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.DISPATCH_MW AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Dispatch_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7702))
AND r.participant_resource_name IN ('PT_400021 GU_400030') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB6: EP2_Market_Schedule_Quantities_raw (1st)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7703 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.quantity AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7703))
AND r.participant_resource_name IN ('PT_400021 GU_400020') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB6: EP2_Market_Schedule_Quantities_raw (2nd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7704 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.quantity AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7704))
AND r.participant_resource_name IN ('PT_400021 GU_400021') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB6: EP2_Market_Schedule_Quantities_raw (3rd)*/
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        7705 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.quantity AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_Market_Schedule_Quantities_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period  AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 7705))
AND r.participant_resource_name IN ('PT_400021 GU_400030') ORDER BY r.participant_resource_name, r.trading_period; 
/*TAB7: EP2_System_Marginal_Price_raw */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        779 AS bi_dim_market_id,
        r.SMP AS clearing_price,
         (SELECT ROUND(AVG(SMP),2)
        FROM EP2_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_System_Marginal_Price_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_System_Marginal_Price_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
         FROM EP2_System_Marginal_Price_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 779))
  ORDER BY  r.trading_period ; 
  
  /*TAB8: EA_raw: SYSTEM_LOAD */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        885 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.system_load AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 885))
        ORDER BY  r.trading_period ; 
  
/*TAB8: EA_raw: NON_WIND_GEN */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        886 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.non_wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 886))
        ORDER BY  r.trading_period ; */
  
    /*TAB8: EA_raw: WIND_GEN */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        887 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 887))
        ORDER BY  r.trading_period ; */
  
  /*TAB8: EA_raw: TOTAL_GEN_COST */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        888 AS bi_dim_market_id,
        r.TOTAL_GEN_COST AS clearing_price,
         (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))   AS ninety_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EA_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 888))
  ORDER BY  r.trading_period ; */
  
  /*TAB8: EA_raw: energy(smp) */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        881 AS bi_dim_market_id,
        r.smp AS clearing_price,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(SMP),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 881))
  ORDER BY  r.trading_period ; 
        
        
        /*TAB8: EA_raw: LAMBDA */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        889 AS bi_dim_market_id,
        r.lambda AS clearing_price,
        (SELECT ROUND(AVG(lambda),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EA_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(lambda),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 889))
  ORDER BY  r.trading_period ; 
        
        /*TAB8: EA_raw: INTER_LAMBDA */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        890 AS bi_dim_market_id,
        r.INTER_LAMBDA AS clearing_price,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EA_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 890))
  ORDER BY  r.trading_period ; */
        
        /*TAB8: EA_raw: INTERCONNECTOR */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        891 AS bi_dim_market_id,
        r.INTERCONNECTOR AS clearing_price,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EA_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EA_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EA_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 891))
  ORDER BY  r.trading_period ; */
  
 /*TAB9: EP1_raw: SYSTEM_LOAD */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        222 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.system_load AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 222))
        ORDER BY  r.trading_period ; 
  
/*TAB9: EP1_raw: NON_WIND_GEN */
/* EPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        223 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.non_wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 223))
        ORDER BY  r.trading_period ; */
  
    /*TAB9: EP1_raw: WIND_GEN */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        224 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 224))
        ORDER BY  r.trading_period ; */
  
  /*TAB9: EP1_raw: TOTAL_GEN_COST */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        225 AS bi_dim_market_id,
        r.TOTAL_GEN_COST AS clearing_price,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP1_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 225))
  ORDER BY  r.trading_period ; */
  
  
  /*TAB9: EP1_raw: energy(smp) */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        221 AS bi_dim_market_id,
        r.smp AS clearing_price,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP1_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 221))
  ORDER BY  r.trading_period ; 
  
        
        /*TAB9: EP1_raw: LAMBDA */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        226 AS bi_dim_market_id,
        r.lambda AS clearing_price,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP1_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
         (SELECT ROUND(AVG(lambda),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 226))
  ORDER BY  r.trading_period ; 
        
        /*TAB9: EP1_raw: INTER_LAMBDA */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        227 AS bi_dim_market_id,
        r.INTER_LAMBDA AS clearing_price,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP1_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 227))
  ORDER BY  r.trading_period ; */
        
        /*TAB9: EP1_raw: INTERCONNECTOR */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        228 AS bi_dim_market_id,
        r.INTERCONNECTOR AS clearing_price,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
         (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP1_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP1_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP1_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 228))
  ORDER BY  r.trading_period ; */
        
        /*TAB10: EP2_raw: SYSTEM_LOAD */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        332 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.system_load AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 332))
        ORDER BY  r.trading_period ; 
  
/*TAB10: EP2_raw: NON_WIND_GEN */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        333 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.non_wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 333))
        ORDER BY  r.trading_period ; */
  
    /*TAB10: EP2_raw: WIND_GEN */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        334 AS bi_dim_market_id,
        NULL AS clearing_price,
        NULL AS thirty_day_avg,
        NULL  AS ninety_day_avg,
        NULL AS previous_year_clearing_price,
        r.wind_gen AS volume,
        NULL AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 334))
        ORDER BY  r.trading_period ; */
  
  /*TAB10: EP2_raw: TOTAL_GEN_COST */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        335 AS bi_dim_market_id,
        r.TOTAL_GEN_COST AS clearing_price,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP2_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(TOTAL_GEN_COST),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 335))
  ORDER BY  r.trading_period ; */
  
  /*TAB10: EP2_raw: energy(smp) */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        331 AS bi_dim_market_id,
        r.smp AS clearing_price,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(SMP),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 331))
  ORDER BY  r.trading_period ; 
        
        /*TAB10: EP2_raw: LAMBDA */
 REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        336 AS bi_dim_market_id,
        r.lambda AS clearing_price,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP2_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(lambda),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 336))
  ORDER BY  r.trading_period ; 
        
        /*TAB10: EP2_raw: INTER_LAMBDA */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        337 AS bi_dim_market_id,
        r.INTER_LAMBDA AS clearing_price,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))   AS ninety_day_avg,
        (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP2_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
         (SELECT ROUND(AVG(INTER_LAMBDA),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 337))
  ORDER BY  r.trading_period ; */
        
        /*TAB10: EP2_raw: INTERCONNECTOR */
/* REPLACE INTO bi_fact_markets_part
SELECT d.id AS bi_dim_date_id,
        338 AS bi_dim_market_id,
        r.INTERCONNECTOR AS clearing_price,
         (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 29 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS thirty_day_avg,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 89 DAY) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt))  AS ninety_day_avg,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP2_raw WHERE trading_period = DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) 
        AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(INTERCONNECTOR),2)
        FROM EP2_raw WHERE trading_period BETWEEN DATE_SUB(d.timestamp_gmt,INTERVAL 1 YEAR) AND
        d.timestamp_gmt AND HOUR(trading_period)=HOUR(d.timestamp_gmt)) AS one_year_avg,
        NULL AS "capacity",
        d.id+16 AS bi_dim_date_id_local
        FROM EP2_raw AS r, bi_dim_date AS d WHERE d.timestamp_gmt = r.trading_period AND DATE(d.timestamp_gmt)<=CURDATE() AND timestamp_gmt >  (SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX(bi_dim_date_id) FROM bi_fact_markets_part WHERE bi_dim_market_id = 338))
  ORDER BY  r.trading_period ; */
  
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_nyiso_Energy_t` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_nyiso_Energy_t` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `update_nyiso_Energy_t`()
BEGIN

/* REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1006) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1007) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1008) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1009) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1010) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1011) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1012) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1013) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1014) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1015) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1016) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1017) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1018) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1019) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.lbmp AS clearing_price,
    (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(lbmp),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1020) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1021) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1022) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1023) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1024) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1025) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1026) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1027) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1028) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1029) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1030) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1031) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1032) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1033) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1034) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_congestion AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
        (SELECT ROUND(AVG(marginal_cost_congestion),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1035) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1036) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp; */

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1037) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1038) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1039) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1040) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1041) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1042) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1043) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1044) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1045) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00') c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1046) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1047) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1048) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1049) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
    b.id AS bi_dim_market_id,
    a.marginal_cost_losses AS clearing_price,
    (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND NAME=a.name ) AS previous_year_clearing_price,
        0 AS volume,
         (SELECT ROUND(AVG(marginal_cost_losses),2)
        FROM nyiso_lbmp_dam_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
        a.time_stamp AND NAME=a.name AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
        NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_dam_raw WHERE
(TIME_STAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) a
JOIN
(SELECT id,service_orig,zone FROM bi_dim_market WHERE id = 1050) b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE (TIMESTAMP BETWEEN '2010-09-16 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-11-30 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1051 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_capitl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_capitl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_capitl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='CAPITL' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1052 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_centrl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_centrl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_centrl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='CENTRL' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1053 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_dunwod_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_dunwod_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_dunwod_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='DUNWOD' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	 1054 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_genese_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_genese_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_genese_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='GENESE' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1055 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hq_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hq_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_hq_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='H Q' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1056 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hud_vl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hud_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_hud_vl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='HUD VL' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1057 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_longil_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_longil_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_longil_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-11-02 00:00:00' AND '2011-11-08 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='LONGIL' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1058 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_mhk_vl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_mhk_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_mhk_vl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='MHK VL' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1059 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_millwd_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_millwd_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_millwd_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='MILLWD' AND c.timestamp=a.time_stamp;







REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1060 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_nyc_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_nyc_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_nyc_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='N.Y.C.' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1061 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_north_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_north_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_north_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='NORTH' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1062 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_npx_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_npx_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_npx_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='NPX' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1063 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_oh_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_oh_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_oh_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='O H' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1064 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_pjm_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_pjm_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_pjm_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='PJM' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1065 AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_west_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_west_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_west_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='WEST' AND c.timestamp=a.time_stamp;



REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1066 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_capitl_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_capitl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_capitl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='CAPITL' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1067 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_centrl_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_centrl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_centrl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='CENTRL' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1068 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_dunwod_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_dunwod_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_dunwod_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='DUNWOD' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1069 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_genese_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_genese_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_genese_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='GENESE' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1070 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hq_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hq_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_hq_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='H Q' AND c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1071 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hud_vl_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hud_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_hud_vl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='HUD VL' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1072 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_longil_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_longil_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_longil_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='LONGIL' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1073 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_mhk_vl_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_mhk_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_mhk_vl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='MHK VL' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1074 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_millwd_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_millwd_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_millwd_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='MILLWD' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1075 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_nyc_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_nyc_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_nyc_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='N.Y.C.' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1076 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_north_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_north_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_north_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='NORTH' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1077 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_npx_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_npx_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_npx_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='NPX' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1078 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_oh_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_oh_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_oh_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='O H' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1079 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_pjm_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_pjm_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_pjm_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='PJM' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1080 AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_west_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_west_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_west_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00'))
AND a.NAME='WEST' AND c.timestamp=a.time_stamp;




REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1081 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_capitl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_capitl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_capitl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='CAPITL' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1082 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_centrl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_centrl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_centrl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='CENTRL' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1083 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_dunwod_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_dunwod_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_dunwod_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='DUNWOD' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1084 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_genese_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_genese_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_genese_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='GENESE' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1085 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hq_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hq_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_hq_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='H Q' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1086 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hud_vl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hud_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_hud_vl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00')
OR
(TIME_STAMP BETWEEN '2012-03-30 00:00:00' AND '2012-05-08 23:45:00'))
AND a.NAME='HUD VL' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1087 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_longil_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_longil_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_longil_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='LONGIL' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1088 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_mhk_vl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_mhk_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_mhk_vl_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='MHK VL' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1089 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_millwd_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_millwd_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_millwd_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='MILLWD' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1090 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_nyc_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_nyc_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_nyc_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='N.Y.C.' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1091 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_north_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_north_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_north_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='NORTH' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1092 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_npx_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_npx_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_npx_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='NPX' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1093 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_oh_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_oh_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_oh_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='O H' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1094 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_pjm_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_pjm_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_pjm_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='PJM' AND c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	1095 AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_west_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_west_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM nyiso_ham_west_raw a, bi_dim_date c WHERE
((TIME_STAMP BETWEEN '2010-09-14 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-05-29 00:00:00' AND '2012-05-29 23:45:00')
OR
(TIME_STAMP BETWEEN '2011-07-11 00:00:00' AND '2012-07-27 23:45:00'))
AND a.NAME='WEST' AND c.timestamp=a.time_stamp;







REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1096) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1097) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1098) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1099) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1100) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1101) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1102) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1103) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1104) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1105) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1106) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1107) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1108) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1109) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1110) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;





REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1111) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1112) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1113) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1114) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1115) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1116) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1117) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1118) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1119) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1120) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1121) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1122) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1123) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1124) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 3 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1125) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;





REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1126) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1127) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1128) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1129) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1130) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1131) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1132) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1133) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1134) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1135) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1136) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1137) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1138) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1139) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE  NAME =a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated  WHERE  NAME = a.name  AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_rt_raw_aggregated WHERE NAME = a.name  AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_rt_raw_aggregated WHERE
(TIME_STAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIME_STAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) a
JOIN
(SELECT * FROM bi_dim_market WHERE id = 1140) b
ON b.zone=a.name
JOIN
(SELECT * FROM bi_dim_date WHERE
(TIMESTAMP BETWEEN '2010-09-15 00:00:00' AND '2011-12-31 23:45:00' )
OR
(TIMESTAMP BETWEEN '2011-11-26 00:00:00' AND '2012-12-01 23:45:00')) c
ON c.timestamp=a.time_stamp;





REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) BETWEEN '2009-01-01' AND '2010-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) BETWEEN '2011-02-27' AND '2012-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) BETWEEN '2011-03-22' AND '2012-03-22'
AND b.timestamp = a.time_stamp;


REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) BETWEEN '2011-04-06' AND '2012-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) BETWEEN '2011-04-16' AND '2012-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) BETWEEN '2012-04-11' AND '2013-04-11'
AND b.timestamp = a.time_stamp;







REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) BETWEEN '2009-01-01' AND '2010-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) BETWEEN '2011-02-27' AND '2012-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) BETWEEN '2011-03-22' AND '2012-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) BETWEEN '2011-04-06' AND '2012-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) BETWEEN '2011-04-16' AND '2012-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) BETWEEN '2012-04-11' AND '2013-04-11'
AND b.timestamp = a.time_stamp;








REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) BETWEEN '2009-01-01' AND '2010-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) BETWEEN '2011-02-27' AND '2012-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) BETWEEN '2011-03-22' AND '2012-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-06' AND '2012-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-16' AND '2012-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) BETWEEN '2012-04-11' AND '2013-04-11'
AND b.timestamp = a.time_stamp;









REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) BETWEEN '2009-01-01' AND '2010-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) BETWEEN '2011-02-27' AND '2012-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) BETWEEN '2011-03-22' AND '2012-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-06' AND '2012-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-16' AND '2012-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) BETWEEN '2012-04-11' AND '2013-04-11'
AND b.timestamp = a.time_stamp;










REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) BETWEEN '2009-01-01' AND '2010-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) BETWEEN '2011-02-27' AND '2012-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) BETWEEN '2011-03-22' AND '2012-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-06' AND '2012-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-16' AND '2012-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) BETWEEN '2012-04-11' AND '2013-04-11'
AND b.timestamp = a.time_stamp;










REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) BETWEEN '2009-01-01' AND '2010-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) BETWEEN '2011-02-27' AND '2012-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) BETWEEN '2011-03-22' AND '2012-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-06' AND '2012-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-16' AND '2012-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) BETWEEN '2012-04-11' AND '2013-04-11'
AND b.timestamp = a.time_stamp;









REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) BETWEEN '2009-01-01' AND '2010-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) BETWEEN '2011-02-27' AND '2012-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) BETWEEN '2011-03-22' AND '2012-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-06' AND '2012-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-16' AND '2012-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) BETWEEN '2012-04-11' AND '2013-04-11'
AND b.timestamp = a.time_stamp;









REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) BETWEEN '2009-01-01' AND '2010-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) BETWEEN '2011-02-27' AND '2012-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) BETWEEN '2011-03-22' AND '2012-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-06' AND '2012-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) BETWEEN '2011-04-16' AND '2012-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part_raw
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) BETWEEN '2012-04-11' AND '2013-04-11'
AND b.timestamp = a.time_stamp;


END */$$
DELIMITER ;

/* Procedure structure for procedure `update_nyiso_ham_energy` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_nyiso_ham_energy` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `update_nyiso_ham_energy`()
BEGIN
/*NYISO ENERGY HAM  lbmp*/
/*
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1054' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='GENESE' AND TIME_STAMP BETWEEN '2011-12-23 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-12-23 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1055' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='H Q' AND TIME_STAMP BETWEEN '2011-12-23 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-12-23 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1056' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='HUD VL' AND TIME_STAMP BETWEEN '2011-12-23 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-12-23 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1057' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='LONGIL' AND TIME_STAMP BETWEEN '2011-12-23 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-12-23 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1058' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='MHK VL' AND TIME_STAMP BETWEEN '2011-12-23 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-12-23 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1059' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='MILLWD' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1060' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='N.Y.C.' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1061' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='NORTH' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1062' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='NPX' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1063' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='O H' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1064' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='PJM' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1065' AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='WEST' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1066' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='CAPITL' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
/*
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1067' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='CENTRL' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1068' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='DUNWOD' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1069' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='GENESE' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1070' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='H Q' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1071' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='HUD VL' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1072' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='LONGIL' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-28 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1073' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='MHK VL' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-28 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1074' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='MILLWD' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-28 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1075' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='N.Y.C.' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-28 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1076' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='NORTH' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-28 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1077' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='NPX' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-28 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1078' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='O H' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-28 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1079' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='PJM' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-28 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1080' AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='WEST' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-26 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-28 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1081' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='CAPITL' AND TIME_STAMP BETWEEN '2011-12-26 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-12-26 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1082' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='CENTRL' AND TIME_STAMP BETWEEN '2011-12-26 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-12-26 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1083' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='DUNWOD' AND TIME_STAMP BETWEEN '2011-12-26 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-12-26 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1084' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='GENESE' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1085' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='H Q' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1086' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='HUD VL' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1087' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='LONGIL' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1088' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='MHK VL' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1089' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='MILLWD' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1090' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='N.Y.C.' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1091' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='NORTH' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1092' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='NPX' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1093' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='O H' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;*/
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
    c.id AS bi_dim_market_id,
    a.settlementpointprice AS clearing_price,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time=DATE_SUB(a.date_time,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    0 AS volume,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
    NULL AS capacity
FROM
(SELECT date_time,settlementpointprice  FROM ercot_realtime_energy_prices WHERE date_time>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2009))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2009))) b
ON a.date_time=b.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='ERCOT' AND market='Real-Time Energy' AND service='Energy' AND zone='All') c;
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
    c.id AS bi_dim_market_id,
    a.settlementpointprice AS clearing_price,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time=DATE_SUB(a.date_time,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    0 AS volume,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_dayahead_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
    NULL AS capacity
FROM
(SELECT date_time,settlementpointprice  FROM ercot_dayahead_energy_prices WHERE date_time>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2008))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2008))) b
ON a.date_time=b.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='ERCOT' AND market='Day-Ahead Energy' AND service='Energy') c;
/*
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
    c.id AS bi_dim_market_id,
    a.settlementpointprice AS clearing_price,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time=DATE_SUB(a.date_time,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    0 AS volume,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
    NULL AS capacity
FROM
(SELECT date_time,settlementpointprice  FROM ercot_realtime_energy_prices WHERE SettlementPointName="HB_HOUSTON" AND  date_time>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2010))) a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP>=(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id=2010))) b
ON a.date_time=b.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='ERCOT' AND market='Real-Time Energy' AND service='Energy' AND zone='HB_HOUSTON') c;
*/
/* ISO-NE RT-DAM energy */
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7005 AS bi_dim_market_id,
        a.energy_component AS clearing_price,
        (SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(energy_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT energy_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >= '2009-01-01 00:00:00'
) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >= '2009-01-01 00:00:00'
) b ON b.timestamp =a.date_time ;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7006 AS bi_dim_market_id,
        a.marginal_loss_component AS clearing_price,
        (SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(marginal_loss_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT marginal_loss_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >= '2009-01-01 00:00:00'
) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >= '2009-01-01 00:00:00'
) b ON b.timestamp =a.date_time ;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7007 AS bi_dim_market_id,
        a.congestion_component AS clearing_price,
        (SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT congestion_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >= '2009-01-01 00:00:00'
) a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
'2009-01-01 00:00:00') b ON b.timestamp =a.date_time;
/*RT */
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7008 AS bi_dim_market_id,
        a.rt_congestion_component AS clearing_price,
        (SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(rt_congestion_component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT rt_congestion_component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
'2009-01-01 00:00:00') a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
'2009-01-01 00:00:00') b ON b.timestamp =a.date_time;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7009 AS bi_dim_market_id,
        a.RT_Marginal_Loss_Component AS clearing_price,
        (SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(RT_Marginal_Loss_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT RT_Marginal_Loss_Component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
'2009-01-01 00:00:00') a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
'2009-01-01 00:00:00') b ON b.timestamp =a.date_time;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        7010 AS bi_dim_market_id,
        a.RT_Energy_Component AS clearing_price,
        (SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS thirty_day_avg,
	(SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS ninety_day_avg,
        (SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time = DATE_SUB(a.date_time,INTERVAL 1 YEAR)
	AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS previous_year_clearing_price,
	0 AS volume,
        (SELECT ROUND(AVG(RT_Energy_Component),2) FROM iso_ne_dam_rt_raw  WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
	a.date_time AND HOUR(a.date_time)=HOUR(TIMESTAMP)) AS one_year_avg,
        NULL AS capacity
FROM (SELECT RT_Energy_Component ,date_time FROM iso_ne_dam_rt_raw  WHERE date_time >=
'2009-01-01 00:00:00') a
JOIN
(SELECT id,TIMESTAMP FROM bi_dim_date WHERE TIMESTAMP >=
'2009-01-01 00:00:00') b ON b.timestamp =a.date_time;
REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
        3050 AS bi_dim_market_id,
        a.clearing_price AS clearing_price,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dayahead_energy WHERE date_time BETWEEN DATE_SUB(a.DATETIME,INTERVAL 29 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATE_TIME) ) AS thirty_day_avg,
	(SELECT ROUND(AVG(clearing_price),2) FROM caiso_dayahead_energy WHERE date_time BETWEEN DATE_SUB(a.DATETIME,INTERVAL 89 DAY) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATE_TIME) ) AS ninety_day_avg,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dayahead_energy WHERE date_time = DATE_SUB(a.DATETIME,INTERVAL 1 YEAR)
	AND HOUR(a.DATETIME)=HOUR(DATE_TIME) ) AS previous_year_clearing_price,
        NULL AS volume,
        (SELECT ROUND(AVG(clearing_price),2) FROM caiso_dayahead_energy WHERE date_time BETWEEN DATE_SUB(a.DATETIME,INTERVAL 1 YEAR) AND
	a.DATETIME AND HOUR(a.DATETIME)=HOUR(DATE_TIME) ) AS one_year_avg,
	 NULL AS "capacity"
   
FROM (SELECT CONVERT_TZ(date_time,'US/Central','GMT') AS DATETIME ,clearing_price FROM caiso_dayahead_energy WHERE DATE_TIME >= '2010-01-01 00:00:00') a
JOIN
(SELECT id,timestamp_gmt FROM bi_dim_date WHERE timestamp_gmt >= '2010-01-01 00:00:00') b ON b.timestamp_gmt =a.datetime ;
/*
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1094' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='PJM' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	'1095' AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL as capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw_2010_11 WHERE NAME='WEST' AND TIME_STAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP BETWEEN '2011-11-06 00:00:00' AND '2011-12-29 23:59:59') c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT b.id AS bi_dim_date_id,
    c.id AS bi_dim_market_id,
    a.settlementpointprice AS clearing_price,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 29 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS thirty_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 89 DAY) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS ninety_day_avg,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time=DATE_SUB(a.date_time,INTERVAL 1 YEAR)) AS previous_year_clearing_price,
    0 AS volume,
    (SELECT ROUND(AVG(settlementpointprice),2)
    FROM  ercot_realtime_energy_prices
    WHERE date_time BETWEEN DATE_SUB(a.date_time,INTERVAL 1 YEAR) AND
    a.date_time AND HOUR(a.date_time)=HOUR(date_time)) AS one_year_avg,
    NULL AS capacity
FROM
(SELECT date_time,settlementpointprice  FROM ercot_realtime_energy_prices WHERE SettlementPointName="HB_HOUSTON" AND  date_time between '2011-12-21 00:00:00' AND '2011-12-25 23:59:59') a
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP between '2011-12-21 00:00:00' and '2011-12-25 23:59:59') b
ON a.date_time=b.timestamp
JOIN
(SELECT * FROM bi_dim_market WHERE iso='ERCOT' AND market='Real-Time Energy' AND service='Energy' AND zone='HB_HOUSTON') c;
*/
/*NYISO ENERGY HAM  lbmp*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1051))) AND NAME='CAPITL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='CAPITL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1051)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1052))) AND NAME='CENTRL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='CENTRL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1052)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1053))) AND NAME='DUNWOD') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='DUNWOD') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1053)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1054))) AND NAME='GENESE') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='GENESE') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1054)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1055))) AND NAME='H Q') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='H Q') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1055)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1056))) AND NAME='HUD VL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='HUD VL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1056)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1057))) AND NAME='LONGIL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='LONGIL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1057)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1058))) AND NAME='MHK VL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='MHK VL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1058)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1059))) AND NAME='MILLWD') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='MILLWD') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1059)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1060))) AND NAME='N.Y.C.') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='N.Y.C.') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1060)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1061))) AND NAME='NORTH') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='NORTH') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1061)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1062))) AND NAME='NPX') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='NPX') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1062)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1063))) AND NAME='O H') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='O H') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1063)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1064))) AND NAME='PJM') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='PJM') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1064)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1065))) AND NAME='WEST') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='WEST') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1065)))) c
ON c.timestamp=a.time_stamp;
/*NYISO ENERGY HAM  marginal_cost_congestion*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080)))) a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion') b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080)))) c
ON c.timestamp=a.time_stamp;
/*NYISO ENERGY HAM marginal_cost_losses*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_lbmp_ham_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_lbmp_ham_raw WHERE TIME_STAMP>=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095)))) a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses') b
ON a.name=b.zone
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095)))) c
ON c.timestamp=a.time_stamp;
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_nyiso_ham_energy_avg` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_nyiso_ham_energy_avg` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `update_nyiso_ham_energy_avg`()
BEGIN
                              /*NYISO ENERGY HAM  clearing_price_energy*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_capitl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_capitl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id as bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_capitl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1051))) AND NAME='CAPITL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='CAPITL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1051)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_centrl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_centrl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_centrl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1052))) AND NAME='CENTRL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='CENTRL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1052)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_dunwod_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_dunwod_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_dunwod_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1053))) AND NAME='DUNWOD') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='DUNWOD') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1053)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_genese_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_genese_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_genese_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1054))) AND NAME='GENESE') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='GENESE') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1054)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hq_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hq_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_hq_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1055))) AND NAME='H Q') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='H Q') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1055)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hud_vl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hud_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_hud_vl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1056))) AND NAME='HUD VL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='HUD VL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1056)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_longil_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_longil_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_longil_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1057))) AND NAME='LONGIL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='LONGIL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1057)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_mhk_vl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_mhk_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_mhk_vl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1058))) AND NAME='MHK VL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='MHK VL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1058)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_millwd_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_millwd_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_millwd_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1059))) AND NAME='MILLWD') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='MILLWD') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1059)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_nyc_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_nyc_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_nyc_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1060))) AND NAME='N.Y.C.') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='N.Y.C.') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1060)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_north_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_north_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_north_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1061))) AND NAME='NORTH') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='NORTH') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1061)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_npx_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_npx_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_npx_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1062))) AND NAME='NPX') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='NPX') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1062)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_oh_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_oh_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_oh_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1063))) AND NAME='O H') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='O H') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1063)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_pjm_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_pjm_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_pjm_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1064))) AND NAME='PJM') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='PJM') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1064)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.lbmp AS clearing_price,
	(SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_west_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_west_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(lbmp),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,lbmp,NAME  FROM nyiso_ham_west_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1065))) AND NAME='WEST') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Energy' AND Zone='WEST') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1065)))) c
ON c.timestamp=a.time_stamp;
                                   /*NYISO ENERGY HAM  marginal_cost_congestion*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_capitl_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_capitl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_capitl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1066))) AND NAME='CAPITL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='CAPITL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1066)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_centrl_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_centrl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_centrl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1067))) AND NAME='CENTRL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='CENTRL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1067)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_dunwod_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_dunwod_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_dunwod_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1068))) AND NAME='DUNWOD') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='DUNWOD') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1068)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_genese_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_genese_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_genese_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1069))) AND NAME='GENESE') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='GENESE') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1069)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hq_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hq_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_hq_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1070))) AND NAME='H Q') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='H Q') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1070)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hud_vl_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hud_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_hud_vl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1071))) AND NAME='HUD VL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='HUD VL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1071)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_longil_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_longil_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_longil_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1072))) AND NAME='LONGIL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='LONGIL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1072)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_mhk_vl_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_mhk_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_mhk_vl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1073))) AND NAME='MHK VL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='MHK VL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1073)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_millwd_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_millwd_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_millwd_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1074))) AND NAME='MILLWD') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='MILLWD') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1074)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_nyc_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_nyc_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_nyc_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1075))) AND NAME='N.Y.C.') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='N.Y.C.') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1075)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_north_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_north_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_north_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1076))) AND NAME='NORTH') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='NORTH') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1076)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_npx_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_npx_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_npx_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1077))) AND NAME='NPX') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='NPX') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1077)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_oh_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_oh_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_oh_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1078))) AND NAME='O H') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='O H') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1078)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_pjm_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_pjm_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_pjm_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1079))) AND NAME='PJM') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='PJM') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1079)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_congestion AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_west_raw WHERE  NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_west_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_congestion),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.NAME AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_congestion,NAME  FROM nyiso_ham_west_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1080))) AND NAME='WEST') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Congestion' AND Zone='WEST') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1080)))) c
ON c.timestamp=a.time_stamp;
                                 /*NYISO ENERGY HAM marginal_cost_losses*/
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_capitl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_capitl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_capitl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_capitl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1081))) AND NAME='CAPITL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='CAPITL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1081)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_centrl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_centrl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_centrl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
      DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_centrl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1082))) AND NAME='CENTRL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='CENTRL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1082)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_dunwod_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_dunwod_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_dunwod_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_dunwod_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1083))) AND NAME='DUNWOD') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='DUNWOD') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1083)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_genese_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_genese_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_genese_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_genese_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1084))) AND NAME='GENESE') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='GENESE') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1084)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hq_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hq_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hq_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_hq_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1085))) AND NAME='H Q') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='H Q') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1085)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hud_vl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hud_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_hud_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_capitl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1086))) AND NAME='HUD VL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='HUD VL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1086)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_longil_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_longil_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_longil_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_longil_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1087))) AND NAME='LONGIL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='LONGIL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1087)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_mhk_vl_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_mhk_vl_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_mhk_vl_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_mhk_vl_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1088))) AND NAME='MHK VL') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='MHK VL') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1088)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_millwd_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_millwd_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_millwd_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_millwd_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1089))) AND NAME='MILLWD') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='MILLWD') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1089)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_nyc_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_nyc_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_nyc_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_nyc_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1090))) AND NAME='N.Y.C.') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='N.Y.C.') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1090)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_north_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_north_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_north_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_north_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1091))) AND NAME='NORTH') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='NORTH') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1091)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_npx_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_npx_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_npx_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_npx_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1092))) AND NAME='NPX') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='NPX') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1092)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_oh_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_oh_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_oh_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_oh_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1093))) AND NAME='O H') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='O H') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1093)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_pjm_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_pjm_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_pjm_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_pjm_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1094))) AND NAME='PJM') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='PJM') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1094)))) c
ON c.timestamp=a.time_stamp;
REPLACE INTO bi_fact_markets_part
SELECT c.id AS bi_dim_date_id,
	b.id AS bi_dim_market_id,
	a.marginal_cost_losses AS clearing_price,
	(SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_west_raw WHERE  NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 29 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59')  AND HOUR(a.time_stamp)=HOUR(time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 89 DAY) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_west_raw  WHERE  NAME = a.name AND  time_stamp=DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) ) AS previous_year_clearing_price,
       0 AS volume,
       (SELECT ROUND(AVG(marginal_cost_losses),2)
       FROM nyiso_ham_west_raw WHERE NAME = a.name AND time_stamp BETWEEN DATE_SUB(DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:00:00'),INTERVAL 1 YEAR) AND
       DATE_FORMAT(a.time_stamp,'%Y-%m-%d %H:59:59') AND HOUR(a.time_stamp)=HOUR(time_stamp))  AS one_year_avg,
       NULL AS capacity,
       c.id AS bi_dim_date_id_local
FROM
(SELECT TIME_STAMP,marginal_cost_losses,NAME  FROM nyiso_ham_west_raw WHERE TIME_STAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1095))) AND NAME='WEST') a
JOIN
(SELECT * FROM bi_dim_market WHERE iso='NYISO' AND market='Hour-Ahead Energy'AND service='Losses' AND Zone='WEST') b
JOIN
(SELECT * FROM bi_dim_date WHERE TIMESTAMP >=
(SELECT TIMESTAMP FROM bi_dim_date WHERE id = (SELECT MAX( bi_dim_date_id) FROM bi_fact_markets_part
WHERE bi_dim_market_id  IN (1095)))) c
ON c.timestamp=a.time_stamp;
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_nyiso_Regulation_t` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_nyiso_Regulation_t` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`puneet.b`@`%` PROCEDURE `update_nyiso_Regulation_t`()
BEGIN

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) = '2009-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) = '2011-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) = '2011-03-22'
AND b.timestamp = a.time_stamp;


REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) = '2011-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) = '2011-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_Regulation AS clearing_price,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Regulation' AND id=1149) c
WHERE DATE(time_stamp) = '2012-04-11'
AND b.timestamp = a.time_stamp;







REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) = '2009-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) = '2011-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) = '2011-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) = '2011-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) = '2011-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Spinning Reserve' AND id=1150) c
WHERE DATE(time_stamp) = '2012-04-11'
AND b.timestamp = a.time_stamp;








REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) = '2009-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) = '2011-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) = '2011-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) = '2011-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) = '2011-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Non-Spinning Reserve' AND id=1151) c
WHERE
DATE(time_stamp) = '2012-04-11'
AND b.timestamp = a.time_stamp;









REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) = '2009-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) = '2011-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) = '2011-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) = '2011-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) = '2011-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.East_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
         /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(East_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'East'AND service = 'Operating Reserve' AND id=1152) c
WHERE
DATE(time_stamp) = '2012-04-11'
AND b.timestamp = a.time_stamp;










REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) = '2009-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) = '2011-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) = '2011-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) = '2011-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) = '2011-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Spinning_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
          /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Spinning_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Spinning Reserve' AND id=1153) c
WHERE
DATE(time_stamp) = '2012-04-11'
AND b.timestamp = a.time_stamp;










REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) = '2009-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) = '2011-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) = '2011-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) = '2011-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) = '2011-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_10_Min_Non_Synchronous_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /* 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_10_Min_Non_Synchronous_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /****************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Non-Spinning Reserve' AND id=1154) c
WHERE
DATE(time_stamp) = '2012-04-11'
AND b.timestamp = a.time_stamp;









REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) = '2009-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) = '2011-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) = '2011-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) = '2011-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) = '2011-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_Regulation AS clearing_price,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
        /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_Regulation),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /*******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West' AND service = 'Regulation' AND id = 1155) c
WHERE
DATE(time_stamp) = '2012-04-11'
AND b.timestamp = a.time_stamp;









REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) = '2009-01-01'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) = '2011-02-27'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) = '2011-03-22'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) = '2011-04-06'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) = '2011-04-16'
AND b.timestamp = a.time_stamp;

REPLACE INTO bi_fact_markets_part
SELECT  b.id AS bi_dim_date_id,
       c.id AS bi_dim_market_id,
       a.West_30_Min_Operating_Reserve AS clearing_price,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 29 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS thirty_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 89 DAY) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS ninety_day_avg,
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw  WHERE time_stamp=DATE_SUB(a.time_stamp,INTERVAL 1 YEAR)
        AND HOUR(time_stamp)=HOUR(a.time_stamp)) AS previous_year_clearing_price,
        NULL AS volume,
       /**** 12 month rolling avg ****/
       (SELECT ROUND(AVG(West_30_Min_Operating_Reserve),2)
       FROM nyiso_ancillary_service_prices_ham_raw WHERE time_stamp BETWEEN DATE_SUB(a.time_stamp,INTERVAL 1 YEAR) AND
       a.time_stamp AND HOUR(time_stamp)=HOUR(a.time_stamp))  AS one_year_avg,
        NULL AS "capacity"
       /******************************/
FROM nyiso_ancillary_service_prices_ham_raw a , bi_dim_date b
JOIN (SELECT * FROM bi_dim_market WHERE zone = 'West'AND service = 'Operating Reserve' AND id = 1156) c
WHERE
DATE(time_stamp) = '2012-04-11'
AND b.timestamp = a.time_stamp;


END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
