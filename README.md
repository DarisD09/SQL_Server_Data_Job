# 📊 Análisis de Rendimiento de Agentes – MyBambu

## Introducción
Este proyecto explora el desempeño de agentes de servicio al cliente de **MyBambu**, enfocándose en métricas de **conversión**, **contactabilidad** y **eficiencia operativa**.  

La meta es identificar agentes con alto y bajo rendimiento, entender los factores que influyen en las conversiones y generar recomendaciones estratégicas para mejorar procesos y resultados.

## Las preguntas que quería responder a través de este análisis fueron: 

1. Analisis del rendimiento en los agentes por eficiencia en conversiones
2. Analisis de rendimiento de los agentes en las llamadas
3. Analisis de contactabilidad por estado, horas y equipos de trabajo. (AS y LT)
4. Recomendaciones para optimizar el proceso y decisión sobre los agentes segun su rendimiento.
5. Qué otras métricas sugeriria, adoptar y por qué.


Los datos provienen de registros de **Conversiones** y **Llamadas**.

##Herramientas Utilizadas
- **SQL (PostgreSQL):** creación de tablas, carga de datos y consultas de análisis.  
- **Power BI:** construcción de dashboards interactivos.  
- **Git & GitHub:** control de versiones y documentación.  
---
## El Análisis
Cada **SQL Query** de este proyecto está diseñada para responder a un aspecto clave del negocio en el área de **atención al cliente y ventas** de MyBambu. 

A continuación se detalla cómo cada una aporta al entendimiento del desempeño de los agentes y la operación:

## 1. Rendimiento de agentes por eficiencia en conversiones

###  Top 10 y Bottom 10 agentes en términos de conversión
Con los siguientes queries podremos identificar a los 10 agentes con mejor y peor desempeño en términos de tasa de conversión, con el fin de comparar resultados, detectar brechas de rendimiento y definir acciones de mejora.
```SQL
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
```

### Top 10 Agentes por Tasa de Conversión
| Nombre Agente      | Conversiones Exitosas | Clientes Únicos | Tasa de Conversión |
|---------------------|-----------------------|-----------------|---------------------|
| MARIA BALLESTEROS  | 3                     | 11              | 0.2727              |
| CARLOS V. CARO     | 19                    | 78              | 0.2436              |
| <span style="color:#228B22; font-weight:bold">CARLOS ESCOBOZA</span> | <span style="color:#228B22; font-weight:bold">75</span>  | <span style="color:#228B22; font-weight:bold">393</span>  | <span style="color:#228B22; font-weight:bold">0.1908</span> |
| MARIA HERNANDEZ    | 21                    | 112             | 0.1875              |
| MANUEL HUERTA      | 2                     | 11              | 0.1818              |
| <span style="color:#228B22; font-weight:bold">CARLOS CARVAJAL</span> | <span style="color:#228B22; font-weight:bold">541</span> | <span style="color:#228B22; font-weight:bold">3056</span> | <span style="color:#228B22; font-weight:bold">0.1770</span> |
| <span style="color:#228B22; font-weight:bold">KENIA COTA</span> | <span style="color:#228B22; font-weight:bold">681</span> | <span style="color:#228B22; font-weight:bold">3901</span> | <span style="color:#228B22; font-weight:bold">0.1746</span> |
| HANNIA ACOSTA      | 3                     | 18              | 0.1667              |
| AARON CRUZ         | 30                    | 189             | 0.1587              |
| PALOMA GOMEZ       | 5                     | 32              | 0.1563              |

---

### Bottom 10 Agentes por Tasa de Conversión (Orden Descendente)
| Nombre Agente              | Conversiones Exitosas | Clientes Únicos | Tasa de Conversión |
|-----------------------------|-----------------------|-----------------|---------------------|
| <span style="color:#B22222; font-weight:bold">GINA BERRUETA</span>           | <span style="color:#B22222; font-weight:bold">215</span>  | <span style="color:#B22222; font-weight:bold">7664</span>  | <span style="color:#B22222; font-weight:bold">0.0281</span> |
| <span style="color:#B22222; font-weight:bold">RODOLFO CALERI RUIBAL</span>   | <span style="color:#B22222; font-weight:bold">120</span>  | <span style="color:#B22222; font-weight:bold">4681</span>  | <span style="color:#B22222; font-weight:bold">0.0256</span> |
| JUAN PINEDA                | 1                     | 54              | 0.0185              |
| <span style="color:#B22222; font-weight:bold">PERLA GARCIA</span>            | <span style="color:#B22222; font-weight:bold">0</span>    | <span style="color:#B22222; font-weight:bold">71</span>    | <span style="color:#B22222; font-weight:bold">0.0000</span> |
| AYELIN MERCADO FONTALVO    | 0                     | 14              | 0.0000              |
| MIGUEL PALACINO            | 0                     | 3               | 0.0000              |
| SHARIFT PELAEZ RUIZ        | 0                     | 18              | 0.0000              |
| DIGNA SERRANO              | 0                     | 1               | 0.0000              |
| DAHYANA BURITICA           | 0                     | 32              | 0.0000              |
| MARVIN CONTRERAS           | 0                     | 1               | 0.0000              |

