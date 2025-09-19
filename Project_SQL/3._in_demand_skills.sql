WITH remote_jobs_skill AS(
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM
    skills_job_dim AS skill_to_job
INNER JOIN 
    job_postings_fact as job_posting ON job_posting.job_id = skill_to_job.job_id
WHERE 
    job_posting.job_work_from_home = TRUE AND job_posting.job_title_short = 'Data Analyst'
GROUP BY
    skill_id
)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM
    remote_jobs_skill
INNER JOIN
    skills_dim as skills ON skills.skill_id = remote_jobs_skill.skill_id
ORDER BY
    skill_count DESC
LIMIT
    5