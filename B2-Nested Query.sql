SELECT INJ.state as "State",
       INJ.State_Rank as "State Rank",
       INJ.Active_company_count as "Active Company Count [Q4-2016]",
       INJ.Industry_type as "Industry Type",
       INJ.Ticket_Volume_Rank as "Ticket Volume Rank [By Industry]",
       INJ.ticket_volume as "Ticket Volume Count [By Industry] ",
       Customer_care.issue_type as "Issue Type",
       count (Customer_care.ticket_id) as "Ticket Count [By Issue Type]", /*Added this column to add more meaning to the query*/
       AVG(Customer_care.solved_at::TIMESTAMP-customer_care.created_At::TIMESTAMP) as "Average Ticket Resolution Time"
FROM   companies INNER JOIN Customer_care ON companies.company_id = Customer_care.company_id
                 INNER JOIN ( SELECT 
								       OG1.state as state,
								       OG2.Rank as State_Rank,
								       OG2.Active_company_count as Active_company_count,
								       OG1.Industry_type as Industry_type,
								       OG1.Ticket_Volume_Rank as Ticket_Volume_Rank,
								       OG1.ticket_volume as ticket_volume
								FROM  (       
										SELECT  d.industry as Industry_type,
										        d.state    as State,
										        d.Rank     as  Ticket_Volume_Rank,
										        d.ticket_volume as ticket_volume
										FROM   (
												SELECT DENSE_RANK () OVER (Partition by c.state ORDER BY c.ticket_volume desc ) as Rank,
												       c.industry as industry,
												       c.state as state,
												       c.ticket_volume as ticket_volume
												FROM   (

														SELECT COUNT(Customer_care.ticket_id) as ticket_volume,
														       companies.industry as industry,
														       companies.state as state
														FROM   companies 
														       INNER JOIN Customer_care ON Customer_care.company_id= companies.company_id
														WHERE  companies.state IN (
																					/*Top 5 largest states by active count- Q4 2016 */
																					SELECT b.state as state
																					FROM   (

																							SELECT DENSE_RANK() OVER ( order by a.Active_company_count DESC) as Rank,
																							       a.state as state
																							FROM
																							       (
																									/*Count of Company from Q4 2016*/
																									SELECT COUNT(company_id) as Active_company_count,
																									       state
																									FROM   companies
																									where  is_active ='True'
																									AND    EXTRACT(YEAR FROM payroll_processed_at at time zone 'pst') = 2016
																									AND    EXTRACT(MONTH FROM payroll_processed_at at time zone 'pst') IN(10,11,12)  
																									GROUP BY state
																									) a 
																					       ) b
																					WHERE b.Rank < 6
																					)
														GROUP BY companies.industry,companies.state
														) c
												) d
										Where d.Rank < 6
										) OG1 ,

								(
								SELECT DENSE_RANK() OVER ( order by a.Active_company_count DESC) as Rank,
								       a.state as state,
								       a.Active_company_count as Active_company_count
								FROM
								       (
										/*Count of Company from Q4 2016*/
										SELECT COUNT(company_id) as Active_company_count,
										       state
										FROM   companies
										where  is_active ='True'
										AND    EXTRACT(YEAR FROM payroll_processed_at at time zone 'pst') = 2016
										AND    EXTRACT(MONTH FROM payroll_processed_at at time zone 'pst') IN(10,11,12)  
										GROUP BY state
										) a 
								) OG2

								where OG1.state= OG2.state
							) INJ
ON CONCAT(INJ.state,INJ.Industry_type) = CONCAT(companies.state,companies.industry)
WHERE Customer_care.ticket_status ='Solved' 
GROUP BY Customer_care.issue_type,INJ.state,INJ.State_Rank,INJ.Active_company_count,INJ.Industry_type,INJ.Ticket_Volume_Rank,INJ.ticket_volume
ORDER BY INJ.State_Rank ASC,INJ.Ticket_Volume_Rank ASC;