---
*Este análisis muestra los **10 agentes con mejor rendimiento** y los **10 con menor rendimiento** en términos de tasa de conversión, calculada a partir de conversiones exitosas sobre clientes únicos.*  

### Insight del análisis
- En el **Top 10**, destacan **Carlos Escoboza, Carlos Carvajal y Kenia Cota**, con tasas cercanas al **18–19%**, lo que significa que convierten entre **17 y 19 clientes por cada 100 atendidos**. Esto refleja una gestión eficiente y un dominio claro de técnicas de conversión.  

- En contraste, en el **Bottom 10**, agentes como **Rodolfo Caleri Ruibal, Gina Berrueta y Perla García** muestran tasas de conversión de apenas **0% a 2.8%**, lo que equivale a convertir de **0 a 3 clientes por cada 100 atendidos**, marcando una diferencia notable frente a los mejores.  

- Esta brecha evidencia la necesidad de **replicar las buenas prácticas de los top performers**, fortalecer la capacitación en los agentes con bajo desempeño y evaluar la calidad de las listas de clientes asignadas para asegurar condiciones más equitativas.  

## 2. Rendimiento de los agentes en las llamadas
El siguiente query mide el desempeño de las llamadas por agente, calculando total de llamadas, minutos hablados, tasa de respuesta y tasa de contacto. Su fin es mostrar a los 20 agentes con más de 30 llamadas, priorizando la mayor tasa de contacto y luego el volumen de llamadas.

```SQL
WITH parsed AS (
  SELECT
    split_part(users, ';', 1) AS agente_principal,
    COALESCE(NULLIF(last_wrap_up, ''), wrap_up) AS estado,
    duration_ms,
    date_ts
  FROM llamadas
)
SELECT
  agente_principal,
  COUNT(*) AS total_llamadas,
  SUM(duration_ms)/60000.0 AS minutos_hablados,
  ROUND(AVG(CASE WHEN lower(estado) NOT LIKE '%voicemail%' 
                     AND lower(estado) NOT LIKE '%no answer%'
                     AND lower(estado) NOT LIKE '%timeout%'
                     AND lower(estado) NOT LIKE '%system error%'
                 THEN 1 ELSE 0 END)::numeric, 3) AS tasa_respuesta,
  ROUND(AVG(CASE WHEN lower(estado) LIKE '%customer contacted%'
                     OR lower(estado) LIKE '%resolved%'
                     OR lower(estado) LIKE '%transfer%'
                     OR lower(estado) LIKE '%answered%'
                 THEN 1 ELSE 0 END)::numeric, 3) AS tasa_contacto
FROM parsed
GROUP BY agente_principal
HAVING COUNT(*) >= 30
ORDER BY tasa_contacto DESC, total_llamadas DESC
LIMIT 20;
```
### Rendimiento de los Agentes por Llamada (Top 20)

<div style="max-height:300px; overflow-y:auto;">

| Agente Principal                                | Total Llamadas | Minutos Hablados | Tasa Respuesta | Tasa Contacto |
|-------------------------------------------------|----------------|------------------|----------------|---------------|
| LT CM Alexia Vergara Ruiz                       | 189            | 2.83             | 0.947          | 0.873         |
| AS IN Giovan Adolfo Torres Cardenas             | 665            | 13.93            | 0.920          | 0.845         |
| AS IN Carlos Ascanio Dias                       | 568            | 10.54            | 0.942          | 0.843         |
| AS IN Martha Estella Bautista Castillo          | 567            | 9.16             | 0.884          | 0.824         |
| AS IN Yiset Valentina Uribe Ahumada             | 767            | 10.89            | 0.909          | 0.823         |
| AS IN Adrian Camilo Pineda Barrera              | 452            | 9.22             | 0.907          | 0.823         |
| AS IN Laura Hernandez                           | 597            | 9.55             | 0.920          | 0.809         |
| AS IN Diana Narvaez Galan                       | 531            | 9.64             | 0.895          | 0.804         |
| AS IN Lucila Cardenas                           | 673            | 10.84            | 0.915          | 0.801         |
| LT IN Isaac Manning Gracia                      | 614            | 9.34             | 0.914          | 0.796         |
| AS IN Darwuin David Hernandez Sotillo           | 791            | 9.10             | 0.934          | 0.791         |
| AS IN Cristian David Mayorga Mongui             | 576            | 8.37             | 0.918          | 0.788         |
| AS IN Ayelin Vanesa Mercado Fontalvo            | 556            | 8.47             | 0.923          | 0.788         |
| AS IN Johan Pardo Ballen                        | 560            | 7.38             | 0.938          | 0.786         |
| AS IN Jose Manuel Morales Camargo               | 476            | 12.81            | 0.847          | 0.786         |
| LT CM Jafet Ceballos Palomino                   | 278            | 6.42             | 0.906          | 0.781         |
| LT CM Elmer Cordova Escarcega                   | 193            | 3.35             | 0.886          | 0.777         |
| AS IN Ander Joel Cortes Vivas                   | 919            | 14.66            | 0.976          | 0.762         |
| LT IN Pedro Penichet Solorio                    | 653            | 14.36            | 0.865          | 0.757         |
| AS Kelly Johanna Torres                         | 40             | 2.08             | 0.800          | 0.750         |

