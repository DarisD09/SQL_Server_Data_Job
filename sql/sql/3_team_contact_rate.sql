WITH base AS (
  SELECT
    split_part(users, ' ', 1) AS team,
    COALESCE(NULLIF(last_wrap_up,''), wrap_up) AS call_status
  FROM 
    calls
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
FROM 
    base
WHERE 
    team IN ('T1','T2')
GROUP BY 
    team;