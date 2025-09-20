SELECT 
    lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) AS estado,
    COUNT(*) AS total
FROM llamadas
GROUP BY 1
ORDER BY total DESC;