</div>

---

*Este análisis muestra el desempeño de los **20 agentes con mayor número de llamadas**, evaluando sus tasas de respuesta, contacto, volumen de llamadas y minutos hablados.*

### Insight del análisis

1. **Altas tasas de respuesta y contacto**  
   - La mayoría de los agentes mantienen tasas de **respuesta superiores al 90%** y de **contacto entre 80% y 87%**, lo que refleja una buena eficiencia operativa.  
   - Destacan **LT CM Alexia Vergara Ruiz (94.7% respuesta / 87.3% contacto)** y **AS IN Carlos Ascanio Dias (94.2% / 84.3%)** como ejemplos de balance entre volumen de llamadas y efectividad.

2. **Volumen de llamadas vs. tiempo hablado**  
   - Agentes como **AS IN Ander Joel Cortes Vivas (919 llamadas, 14.66 horas)** y **AS IN Giovan Adolfo Torres Cardenas (665 llamadas, 13.92 horas)** muestran **altos volúmenes y minutos hablados**, pero con tasas de contacto ligeramente más bajas (76–84%).  
   - En contraste, agentes con menos llamadas como **LT CM Alexia Vergara Ruiz (189 llamadas, 2.83 horas)** mantienen una tasa de contacto más sólida (87.3%), lo que puede sugerir mayor efectividad por interacción.

3. **Oportunidades de mejora**  
   - Algunos agentes presentan **tasas de contacto por debajo del 78%**, como **Pedro Penichet Solorio (75.7%)** y **Kelly Johanna Torres (75%)**. Esto indica áreas donde se podría mejorar la calidad de los leads asignados o fortalecer la capacitación en técnicas de conexión.  
   - Se recomienda un análisis de **calidad de datos (listas de clientes)** y **revisión de guiones de llamada** para aumentar la efectividad en los agentes con menor rendimiento.

En general, los datos reflejan un equipo con **buen desempeño promedio**, aunque existe una **brecha clara entre agentes con más volumen pero menor contacto** y aquellos con menos llamadas pero más efectivos en la conexión.


## 3.0. Contactabilidad por estado

Este query busca analizar la distribución de llamadas según su estado final (ej. message played, no answer, voicemail, customer contacted), con el fin de identificar en qué categorías se concentran más intentos y así medir la efectividad real del contacto.

```SQL
SELECT 
    lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) AS estado,
    COUNT(*) AS total
FROM llamadas
GROUP BY 1
ORDER BY total DESC;
```

### Contactabilidad por Estado

<div style="max-height:300px; overflow-y:auto;">

| Estado                                           | Total   |
|--------------------------------------------------|---------|
| message played                                   | 165,740 |
| inin-outbound-no-answer                          | 99,919  |
| no answer                                        | 86,573  |
| voicemail                                        | 76,490  |
| inin-outbound-disconnect                         | 50,774  |
| customer contacted                               | 22,441  |
| inin-outbound-sit-callable                       | 20,586  |
| inin-outbound-number_could_not_be_dialed         | 15,699  |
| resolved                                         | 15,263  |
| call interruption                                | 14,243  |
| inin-outbound-sit-uncallable                     | 13,563  |
| inin-outbound-busy                               | 8,244   |
| system error                                     | 7,975   |
| not resolved - escalated                         | 6,842   |
| out of service                                   | 6,344   |
| inin-wrap-up-timeout                             | 3,237   |
| hung- up                                         | 2,963   |
| updates provided                                 | 1,528   |
| inin-outbound-failed-to-reach-agent              | 1,178   |
| wrong number                                     | 936     |
| inin-outbound-externally-throttled               | 766     |
| reschedule – any agent                           | 750     |
| answered by a family member                      | 698     |
| do not call – account approved                   | 611     |
| do not call – risk close                         | 236     |
| busy                                             | 231     |
| inin-outbound-zone-blocked-skipped               | 225     |
| information provided                             | 218     |
| inin-outbound-preview-skipped                    | 217     |
| inin-outbound-no-callable-numbers-skipped        | 177     |
| test call                                        | 164     |
| inin-outbound-number-uncallable-skipped          | 145     |
| inin-outbound-contact-attempt-limit-skipped      | 138     |
| do not call                                      | 131     |
| issue identified                                 | 66      |
| inin-outbound-number-attempt-limit-skipped       | 62      |
| inin-outbound-failed-to-reach-flow               | 56      |
| inin-outbound-fax                                | 54      |
| inin-wrap-up-deleted                             | 43      |
| english speaker                                  | 35      |
| inin-outbound-transferred-to-flow                | 21      |
| call dropped / disconnected                      | 18      |
| inin-outbound-contact-uncallable-skipped         | 15      |
| inin-outbound-machine                            | 14      |
| inin-outbound-campaign-recycle-cancelled-recall  | 5       |
| inin-outbound-live-voice                         | 1       |

