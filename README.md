# Introduction
📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

💬 SQL queries? Check them out here: [Project SQL Folder](/Project_SQL/).

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

The Data it's packed with insights on job titles, salaries, locations, and essential skills.

## The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?  
2. What skills are required for these top-paying jobs?  
3. What skills are most in demand for data analysts?  
4. Which skills are associated with higher salaries?  
5. What are the most optimal skills to learn?  


# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.  
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.  
- **Visual Studio Code:** My go-to for database management and executing SQL queries.  
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.  
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market.
Here’s how I approached each question:

### 1. Top Paying Jobds for Data Analysts
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```SQL
SELECT
    job_id,
    name AS company_name,
    job_title_short AS job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date:: DATE
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_location = 'Anywhere' AND
    job_title = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT
    10
```

Here's the breakdown of the top data analyst jobs in 2023:  

- **Wide Salary Range:** Top 10 paying data analyst jobs span from $184,000 to $650,000, indicating significant salary potential in the field.  
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.  
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.  

| Company                              | Average Yearly Salary ($) |
|--------------------------------------|----------------------------|
| Mantys                               | $650,000                  |
| Get It Recruit - Information Technology | $165,000                  |
| Plexus Resource Solutions            | $165,000                  |
| Get It Recruit - Healthcare          | $151,500                  |
| Level                                | $145,000                  |
| CyberCoders                          | $145,000                  |
| Uber                                 | $140,500                  |
| Overmind                             | $138,500                  |
| EPIC Brokers                         | $135,000                  |
| InvestM Technology LLC               | $135,000                  |

*This table shows the salary for the top 10 jobs
for data analysts; ChatGPT generated this table from my
SQL query results*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```SQL
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
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

- **SQL** is leading with a bold count of 9.  
- **Python** follows closely with a bold count of 8.  
- **Tableau** is also highly sought after, with a bold count of 6. Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.  

| Skill      | Count of Skill Appearances |
|------------|-----------------------------|
| SQL        | 9                           |
| Python     | 8                           |
| Tableau    | 6                           |
| R          | 4                           |
| Jira       | 3                           |
| Snowflake  | 3                           |
| Oracle     | 2                           |
| Excel      | 2                           |
| Atlassian  | 2                           |
| Bitbucket  | 2                           |

*This table shows the count of skills for the top 10 paying jobs
for data analysts; ChatGPT generated this table from my
SQL query results*

### 3. In-Demand Skills for Data Analysts 
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```SQL
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
```
Here's the breakdown of the most demanded skills for data analysts in 2023

- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.  
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.  

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```SQL
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT
    25
