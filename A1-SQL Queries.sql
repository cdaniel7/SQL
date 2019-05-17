/*  This Doc Contains
1) Basic SQL queries
2) Joins
3) Pivoting Query
4) Sum Over functions
5) Nested Queries*/


/* CREATE A TABELE */
create table Git_test
(Serial_no number,unique_ID varchar2(13),
description varchar2(20),stock number,amount number,venue varchar2(20),country_code varchar2(20),region varchar2(20),
Date_of_Entry date, time_stamp number)

/*Data*/
insert into GIT_TEST values (1,'A1','Initial Stock',1000,1000,'Atlanta','US','NA','01-JAN-2017',1483328167000000);
insert into GIT_TEST values (2,'B2','Purchase',70,175,'London','GBR','EMEA','01-JAN-2017',1483328167000000);
insert into GIT_TEST values (3,'C3','Carry Over',293,845,'Munich','DE','EMEA','01-JAN-2017',1483328167000000);
insert into GIT_TEST values (4,'D4','Damaged',1000,1000,'Brisbane','AUS','APAC','01-JAN-2017',1483328167000000);
insert into GIT_TEST values (5,'E5','Returned',1000,1000,'Tokyo','JP','APAC','01-JAN-2017',1483328167000000);
insert into GIT_TEST values (6,'F6','Initial Stock',1000,1000,'Sao Paulo','BR','LATAM','30-DEC-2016',1483155367000000);
insert into GIT_TEST values (7,'G7','Initial Stock',1000,1000,'Metepec','MX','LATAM','29-DEC-2016',1483068967000000);
insert into GIT_TEST values (8,'H8','Carry Over',1000,1000,'Qubec','CA','NA','30-DEC-2016',1483155367000000);
insert into GIT_TEST values (9,'I9','Initial Stock',1000,1000,'Tampa','US','NA','27-DEC-2016',1482896167000000);
insert into GIT_TEST values (10,'J10','Returned',1000,1000,'Montreal','CA','NA','01-JAN-2017',1483328167000000);
insert into GIT_TEST values (11,'K11','Initial Stock',1000,1000,'Lzcalli','MX','LATAM','15-DEC-2011',1479267367000000);
insert into GIT_TEST values (12,'L12','Purchase',1000,1000,'Salvador','BR','LATAM','11-DEC-2016',1478921767000000);
insert into GIT_TEST values (13,'M13','Initial Stock',1000,1000,'Kyoto','JP','APAC','1-NOV-2016',147805416700000);
insert into GIT_TEST values (14,'N14','Damaged',1000,1000,'Sydney','AUS','APAC','10-DEC-2016',1481427367000000);
insert into GIT_TEST values (15,'O15','Initial Stock',1000,1000,'Frankfurt','DE','EMEA','27-DEC-2016',1482896167000000);
insert into GIT_TEST values (16,'P16','Returned',1000,1000,'New Castle','GBR','EMEA','20-DEC-2016',1482291367000000);
insert into GIT_TEST values (17,'Q17','Carry Over',1000,1000,'Venice','ITA','EMEA','20-DEC-2016',1482291367000000);
insert into GIT_TEST values (18,'R18','Purchase',1000,1000,'Melbourne','AUS','APAC','20-DEC-2016',1482291367000000);
insert into GIT_TEST values (19,'S19','Damaged',1000,1000,'Hiroshima','JP','APAC','20-DEC-2016',1482291367000000);
insert into GIT_TEST values (20,'T20','Carry Over',1000,1000,'Miami','US','NA','20-DEC-2016',1482291367000000);
/*Data*/


/*Queries*/

/*Aggregate Queries*/
SELECT AVG(stock) as Average,
       MIN(stock) as Minium_Stock,
       MAX(stock) as MAximum_Stock,
       ROUND(AVG(stock),-1) as Rounded_Average,
       SUM(stock) as Sum,
       COUNT(stock) as Count
FROM git_test;


/*Aggregate Queries with Having clause*/
SELECT AVG(amount) as Average,
       MIN(amount) as Minium_Stock,
       MAX(amount) as MAximum_Stock,
       ROUND(AVG(amount),-1) as Rounded_Average,
       SUM(amount) as Sum,
       COUNT(amount) as Count
