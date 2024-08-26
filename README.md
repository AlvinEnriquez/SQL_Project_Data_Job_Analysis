# Introduction

Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background

The questions I wanted to answer through my SQL queries were:

What are the top-paying data analyst jobs?

What skills are required for these top-paying jobs?

What skills are most in demand for data analysts?

Which skills are associated with higher salaries?

What are the most optimal skills to learn?

# Tools I Used


For my deep dive into the data analyst job market, I harnessed the power of several key tools:

**SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.

**PostgreSQL**: The chosen database management system, ideal for handling the job posting data.

**Visual Studio Code**: My go-to for database management and executing SQL queries.

**Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analytics

ach query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
select job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name as company_name
from job_postings_fact
    left join company_dim using (company_id)
where job_title_short = 'Data Analyst'
    and job_work_from_home = TRUE
    and salary_year_avg is not null
order by salary_year_avg desc nulls last
limit 10;
```

2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
    select job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        company_dim.name as company_name
    from job_postings_fact
        left join company_dim using (company_id)
    where job_title_short = 'Data Analyst'
        and job_work_from_home = TRUE
        and salary_year_avg is not null
    order by salary_year_avg desc
    limit 10
)
Select top_paying_jobs.*,
    skills_job_dim.skill_id,
    skills_dim.skills
from top_paying_jobs
    inner join skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    inner join skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
order by salary_year_avg desc;
```

3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT skill_id,
	COUNT(*) AS skill_count,
	skills as skill_name
FROM skills_job_dim AS skills_to_job
	INNER JOIN job_postings_fact AS job_postings USING (job_id)
	INNER JOIN skills_dim AS skills USING (skill_id)
WHERE 1 = 1 --job_postings.job_work_from_home = True 
	AND job_postings.job_title_short = 'Data Engineer'
GROUP BY skill_id,
	skills
ORDER BY skill_count DESC
LIMIT 10;
```

"skill_id","skill_count","skill_name"
0,"113375","sql"
1,"108265","python"
76,"62174","aws"
74,"60823","azure"
92,"53789","spark"
4,"35642","java"
98,"29163","kafka"
97,"28883","hadoop"
3,"28791","scala"
75,"27532","databricks"


4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT skill_id,
    skills as skill_name,
    ROUND (AVG(salary_year_avg), 0) as avg_salary
FROM skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings USING (job_id)
    INNER JOIN skills_dim AS skills USING (skill_id)
WHERE 1 = 1 --job_postings.job_work_from_home = True 
    AND job_postings.job_title_short = 'Data Analyst'
    AND salary_year_avg is not null
GROUP BY skill_id,
    skills
ORDER BY avg_salary DESC
LIMIT 10;
```

"skill_id","skill_count","skill_name"
0,"113375","sql"
1,"108265","python"
76,"62174","aws"
74,"60823","azure"
92,"53789","spark"
4,"35642","java"
98,"29163","kafka"
97,"28883","hadoop"
3,"28791","scala"
75,"27532","databricks"


5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
WITH skills_demand AS (
    SELECT skill_id,
        COUNT(*) AS skill_count,
        skills as skill_name
    FROM skills_job_dim AS skills_to_job
        INNER JOIN job_postings_fact AS job_postings USING (job_id)
        INNER JOIN skills_dim AS skills USING (skill_id)
    WHERE job_postings.job_work_from_home = True
        AND job_postings.job_title_short = 'Data Analyst'
        AND salary_year_avg is not null
    GROUP BY skill_id,
        skills --ORDER BY
),
average_salary AS (
    SELECT skill_id,
        skills as skill_name,
        ROUND (AVG(salary_year_avg), 0) as avg_salary
    FROM skills_job_dim AS skills_to_job
        INNER JOIN job_postings_fact AS job_postings USING (job_id)
        INNER JOIN skills_dim AS skills USING (skill_id)
    WHERE job_postings.job_work_from_home = True
        AND job_postings.job_title_short = 'Data Analyst'
        AND salary_year_avg is not null
    GROUP BY skill_id,
        skills --ORDER BY
        --avg_salary DESC
)
SELECT skills_demand.skill_name,
    skills_demand.skill_count,
    average_salary.avg_salary
from skills_demand
    INNER JOIN average_salary USING (skill_id)
where skill_count > 10
order by avg_salary DESC,
    skill_count DESC;
```

"skill_name","skill_count","avg_salary"
"go","27","115320"
"confluence","11","114210"
"hadoop","22","113193"
"snowflake","37","112948"
"azure","34","111225"
"bigquery","13","109654"
"aws","32","108317"
"java","17","106906"
"ssis","12","106683"
"jira","20","104918"
"oracle","37","104534"
"looker","49","103795"
"nosql","13","101414"
"python","236","101397"
"r","148","100499"
"redshift","16","99936"
"qlik","13","99631"
"tableau","230","99288"
"ssrs","14","99171"
"spark","13","99077"


# What I learned

Postgres, SQL

# Conclusion

From the analysis, several general insights emerged:

Top-Paying Data Analyst Jobs: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
Skills for Top-Paying Jobs: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
Most In-Demand Skills: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
Skills with Higher Salaries: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
Optimal Skills for Job Market Value: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.