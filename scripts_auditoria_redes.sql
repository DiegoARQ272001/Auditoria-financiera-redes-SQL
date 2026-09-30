-- =============================================================================
-- PROYECTO: Auditoría Transaccional y Modelado de Redes Jerárquicas
-- OBJETIVO: Detección de anomalías en comisiones y cálculo de linajes multinivel
-- MOTOR: PostgreSQL
-- NOTA: Datos y esquemas anonimizados con fines demostrativos y de confidencialidad
-- =============================================================================

-- 1. MODELADO DE LINAJES DESCENDENTES (Árbol de Patrocinio Recursivo)
WITH RECURSIVE arbol_red AS (
    SELECT 
        id_usuario,
        nombre_anonimizado,
        id_patrocinador,
        0 AS nivel_profundidad,
        CAST(id_usuario AS VARCHAR(255)) AS ruta_linaje
    FROM usuarios
    WHERE id_usuario = 1001

    UNION ALL

    SELECT 
        u.id_usuario,
        u.nombre_anonimizado,
        u.id_patrocinador,
        r.nivel_profundidad + 1,
        CAST(r.ruta_linaje || ' -> ' || u.id_usuario AS VARCHAR(255))
    FROM usuarios u
    INNER JOIN arbol_red r ON u.id_patrocinador = r.id_usuario
)
SELECT 
    nivel_profundidad,
    id_usuario,
    nombre_anonimizado,
    id_patrocinador,
    ruta_linaje
FROM arbol_red
ORDER BY nivel_profundidad, id_usuario;


-- 2. AUDITORÍA FORENSE: Detección de Comisiones Asignadas sin Calificación Activa
SELECT 
    u.id_usuario,
    u.nombre_anonimizado,
    c.id_corte,
    c.puntos_personales,
    SUM(com.monto_comision) AS total_comision_irregular,
    w.saldo_disponible_billetera,
    CASE 
        WHEN w.saldo_disponible_billetera >= SUM(com.monto_comision) THEN 'Recuperable en Billetera'
        ELSE 'Riesgo / Ya Retirado'
    END AS estatus_recuperacion
FROM usuarios u
INNER JOIN calificaciones_periodo c ON u.id_usuario = c.id_usuario
INNER JOIN comisiones_generadas com ON u.id_usuario = com.id_usuario AND c.id_corte = com.id_corte
LEFT JOIN billeteras_virtuales w ON u.id_usuario = w.id_usuario
WHERE c.puntos_personales = 0 
GROUP BY u.id_usuario, u.nombre_anonimizado, c.id_corte, c.puntos_personales, w.saldo_disponible_billetera
HAVING SUM(com.monto_comision) > 0
ORDER BY total_comision_irregular DESC;


-- 3. TRAZABILIDAD DE TRANSFERENCIAS: Detección de Cuentas Puente y Nodos Concentradores
SELECT 
    t.id_usuario_origen,
    u_orig.nombre_anonimizado AS origen,
    t.id_usuario_destino,
    u_dest.nombre_anonimizado AS receptor_concentrador,
    COUNT(t.id_transferencia) AS numero_movimientos,
    SUM(t.monto) AS volumen_total_triangulado
FROM transferencias_billetera t
INNER JOIN usuarios u_orig ON t.id_usuario_origen = u_orig.id_usuario
INNER JOIN usuarios u_dest ON t.id_usuario_destino = u_dest.id_usuario
WHERE t.fecha_transferencia BETWEEN '2026-09-01' AND '2026-09-30'
GROUP BY t.id_usuario_origen, u_orig.nombre_anonimizado, t.id_usuario_destino, u_dest.nombre_anonimizado
HAVING SUM(t.monto) > 5000
ORDER BY volumen_total_triangulado DESC;
