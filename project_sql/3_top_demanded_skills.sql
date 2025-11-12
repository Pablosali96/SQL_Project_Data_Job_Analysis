/*
Question: What are the most in-demand skills for data analysts?
-Join job postings to inner join table similar to query 2
-Identify the top 5 in-demand skills for a data analyst
-Focus on all job postings (opposite to problem 1 and 2)
-Why? Retrieves the top 5 skills with the highest demand in the job market.
    providing insights inot the most valuables skills for job seekers.
*/

SELECT 
    s.skills,
    COUNT(sj.job_id) as demand_count
FROM job_postings_fact as j
INNER JOIN skills_job_dim as sj ON j.job_id = sj.job_id
INNER JOIN skills_dim as s ON sj.skill_id = s.skill_id
WHERE
    j.job_title_short = 'Data Analyst' AND
    j.job_location ='Anywhere'
GROUP BY
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;