FROM git_test
       HAVING SUM(stock+500)>100;

/*Sum Over Function with Partition by Clause et al */

SELECT SUM(AMOUNT) OVER (PARTITION BY region order by Date_of_Entry ASC ) as Cummulative_Sum,
       Region
FROM   GIT_TEST;


SELECT SUM(AMOUNT) as Total_Amount,
       Region
FROM   GIT_TEST
GROUP BY Region
ORDER BY Region ASC;

/*Ranking using Partition by Clause*/

SELECT Country_code,
       RANK () OVER (PARTITION BY Country_code ORDER BY Amount DESC) as Rnk,
       Amount
FROM GIT_TEST;


/*Grant and Revoke access queries*/

GRANT READER ON TABLE GIT_TEST To 'xyz@github.com'
GRANT OWNER  ON TABLE GIT_TEST To  'rst&yahoo.com'
GRANT WRITER  ON TABLE GIT_TEST To  'rst&yahoo.com'

REVOKE ALL ON GIT_TETST FROM 'rst@gmail.com'
REVOKE SELECT,UPDATE ON GIT_TETST FROM 'rst@gmail.com'


/*CASE statement in SELECT & WHERE Clause*/

SELECT Country_code,
       CASE  WHEN Venue IN ('Atlanta','Qubec','Tampa','Montreal','Miami') THEN 'North America'
             WHEN Venue IN ('Brisbane','Tokyo','Kyoto','Sydney','Melbourne','Hiroshima') THEN 'Asia Pacific'
             WHEN Venue IN ('Sao Paulo','Metepec','Lzcalli','Salvador') THEN 'Latin America'
             ELSE 'EMEA' END as Business_Region
FROM   GIT_TEST
GROUP BY Country_code,Venue;


SELECT Unique_ID,
       Description,
       Stock,
       Amount,
       Venue,
       Country_code,
       Region,
       Date_of_Entry
FROM   GIT_TEST
WHERE  CASE COUNTRY_CODE WHEN COUNTRY_CODE IN ('CA','US') THEN Amount >999
            WHEN COUNTRY_CODE IN ('AUS','JP') THEN stock >500
            WHEN COUNTRY_CODE IN ('AUS','JP') THEN stock >500
            WHEN COUNTRY_CODE IN ('MX','ITA') THEN Description IN ('Initial Stock','Carry Over')
      END;


/*CONCATENATE*/

SELECT 'The Venue is ' || Venue as Venue
FROM GIT_TEST;

/*SUBSTR, REPLACE & LEN Queries*/

SELECT SUBSTR(time_stamp,1,10) as Seconds,
       REPLACE(country_code,'CA','Canada') as Country_code,
       LENGTH(time_stamp) as Length
FROM   GIT_TEST

/*ALL, ANY, SOME Queries*/

SELECT Unique_id,
       Description,
       Venue,
       Region
FROM   GIT_TEST
WHERE Amount > ALL (100,200,300);

SELECT Unique_id,
       Description,
       Venue,
       Region
FROM   GIT_TEST
WHERE Amount > ANY (100,200,300);

SELECT Unique_id,
       Description,
       Venue,
       Region
FROM   GIT_TEST
WHERE Amount > SOME (100,200,300);

/*Like in Where clause*/
SELECT Unique_id,
       Description,
       Venue,
       Region
FROM   GIT_TEST
WHERE DESCRIPTION LIKE '%Pur%'

SELECT Unique_id,
       Description,
       Venue,
       Region
FROM   GIT_TEST
WHERE DESCRIPTION LIKE 'In%'


/*COALESCE Funtion in query */


SELECT Unique_id,
       Description,
       Venue,
       Region,
       COALESCE(Amount,0) as Coalesce_Function
FROM   GIT_TEST


/*Function Based on Microseconds */

SELECT MONTHNAME(time_stamp),
       DAYOFMONTH(time_stamp),
       DAYNAME(time_stamp),
       MONTH(time_stamp),
       YEAR(time_stamp),
       STRFTIME_USEC(time_stamp),
       FORMAT_TIME_USEC(time_stamp),
       MONTHNAME(time_stamp),
       STRFTIME_USEC(time_stamp,'%x') as Date_Representation ,
       STRFTIME_USEC(time_stamp,'%X') as Time_Representation ,
       STRFTIME_USEC(time_stamp,'%a') as Weekday,
       STRFTIME_USEC(time_stamp,'%c') as Date_Time,
       STRFTIME_USEC(time_stamp,'%j') as Day_of_Year,
       STRFTIME_USEC(time_stamp,'%p') as AM_PM

