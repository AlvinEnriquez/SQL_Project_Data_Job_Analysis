/*
Question: What skills are required for the top paying jobs
--Use the top 10 highest paying jobs from first query
--Add specific skills required for these roles
*/


WITH top_paying_jobs AS (
select job_id, job_title, job_location, 
job_schedule_type, salary_year_avg, job_posted_date,
company_dim.name as company_name
from job_postings_fact
left join company_dim using (company_id)
where job_title_short = 'Data Analyst'
and job_work_from_home = TRUE
and salary_year_avg is not null
order by salary_year_avg desc
limit 10) 

Select top_paying_jobs.*, skills_job_dim.skill_id ,
skills_dim.skills
from top_paying_jobs
inner join skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
inner join skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
order by salary_year_avg desc
;
