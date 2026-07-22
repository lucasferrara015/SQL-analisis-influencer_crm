# 📊 SQL-analisis-influencer_crm

## 📖 Introducción

La base de datos **influencer_crm** forma parte de un proyecto más amplio orientado a la creación de un sistema de decisiones inteligente para campañas de marketing.  
Está diseñada para almacenar información sobre influencers, campañas de marketing, marcas y colaboraciones entre ellos.

Sobre esta base se aplican consultas SQL que permiten generar **inteligencia de negocio**.  
Cada consulta responde a preguntas clave de marketing y se traduce en **insights accionables** para optimizar inversión, seleccionar talento y maximizar el rendimiento de campañas.


---

## 🎯 Objetivo
Demostrar cómo los datos operativos de la db influencers_crm pueden convertirse en **herramientas estratégicas** para la toma de decisiones.  
A lo largo del análisis se exploran:
- Métricas de eficiencia (ROI en engagement y clics)  
- Rendimiento de campañas  
- Comportamiento de audiencia  
- Segmentación estratégica  

Todo ello con un enfoque práctico y orientado a resultados.

---

## 📋 Cada consulta incluye:
- **Pregunta de negocio** → qué queremos saber  
- **Código SQL** → formateado con bloque ```sql```  
- **Captura de resultados** → imagen desde MySQL Workbench  
- **Insight de negocio** → qué decisión tomar con esos números  

---

## 📌 Estructura del repositorio
- `/notebooks` → Jupyter Notebooks con las consultas y análisis  
- `/sql` → scripts SQL individuales  
- `/images` → capturas de pantalla de resultados  
- `README.md` → documentación principal  

---
# 📈 Guía de Consultas Analíticas

Este proyecto contiene 12 consultas SQL aplicadas a un CRM de influencers.  
Cada consulta responde a una pregunta clave de marketing y se traduce en insights accionables.

---

## 1. ROI Engagement
**Pregunta de negocio:** ¿Qué influencers generan mayor retorno en interacciones?   
📂 [Ver consulta completa](./sql/roi_engagement.sql)

📸 Resultado en MySQL Workbench (vista parcial):  
![ROI Engagement Result](./screenshots/01_roi_engagement_ranking_global.png)

**Insight de negocio:**  

Ana López lidera con el ROI más alto (2.94), logrando gran eficiencia: pocas inversiones y alto volumen de interacciones.

Javier Torres ocupa el segundo lugar (2.70) con un volumen masivo de interacciones (más de 100k), lo que lo convierte en un perfil clave para campañas de alcance masivo.

María García mantiene un ROI sólido (2.38) con inversión moderada, lo que la hace confiable para campañas balanceadas entre costo y rendimiento.

Elena Muñoz y Diego Rivas muestran ROI intermedio (1.31 y 1.13), útiles para sostener consistencia pero sin picos de eficiencia.

Carlos Ruiz, Sofía Medina y Roberto Sánchez presentan ROI bajo (<1.1), lo que indica que sus campañas generan menos retorno por cada peso invertido.

🚀 **Conclusión estratégica:**
La estrategia debería priorizar a Ana López como referente de eficiencia y a Javier Torres para campañas de gran alcance. María García es ideal como perfil versátil que combina buen ROI con inversión moderada. El resto del grupo puede mantenerse en campañas de soporte o visibilidad, pero con expectativas controladas en términos de conversión y retorno.

---

## 2. ROI Clicks
**Pregunta de negocio:** ¿Qué influencers convierten mejor en clics?  
📂 [Ver consulta completa](./sql/roi_clicks.sql)

📸 Resultado en MySQL Workbench (vista parcial):  
![ROI Click Result](./screenshots/02_roi_clicks_ranking_global.png)

**Insight de negocio:**

Ana López y Carlos Ruiz comparten el ROI por clics más alto (1.13), aunque con perfiles distintos: Ana logra volumen considerable (11.530 clics) mientras Carlos lo hace con bajo volumen (1.800), lo que sugiere eficiencia en ambos extremos.