FROM   GIT_TEST;




/*Convert_TZ*/

SELECT CASE WHEN Country_code  IN ('JP') THEN CONVERT_TZ(time_stamp,'Japan/Tokyo','US/Pacific')
            WHEN Country_code  IN ('AUS') THEN CONVERT_TZ(time_stamp,'Brisbane/Australia','US/Pacific')
            WHEN Country_code  IN ('DE') THEN CONVERT_TZ(time_stamp,'Munich/Germany','US/Pacific')
            WHEN Country_code  IN ('GBR') THEN CONVERT_TZ(time_stamp,'London/England','US/Pacific')
            WHEN Country_code  IN ('MX') THEN CONVERT_TZ(time_stamp,'Lzcalli/Mexico','US/Pacific')
            WHEN Country_code  IN ('BR') THEN CONVERT_TZ(time_stamp,'Sao Paulo/Brazil','US/Pacific')
            END as Time_stamp
FROM   GIT_TEST

/*Nested Query */

SELECT Unique_id,
       Description,
       Venue,
       Region,
       COALESCE(Amount,0) as Coalesce_Function
FROM   GIT_TEST
WHERE Region in (SELECT Region FROM GIT_TEST WHERE Amount > 99);

/*Date Query*/

Select date_of_entry,
       date_of_entry +10,
       date_of_entry - 10,
       Country_code,
       Venue
FROM   GIT_TEST
WHERE  date_of_entry > '01-MAY-2016'

/*Joins*/

DEFINE INLINE TABLE S1 as
SELECT * FROM GIT_TEST

SELECT S1.Unique_ID as Unique_ID,
       Git_TEST.Description as Description,
       Git_TEST.stock,
       Git_TEST.amount
       Git_TEST.Region,
       S1.time_stamp
FROM   Git_TEST INNER JOIN S1
       ON S1.Serial_No = GIT_TEST.Serial_NO
WHERE  S1.time_stamp > 10000000000

/*Pivoting*/
/* Orcale SQL Developer*/


/*Creating a Table*/
CREATE TABLE cup (Agent varchar2(20),Amount number, Region Varchar2(20));
/*Inserting Data*/
INSERT INTO cup values ('Chris',100,'LAX');
INSERT INTO cup values ('Daniel',400,'LAX');
INSERT INTO cup values ('Tom',120,'LAX');
INSERT INTO cup values ('Jerry',80,'LAX');
INSERT INTO cup values ('Scobby',40,'LAX');
INSERT INTO cup values ('Jackie',50,'LAX');
INSERT INTO cup values ('Chris',123,'SEA');
INSERT INTO cup values ('Daniel',223,'SEA');
INSERT INTO cup values ('Tom',546,'SEA');
INSERT INTO cup values ('Jerry',75,'SEA');
INSERT INTO cup values ('Scobby',345,'SEA');
INSERT INTO cup values ('Jackie',655,'SEA');
INSERT INTO cup values ('Chris',100,'MTV');
INSERT INTO cup values ('Daniel',100,'MTV');
INSERT INTO cup values ('Tom',100,'MTV');
INSERT INTO cup values ('Jerry',100,'MTV');
INSERT INTO cup values ('Scobby',100,'MTV');
INSERT INTO cup values ('Jackie',100,'MTV');
INSERT INTO cup values ('Chris',200,'CHI');
INSERT INTO cup values ('Daniel',200,'CHI');
INSERT INTO cup values ('Tom',200,'CHI');
INSERT INTO cup values ('Jerry',200,'CHI');
INSERT INTO cup values ('Scobby',200,'CHI');
INSERT INTO cup values ('Jackie',200,'CHI');


/*The Pivot Query*/
SELECT Agent,
       Los_Angeles,
       Mountain_View,
       Chicago,
       Seattle
FROM
(
SELECT * FROM cup
)
PIVOT
(
SUM(amount) for Region IN ('LAX' as Los_Angeles ,'MTV' as Mountain_View,'CHI' as Chicago,'SEA' as Seattle)
)

