SELECT 
    EXTRACT(hour FROM date_ts) AS hora,
    COUNT(*) AS total_llamadas,
    SUM(CASE WHEN lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) NOT LIKE '%voicemail%'
                  AND lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) NOT LIKE '%no answer%'
                  AND lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) NOT LIKE '%timeout%'
                  AND lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) NOT LIKE '%system error%'
             THEN 1 ELSE 0 END) AS llamadas_respondidas,
    SUM(CASE WHEN lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE '%customer contacted%'
                  OR lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE '%resolved%'
                  OR lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE '%transfer%'
                  OR lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) LIKE '%answered%'
             THEN 1 ELSE 0 END) AS llamadas_contactadas
FROM llamadas
GROUP BY hora
ORDER BY hora;
