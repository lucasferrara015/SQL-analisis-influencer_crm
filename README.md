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
# 📊 Guía de Consultas SQL - Influencer CRM

Este proyecto contiene 12 consultas SQL aplicadas a un CRM de influencers.  
Cada consulta responde a una pregunta clave de marketing y se traduce en insights accionables.

---

## 1. ROI Engagement
**Pregunta de negocio:** ¿Qué influencers generan mayor retorno en interacciones?  
**Insight esperado:** Ranking de influencers según interacciones vs inversión.  
📂 [Ver consulta completa](./sql/roi_engagement.sql)
📸 Resultado en MySQL Workbench (vista parcial):  
![ROI Engagement Result](./screenshots/roi_engagement_result.png)

---

## 2. ROI Clicks
**Pregunta de negocio:** ¿Qué influencers convierten mejor en clics?  
**Insight esperado:** ROI basado en clics generados vs inversión.  
📂 [Ver consulta completa](./sql/roi_clicks.sql)

---

## 3. Selección de talento
**Pregunta de negocio:** ¿Qué influencers activos son recomendables para próximas campañas?  
**Insight esperado:** Filtrado por engagement real y estado de colaboración.  
📂 [Ver consulta completa](./sql/influencers_recomendados.sql)

---

## 4. Evaluación de campañas: Rentabilidad (Costo por interacción)
**Pregunta de negocio:** ¿Cuál es el costo promedio por interacción en cada campaña?  
**Insight esperado:** Ranking de campañas más rentables.  
📂 [Ver consulta completa](./sql/costo_por_interaccion.sql)

---

## 5. Análisis de contenido: Mejores temáticas por engagement real
**Pregunta de negocio:** ¿Qué temáticas generan mayor engagement promedio?  
**Insight esperado:** Comparación de temáticas según interacciones/publicación.  
📂 [Ver consulta completa](./sql/engagement_tematica.sql)

---

## 6. Evolución del engagement en el tiempo
**Pregunta de negocio:** ¿Cómo evoluciona el engagement de un influencer en distintos periodos?  
**Insight esperado:** Tendencia diaria, semanal o mensual.  
📂 [Ver consulta completa](./sql/evolucion_engagement.sql)

---

## 7. Medición de ventas: Tasa de conversión de códigos de descuento
**Pregunta de negocio:** ¿Qué códigos de descuento generan más ventas y ROI?  
**Insight esperado:** Conversión clics → ventas y ROI por ingresos.  
📂 [Ver consulta completa](./sql/conversion_codigos.sql)

---

## 8. Segmentación estratégica: Matriz de rendimiento y coste
**Pregunta de negocio:** ¿Cómo clasificar influencers según ROI y coste?  
**Insight esperado:** Cuadrantes estratégicos para priorizar inversión.  
📂 [Ver consulta completa](./sql/matriz_rendimiento_coste.sql)

---

## 9. Optimización de frecuencia
**Pregunta de negocio:** ¿Cuántas publicaciones semanales son óptimas para maximizar engagement?  
**Insight esperado:** Relación publicaciones vs engagement promedio.  
📂 [Ver consulta completa](./sql/frecuencia_optima.sql)

---

## 10. Lealtad del influencer: Repetibilidad y mejora en el tiempo
**Pregunta de negocio:** ¿Los influencers mejoran, mantienen o declinan su rendimiento en colaboraciones sucesivas?  
**Insight esperado:** Clasificación de tendencia (mejora, se mantiene, declina).  
📂 [Ver consulta completa](./sql/lealtad_influencer.sql)

---

## 11. Rendimiento por plataforma y formato
**Pregunta de negocio:** ¿Qué plataformas y formatos generan mayor engagement promedio?  
**Insight esperado:** Comparación de rendimiento por tipo de contenido.  
📂 [Ver consulta completa](./sql/rendimiento_plataforma_formato.sql)

---

## 12. Crecimiento de audiencia: Ganancia de seguidores durante la campaña
**Pregunta de negocio:** ¿Qué campañas generan mayor crecimiento de seguidores?  
**Insight esperado:** Tasa de crecimiento relativa de audiencia.  
📂 [Ver consulta completa](./sql/crecimiento_audiencia.sql)

---

## 📌 Conclusión
Este proyecto muestra cómo las consultas SQL permiten transformar datos en **inteligencia de negocio real**.  
La información obtenida ayuda a:
- Optimizar la inversión en campañas  
- Seleccionar el mejor talento  
- Maximizar el rendimiento de las estrategias de marketing con influencers  