</div>

---
*Este análisis muestra la contactabilidad de las llamadas por estado, evaluando los intentos exitosos frente a aquellos que no generaron interacción, así como las incidencias técnicas que afectan la efectividad general del proceso.*

### Insight del análisis

1. **Altos volúmenes en intentos sin contacto**  
   - Los estados más frecuentes son **“message played” (165,740)**, **“no answer” (86,573)** y **“voicemail” (76,490)**. Esto indica que una gran parte de los intentos de contacto **no culminan en interacción directa con el cliente**, lo cual limita la efectividad global de la campaña.  

2. **Contactos efectivos bajos en comparación**  
   - Solo **22,441 casos como “customer contacted”** y **15,263 como “resolved”** se registran como interacciones exitosas. Esto representa menos del **15% del total** frente a estados fallidos o intermedios, lo que muestra una **brecha significativa entre intentos y conversiones reales**.  

3. **Problemas técnicos y operativos**  
   - Estados como **“system error” (7,975)**, **“call interruption” (14,243)** y **“inin-outbound-failed-to-reach-agent” (1,178)** reflejan incidencias técnicas que afectan la eficiencia. Reducir estos fallos podría incrementar la contactabilidad sin necesidad de aumentar el volumen de llamadas.  

**Conclusión:** La mayor parte de los intentos no logran contacto directo con clientes. Se recomienda **optimizar las bases de datos**, mejorar los **horarios de marcación**, y **reforzar la infraestructura técnica** para disminuir errores y elevar la tasa de contactos efectivos.  


## 3.1. Contactabilidad por Hora
Este query busca analizar la efectividad de las llamadas según la hora del día, identificando en qué franjas horarias se concentran más intentos, respuestas y contactos efectivos para optimizar la estrategia de marcación.

```SQL
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
```
---

### Distribución de Llamadas por Hora

<div style="max-height:300px; overflow-y:auto;">

| Hora | Total Llamadas | Llamadas Respondidas | Llamadas Contactadas |
|------|----------------|-----------------------|-----------------------|
| 0    | 193            | 192                   | 0                     |
| 7    | 7              | 7                     | 4                     |
| 8    | 18,587         | 13,044                | 1,481                 |
| 9    | 32,499         | 25,564                | 2,224                 |
| 10   | 42,583         | 30,343                | 3,306                 |
| 11   | 57,326         | 36,048                | 4,685                 |
| 12   | 59,579         | 37,812                | 5,222                 |
| 13   | 55,436         | 37,463                | 4,511                 |
| 14   | 66,950         | 46,667                | 5,061                 |
| 15   | 51,731         | 34,636                | 4,800                 |
| 16   | 48,344         | 33,167                | 4,048                 |
| 17   | 43,648         | 31,023                | 3,501                 |
| 18   | 42,672         | 30,720                | 3,029                 |
| 19   | 35,910         | 28,318                | 2,228                 |
| 20   | 26,511         | 24,161                | 904                   |
| 21   | 21,423         | 20,853                | 112                   |
| 22   | 13,290         | 12,778                | 86                    |
| 23   | 8,946          | 8,564                 | 63                    |

</div>

---
*El análisis revela que la mayor concentración de llamadas y contactos efectivos ocurre entre las 10:00 y las 15:00 horas, siendo estas las franjas más productivas. En cambio, durante la noche la efectividad disminuye, con menos contactos logrados a pesar de que aún se realizan intentos de llamada.*

### Insights del Análisis de Llamadas por Hora

1. **Mayor productividad en la mañana y primeras horas de la tarde**  
   - Los picos de llamadas y contactos efectivos se concentran entre **10:00 y 15:00 horas**, donde no solo se realizan más intentos, sino que también se logra una mayor tasa de contacto.  
   - Este rango horario debe considerarse como la **franja óptima de operación** para maximizar la efectividad.

