# Cobol-ATM-System
Motor transaccional bancario y procesador Batch programado en COBOL. Simulación de entorno Mainframe con archivos indexados y logs secuenciales.

# 🏦 Simulador Bancario en COBOL (ATM & Batch)

Este es un proyecto práctico desarrollado íntegramente en **COBOL** que simula la lógica transaccional y el procesamiento de datos de un entorno Mainframe/Host bancario.

## ⚙️ ¿Qué incluye este ecosistema?
El proyecto está compuesto por tres programas que interactúan entre sí:

1. **Inicializador (`crear_bd.cob`):** Genera la base de datos principal (`cuentas.dat`) con registros semilla para poder hacer pruebas.
2. **Cajero Interactivo (`cajero.cob`):** Interfaz de consola que solicita la cuenta al usuario, valida si existe, y permite realizar **ingresos** o **reintegros**. Incluye control de morosidad (bloquea reintegros sin fondos) y genera un recibo automático en un archivo de log (`historial.txt`).
3. **Procesador Nocturno (`ProcesadorBatch.cbl`):** Simula un proceso *Batch*. Lee un archivo secuencial con operaciones diarias (`movimientos.txt`), hace el cálculo matemático y genera un reporte final de cuadre (`informe.txt`).

## 🚀 Conceptos Técnicos Aplicados
* **Lenguaje:** COBOL (GnuCOBOL).
* **Gestión de Archivos:** Uso de archivos Indexados (`ORGANIZATION IS INDEXED`) simulando la tecnología VSAM con acceso aleatorio a registros.
* **Operaciones I/O:** Manejo de archivos secuenciales en modos `INPUT` (lectura), `OUTPUT` (creación) y `EXTEND` (añadir registros).
* **Control de Errores:** Captura de excepciones del sistema operativo (`FILE STATUS` 30, 35, etc.) para evitar caídas del programa.
* **Edición Financiera:** Uso de máscaras (`PIC ZZZZ9.99`) para formatear variables lógicas en importes legibles por el usuario.

## 🛠️ Cómo ejecutarlo en local
1. Ejecutar `crear_bd.cob` para crear el archivo binario de cuentas.
2. Ejecutar `cajero.cob` e interactuar con el menú por pantalla.
3. Crear un archivo de texto `movimientos.txt` con datos de prueba y ejecutar el procesador Batch para generar el informe.