/*Sum Over Funciton*/
/* Oracle SQL Developer */
/*Create a Table*/
CREATE TABLE box
(id number,
start_date Date,
end_date Date,
Amount NUMBER,
Region Varchar2(20),
Local_Region Varchar2(20));


/*Insert Values */
INSERT INTO box values (1,'25-DEC-1988','25-DEC-1988',100,'NA','MTV');
INSERT INTO box values (2,'24-DEC-1988','25-DEC-1988',100,'NA','LAX');
INSERT INTO box values (3,'22-MAR-1988','25-DEC-1988',100,'NA','MTV');
INSERT INTO box values (4,'20-DEC-1988','25-DEC-1988',100,'NA','LAX');
INSERT INTO box values (5,'18-DEC-1988','25-DEC-1988',100,'EMEA','LON');
INSERT INTO box values (6,'19-MAR-1988','25-DEC-1988',100,'EMEA','DE');
INSERT INTO box values (7,'1-DEC-1988','25-DEC-1988',100,'EMEA','LON');
INSERT INTO box values (8,'2-DEC-1988','25-DEC-1988',100,'EMEA','DE');
INSERT INTO box values (9,'2-DEC-1988','25-DEC-1988',100,'EMEA','LON');
INSERT INTO box values (10,'5-MAR-1988','25-DEC-1988',100,'EMEA','DE');
INSERT INTO box values (11,'17-DEC-1988','25-DEC-1988',100,'EMEA','LON');
INSERT INTO box values (12,'19-DEC-1988','25-DEC-1988',100,'APAC','JP');
INSERT INTO box values (13,'07-DEC-1988','25-DEC-1988',100,'APAC','JP');
INSERT INTO box values (14,'3-MAR-1988','25-DEC-1988',100,'APAC','JP');
INSERT INTO box values (15,'4-DEC-1988','25-DEC-1988',100,'APAC','JP');
INSERT INTO box values (16,'5-DEC-1988','25-DEC-1988',100,'NA','MTV');
INSERT INTO box values (17,'25-DEC-1988','25-DEC-1988',100,'NA','CHI');
INSERT INTO box values (18,'25-DEC-1988','25-DEC-1988',100,'NA','MTV');
INSERT INTO box values (19,'25-DEC-1988','25-DEC-1988',100,'NA','CHI');
INSERT INTO box values (20,'25-MAR-1988','25-DEC-1988',100,'NA','MTV');



/*SUM OVER Functions-Partition By  */
/*CASE Statement*/
/*Simple Date Manipulation*/
SELECT SUM (AMOUNT) OVER ( PARTITION BY Region,Local_Region ORDER BY ID DESC) as Cummulative_Sum,
       Region,
       CASE WHEN Local_Region ='JP' THEN 'JAPAN'
            WHEN Local_Region ='DE'  THEN 'GERMANY'
            WHEN Local_Region ='LON'  THEN 'London'
            WHEN Local_Region ='CHI'  THEN 'Chicago'
            WHEN Local_Region ='LAX'  THEN 'Los Angeles'
            WHEN Local_Region ='MTV'  THEN 'Mountain View'
            ELSE 'Lookup-Update Needed'
            END AS Local_Region,
       id as ID,
       ROUND((END_DATE-START_DATE)/24,2) as Days_Diff
FROM    box;

/*SUM OVER Function- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  */
/*CASE Statement*/
/*Simple Date Manipulation*/

