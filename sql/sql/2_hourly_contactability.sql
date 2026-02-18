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
FROM 
    calls
GROUP BY 
    hour
ORDER BY 
    hour;