```
Here's a breakdown of the results for top paying skills for Data Analysts:

- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.  

- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.  

- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.  

| Skills       | Average Salary ($) |
|--------------|---------------------|
| svn          | 400,000.00         |
| solidity     | 179,000.00         |
| couchbase    | 160,515.00         |
| datarobot    | 155,485.50         |
| golang       | 155,000.00         |
| mxnet        | 149,000.00         |
| dplyr        | 147,633.33         |
| vmware       | 147,500.00         |
| terraform    | 146,733.83         |
| twilio       | 138,500.00         |
| gitlab       | 134,126.00         |
| kafka        | 129,999.16         |
| puppet       | 129,820.00         |
| keras        | 127,013.33         |
| pytorch      | 125,226.20         |
| perl         | 124,685.75         |
| ansible      | 124,370.00         |
| hugging face | 123,950.00         |
| tensorflow   | 120,646.83         |
| cassandra    | 118,406.68         |
| notion       | 118,091.67         |
| atlassian    | 117,965.60         |
| bitbucket    | 116,711.75         |
| airflow      | 116,387.26         |
| scala        | 115,479.53         |

*Table of the average salary for the top 10 paying skills for data analysts*

### 5. Most Optimal Skills to Learn
combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic docus for skill development.

```SQL
WITH skills_demand AS(
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id),
        average_salary AS (
        SELECT 
            skills_job_dim.skill_id,
            ROUND(AVG(salary_year_avg), 2) AS avg_salary
        FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
        WHERE
            job_title_short = 'Data Analyst'
            AND salary_year_avg IS NOT NULL
            AND job_work_from_home = TRUE
        GROUP BY
            skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN 
    average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC
```
| Skill ID | Skills      | Demand Count | Average Salary ($) |
|----------|-------------|--------------|---------------------|
| 8        | go          | 27           | 115,319.89         |
| 234      | confluence  | 11           | 114,209.91         |
| 97       | hadoop      | 22           | 113,192.57         |
| 80       | snowflake   | 37           | 112,947.97         |
| 74       | azure       | 34           | 111,225.10         |
| 77       | bigquery    | 13           | 109,653.85         |
| 76       | aws         | 32           | 108,317.30         |
| 4        | java        | 17           | 106,906.44         |
| 194      | ssis        | 12           | 106,683.33         |
| 233      | jira        | 20           | 104,917.90         |
| 79       | oracle      | 37           | 104,533.70         |
| 185      | looker      | 49           | 103,795.30         |
| 2        | nosql       | 13           | 101,413.73         |
| 1        | python      | 236          | 101,397.22         |
| 5        | r           | 148          | 100,498.77         |
| 78       | redshift    | 16           | 99,936.44          |
| 187      | qlik        | 13           | 99,630.81          |
| 182      | tableau     | 230          | 99,287.65          |
| 197      | ssrs        | 14           | 99,171.43          |
| 92       | spark       | 13           | 99,076.92          |
| 13       | c++         | 11           | 98,958.23          |
| 186      | sas         | 63           | 98,902.37          |
| 7        | sas         | 63           | 98,902.37          |
| 61       | sql server  | 35           | 97,785.73          |
| 9        | javascript  | 20           | 97,587.00          |
| 183      | power bi    | 110          | 97,431.30          |
| 0        | sql         | 398          | 97,237.16          |
| 215      | flow        | 28           | 97,200.00          |
| 201      | alteryx     | 17           | 94,144.53          |
| 199      | spss        | 24           | 92,169.68          |
| 198      | outlook     | 13           | 90,077.42          |
| 22       | vba         | 24           | 88,783.29          |
| 196      | powerpoint  | 58           | 88,701.09          |
| 181      | excel       | 256          | 87,288.21          |
| 192      | sheets      | 32           | 86,087.79          |
| 188      | word        | 48           | 82,576.04          |
| 195      | sharepoint  | 18           | 81,633.58          |

*Table of the most optimal skills for data analyst sorted by salary*

Breakdown of the Most Optimal Skills for Data Analysts in 2023

- **High-Demand Programming Languages**:  
  Python and R stand out for their high demand, with demand counts of 236 and 148 respectively.  
  Despite their high demand, their average salaries are around **$101,397 for Python** and **$100,499 for R**,  
  indicating that proficiency in these languages is highly valued but also widely available.  

- **Cloud Tools and Technologies**:  
  Skills in specialized technologies such as **Snowflake, Azure, AWS, and BigQuery** show significant demand  
  with relatively high average salaries, pointing towards the growing importance of cloud platforms  
  and big data technologies in data analysis.  

- **Business Intelligence and Visualization Tools**:  
  **Tableau** and **Looker**, with demand counts of 230 and 49 respectively, and average salaries around  
  **$99,288 and $103,795**, highlight the critical role of data visualization and business intelligence  
  in deriving actionable insights from data.  

- **Database Technologies**:  
  The demand for skills in traditional and NoSQL databases (**Oracle, SQL Server, NoSQL**) with average salaries  
  ranging from **$97,786 to $104,534**, reflects the enduring need for data storage, retrieval, and management expertise.  

# Conclusions
### 🔍 Insights

1. **Top-Paying Data Analyst Jobs**:  
   The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at **$650,000**!  

2. **Skills for Top-Paying Jobs**:  
   High-paying data analyst jobs require advanced proficiency in **SQL**, suggesting it’s a critical skill for earning a top salary.  

3. **Most In-Demand Skills**:  
   **SQL** is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.  

4. **Skills with Higher Salaries**:  
   Specialized skills, such as **SVN** and **Solidity**, are associated with the highest average salaries, indicating a premium on niche expertise.  

5. **Optimal Skills for Job Market Value**:  
   **SQL** leads in demand and offers a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.  

### 💡 Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst job market.  
The findings from the analysis serve as a guide to prioritizing skill development and job search efforts.  

Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills.  
This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.  

