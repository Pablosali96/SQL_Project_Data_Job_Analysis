/*
Question: What are the most optimal skills to learn? (aka it's in high demand and a high-paying skill)
-Identify skills in high demand and associated with high average salaries for Data Analust roles
-Concentrates on remote positions with specific salaries
-Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis 
*/

WITH skills_demand as(
    SELECT 
        s.skill_id,
        s.skills,
        COUNT(sj.job_id) as demand_count
    FROM job_postings_fact as j
    INNER JOIN skills_job_dim as sj ON j.job_id = sj.job_id
    INNER JOIN skills_dim as s ON sj.skill_id = s.skill_id
    WHERE
        j.job_title_short = 'Data Analyst' AND
        j.job_work_from_home = True AND
        salary_year_avg IS NOT NULL
    GROUP BY
        s.skill_id
), average_salary AS (
    SELECT 
        s.skill_id,
        s.skills,
        ROUND(AVG(j.salary_year_avg),0) as avg_salary
    FROM job_postings_fact as j
    INNER JOIN skills_job_dim as sj ON j.job_id = sj.job_id
    INNER JOIN skills_dim as s ON sj.skill_id = s.skill_id
    WHERE
        j.job_title_short = 'Data Analyst' AND
        j.job_work_from_home = True AND
        salary_year_avg IS NOT NULL
    GROUP BY
        s.skill_id
)

SELECT 
    sd.skill_id,
    sd.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand as sd
INNER JOIN average_salary as avgs ON sd.skill_id = avgs.skill_id
WHERE demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

--rewriting this query to be more concise 
SELECT 
    sd.skill_id,
    sd.skills,
    COUNT(sj.job_id) as demand_count,
    ROUND(AVG(jp.salary_year_avg),0) as avg_salary
FROM job_postings_fact as jp
INNER JOIN skills_job_dim as sj ON jp.job_id = sj.job_id
INNER JOIN skills_dim as sd ON sj.skill_id = sd.skill_id
WHERE
    jp.job_title_short = 'Data Analyst' AND
    jp.salary_year_avg IS NOT NULL AND
    jp.job_work_from_home = True
GROUP BY
    sd.skill_id
HAVING 
    COUNT(sj.job_id) > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;