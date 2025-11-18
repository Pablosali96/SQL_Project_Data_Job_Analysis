# Introduction
In this project, I'll dive into the data job market. I intend to explore top-paying jobs, in-demand skills and the conjunction between high demand and high salary in data analytics.

This is my first project diving into the world of Data Analytics, it follows the course provided by the Data Analyst [Luke Barousse](https://www.youtube.com/@LukeBarousse). 

All the SQL queries can be checked here: [project sql folder](/project_sql/)

# Background

The database in this project was created with the aim of analysing the job market in 2023/2024 for Data related occupations as well as providing aid to others to find an optimal job with information such as top-paying jobs and in-demand skills.

The data comes from Luke's [SQL Data Analysis Course](https://www.lukebarousse.com/sql). It contains multiple tables with information related to job titles, salaries, locations, skills and more.

### The questions I aim to answer through my SQL questies were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are the most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used

To answer the previosly mentioned questions about the data job market, I used the following key tools:

- **SQL**: The main tool used, it allows me to query the necessary information to uncover relevant insights.
- **PostgreSQL**: Used to handle the job postings data, this was the chosen data management tool.
- **Visual Studio Code**: Used to query data in SQL format, it's one of the most popular database management tools.
- **Github**: Essential tool for version control, it is used to share the SQL scripts and analysis, allowing for project tracking.

# The Analysis
Each of the questions aimed to provide answer to multiple aspects of the data analysis job market. Here is how each question was tackled:

### 1. Top Paying Data Analyst Jobs.
To answer this question, I focused on the average yearly salary and the location, also evaluation remote jobs in the process. This query shows the top 10 high-paying job opportunities in the field.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    c.name as company_name
FROM job_postings_fact as j
LEFT JOIN company_dim as c ON j.company_id=c.company_id 
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10;
```
Here are some of the key points of the result set:
- **Diverse Industries**: We can find job opportunities across multiple industries such as Meta, AT&T, Mantys, etc This shows that the role of Data Analysis is required in a variety of organisations from healthcare, to technology and Advertisement.
- **Wide Range Of Salaries**: We can find salaries from $184k to a outstanding $650k yearly, the later being more of an outlayer as it being almost double than the previous job opportunity salary.
- **Job Title Variety**: Job titles range from a simple Data Analyst to positions advertising a Hybrid/Remote modality, data analyst with focus on marketing and 3 principal data analysts.

### 2. Top Paying Job Skills.
Here, I used the previous query in a CTE as it contains the top high-paying jobs which we can use to find out what are the skills they require. We gather all the information from said CTE and added the name of the skills each job posting required.

```sql
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
```
Here are some of the key points of the result set:
- **SQL** leads the count of the most requested skill being present in 8 listings
- **Python** follows up closely being present in 7 listings
- The visualization software of **Tableau** is third in the race with 6 job listings requiring it.

### 3. The Most In-Demand Skills.
Here I joined the job postings table with the necesarry skills tables so count and extract the top 5 most demanded skills for Data Analysts in remote positions.

```sql
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
```
Here are some of the key points of the result set:
- **SQL** is toping the list of the most in demand skills being present in more than 8k job postings. Showing how important it is for data analyst to be able to be familiar with it.
- **Python** follows behind with around 7.1k job postings. Following the same trend as SQL, Python is a relevant tool which will increases the changes of getting an adequate for.
- **Excel** takes number 3 with around 5.3k job postings. This tool has been for a long time one of the most popular tools used by Data Analyst and the number of job postings requiring it shows that this is still true to this day.


| Skill     | Demand Count |
|-----------|--------------|
| SQL       | 8123         |
| Python    | 7120         |
| Excel     | 5330         |
| Tableau   | 4211         |
| Power BI  | 3188         |

### 4. Top paying skills.
Here I wanted to discover what skills payed the most, so data analyst professionals are provided with information about what skills are the most profitable to learn and master. 

```sql
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
```

Here are some of the key points of the result set:
- **Pyshark** dominate the highest salary skill with a outstanding $208k average yearly salary. This data processing tool is used in data engineering and machine learning pipeliness which demand high skill and knowledge.
- **Version control tools** are quite high in the list with tools like Bitbucket($189k), Gitlab($154k), Jenkins($124k) and others.
- **AI/ML platforms** also position themselves high of the list of skills with tolls such as Watson($160k), DataRobot($155k), Jupyter($152k), Pandas($151k) and numpy($143) which are also used on statistical analysis.

### 5. The most optimal skills.
With both the most in-demand skills and the highest paid skills, I want to answer what would be the best skills to be proficient on. Skills that are both required in a lot of job postings and allow for the potential of great earnings.

```sql
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
```

Here are some of the key points of the result set:
- **Cloud and Big Data skills** are high on the top of optimal skills. Go($155k), Confluence($144k), Hadoop($133k) dominate the list which means that data analysts who can work with cloud data warehouses are up to good job opportunities
- **High-demand skills** such as Python($101k), Tableau($99k) and R($100k) offer job stability due to the demand but not very high salary, this happens because of the high supply and demand, they are essential skills but may not provide high paid job opportunities.
- **Niche skills** such as Go, Spark and SSRS appear to be high in salary but low in demand. These skills are more specialised but tend to be more data engineering focused.

# What I Learned
Throughout this venture in the world of SQL, I learned some valiables skills in a scenerio with real-life data, here are some of the insights I gained:
- **SQL basics**: I learned the basic structure of SQL, the syntaxes of SELECT, FROM, WHERE. I learned about how to join tables using primery and foreign keys from each tables, how to ORDER BY and LIMIT my queries to answer relevant questions.
- **Data Aggregation**: I learned how to use statistical function to extract averages, counts or occurances of certain pieces of information and how to use GROUP BY to evaluate these aggregations against multiple categories/values.
- **Usage of Data**: I learned how to use result sets to answer questions which may be of use to people in the area of Data, these results can guide people in the data sphere, such as myself, on what to learn, where to apply for jobs and more.

# Conclusions

This project was of great value as it allows me to learn and get myself familiar with SQL, databases and programs such as Postgres and Visual Studio Code, as well as analyzing real-life data which can be used by multiple people to see how the data job market behaved in the past years and what they may expect in the present or future. I'm very grateful to stumble upon this project and very thankful the Luke Barousse and his tutorial which allowed me to enter into this new field of Data Analysis.