2. **Descenso progresivo en la tarde-noche**  
   - A partir de las **17:00 horas**, aunque sigue habiendo un volumen alto de llamadas, el número de contactos efectivos comienza a caer de manera sostenida.  
   - Entre **20:00 y 23:00**, la productividad es mínima: se realizan intentos, pero con muy pocos resultados en términos de contactos.

3. **Oportunidades de optimización**  
   - Reorientar recursos hacia las horas más productivas podría mejorar la tasa de éxito global.  
   - Reducir llamadas en horarios nocturnos ayudaría a optimizar tiempo y costos, ya que la **efectividad es muy baja en esas franjas**.

**Conclusión:** El análisis muestra que las **horas laborales centrales (10:00–15:00)** son las más estratégicas para maximizar contactos, mientras que las horas nocturnas aportan poco valor operativo.


### 3.2. Contactabilidad por Equipo
---
Este query busca comparar el desempeño entre los equipos AS y LT, midiendo el total de llamadas, la tasa de respuesta y la tasa de contacto, para identificar cuál equipo logra mayor efectividad en la gestión de llamadas.

```SQL
WITH base AS (
  SELECT
    split_part(users, ' ', 1) AS equipo,
    COALESCE(NULLIF(last_wrap_up,''), wrap_up) AS estado
  FROM llamadas
)
SELECT
  equipo,
  COUNT(*) AS total_llamadas,
  ROUND(AVG(CASE WHEN lower(estado) NOT LIKE '%voicemail%' 
                     AND lower(estado) NOT LIKE '%no answer%'
                     AND lower(estado) NOT LIKE '%timeout%'
                     AND lower(estado) NOT LIKE '%system error%'
                 THEN 1 ELSE 0 END)::numeric, 3) AS tasa_respuesta,
  ROUND(AVG(CASE WHEN lower(estado) LIKE '%customer contacted%'
                     OR lower(estado) LIKE '%resolved%'
                     OR lower(estado) LIKE '%transfer%'
                     OR lower(estado) LIKE '%answered%'
                 THEN 1 ELSE 0 END)::numeric, 3) AS tasa_contacto
FROM base
WHERE equipo IN ('AS','LT')
GROUP BY equipo;
```
---

### Resultados Comparativos por Equipo

| Equipo | Total Llamadas | Tasa de Respuesta | Tasa de Contacto |
|--------|----------------|-------------------|------------------|
| AS     | 162,448        | 23.4%             | 14.1%            |
| LT     | 76,290         | 44.1%             | 26.7%            |
---
*El análisis muestra que, aunque el equipo AS realizó más llamadas (162,448), el equipo LT obtuvo una tasa de respuesta (44.1%) y contacto (26.7%) mucho más alta que la del equipo AS (23.4% y 14.1% respectivamente).*

- **Total de llamadas** (columna gris):  
  - El equipo **AS** tiene un volumen mucho mayor de llamadas (**162,448**) comparado con el equipo **LT** (**76,290**).  
  - Esto refleja que AS maneja más carga operativa.  

- **Tasa de respuesta** (columna azul):  
  - El equipo **LT** presenta una tasa de respuesta mucho más alta (**44.1%**) frente al equipo **AS** (**23.4%**).  
  - Esto significa que LT logra atender exitosamente casi la mitad de las llamadas, mientras que AS no alcanza ni una cuarta parte.  

- **Tasa de contacto** (columna verde):  
  - Nuevamente, **LT** supera con un **26.7%** de efectividad, mientras que **AS** se queda en **14.1%**.  
  - Es decir, LT convierte más llamadas en interacciones reales con clientes. 

 **En palabras simples:**  El equipo **AS ya trabaja con un gran esfuerzo**, realizando más de **162 mil llamadas**, pero gran parte de ese esfuerzo no se traduce en contactos efectivos.  
En cambio, el equipo **LT, con la mitad de llamadas**, logra casi los mismos resultados gracias a una **tasa de respuesta y contacto mucho más alta**.  

**La oportunidad está en replicar las prácticas de LT dentro de AS**:  
- Si AS mantuviera su volumen pero alcanzara las tasas de respuesta de LT, **podría casi duplicar sus contactos efectivos (+20 mil adicionales)**.  
- Esto no implica trabajar más, sino **trabajar de forma más inteligente**, ajustando horarios, calidad de bases de datos y estrategias de marcación.  

En conclusión: **AS ya demuestra capacidad de ejecución, pero necesita la eficiencia de LT. Si unimos esfuerzo con efectividad, el potencial de crecimiento es enorme sin necesidad de aumentar el costo operativo.**

