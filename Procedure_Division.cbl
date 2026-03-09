           >>SOURCE FORMAT FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. ProcesadorBatch.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT ArchivoMovimientos ASSIGN TO "..\movimientos.txt"
    ORGANIZATION IS LINE SEQUENTIAL.
    SELECT ArchivoInforme ASSIGN TO "..\informe.txt"
    ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD ArchivoMovimientos.
01 RegistroMovimiento.
   02 Cuenta        PIC 9(5).
   02 TipoOperacion PIC X(1).
   02 Cantidad      PIC 9(4)V99.


FD ArchivoInforme.
01 LineaInforme     PIC X(45).

WORKING-STORAGE SECTION.
01 FinDeArchivo     PIC X(1) VALUE 'N'.
01 DineroBonito     PIC ZZZZ9.99.
01 TotalBanco       PIC 9(7)V99 VALUE ZEROS.
01 TotalBonito      PIC Z,ZZZ,ZZ9.99.

PROCEDURE DIVISION.
    *> Abrimos uno para leer INPUT y otro para escribir OUTPUT
    OPEN INPUT ArchivoMovimientos
         OUTPUT ArchivoInforme.

    READ ArchivoMovimientos
        AT END MOVE 'Y' TO FinDeArchivo
    END-READ.

    PERFORM UNTIL FinDeArchivo = 'Y'

       IF TipoOperacion = 'I'
           ADD Cantidad TO TotalBanco
       ELSE
           SUBTRACT Cantidad FROM TotalBanco
       END-IF

        *>Construimos la frase y la ESCRIBIMOS en el archivo nuevo
        STRING "Cuenta: " Cuenta " | EUR: " DineroBonito INTO LineaInforme
        WRITE LineaInforme

        *>Leemos la siguiente línea
        READ ArchivoMovimientos
            AT END MOVE 'Y' TO FinDeArchivo
        END-READ

    END-PERFORM.

    *> Escribimos el resumen
    MOVE TotalBanco TO TotalBonito
    STRING "-----------------------------------" INTO LineaInforme
    WRITE LineaInforme
    STRING "TOTAL VOLUMEN NOCHE: " TotalBonito INTO LineaInforme
    WRITE LineaInforme.

    CLOSE ArchivoMovimientos
          ArchivoInforme.

    DISPLAY "PROCESO TERMINADO CON EXITO.".
    DISPLAY "Revisa tu carpeta, se ha creado el informe.txt".
    STOP RUN.
