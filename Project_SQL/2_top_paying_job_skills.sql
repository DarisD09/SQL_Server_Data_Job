WITH top_paying_jobs AS (
SELECT
    job_id,
    name AS company_name,
    job_title_short AS job_title,
    salary_year_avg
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_location = 'Anywhere' AND
    job_title LIKE '%Data Analyst%' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT
    10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;

--Results
/*
Core Skills in Demand

SQL (9 mentions) – The most common requirement, highlighting that database querying is the backbone of data analysis.
Python (8 mentions) – Strong demand for programming to handle data manipulation, automation, and analytics.
Tableau (6 mentions) – Visualization is key, with Tableau being the most frequently requested BI tool.

{
    "job_id": 99305,
    "company_name": "Pinterest Job Advertisements",
    "job_title": "Data Analyst",
    "salary_year_avg": "232423.0",
    "skills": "sql"
  },
  {
    "job_id": 99305,
    "company_name": "Pinterest Job Advertisements",
    "job_title": "Data Analyst",
    "salary_year_avg": "232423.0",
    "skills": "python"
  },
  {
    "job_id": 99305,
    "company_name": "Pinterest Job Advertisements",
    "job_title": "Data Analyst",
    "salary_year_avg": "232423.0",
    "skills": "r"
  },
  {
    "job_id": 99305,
    "company_name": "Pinterest Job Advertisements",
    "job_title": "Data Analyst",
    "salary_year_avg": "232423.0",
    "skills": "hadoop"
  },
  {
    "job_id": 99305,
    "company_name": "Pinterest Job Advertisements",
    "job_title": "Data Analyst",
    "salary_year_avg": "232423.0",
    "skills": "tableau"
  },
  {
    "job_id": 1021647,
    "company_name": "Uclahealthcareers",
    "job_title": "Data Analyst",
    "salary_year_avg": "217000.0",
    "skills": "sql"
  },
  {
    "job_id": 1021647,
    "company_name": "Uclahealthcareers",
    "job_title": "Data Analyst",
    "salary_year_avg": "217000.0",
    "skills": "crystal"
  },
  {
    "job_id": 1021647,
    "company_name": "Uclahealthcareers",
    "job_title": "Data Analyst",
    "salary_year_avg": "217000.0",
    "skills": "oracle"
  },
  {
    "job_id": 1021647,
    "company_name": "Uclahealthcareers",
    "job_title": "Data Analyst",
    "salary_year_avg": "217000.0",
    "skills": "tableau"
  },
  {
    "job_id": 1021647,
    "company_name": "Uclahealthcareers",
    "job_title": "Data Analyst",
    "salary_year_avg": "217000.0",
    "skills": "flow"
  },
  {
    "job_id": 168310,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "205000.0",
    "skills": "sql"
  },
  {
    "job_id": 168310,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "205000.0",
    "skills": "python"
  },
  {
    "job_id": 168310,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "205000.0",
    "skills": "go"
  },
  {
    "job_id": 168310,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "205000.0",
    "skills": "snowflake"
  },
  {
    "job_id": 168310,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "205000.0",
    "skills": "pandas"
  },
  {
    "job_id": 168310,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "205000.0",
    "skills": "numpy"
  },
  {
    "job_id": 168310,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "205000.0",
    "skills": "excel"
  },
  {
    "job_id": 168310,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "205000.0",
    "skills": "tableau"
  },
  {
    "job_id": 168310,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "205000.0",
    "skills": "gitlab"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "sql"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "python"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "azure"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "aws"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "oracle"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "snowflake"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "tableau"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "power bi"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "sap"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "jenkins"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "bitbucket"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "atlassian"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "jira"
  },
  {
    "job_id": 731368,
    "company_name": "Inclusively",
    "job_title": "Data Analyst",
    "salary_year_avg": "189309.0",
    "skills": "confluence"
  },
  {
    "job_id": 310660,
    "company_name": "Motional",
    "job_title": "Data Analyst",
    "salary_year_avg": "189000.0",
    "skills": "sql"
  },
  {
    "job_id": 310660,
    "company_name": "Motional",
    "job_title": "Data Analyst",
    "salary_year_avg": "189000.0",
    "skills": "python"
  },
  {
    "job_id": 310660,
    "company_name": "Motional",
    "job_title": "Data Analyst",
    "salary_year_avg": "189000.0",
    "skills": "r"
  },
  {
    "job_id": 310660,
    "company_name": "Motional",
    "job_title": "Data Analyst",
    "salary_year_avg": "189000.0",
    "skills": "git"
  },
  {
    "job_id": 310660,
    "company_name": "Motional",
    "job_title": "Data Analyst",
    "salary_year_avg": "189000.0",
    "skills": "bitbucket"
  },
  {
    "job_id": 310660,
    "company_name": "Motional",
    "job_title": "Data Analyst",
    "salary_year_avg": "189000.0",
    "skills": "atlassian"
  },
  {
    "job_id": 310660,
    "company_name": "Motional",
    "job_title": "Data Analyst",
    "salary_year_avg": "189000.0",
    "skills": "jira"
  },
  {
    "job_id": 310660,
    "company_name": "Motional",
    "job_title": "Data Analyst",
    "salary_year_avg": "189000.0",
    "skills": "confluence"
  },
  {
    "job_id": 1749593,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "186000.0",
    "skills": "sql"
  },
  {
    "job_id": 1749593,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "186000.0",
    "skills": "python"
  },
  {
    "job_id": 1749593,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "186000.0",
    "skills": "go"
  },
  {
    "job_id": 1749593,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "186000.0",
    "skills": "snowflake"
  },
  {
    "job_id": 1749593,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "186000.0",
    "skills": "pandas"
  },
  {
    "job_id": 1749593,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "186000.0",
    "skills": "numpy"
  },
  {
    "job_id": 1749593,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "186000.0",
    "skills": "excel"
  },
  {
    "job_id": 1749593,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "186000.0",
    "skills": "tableau"
  },
  {
    "job_id": 1749593,
    "company_name": "SmartAsset",
    "job_title": "Data Analyst",
    "salary_year_avg": "186000.0",
    "skills": "gitlab"
  },
  {
    "job_id": 1638595,
    "company_name": "Patterned Learning AI",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "185000.0",
    "skills": "sql"
  },
  {
    "job_id": 1638595,
    "company_name": "Patterned Learning AI",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "185000.0",
    "skills": "python"
  },
  {
    "job_id": 1638595,
    "company_name": "Patterned Learning AI",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "185000.0",
    "skills": "html"
  },
  {
    "job_id": 1638595,
    "company_name": "Patterned Learning AI",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "185000.0",
    "skills": "css"
  },
  {
    "job_id": 1638595,
    "company_name": "Patterned Learning AI",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "185000.0",
    "skills": "aws"
  },
  {
    "job_id": 1638595,
    "company_name": "Patterned Learning AI",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "185000.0",
    "skills": "keras"
  },
  {
    "job_id": 1638595,
    "company_name": "Patterned Learning AI",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "185000.0",
    "skills": "angular"
  },
  {
    "job_id": 1638595,
    "company_name": "Patterned Learning AI",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "185000.0",
    "skills": "flask"
  },
  {
    "job_id": 1638595,
    "company_name": "Patterned Learning AI",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "185000.0",
    "skills": "fastapi"
  },
  {
    "job_id": 1638595,
    "company_name": "Patterned Learning AI",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "185000.0",
    "skills": "windows"
  },
  {
    "job_id": 387860,
    "company_name": "Get It Recruit - Information Technology",
    "job_title": "Data Analyst",
    "salary_year_avg": "184000.0",
    "skills": "sql"
  },
  {
    "job_id": 387860,
    "company_name": "Get It Recruit - Information Technology",
    "job_title": "Data Analyst",
    "salary_year_avg": "184000.0",
    "skills": "python"
  },
  {
    "job_id": 387860,
    "company_name": "Get It Recruit - Information Technology",
    "job_title": "Data Analyst",
    "salary_year_avg": "184000.0",
    "skills": "r"
  },
  {
    "job_id": 813346,
    "company_name": "Zoom Video Communications",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "181000.0",
    "skills": "sql"
  },
  {
    "job_id": 813346,
    "company_name": "Zoom Video Communications",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "181000.0",
    "skills": "python"
  },
  {
    "job_id": 813346,
    "company_name": "Zoom Video Communications",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "181000.0",
    "skills": "r"
  },
  {
    "job_id": 813346,
    "company_name": "Zoom Video Communications",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "181000.0",
    "skills": "tableau"
  },
  {
    "job_id": 813346,
    "company_name": "Zoom Video Communications",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "181000.0",
    "skills": "jira"
  },
  {
    "job_id": 813346,
    "company_name": "Zoom Video Communications",
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "181000.0",
    "skills": "zoom"
  }
*/