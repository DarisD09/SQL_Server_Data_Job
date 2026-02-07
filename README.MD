# 📊 Agent Performance Analysis

## Executive Summary
### Purpose
This analysis evaluates operational performance within an outbound call center environment. The objective is to analyze agent effectiveness, contactability, and dialing efficiency in order to identify operational inefficiencies and recommend process improvements that can increase successful customer contacts and conversions without increasing staffing or call volume.

### Key Findings
- A large majority of outbound call attempts do not result in live customer contact, indicating significant dialing inefficiency.
- Call outcomes are highly dependent on time of day, with midday hours producing substantially higher effective contact rates than evening hours.
- Agent performance differences are influenced not only by skill but also by lead distribution and lead quality.
- Some agents classified as underperformers are likely affected by poor quality lead assignments rather than productivity issues.
- Technical call outcomes (e.g., system errors, unreachable numbers, failed routing) materially reduce operational productivity.

### Operational Impact
If implemented, the recommendations from this analysis could:
- Increase effective contacts without increasing call volume
- Improve agent productivity and fairness of performance evaluation
- Reduce wasted dialing effort and operational downtime
- Support better staffing and workforce management decisions
- Improve customer experience by prioritizing higher probability contact windows

---

## Introduction
This project analyzes the performance of customer service and sales agents at **FinServe Contact Center**, focusing on **conversion rates**, **contactability**, and **operational efficiency**.

The objective is to identify high and low performing agents, understand the factors that influence successful conversions, and generate data driven recommendations to improve processes, agent effectiveness, and overall business results.

---

## Key Business Questions Addressed

1. How do agents perform in terms of conversion efficiency?
2. How effective are agents in handling outbound calls?
3. How does contactability vary by call outcome, hour of day, and team (AS vs LT)?
4. What process and staffing recommendations can be made based on agent performance?
5. What additional metrics should be adopted to improve performance measurement, and why?

The data used in this analysis comes from **Conversion Records** and **Call Logs**.

---

## Tools Used
- **SQL (PostgreSQL):** table creation, data ingestion, and analytical queries  
- **Power BI:** development of interactive dashboards  
- **Git & GitHub:** version control and project documentation  

---

## Analysis Overview
Each SQL query in this project is designed to answer a specific business question related to **call center operations and sales performance**.

Below is a detailed explanation of how each analysis contributes to understanding agent efficiency and operational effectiveness.

---

## 1. Agent Performance by Conversion Efficiency

### Top 10 and Bottom 10 Agents by Conversion Rate
The following queries identify the top and bottom 10 agents based on conversion rate. This comparison highlights performance gaps, detects inefficiencies, and helps define targeted improvement actions.

```sql
-- Top 10 agents by conversion efficiency
SELECT 
    agent_name,
    SUM(successful_conversions) AS successful_conversions,
    SUM(unique_clients) AS unique_clients,
    ROUND(
        SUM(successful_conversions)::numeric 
        / NULLIF(SUM(unique_clients), 0), 
        4
    ) AS conversion_rate
FROM conversions
GROUP BY agent_name
HAVING SUM(unique_clients) >= 50
ORDER BY conversion_rate DESC, successful_conversions DESC
LIMIT 10;

-- Bottom 10 agents by conversion efficiency
SELECT 
    agent_name,
    SUM(successful_conversions) AS successful_conversions,
    SUM(unique_clients) AS unique_clients,
    ROUND(
        SUM(successful_conversions)::numeric 
        / NULLIF(SUM(unique_clients), 0), 
        4
    ) AS conversion_rate
FROM conversions
GROUP BY agent_name
HAVING SUM(unique_clients) >= 50
ORDER BY conversion_rate ASC, successful_conversions ASC
LIMIT 10;
```

### Top 10 Agents by Conversion Rate