Javier Torres se posiciona tercero (ROI 1.06) pero con un volumen masivo de clics (41.020), lo que lo convierte en un activo clave para campañas de gran alcance.

María García y Valentina Paz muestran ROI moderado (0.92 y 0.84), útiles para mantener consistencia pero sin picos de eficiencia.

Diego Rivas, Elena Muñoz y Roberto Sánchez presentan ROI bajo (<0.7), lo que indica menor retorno por inversión y necesidad de reevaluar su rol en campañas de performance.

🚀 **Conclusión estratégica:**

La estrategia debería priorizar a Ana López y Javier Torres como perfiles estrella: Ana por su eficiencia y Javier por su alcance masivo. Carlos Ruiz es un caso interesante de alta eficiencia con bajo volumen, ideal para pruebas de nicho o campañas de bajo presupuesto. María García y Valentina Paz pueden sostener campañas de soporte con ROI aceptable. El resto del grupo requiere renegociación o asignación a campañas de visibilidad, ya que su aporte en conversión es limitado.

---

## 3. Selección de talento
**Pregunta de negocio:** ¿Qué influencers activos son recomendables para próximas campañas?  

📂 [Ver consulta completa](./sql/Selección_de_Talento.sql)

📸 Resultado en MySQL Workbench (vista parcial):  
![Influencer recomendado Result](./screenshots/03_Seleccion_Talento.png)

**Insight de negocio:**

Ana López cumple con los criterios de temática (Moda), supera el mínimo de engagement y está activa.
Su rendimiento histórico muestra buen nivel de interacciones y una colaboración reciente.
**Acción:** recomendarla como candidata prioritaria para la próxima campaña de moda.

---

## 4. Evaluación de campañas: Rentabilidad (Costo por interacción)
**Pregunta de negocio:** ¿Cuál es el costo promedio por interacción en cada campaña?  
 
📂 [Ver consulta completa](./sql/costo_por_interaccion.sql)

📸 Resultado en MySQL Workbench (vista parcial):  
![Campania costo por interacción Result](./screenshots/04_Costo_por_interaccion.png)

**Insight de negocio:** 

Campañas 2, 10 y 1 → más rentables, con menor costo por interacción; generan gran engagement con baja inversión.
Campañas 11 y 4 → rentabilidad intermedia, aún aceptables en eficiencia.
Campañas 15, 5, 13 y 12 → menos eficientes, con alto costo por interacción; requieren revisión de estrategia o renegociación de condiciones.
🚀 **Conclusión estratégica:**

Priorizar campañas con bajo costo por interacción para maximizar ROI, y ajustar presupuesto o estrategia en aquellas con baja eficiencia.

---

## 5. Análisis de contenido: Mejores temáticas por engagement real
**Pregunta de negocio:** ¿Qué temáticas generan mayor engagement promedio?  
  
📂 [Ver consulta completa](./sql/engagement_tematica.sql)

📸 Resultado en MySQL Workbench (vista parcial):

![Tematica engagement Result](./screenshots/05_clasificacion_tematicas.png)

**Insight de negocio:** 

Fitness y Tecnología destacan como las temáticas con mayor engagement promedio, generando más interacciones por publicación.
Moda muestra un engagement menor en comparación, aunque sigue siendo relevante.
**Acción estratégica:**

priorizar campañas en torno a Fitness y Tecnología para maximizar interacción, y mantener Moda como temática complementaria según objetivos de marca.

---

## 6. Evolución del engagement en el tiempo
**Pregunta de negocio:** ¿Cómo evoluciona el engagement de un influencer en distintos periodos?  

📂 [Ver consulta completa](./sql/evolucion_engagement.sql)

📸 Resultado en MySQL Workbench (vista parcial):

![Evolucion engagement en el tiempo Result](./screenshots/06_evaluacion_mensual_LAG.png)

**Insight de negocio:**

