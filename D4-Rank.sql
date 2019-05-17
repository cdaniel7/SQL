
/*Please test it on MS SQL Server engine*/

SELECT OG1.submission_date as submission_date,
       OG1.Unique_visitors as Unique_visitors,
       OG2.hacker_id as hacker_id,
       OG2.name as name
FROM
(
SELECT d.count as Unique_visitors,
             d.submission_date as submission_date
FROM
        (

        SELECT RANK () OVER (Partition by c.submission_date order by c.inner_rank Desc) as Outer_Rank,
                c.count as count,
                c.submission_date
                
        FROM 
                  (
                  SELECT COUNT(b.Rank) as count , b.Rank as inner_rank, b.submission_date as submission_date
                  FROM
                            (
                            SELECT RANK () OVER (partition by a.hacker_id order by a.submission_date asc ) as Rank,
                                   submission_date
                            FROM   
                                        (
                                            SELECT  hacker_id,
                                           submission_date
                                    FROM   submissions
                                    Group BY hacker_id,submission_date
                                        ) as a
    
                        ) as b
                        GROUP By b.Rank,b.submission_date
              ) as c
    ) as d
    where d.Outer_Rank=1
) as OG1,
(
SELECT b.submission_date as submission_date,
       b.hacker_id as hacker_id,
       b.name as name
FROM 
(
  SELECT RANK () OVER(Partition by submission_date order by a.submissions_count desc,a.hacker_id asc ) as Rank,
         a.hacker_id as hacker_id,
         a.name as name,
         a.submission_date as submission_date
  FROM 
            (
            SELECT Count (submissions.hacker_id) as submissions_count,
                   submissions.hacker_id as hacker_id ,
                   hackers.name as name,
                   submissions.submission_date as submission_date
            From   submissions
            INNER JOIN  hackers ON hackers.hacker_id = submissions.hacker_id
            GROUP BY submissions.hacker_id,submission_date,hackers.name
            ) as a
) as b
where b.Rank =1
) OG2
where OG2.submission_date= OG1.submission_date;