| Agent Name               | Successful Conversions | Unique Clients | Conversion Rate |
|--------------------------|------------------------|----------------|-----------------|
| CARLOS V. CARO           | 19                     | 78             | 24.36%          |
| CARLOS ESCOBOZA          | 75                     | 393            | 19.08%          |
| MARIA HERNANDEZ          | 21                     | 112            | 18.75%          |
| CARLOS CARVAJAL          | 541                    | 3,056          | 17.70%          |
| KENIA COTA               | 681                    | 3,901          | 17.46%          |
| AARON CRUZ               | 30                     | 189            | 15.87%          |
| ALEX PEREA               | 731                    | 4,827          | 15.14%          |
| MARIA LOZADA             | 12                     | 83             | 14.46%          |
| VALERIA DUARTE           | 19                     | 132            | 14.39%          |
| MIGUEL LOPEZ MELICOFF    | 73                     | 510            | 14.31%          |

---

### Bottom 10 Agents by Conversion Rate

| Agent Name               | Successful Conversions | Unique Clients | Conversion Rate |
|--------------------------|------------------------|----------------|-----------------|
| PERLA GARCIA             | 0                      | 71             | 0.00%           |
| JUAN PINEDA              | 1                      | 54             | 1.85%           |
| RODOLFO CALERI RUIBAL    | 120                    | 4,681          | 2.56%           |
| GINA BERRUETA            | 215                    | 7,664          | 2.81%           |
| FABIAN LOPEZ             | 129                    | 4,348          | 2.97%           |
| JAMES GARCIA             | 91                     | 2,980          | 3.05%           |
| EDWIN MONSALVE           | 53                     | 1,669          | 3.18%           |
| MARIA ZEA                | 35                     | 1,077          | 3.25%           |
| PAULINA HARO             | 270                    | 8,286          | 3.26%           |
| ANGELICA FORERO FORERO   | 465                    | 13,960         | 3.33%           |

### Analysis Insights

- **High-performing agents:** Agents such as Carlos V. Caro (24%), Carlos Escoboza (19%), and María Hernández (18%) convert between 18 and 24 customers out of every 100 contacted, significantly outperforming the average. This reflects strong proficiency in opportunity management and closing techniques.

- **Scalable performance with quality:** Carlos Carvajal (17.7%), Kenia Cota (17.5%), and Alex Perea (15.1%) stand out because, despite handling high volumes of 3,000–4,800 unique clients, they maintain stable conversion rates, achieving 17–18 conversions per 100 clients. This balance between volume and efficiency should serve as a benchmark for other agents.

- **Value leakage risk:** In contrast, agents such as Rodolfo Caleri (2.5%), Gina Berrueta (2.8%), and Angélica Forero (3.3%) manage large portfolios (4,600–13,900 clients) but convert only 2–3 customers per 100 contacted. This indicates that the majority of opportunities are not generating returns.

- **Performance gap implications:** This gap highlights the need to **replicate best practices from top performers**, strengthen coaching and training for lower-performing agents, and evaluate the quality of assigned lead lists to ensure more equitable and effective conditions.

---

## 2. Agent Call Performance

The following query measures call performance by agent, calculating total calls, talk time, response rate, and contact rate.  
Its goal is to identify the **top 20 agents with at least 30 calls**, prioritizing **higher contact rates** and then **call volume**.

### SQL Query

```sql
WITH parsed_calls AS (
  SELECT
    split_part(users, ';', 1) AS primary_agent,
    COALESCE(NULLIF(last_wrap_up, ''), wrap_up) AS call_status,
    duration_ms,
    call_timestamp
  FROM calls
)
SELECT
  primary_agent,
  COUNT(*) AS total_calls,
  SUM(duration_ms) / 60000.0 AS talk_minutes,
  ROUND(
    AVG(
      CASE 
        WHEN lower(call_status) NOT LIKE '%voicemail%' 
         AND lower(call_status) NOT LIKE '%no answer%'
         AND lower(call_status) NOT LIKE '%timeout%'
         AND lower(call_status) NOT LIKE '%system error%'
        THEN 1 ELSE 0 
      END
    )::numeric, 3
  ) AS response_rate,
  ROUND(
    AVG(
      CASE 
        WHEN lower(call_status) LIKE '%customer contacted%'
          OR lower(call_status) LIKE '%resolved%'
          OR lower(call_status) LIKE '%transfer%'
          OR lower(call_status) LIKE '%answered%'
        THEN 1 ELSE 0 
      END
    )::numeric, 3
  ) AS contact_rate
FROM parsed_calls
GROUP BY primary_agent
HAVING COUNT(*) >= 30
ORDER BY contact_rate DESC, total_calls DESC
LIMIT 20;
```
### Agent Call Performance (Top 20)