Se observa una tendencia creciente en el engagement a lo largo del tiempo.
Los picos en julio sugieren que la segunda campaña tuvo mayor impacto en la audiencia.
Las variaciones diarias permiten identificar qué contenidos generan más interacción.
**Acción estratégica:**

reforzar las prácticas de publicación que dieron mejores resultados y ajustar las que mostraron caídas.
📌 Nota: El procedimiento almacenado también puede cubrir análisis semanales y mensuales, lo que permite comparar patrones de engagement en diferentes escalas de tiempo.

---

## 7. Medición de ventas: Tasa de conversión de códigos de descuento
**Pregunta de negocio:** ¿Qué códigos de descuento generan más ventas y ROI?  

📂 [Ver consulta completa](./sql/Tasa_de_Conversion.sql)

📸 Resultado en MySQL Workbench (vista parcial):
![Ventas roi tasa conversion Result](./screenshots/07_Tasa_de_conversion.png)

**Insight de negocio:** 

María García es la influencer más rentable, con el ROI más alto y una tasa de conversión sólida: ideal para campañas orientadas a ventas directas.
Roberto Sánchez, Valentina Paz y Ana López muestran un buen equilibrio entre ingresos y conversión, recomendables para mantener consistencia en resultados.
Javier Torres genera ingresos elevados pero con baja tasa de conversión, lo que lo posiciona mejor en campañas de alcance y branding.
Elena Muñoz, Carlos Ruiz, Sofía Medina y Diego Rivas presentan menor eficiencia en ROI y conversión, por lo que conviene asignarles campañas de visibilidad o engagement en lugar de performance puro.

---

## 8. Segmentación estratégica: Matriz de rendimiento y coste
**Pregunta de negocio:** ¿Cómo clasificar influencers según ROI y coste?  

📂 [Ver consulta completa](./sql/matriz_rendimiento_coste.sql)

📸 Resultado en MySQL Workbench (vista parcial):

![Matriz rendimiento coste Result](./screenshots/08_matriz_rendimiento_coste.png)

**Insight de negocio:** 

Prioridad máxima: Roberto Sánchez, Valentina Paz, María García, Ana López y Carlos Ruiz → combinan ROI alto con costes bajos, ideales para escalar campañas.
Evaluación de presupuesto: ninguno en este corte, lo que simplifica la asignación de recursos.
Bajo riesgo: Sofía Medina y Elena Muñoz → ROI bajo pero costes moderados, útiles para campañas de prueba o visibilidad.
Descartar/renegociar: Javier Torres y Diego Rivas → ROI insuficiente frente a costes elevados, requieren revisión de estrategia o renegociación de condiciones.

---

## 9. Optimización de frecuencia
**Pregunta de negocio:** ¿Cuántas publicaciones semanales son óptimas para maximizar engagement?  
 
📂 [Ver consulta completa](./sql/frecuencia_optima.sql)

📸 Resultado en MySQL Workbench (vista parcial):

![Optimizacion freuencia screenshot Result](./screenshots/09_optimizacion_frecuencia.png)

**Insight de negocio:** 

Frecuencia óptima: los influencers con 2–3 publicaciones por semana (ej. María García, Roberto Sánchez, Valentina Paz) mantienen un engagement promedio alto y estable.
Saturación detectada: cuando la frecuencia supera las 4–5 publicaciones semanales (ej. Sofía Medina, Javier Torres), el engagement promedio tiende a caer, indicando sobreexposición de la audiencia.
Publicaciones aisladas (1 por semana) muestran picos de engagement muy altos (ej. Ana López, Diego Rivas), lo que sugiere que la audiencia responde mejor a contenidos menos frecuentes pero más relevantes.
**Recomendación estratégica:** 

mantener un rango de 2–3 publicaciones semanales como estándar, reservando publicaciones adicionales solo para campañas especiales, evitando la saturación y maximizando el engagement.

---