## 4. Métricas adicionales sugeridas
### A) Conversion por contacto
Esto ayudara a identificar la efectividad de los agentes en términos de tasa de conversión sobre llamadas contactadas, para evaluar qué tan eficientes son convirtiendo contactos en resultados.

```SQL
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
```
---

### Tabla de Conversion por Contacto

<div style="max-height:300px; overflow-y:auto;">

| Agente                     | Llamadas Contactadas | Conversiones | Conversion/Contact Rate |
|-----------------------------|----------------------|--------------|-------------------------|
| HOLMAN LUGO GUAYARA         | 41                   | 361          | 8.8049                  |
| RAFAEL GARCIA GOMEZ         | 240                  | 639          | 2.6625                  |
| BARBARA RUIBAL              | 286                  | 696          | 2.4336                  |
| MADELENNE PEREZ             | 351                  | 752          | 2.1425                  |
| DIANA VANEGAS               | 391                  | 700          | 1.7903                  |
| MAGALI SALCEDO PEREZ        | 366                  | 650          | 1.7760                  |
| LUCY CARDOZO RAMIREZ        | 360                  | 634          | 1.7611                  |
| LUISA MEDINA                | 283                  | 495          | 1.7491                  |
| ANGELICA FORERO FORERO      | 286                  | 465          | 1.6259                  |
| ANA PEREZ                   | 323                  | 499          | 1.5449                  |
| MIRANDA PIRAVAGUEN          | 353                  | 511          | 1.4476                  |
| OSCAR CASTRO SALAMANCA      | 331                  | 463          | 1.3988                  |
| BELSISMAR SILVA CELIS       | 534                  | 706          | 1.3221                  |
| LUIS LAVACUDE RIVERA        | 449                  | 568          | 1.2650                  |
| IRENE RAMIREZ CAICEDO       | 402                  | 501          | 1.2463                  |
| HELLEN CARDENAS             | 288                  | 242          | 0.8403                  |
| SANDRA MAGALLANES VALDES    | 240                  | 120          | 0.5000                  |
| ADRIAN BARRAZA              | 371                  | 110          | 0.2965                  |
| MIGUEL LOPEZ MELICOFF       | 282                  | 73           | 0.2589                  |
| SHARIFT PELAEZ RUIZ         | 550                  | 0            | 0.0000                  |

</div>

*El análisis muestra una amplia variabilidad en el desempeño: algunos agentes alcanzan tasas de conversión muy altas, mientras que otros presentan resultados bajos o nulos, evidenciando la necesidad de acciones de mejora y estandarización.*

### Insight de análisis
Al profundizar en los datos:

- **Top performer absoluto**:  
  Holman Lugo Guayara convierte casi **9 contactos de cada 100**, lo que indica que domina el proceso de conversión y probablemente sigue mejores prácticas de discurso, timing o segmentación. Este agente puede ser un **modelo de referencia** para entrenar a los demás.  

- **Grupo promedio**:  
  La mayoría de los agentes (como Rafael García, Bárbara Ruibal, Madelenne Pérez, Diana Vanegas) convierten entre **1.4% y 2.6%**, lo que indica un desempeño consistente pero con **oportunidad de mejora**. La eficiencia aquí parece estar ligada a volumen más que a calidad.  

- **Bajo desempeño**:  
  Agentes como Hellen Cárdenas, Sandra Magallanes, Adrián Barraza y Miguel López tienen tasas de conversión menores a **1%**, lo que representa **pérdida de recursos** porque hacen llamadas pero logran pocos resultados.  

- **Caso crítico**:  
  Sharift Pelaez Ruiz, con **0% en 550 llamadas**, requiere **revisión inmediata**: puede tratarse de problemas de capacitación, falta de enfoque, errores en los leads asignados o una posible desconexión con el rol.  

---

**Conclusión**  
El desempeño muestra que el equipo tiene **islas de excelencia** (Holman) y un núcleo con desempeño aceptable, pero también **focos de bajo rendimiento** que reducen la eficiencia global.

**Recomendaciones:**
- Usar a los agentes con mayor tasa de conversión como **benchmark para entrenamientos y roleplays**.  
- Identificar si los agentes de bajo desempeño necesitan **coaching, cambio de scripts o depuración de bases de datos**.  
- Considerar **revisión de leads y segmentación**, ya que un 0% sobre 550 llamadas también puede reflejar problemas en la calidad de contactos asignados, no solo del agente.  
---
### B) Average Handle Time (AHT)
Este query busca calcular el Average Handle Time (AHT) por agente, es decir, cuánto tiempo en promedio dedica cada uno a manejar llamadas efectivas, excluyendo estados no atendidos como voicemail, no answer o errores del sistema.