<div style="max-height:300px; overflow-y:auto;">

| Primary Agent                              | Total Calls | Talk Minutes | Response Rate | Contact Rate |
|-------------------------------------------|-------------|--------------|---------------|--------------|
| LT CM Alexia Vergara Ruiz                  | 189         | 2.83         | 0.947         | 0.873        |
| AS IN Giovan Adolfo Torres Cardenas        | 665         | 13.93        | 0.920         | 0.845        |
| AS IN Carlos Ascanio Dias                  | 568         | 10.54        | 0.942         | 0.843        |
| AS IN Martha Estella Bautista Castillo     | 567         | 9.16         | 0.884         | 0.824        |
| AS IN Yiset Valentina Uribe Ahumada        | 767         | 10.89        | 0.909         | 0.823        |
| AS IN Adrian Camilo Pineda Barrera         | 452         | 9.22         | 0.907         | 0.823        |
| AS IN Laura Hernandez                     | 597         | 9.55         | 0.920         | 0.809        |
| AS IN Diana Narvaez Galan                  | 531         | 9.64         | 0.895         | 0.804        |
| AS IN Lucila Cardenas                     | 673         | 10.84        | 0.915         | 0.801        |
| LT IN Isaac Manning Gracia                 | 614         | 9.34         | 0.914         | 0.796        |
| AS IN Darwuin David Hernandez Sotillo      | 791         | 9.10         | 0.934         | 0.791        |
| AS IN Cristian David Mayorga Mongui        | 576         | 8.37         | 0.918         | 0.788        |
| AS IN Ayelin Vanesa Mercado Fontalvo       | 556         | 8.47         | 0.923         | 0.788        |
| AS IN Johan Pardo Ballen                  | 560         | 7.38         | 0.938         | 0.786        |
| AS IN Jose Manuel Morales Camargo          | 476         | 12.81        | 0.847         | 0.786        |
| LT CM Jafet Ceballos Palomino              | 278         | 6.42         | 0.906         | 0.781        |
| LT CM Elmer Cordova Escarcega              | 193         | 3.35         | 0.886         | 0.777        |
| AS IN Ander Joel Cortes Vivas              | 919         | 14.66        | 0.976         | 0.762        |
| LT IN Pedro Penichet Solorio               | 653         | 14.36        | 0.865         | 0.757        |
| AS Kelly Johanna Torres                   | 40          | 2.08         | 0.800         | 0.750        |

</div>

---

*Differences in contact rate may be driven by **variations in lead list quality, agent experience levels, or campaign differences**. Validating these factors would help determine whether low performance is attributable to the agent or to external conditions.*

---

### Important Observation

**An inconsistency was detected in the talk time metric.**  
For example, **LT CM Alexia Vergara Ruiz** shows 189 calls with only **2.83 total minutes**, which equates to less than one second per call. This suggests that the `duration_ms` field may not accurately capture real conversation time and could be truncated or incorrectly mapped in the database.

This limitation should be considered before making decisions based on talk time metrics.

---
### Analysis Insights

**High response and contact rates**
- Most agents maintain response rates above 90% and contact rates between 80% and 87%, reflecting strong operational efficiency.
- Agents such as **LT CM Alexia Vergara Ruiz** (94.7% response / 87.3% contact) and **AS IN Carlos Ascanio Dias** (94.2% / 84.3%) stand out as examples of balanced volume and effectiveness.

**Call volume vs. talk time**
- Agents like **AS IN Ander Joel Cortes Vivas** (919 calls) and **AS IN Giovan Adolfo Torres Cardenas** (665 calls) handle high volumes with moderate contact rates (76–84%).
- In contrast, agents with fewer calls, such as **LT CM Alexia Vergara Ruiz** (189 calls), maintain strong contact rates, though recorded talk time appears inconsistent and should be validated.

