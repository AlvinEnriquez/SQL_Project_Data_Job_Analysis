WITH remote_job_skills AS (
	SELECT skill_id, COUNT(*) AS skill_count
	FROM 
	skills_job_dim AS skills_to_job
	INNER JOIN job_postings_fact AS job_postings USING (job_id)
	WHERE job_postings.job_work_from_home = True 
   	  AND job_postings.job_title_short = 'Data Analyst'
	GROUP BY skill_id
)

SELECT skills.skill_id, skills as skill_name, skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills USING (skill_id)
ORDER BY
skill_count DESC
LIMIT 5;



--------



	SELECT skill_id, COUNT(*) AS skill_count, skills as skill_name
	FROM 
	skills_job_dim AS skills_to_job
	INNER JOIN job_postings_fact AS job_postings USING (job_id)
	INNER JOIN skills_dim AS skills USING (skill_id)
	WHERE 1=1 --job_postings.job_work_from_home = True 
   	  AND job_postings.job_title_short = 'Data Engineer'
	GROUP BY skill_id, skills
	ORDER BY
	skill_count DESC
	LIMIT 10;