## 10. Lealtad del influencer: Repetibilidad y mejora en el tiempo
**Pregunta de negocio:** ¿Los influencers mejoran, mantienen o declinan su rendimiento en colaboraciones sucesivas?  
 
📂 [Ver consulta completa](./sql/Trayectoria_de_rendimiento.sql)

📸 Resultado en MySQL Workbench (vista parcial):

![Lealtad influencer Result](./screenshots/10_trayectoria_de_rendimiento.png)

**Insight de negocio:**

Mejora en el tiempo: Ana López, María García, Diego Rivas y Elena Muñoz logran aumentar su engagement en colaboraciones posteriores, mostrando capacidad de sostener y escalar el interés de la audiencia.
Se mantiene: Carlos Ruiz, Valentina Paz y Roberto Sánchez mantienen un engagement estable, lo que los hace confiables para campañas de continuidad sin riesgo de caída.
Declina: Javier Torres y Sofía Medina muestran una reducción significativa en engagement con el tiempo, lo que sugiere saturación o pérdida de relevancia; requieren ajustes de estrategia o renegociación de condiciones.
👉 Estrategia: priorizar a quienes mejoran, sostener a los estables y replantear la inversión en quienes declinan.

---

## 11. Rendimiento por plataforma y formato
**Pregunta de negocio:** ¿Qué plataformas y formatos generan mayor engagement promedio?  
  
📂 [Ver consulta completa](./sql/rendimiento_plataforma_formato.sql)

📸 Resultado en MySQL Workbench (vista parcial):

![Rendimiento plataforma formato Result](./screenshots/11_rendimiento_plataforma_formato.png)

**Insight de negocio:** 

TikTok (video) domina en engagement promedio, confirmando que los contenidos audiovisuales cortos y dinámicos son los más efectivos para captar la atención.

YouTube (video) también muestra un rendimiento elevado, ideal para contenidos más largos y profundos que mantienen la interacción.

Instagram reels se consolidan como el formato más competitivo dentro de Instagram, con un engagement cercano al de los videos, siendo la mejor apuesta en esa plataforma.

Instagram video tiene un rendimiento intermedio, mientras que Instagram imagen queda muy por debajo, evidenciando que los formatos estáticos generan menor interacción.

**Estrategia:** priorizar video en TikTok y YouTube, mantener reels en Instagram como formato clave, y reducir la inversión en publicaciones estáticas para maximizar el retorno en engagement.



---

## 12. Crecimiento de audiencia: Ganancia de seguidores durante la campaña
**Pregunta de negocio:** ¿Qué campañas generan mayor crecimiento de seguidores?  
  
📂 [Ver consulta completa](./sql/crecimiento_audiencia.sql)

📸 Resultado en MySQL Workbench (vista parcial):

![Crecimiento audiencia seguidores campania Result](./screenshots/12_crecimiento_audiencia.png)

**Insight de negocio:** 

Elena Muñoz lidera con la mayor tasa de crecimiento (21.43%), mostrando fuerte impacto en campañas.
Ana López y María García mantienen un crecimiento sólido (20%), posicionándose como influencers confiables.
Diego Rivas presenta crecimiento moderado (18.75%).
Javier Torres apenas crece (2.56%), lo que sugiere saturación de su audiencia.
👉 Priorizar a Elena Muñoz y mantener inversión en Ana López y María García para maximizar ROI.



---

## 🧠 Conclusión General
El uso de SQL analítico avanzado (CTEs, funciones de ventana, rankings, análisis temporal y de frecuencia) permite extraer valor estratégico de los datos operativos de un CRM de influencers.
Cada una de las 12 consultas entrega insights accionables que responden a preguntas de negocio reales:

Dónde invertir para maximizar ROI.

A quién elegir para cada objetivo (eficiencia, alcance, conversión, crecimiento).

Cómo ajustar la estrategia de contenido (frecuencia, formato, plataforma).

Cuándo renegociar o descartar un influencer.

Este repositorio es una demostración práctica de cómo los datos pueden guiar decisiones de marketing con precisión.  