**Improvement opportunities**
- Some agents show contact rates below 78%, suggesting a need to review lead quality or reinforce connection techniques.

**Recommended actions**
- Validate call duration metrics before using them in reporting.
- Replicate best practices from agents with high contact rates and strong volumes.
- Review high-volume, low-contact agents to determine whether issues stem from lead quality, timing, or technique.

Overall, the data reflects a team with **solid average performance**, but also a **clear gap between high-volume, lower-contact agents and those achieving stronger connections with fewer calls**.

---

## 3.0. Contactability by Call Outcome

This query analyzes the distribution of calls based on their final status (e.g., *message played*, *no answer*, *voicemail*, *customer contacted*) in order to identify where the majority of call attempts are concentrated and to measure the true effectiveness of customer contact.

### SQL Query

```sql
-- Contactability by call outcome (Categorized)
WITH normalized_calls AS (
    SELECT 
        CASE
            WHEN lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) IN 
                 ('customer contacted','resolved','answered','transfer') 
                THEN 'Contacted'
            WHEN lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) IN 
                 ('no answer','voicemail','busy','out of service') 
                THEN 'Not Contacted'
            WHEN lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE 'system error%' 
              OR lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE '%skipped%' 
              OR lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE '%throttled%' 
              OR lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) = 'fax' 
                THEN 'Technical Errors'
            ELSE 'Other'
        END AS call_category
    FROM calls
)
SELECT 
    call_category,
    COUNT(*) AS total_calls,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM normalized_calls
GROUP BY call_category
ORDER BY total_calls DESC;
```
_The analysis reveals that nearly **92% of calls do not result in direct customer contact**, while only about **6% correspond to effective interactions**. This highlights a significant gap between call attempts and actual outcomes._

---

### Contactability by Call Outcome (Categorated)

| Category          | Total Calls | Percentage |
|-------------------|-------------|------------|
| Other             | 408,573     | 65.31%     |
| Not Contacted     | 169,638     | 27.11%     |
| Contacted         | 37,704      | 6.03%      |
| Technical Errors  | 9,720       | 1.55%      |

---

## 3.0. Contactability by Call Outcome (Detailed)

The following query provides a detailed breakdown of call outcomes by their final status. This analysis helps identify which specific call states account for the highest volume of attempts and where contact efforts are breaking down.

### SQL Query

```sql
-- Contactability by call outcome (Detailed)
SELECT 
    lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) AS call_status,
    COUNT(*) AS total_calls
FROM calls
GROUP BY 1
ORDER BY total_calls DESC;
```
### Contactability by Call Outcome (Detailed)

<div style="max-height:300px; overflow-y:auto;">

| Call Status | Total Calls |
|------------|-------------|
| message played | 165,740 |
| inin-outbound-no-answer | 99,919 |
| no answer | 86,573 |
| voicemail | 76,490 |
| inin-outbound-disconnect | 50,774 |
| customer contacted | 22,441 |
| inin-outbound-sit-callable | 20,586 |
| inin-outbound-number_could_not_be_dialed | 15,699 |
| resolved | 15,263 |
| call interruption | 14,243 |
| inin-outbound-sit-uncallable | 13,563 |
| inin-outbound-busy | 8,244 |
| system error | 7,975 |
| not resolved - escalated | 6,842 |
| out of service | 6,344 |
| inin-wrap-up-timeout | 3,237 |
| hung-up | 2,963 |
| updates provided | 1,528 |
| inin-outbound-failed-to-reach-agent | 1,178 |
| wrong number | 936 |
| inin-outbound-externally-throttled | 766 |
| reschedule – any agent | 750 |
| answered by a family member | 698 |
| do not call – account approved | 611 |
| do not call – risk close | 236 |
| busy | 231 |
| inin-outbound-zone-blocked-skipped | 225 |
| information provided | 218 |
| inin-outbound-preview-skipped | 217 |
| inin-outbound-no-callable-numbers-skipped | 177 |
| test call | 164 |
| inin-outbound-number-uncallable-skipped | 145 |
| inin-outbound-contact-attempt-limit-skipped | 138 |
| do not call | 131 |
| issue identified | 66 |
| inin-outbound-number-attempt-limit-skipped | 62 |
| inin-outbound-failed-to-reach-flow | 56 |
| inin-outbound-fax | 54 |
| inin-wrap-up-deleted | 43 |
| english speaker | 35 |
| inin-outbound-transferred-to-flow | 21 |
| call dropped / disconnected | 18 |
| inin-outbound-contact-uncallable-skipped | 15 |
| inin-outbound-machine | 14 |
| inin-outbound-campaign-recycle-cancelled-recall | 5 |
| inin-outbound-live-voice | 1 |

