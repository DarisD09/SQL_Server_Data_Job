-- Los 10 agentes con el rendimiento mas alto en terminos de conversion
SELECT 
    nombre_agente,
    conversiones_exitosas,
    clientes_unicos,
    ROUND(conversiones_exitosas::numeric / NULLIF(clientes_unicos, 0), 4) AS tasa_conversion
FROM conversiones
ORDER BY tasa_conversion DESC, conversiones_exitosas DESC
LIMIT 10

-- Los 10 agentes con el rendimiento mas bajo en terminos de conversion
SELECT 
    nombre_agente,
    conversiones_exitosas,
    clientes_unicos,
    ROUND(conversiones_exitosas::numeric / NULLIF(clientes_unicos, 0), 4) AS tasa_conversion
FROM conversiones
ORDER BY tasa_conversion ASC, conversiones_exitosas ASC
LIMIT 10