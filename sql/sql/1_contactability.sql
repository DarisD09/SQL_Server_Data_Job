-- Contactability analysis
WITH clean_calls AS (
    SELECT
        LOWER(
            COALESCE(
                NULLIF(TRIM(last_wrap_up), ''),
                TRIM(wrap_up)
            )
        ) AS call_status
    FROM 
        calls
),
categorized_calls AS (
    SELECT
        CASE
            WHEN call_status IN ( 'customer contacted','resolved','answered','transfer' )
                THEN 'Contacted'
            WHEN call_status IN ( 'no answer','voicemail','busy','out of service' )
                THEN 'Not Contacted'
            WHEN call_status LIKE 'system error%'
              OR call_status LIKE '%skipped%'
              OR call_status LIKE '%throttled%'
              OR call_status = 'fax'
                THEN 'Technical Errors'
            ELSE 'Other'
        END AS call_category
    FROM clean_calls
)
SELECT
    call_category,
    COUNT(*) AS total_calls,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM 
    categorized_calls
GROUP BY 
    call_category
ORDER BY 
    total_calls DESC;