</div>

---

### Analysis Insights

1. **High volume of unsuccessful contact attempts**  
   The most frequent call outcomes are **“message played” (165,740)**, **“no answer” (86,573)**, and **“voicemail” (76,490)**. This indicates that a large share of outbound attempts **do not result in direct customer interaction**, limiting overall campaign effectiveness.

2. **Low proportion of effective contacts**  
   Only **22,441 calls labeled as “customer contacted”** and **15,263 as “resolved”** are considered successful interactions. Combined, these account for **less than 15% of total attempts**, highlighting a significant gap between dialing effort and actual engagement.

3. **Technical and operational issues**  
   Outcomes such as **“system error” (7,975)**, **“call interruption” (14,243)**, and **“inin-outbound-failed-to-reach-agent” (1,178)** indicate technical or operational failures. Addressing these issues could meaningfully improve contact rates without increasing call volume.

**Conclusion:**  
Most call attempts fail to produce direct customer contact. To improve effectiveness, it is recommended to **optimize lead quality**, refine **dialing schedules**, and **strengthen technical infrastructure** to reduce errors and increase the rate of effective contacts.

---

## 3.1. Contactability by Hour

This query analyzes call effectiveness by hour of day, identifying when call attempts, responses, and effective contacts are most concentrated in order to optimize the dialing strategy.

### SQL Query

```sql
SELECT 
    EXTRACT(hour FROM date_ts) AS hour,
    COUNT(*) AS total_calls,
    SUM(
        CASE 
            WHEN lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) NOT LIKE '%voicemail%'
             AND lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) NOT LIKE '%no answer%'
             AND lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) NOT LIKE '%timeout%'
             AND lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) NOT LIKE '%system error%'
            THEN 1 ELSE 0 
        END
    ) AS responded_calls,
    SUM(
        CASE 
            WHEN lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE '%customer contacted%'
              OR lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE '%resolved%'
              OR lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE '%transfer%'
              OR lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE '%answered%'
            THEN 1 ELSE 0 
        END
    ) AS contacted_calls
FROM calls
GROUP BY hour
ORDER BY hour;
```
### Call Distribution by Hour

<div style="max-height:300px; overflow-y:auto;">

| Hour | Total Calls | Responded Calls | Contacted Calls |
|------|-------------|-----------------|-----------------|
| 0    | 193         | 192             | 0               |
| 7    | 7           | 7               | 4               |
| 8    | 18,587      | 13,044          | 1,101           |
| 9    | 32,499      | 25,564          | 1,712           |
| 10   | 42,583      | 30,343          | 2,668           |
| 11   | 57,326      | 36,048          | 3,891           |
| 12   | 59,579      | 37,812          | 4,363           |
| 13   | 55,436      | 37,463          | 3,752           |
| 14   | 66,950      | 46,667          | 4,315           |
| 15   | 51,731      | 34,636          | 4,077           |
| 16   | 48,344      | 33,167          | 3,441           |
| 17   | 43,648      | 31,023          | 2,927           |
| 18   | 42,672      | 30,720          | 2,603           |
| 19   | 35,910      | 28,318          | 1,869           |
| 20   | 26,511      | 24,161          | 733             |
| 21   | 21,423      | 20,853          | 106             |
| 22   | 13,290      | 12,778          | 84              |
| 23   | 8,946       | 8,564           | 58              |

</div>

---