```SQL
WITH parsed AS (
  SELECT
    split_part(users, ';', 1) AS agente_principal,
    duration_ms,
    lower(COALESCE(NULLIF(last_wrap_up,''), wrap_up)) AS estado
  FROM llamadas
),
flagged AS (
  SELECT
    agente_principal,
    duration_ms,
    CASE 
      WHEN estado NOT LIKE '%voicemail%'
       AND estado NOT LIKE '%no answer%'
       AND estado NOT LIKE '%timeout%'
       AND estado NOT LIKE '%system error%'
       AND estado NOT LIKE '%out of service%'
      THEN 1 ELSE 0 
    END AS answered_flag
  FROM parsed
)
SELECT
  agente_principal,
  COUNT(*) FILTER (WHERE answered_flag=1) AS answered_calls,
  ROUND(SUM(duration_ms)/60000.0,2) AS total_tiempo_min,
  ROUND(
    (SUM(duration_ms)/60000.0) / NULLIF(COUNT(*) FILTER (WHERE answered_flag=1),0)
  ,2) AS AHT_minutos
FROM flagged
GROUP BY agente_principal
HAVING COUNT(*) >= 30
ORDER BY AHT_minutos DESC;
```
---

<div style="max-height:500px; overflow-y:auto;">

| Agente Principal                                | Answered Calls | Total Tiempo (min) | AHT (min) |
|-------------------------------------------------|----------------|---------------------|-----------|
| LT Sergio Osvaldo Acosta Bustamante             | 9              | 10.85               | 1.21      |
| AS OUT Angelica Forero Forero                   | 574            | 592.77              | 1.03      |
| AS OUT Carlos Arturo Hernandez                  | 452            | 422.68              | 0.94      |
| AS OUT Kerly Torres Gamez                       | 610            | 437.69              | 0.72      |
| AS OUT Hellen Cardenas                          | 580            | 411.92              | 0.71      |
| AS OUT Ana Perez                                | 553            | 375.78              | 0.68      |
| AS OUT Juan Carlos Fandino Suarez               | 373            | 244.33              | 0.66      |
| AS OUT Sorandi Dayana Gonzalez Tovar            | 498            | 326.15              | 0.65      |
| AS OUT Luz Adriana Vargas                       | 504            | 313.80              | 0.62      |
| AS OUT Karen Villero Parra                      | 643            | 390.30              | 0.61      |
| AS OUT Madelenne Perez                          | 774            | 455.73              | 0.59      |
| AS MIV Daniel Rodriguez                         | 321            | 182.61              | 0.57      |
| AS OUT Rafael Garcia Gomez                      | 603            | 343.60              | 0.57      |
| AS OUT Heider Fabian Chavarria Grajales         | 596            | 290.52              | 0.49      |
| AS OUT Oscar Castro Salamanca                   | 666            | 318.28              | 0.48      |
| AS OUT Lucy Cardozo Ramirez                     | 717            | 337.42              | 0.47      |
| AS OUT Luis Lavacude Rivera                     | 684            | 321.23              | 0.47      |
| AS OUT Diana Vanegas                            | 751            | 349.52              | 0.47      |
| AS OUT Magali Salcedo Perez                     | 725            | 334.87              | 0.46      |
| AS OUT Barbara Ruibal                           | 779            | 352.13              | 0.45      |
| AS OUT Luisa Medina                             | 642            | 289.63              | 0.45      |
| AS OUT Miranda Piravagüen                      | 747            | 322.36              | 0.43      |
| AS OUT Giovan Adolfo Torres Cardenas            | 604            | 258.55              | 0.43      |
| AS OUT Johan Pardo Ballen                       | 614            | 258.34              | 0.42      |
| AS OUT Jose Manuel Morales Camargo              | 532            | 222.77              | 0.42      |
| AS OUT Yiset Valentina Uribe Ahumada            | 849            | 351.53              | 0.41      |
| AS OUT Cristian David Mayorga Mongui            | 658            | 261.89              | 0.40      |
| AS OUT Lucila Cardenas                          | 742            | 295.16              | 0.40      |
| AS OUT Adrian Camilo Pineda Barrera             | 535            | 213.34              | 0.40      |
| AS OUT Laura Hernandez                          | 712            | 270.06              | 0.38      |
| AS OUT Diana Narvaez Galan                      | 641            | 245.76              | 0.38      |
| AS OUT Ayelin Vanesa Mercado Fontalvo           | 639            | 243.40              | 0.38      |
| LT IN Isaac Manning Gracia                      | 685            | 258.79              | 0.38      |
| LT CM Alexia Vergara Ruiz                       | 210            | 79.74               | 0.38      |
| AS OUT Ander Joel Cortes Vivas                  | 987            | 374.16              | 0.38      |
| LT IN Pedro Penichet Solorio                    | 738            | 267.18              | 0.36      |
| LT CM Jafet Ceballos Palomino                   | 305            | 107.13              | 0.35      |
| LT CM Elmer Cordova Escarcega                   | 208            | 72.17               | 0.35      |
| AS Kelly Johanna Torres                         | 42             | 14.80               | 0.35      |
| HOLMAN LUGO GUAYARA                             | 41             | 361.00              | 8.80      |
| WPB CM Natalia Serrano                          | 12             | 0.08                | 0.01      |
| (Sin nombre / null)                             | 375594         | 324.95              | 0.00      |

