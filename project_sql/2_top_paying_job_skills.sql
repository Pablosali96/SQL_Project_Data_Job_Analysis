/*
Question: What skills are required for the top-paying Data Analysy jobs?
-Use top 10 highest-paying Data Analyst jobs from the first query
-Add the specific skills required for these jobs
-Why? It provides a detailed look at which high-apying jobs demand certain skills,
helping job seekers understand which skills to develop that align with top salaries
*/

With top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        c.name as company_name
    FROM job_postings_fact as j
    LEFT JOIN company_dim as c ON j.company_id=c.company_id 
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)
SELECT t.*,
    s.skills as skill_name
FROM top_paying_jobs as t
INNER JOIN skills_job_dim as sjd ON t.job_id = sjd.job_id
INNER JOIN skills_dim as s ON sjd.skill_id = s.skill_id;

/*
Here's the breakdown of the most demanded skills for data analyst high-paying jobs in 2023, based on job postings:
-SQL is leading the count with 8 jobs requiring it.
-Python is coming second with a count of 7 jobs.
-Tableau is also highly sought after, with a count of 6.
-Other skills such as R, Snowflake, Pandas and Excel show different degrees of demand.
*/