_Note:_ **“Responded calls”** include interactions that did not always result in a valid customer contact (e.g., answered without a meaningful conversation). Therefore, the key metric for evaluating true effectiveness is **“Contacted calls.”**

---

### Analysis Insights

This analysis shows the hourly distribution of call activity, distinguishing between total attempts, responded calls, and effective contacts.  
Peak productivity occurs between **10:00 AM and 3:00 PM**, while evening hours show inefficient resource usage.

- **Peak hours (10:00–15:00):** Highest volumes and strongest effectiveness, averaging more than **4,000 effective contacts per hour**.
- **Late afternoon decline:** After **5:00 PM**, call volumes remain high, but effective contacts steadily decrease.
- **Night hours (20:00–23:00):** Over **21,000 call attempts** resulted in only about **250 effective contacts**, indicating very low operational efficiency.

### Conclusion

Efforts should be focused on **core business hours (10:00–15:00)**, while reducing evening and night calling to improve overall efficiency and maximize return on effort.

---
## 3.2. Contactability by Team

This query compares performance between the **AS** and **LT** teams by measuring total calls, response rate, and contact rate to identify which team achieves higher effectiveness in call handling.

### SQL Query

```sql
WITH base AS (
  SELECT
    split_part(users, ' ', 1) AS team,
    COALESCE(NULLIF(last_wrap_up,''), wrap_up) AS call_status
  FROM calls
)
SELECT
  team,
  COUNT(*) AS total_calls,
  ROUND(
    100.0 * AVG(
      CASE 
        WHEN lower(call_status) NOT LIKE '%voicemail%' 
         AND lower(call_status) NOT LIKE '%no answer%'
         AND lower(call_status) NOT LIKE '%timeout%'
         AND lower(call_status) NOT LIKE '%system error%'
        THEN 1 ELSE 0 
      END
    )::numeric, 1
  ) AS response_rate,
  ROUND(
    100.0 * AVG(
      CASE 
        WHEN lower(call_status) LIKE '%customer contacted%'
          OR lower(call_status) LIKE '%resolved%'
          OR lower(call_status) LIKE '%transfer%'
          OR lower(call_status) LIKE '%answered%'
        THEN 1 ELSE 0 
      END
    )::numeric, 1
  ) AS contact_rate,
  ROUND(
    COUNT(*) * AVG(
      CASE 
        WHEN lower(call_status) LIKE '%customer contacted%'
          OR lower(call_status) LIKE '%resolved%'
          OR lower(call_status) LIKE '%transfer%'
          OR lower(call_status) LIKE '%answered%'
        THEN 1 ELSE 0 
      END
    )::numeric
  ) AS effective_contacts
FROM base
WHERE team IN ('AS','LT')
GROUP BY team;
```
### Comparative Results by Team

| Team | Total Calls | Response Rate | Contact Rate | Effective Contacts |
|------|-------------|---------------|--------------|--------------------|
| AS   | 162,448     | 23.4%         | 14.1%        | 22,900             |
| LT   | 76,290      | 44.1%         | 26.7%        | 20,300             |

---

_The analysis shows that although the **AS team** made significantly more calls (162,448), the **LT team** achieved much higher response (44.1%) and contact rates (26.7%) compared to AS (23.4% and 14.1%, respectively)._

---

### Key Observations

#### Call Volume
- The AS team handles a substantially higher call volume (162,448) than LT (76,290).
- This indicates that AS carries a heavier operational workload and execution effort.

#### Response Rate
- The LT team stands out with a **44.1% response rate**, nearly double that of AS (23.4%).
- Nearly half of LT’s call attempts are answered, while AS achieves responses on less than a quarter of attempts.

#### Contact Rate
- LT again outperforms with a **26.7% contact rate**, compared to **14.1% for AS**.
- This means an LT call is almost twice as likely to result in real customer contact.

#### Effective Contacts
- AS generates more effective contacts in absolute numbers (22,900) due to its higher volume.
- However, LT achieves nearly the same number of effective contacts (20,300) with less than half the calls, demonstrating significantly higher relative productivity.

---

### Explanation of Observed Differences

