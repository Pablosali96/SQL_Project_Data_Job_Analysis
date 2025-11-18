/*
Question: What are the top skills based on salary?
-Look at the average salary associated with each skill for Data Analyst positions
-Focuses on roles with specific salaries, regardless of location
-Why? It reveals how different skills impact salary levels for Data Analyst and
    helps identify the most financially rewarding skills to acquire or improve.
*/

SELECT 
    s.skills,
    ROUND(AVG(j.salary_year_avg),0) as avg_salary
FROM job_postings_fact as j
INNER JOIN skills_job_dim as sj ON j.job_id = sj.job_id
INNER JOIN skills_dim as s ON sj.skill_id = s.skill_id
WHERE
    j.job_title_short = 'Data Analyst' AND
    j.job_location ='Anywhere' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY 
    avg_salary DESC
LIMIT 25;