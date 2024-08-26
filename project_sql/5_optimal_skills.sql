

WITH skills_demand AS (
    	SELECT skill_id, COUNT(*) AS skill_count, skills as skill_name
	FROM 
	skills_job_dim AS skills_to_job
	INNER JOIN job_postings_fact AS job_postings USING (job_id)
	INNER JOIN skills_dim AS skills USING (skill_id)
	WHERE job_postings.job_work_from_home = True 
   	  AND job_postings.job_title_short = 'Data Analyst'
      AND salary_year_avg is not null
	GROUP BY skill_id, skills
	--ORDER BY
),  average_salary AS (
        SELECT skill_id, skills as skill_name, 
    ROUND (AVG(salary_year_avg),0) as avg_salary
	FROM 
	skills_job_dim AS skills_to_job
	INNER JOIN job_postings_fact AS job_postings USING (job_id)
	INNER JOIN skills_dim AS skills USING (skill_id)
	WHERE job_postings.job_work_from_home = True 
   	  AND job_postings.job_title_short = 'Data Analyst'
      AND salary_year_avg is not null
	GROUP BY skill_id, skills
	--ORDER BY
	--avg_salary DESC
)

SELECT skills_demand.skill_name,
skills_demand.skill_count,
average_salary.avg_salary
from skills_demand
INNER JOIN average_salary USING (skill_id)
where skill_count > 10
order by 
avg_salary DESC, 
skill_count DESC;