One possible explanation is that **LT receives cleaner lead lists or operates during more effective calling hours**, while AS handles higher volumes during lower-response periods.  
Another possibility is that AS may not be consistently applying the same connection practices or closing scripts used by LT.

---

### Potential Impact

If the **AS team matched the efficiency rates of the LT team** while maintaining its current call volume:

- AS could exceed **43,000 effective contacts**, nearly **doubling current performance**.
- This improvement would **not require additional cost or increased call volume**, only the replication of LT’s best practices (timing, lead quality, dialing techniques).

---

## 4. Strategic Recommendations Based on Agent Performance Analysis

### 1. Process Optimization

#### Improve operational efficiency
- Monitor agents with low contact rates to determine whether issues stem from technique, timing, or lead quality.
- Replicate best practices from agents with the highest contact and conversion rates.
- Design a standardized playbook including scripts, objection handling, and closing techniques.
- Implement role-playing sessions and cross-training led by top performers.

#### Optimize workload distribution
- Avoid overloading agents with high volume but low effectiveness, as this dilutes results.
- Distribute calls more evenly, prioritizing quality over quantity.
- Assign complex cases to agents with higher consistency and experience.

#### Increase management agility
- Review call flows to eliminate redundant steps and bottlenecks.
- Implement quick-reference guides and checklists for repetitive call scenarios.
- Use real-time dashboards to allow supervisors to intervene proactively.

---

### 2. Performance-Based Agent Decisions

#### Top performers (e.g., Juliana Zapata, Paula Sepúlveda)
- Publicly recognize their performance and assign them high-value campaigns.
- Use them as internal mentors to transfer successful practices.

#### Low-performing agents
- Assess whether underperformance is due to training gaps, time management, or lead quality.
- Provide targeted coaching and establish clear improvement plans.
- Track progress weekly to measure improvement.

#### Mid-performing agents (high volume, moderate effectiveness)
- Review assigned lead quality to rule out external factors.
- Reinforce training in first-contact resolution and connection techniques.
- Strengthen this group through cross-training, as they represent the key lever for raising overall standards.

---

### 3. Expected Impact

- Improved customer satisfaction and conversion rates.
- Increased motivation and competitiveness through feedback and recognition.
- Reduced operational inefficiencies and better use of existing resources.
- Growth potential without increasing operational costs.

---

## Conclusion

The analysis reveals a wide range of agent performance: some agents are highly effective, while others require additional support.  
The key lies in **standardizing best practices, optimizing workload distribution, and reinforcing training**, which will help close performance gaps and improve result consistency without increasing costs.

Overall, the data shows clear performance patterns, but it is also likely that **structural factors** (lead quality, campaigns, schedules) contribute to observed gaps.  
Therefore, recommendations should not focus solely on agents, but also on improving operational processes and the quality of data used in campaigns.

---

## 5. Additional Metrics to Consider and Why

### Conversion Rate by Time Slot
- **What it measures:** Percentage of calls that result in conversions by hour of day.
- **Why adopt it:** Identifies the most effective time windows, optimizing resource allocation and assigning top agents to high-value hours.

### First Contact Resolution (FCR)
- **What it measures:** Proportion of customers resolved on the first attempt without follow-up calls.
- **Why adopt it:** Reflects service quality and efficiency. High FCR reduces costs, prevents line saturation, and improves customer satisfaction.

### Relative Agent Efficiency (Conversions / Effective Contacts)
- **What it measures:** True agent performance adjusted for effective contacts, removing volume-driven distortions.
- **Why adopt it:** Differentiates agents with high volume but low effectiveness from those who convert more with fewer contacts.

---

### Additional Recommendation

Metrics such as **Conversion per Contact** and **Average Handle Time (AHT)** are strongly recommended, but current data shows inconsistencies (e.g., more conversions than contacts, incorrect duration tracking).  
These metrics will become extremely valuable once data is properly structured with unique identifiers and accurate duration tracking.

---

### Expected Impact

Adopting these metrics enables a more accurate and fair evaluation of operational performance, strengthens the **customer experience**, reduces costs, and supports strategic decisions related to **resource allocation and agent training**.

---

## Signed By:
*Daris Daniel Abad*