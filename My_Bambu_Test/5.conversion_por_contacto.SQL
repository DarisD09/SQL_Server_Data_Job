WITH parsed_calls AS (
  SELECT
    split_part(users, ';', 1) AS raw_user,
    lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) AS estado
  FROM llamadas
),
cleaned AS (
  SELECT
    trim(
      regexp_replace(raw_user, '^(AS|LT|WPB)\s+(IN|OUT|MIV)?\s*', '', 'i')
    ) AS agente_nombre,
    estado
  FROM parsed_calls
),
contacted AS (
  SELECT
    upper(agente_nombre) AS agente_nombre,
    COUNT(*) FILTER (
      WHERE estado LIKE '%customer contacted%'
         OR estado LIKE '%resolved%'
         OR estado LIKE '%transfer%'
         OR estado LIKE '%answered%'
    ) AS llamadas_contactadas
  FROM cleaned
  GROUP BY upper(agente_nombre)
),
conv AS (
  SELECT
    upper(nombre_agente) AS agente_nombre,
    SUM(conversiones_exitosas) AS total_conversiones
  FROM conversiones
  GROUP BY upper(nombre_agente)
)
SELECT
  c.agente_nombre,
  ct.llamadas_contactadas,
  c.total_conversiones,
  ROUND(c.total_conversiones::numeric / NULLIF(ct.llamadas_contactadas,0), 4) AS conversion_to_contact_rate
FROM conv c
JOIN contacted ct USING (agente_nombre)
ORDER BY conversion_to_contact_rate DESC;

