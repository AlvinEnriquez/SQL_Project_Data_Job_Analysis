--Question: What are the top paying data analyst jobs
--Top 10 highest paying data analyst roles that are available remotely
--Focus on job postings with specified salary
select job_id, job_title, job_location, 
job_schedule_type, salary_year_avg, job_posted_date,
company_dim.name as company_name
from job_postings_fact
left join company_dim using (company_id)
where job_title_short = 'Data Analyst'
and job_work_from_home = TRUE
and salary_year_avg is not null
order by salary_year_avg desc nulls last
limit 10;