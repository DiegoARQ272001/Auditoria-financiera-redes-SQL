# Auditoría Forense y Modelado de Redes Jerárquicas con SQL

## Descripción del Proyecto
Implementación de un modelo de auditoría transaccional y validación de reglas de negocio sobre bases de datos relacionales. El sistema automatiza la detección de anomalías en asignación de comisiones, conciliación de saldos y modelado de linajes de red mediante consultas estructuradas avanzadas.

## Problema de Negocio
Desfase en la validación de compras mínimas calificadoras que derivó en asignación irregular de comisiones y triangulación de saldos hacia cuentas puente, generando un riesgo financiero de **$57,925.00 MXN**.

## Tecnologías y Herramientas
- **Motor BD:** PostgreSQL / SQL Server
- **Técnicas SQL:** Common Table Expressions recursivas (`WITH RECURSIVE`), Window Functions, Subconsultas correlacionadas, `CASE WHEN` analítico.
- **Herramientas Complementarias:** Power Query, Excel Avanzado (Modelado relacional y análisis forense).

## Metodología Técnica
1. **Reconstrucción de Linajes:** Uso de recursión SQL para trazar la jerarquía completa de la red y calcular volúmenes descendentes.
2. **Auditoría Transaccional:** Cruce entre registros de calificación mensual y dispersión de comisiones para aislar usuarios con 0 puntos activos.
3. **Trazabilidad de Triangulaciones:** Detección de cuentas concentradoras y flujos atípicos entre monederos virtuales.

## Resultados e Impacto
- **$57,925.00 MXN** en riesgo financiero detectado y aislado previo a dispersión.
- **$17,570.00 MXN** contenidos directamente en billeteras virtuales para recuperación inmediata.
- Identificación de cuentas intermediarias con movimientos por **$32,525.00 MXN**.

> *Nota: Datos y esquemas completamente anonimizados con fines demostrativos.*