</div>

---

El análisis revela que existe una gran variabilidad en el AHT entre agentes: algunos presentan tiempos promedio superiores al minuto por llamada, mientras que la mayoría se sitúa por debajo de los 40 segundos. Además, aunque agentes con menor AHT manejan un alto volumen de llamadas, no necesariamente significa mayor efectividad, lo que indica la necesidad de contrastar este indicador con métricas como tasa de contacto y conversiones para tener una visión completa del desempeño.

### Insight del análisis

- **Desbalance entre agentes:** mientras que Sergio Osvaldo Acosta Bustamante tiene un AHT de 1.21 min (más alto), la mayoría de agentes manejan llamadas en menos de 0.5 min, lo que marca una diferencia operativa importante.  

- **Eficiencia vs. calidad:** un AHT muy bajo (ej. 0.10–0.30 min) puede indicar que las llamadas son resueltas rápidamente, pero también puede significar interacciones superficiales o falta de oportunidad de conversión.  

- **Oportunidad de mejora:** los agentes con AHT elevado deben ser revisados para entender si se debe a **procesos más complejos o ineficiencia**, mientras que los de AHT extremadamente bajo requieren evaluación para confirmar que las llamadas sean **efectivas y de calidad**.  
---
 
## Recomendaciones Estratégicas Basadas en el Análisis de Agentes

### 1. Balancear eficiencia y calidad
- Monitorear a los agentes con **AHT muy bajos (<0.3 min)** para asegurar que las llamadas sean de calidad y no solo rápidas.  
- Revisar casos con **AHT altos (>1 min)** para identificar si se debe a procesos complejos o a falta de eficiencia operativa.  

### 2. Segmentación de agentes según desempeño
- **Agentes de alto volumen y bajo AHT (ej. Juliana Zapata, Paula Sepulveda):** son eficientes, pero deben ser evaluados en conversión para confirmar efectividad.  
- **Agentes con alto AHT (ej. Sergio Acosta):** revisar su proceso y brindar coaching para reducir tiempos sin perder calidad.  
- **Agentes intermedios:** potencial para entrenamiento cruzado y compartir mejores prácticas.  

### 3. Capacitación y coaching
- Implementar **capacitaciones focalizadas** para agentes con mayor AHT.  
- Crear **sesiones de role play** con agentes de mejor desempeño para estandarizar buenas prácticas.  
- Enfocarse en mejorar **resolución en primer contacto** y técnicas de cierre.  

### 4. Optimización del proceso operativo
- Revisar **flujos de llamadas** para identificar pasos redundantes o cuellos de botella.  
- Implementar **guías rápidas y checklists** para mejorar la eficiencia en llamadas repetitivas.  
- Usar dashboards en tiempo real para que supervisores puedan intervenir de forma proactiva.  

### 5. Toma de decisiones estratégicas
- Usar las métricas de **AHT, volumen de llamadas y conversión** como un conjunto, no de manera aislada.  
- Incentivar con **bonos o reconocimientos** a los agentes que logren el balance correcto entre volumen y calidad.  
- Asignar **llamadas más complejas** a agentes con mayor experiencia y consistencia en resultados.  

### 6. Impacto esperado
- Reducción del tiempo promedio de llamadas sin comprometer calidad.  
- Mejora en la **satisfacción del cliente** y en la **tasa de conversión**.  
- Mayor motivación y competitividad en el equipo gracias a la retroalimentación y reconocimiento.  
---

## Conclusión
El análisis muestra que el equipo tiene un rango muy amplio en desempeño, con agentes altamente eficientes y otros que requieren apoyo adicional. Optimizar procesos y enfocar la capacitación permitirá cerrar esa brecha, incrementando la consistencia general.  

## Reflexiones Finales
1. La clave no es solo reducir el tiempo de llamada, sino asegurar que cada interacción sea **efectiva y de calidad**.  
2. Un modelo de gestión que combine **coaching, métricas balanceadas e incentivos claros** permitirá escalar la productividad de todo el equipo.  
3. Este enfoque no solo impactará en la **satisfacción del cliente**, sino también en la **moral y motivación de los agentes**, generando un círculo positivo de mejora continua.  


  