SELECT SUM (AMOUNT) OVER (  ORDER BY ID DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Cummulative_Sum,
       Region,
       CASE WHEN Local_Region ='JP' THEN 'JAPAN'
            WHEN Local_Region ='DE'  THEN 'GERMANY'
            WHEN Local_Region ='LON'  THEN 'London'
            WHEN Local_Region ='CHI'  THEN 'Chicago'
            WHEN Local_Region ='LAX'  THEN 'Los Angeles'
            WHEN Local_Region ='MTV'  THEN 'Mountain View'
            ELSE 'Lookup-Update Needed'
            END AS Local_Region,
       id as ID,
       ROUND((END_DATE-START_DATE)/24,2) as Days_Diff
FROM    box;


/*SUM OVER Function- ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING  */
/*CASE Statement*/
/*Simple Date Manipulation*/
SELECT SUM (AMOUNT) OVER (  ORDER BY ID DESC ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) as Cummulative_Sum,
       Region,
       CASE WHEN Local_Region ='JP' THEN 'JAPAN'
            WHEN Local_Region ='DE'  THEN 'GERMANY'
            WHEN Local_Region ='LON'  THEN 'London'
            WHEN Local_Region ='CHI'  THEN 'Chicago'
            WHEN Local_Region ='LAX'  THEN 'Los Angeles'
            WHEN Local_Region ='MTV'  THEN 'Mountain View'
            ELSE 'Lookup-Update Needed'
            END AS Local_Region,
       id as ID,
       ROUND((END_DATE-START_DATE)/24,2) as Days_Diff
FROM    box;

/* Nested Queries*/
SELECT COUNT(OG2.userid) as No_of_New_Users,
      OG2.geo_country as Geo_Country,
      TO_CHAR(OG2.ts,'MonthYYYY') as Month_Year
FROM
     (
     SELECT OG1.userid as userid,
     OG1.geo_country as geo_country,
     OG1.ts as ts
     FROM
     (
         SELECT u.userid as userid,
         u.geo_country as geo_country,
         e.ts as ts,
        RANK () OVER(PARTITION BY u.userid ORDER BY e.ts ASC) as RANK
         FROM users u FULL OUTER JOIN events e ON u.userid = e.userid
     )
     OG1 WHERE OG1.RANK =1
     )
OG2 WHERE TO_CHAR(OG2.ts,'FMMonthYYYY') = 'January2017'
GROUP BY OG2.Geo_Country
ORDER BY No_of_New_Users DESC
LIMIT 1;

/* Mega Nested Query*/
SELECT ROUND(((start.start_video_count/total.new_user_count)*100),2) as Percentage
FROM
 (
     SELECT COUNT (event) as start_video_count,
     TO_CHAR(ts,'MonthYYYY') as Month_Year
     FROM events
     WHERE event = 'start_video'
     AND userid
     IN (SELECT OG2.userid
     FROM
 (
     SELECT OG1.userid as userid,
    FROM
 (
       SELECT u.userid as userid,
       TO_CHAR(e.ts,'FMMonthYYYY') as time_stamp,
       RANK () OVER(PARTITION BY u.userid ORDER BY e.ts ASC) as RANK
      FROM users u FULL OUTER JOIN events e ON u.userid = e.userid
 )
       OG1 WHERE OG1.RANK =1
      AND OG1.time_stamp = 'January2017'
 )
OG2
)
) start,
(
SELECT COUNT (event) as new_user_count,
 TO_CHAR(ts,'MonthYYYY') as Month_Year
FROM events
WHERE userid
     IN (SELECT D2.userid
    FROM
 (
     SELECT D1.userid as userid,
     FROM
 (
     SELECT u.userid as userid,
     TO_CHAR(e.ts,'FMMonthYYYY') as time_stamp,
     RANK () OVER(PARTITION BY u.userid ORDER BY e.ts ASC) as RANK
     FROM users u FULL OUTER JOIN events e ON u.userid = e.userid

 )
 D1 WHERE D1.RANK =1
 AND D1.time_stamp = 'January2017'
 )
D2
)
) total 

/*Query Tuning*/
EXPLAIN PLAN for  SELECT * FROM git_test;
SELECT * FROM table(dbms_xplan.display);

/*For postgres*/
EXPLAIN ANAlYZE SELECT * FROM git_test;

/*Timezone conversion*/
SELECT mani, mani at time zone 'PST' FROM og


/*LEAD*/
SELECT venue , lead(venue,1,'Chris') over (order by venue asc)
FROM git_test 
order by venue asc

/*LAG*/
SELECT venue , LAG(venue,1,'Chris') over (order by venue asc)
FROM git_test 
order by venue asc


/*Generate Series*/
SELECT  generate_series('2017-01-01'::date,
                              '2017-12-31', '1 day') :: date as c1
                              

/*first value*/
SELECT first_value(unique_id) over (order by amount desc) as First_value,
first_value(unique_id) over (order by amount asc) as last_value
FROM git_test;
