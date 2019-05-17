/*Answer 1 Query */

SELECT  ROUND((OG1.Count*1.0/ OG2. acquisition_platform_count)*100,2) as "Conversion Rate",
               OG1.count "First Session Completed Count",
               OG2. acquisition_platform_count as "Aquisition Platform Count",
              OG2. acquisition_platform as "Aquisition  Platform"
FROM 
             (
	SELECT a.platform as platform,
	              count (a.platform) as count
	FROM 
		(
		SELECT  RANK () OVER (PARTITION BY user_id order by date_completed asc) as Rank,
		               user_id,
		               platform
		 FROM   journey
		             where status = 'COMPLETED' AND pack ='Foundation Level 1' 
                           ) as a
             where a.Rank =1
             GROUP BY a.platform
             ) as OG1,

	(
	SELECT count(acquisition_platform) as acquisition_platform_count,
	              acquisition_platform
	FROM   users
	GROUP BY acquisition_platform
	) as OG2
where OG2.acquisition_platform =OG1. platform;

/*Answer 2 Query*/
SELECT  ROUND((OG1.Count*1.0/ OG2. acquisition_platform_count)*100,2) as "Conversion Rate",
               OG1.count "First Session Completed Count",
                OG2. acquisition_platform_count as "Aquisition Platform Count",
                OG2. year_month
FROM 
            (
	SELECT count (user_id) as count,
	              a. year_month
	FROM 
		(
		SELECT RANK () OVER (PARTITION BY user_id order by date_completed asc) as Rank,
		               user_id,
		               DATE_PART('year', date_completed)||'-'|| DATE_PART('Month', date_completed) as year_month
                          FROM    journey
		where status = 'COMPLETED' AND pack ='Foundation Level 1' 
		) a
where a.Rank =1
GROUP BY a.year_month
) as OG1 FULL JOIN

	(
	SELECT count(acquisition_platform) as acquisition_platform_count,
	               DATE_PART('year',account_creation_date)||'-'|| DATE_PART('Month',account_creation_date) as year_month
	FROM    users
	GROUP BY year_month
	) as OG2
ON  OG2. year_month =OG1. year_month;

/*Answer 3 Query*/
SELECT  a.platform, 
               COUNT(a.platform)
FROM 
(
  SELECT RANK () OVER (PARTITION BY user_id order by date_completed asc) as Rank,
                user_id,
                platform
 FROM    journey
where status = 'COMPLETED' AND pack ='Foundation Level 1' 
) as a
where user_id IN (SELECT user_id from users where acquisition_platform ='Desktop')
AND a.Rank =1
GROUp BY a.platform