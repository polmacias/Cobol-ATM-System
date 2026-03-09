           >>SOURCE FORMAT FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. InstaladorBD.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT ArchivoCuentas ASSIGN TO "..\cuentas.dat"
    ORGANIZATION IS INDEXED
    ACCESS MODE IS SEQUENTIAL
    RECORD KEY IS IdCuenta.

DATA DIVISION.
FILE SECTION.
FD ArchivoCuentas.
01 RegistroCuenta.
   02 IdCuenta     PIC 9(5).
   02 Nombre       PIC X(15).
   02 Saldo        PIC 9(5)V99.

WORKING-STORAGE SECTION.

PROCEDURE DIVISION.
    *> Abrimos en modo OUTPUT para crear el archivo desde cero
    OPEN OUTPUT ArchivoCuentas.

    *> Cliente 1: Tú (con 1.500,50 EUR)
    MOVE 10001 TO IdCuenta
    MOVE "Pol Macias     " TO Nombre
    MOVE 0150050 TO Saldo
    WRITE RegistroCuenta.

    *> Cliente 2: Cliente Random (con 300,00 EUR)
    MOVE 10002 TO IdCuenta
    MOVE "Ana Garcia     " TO Nombre
    MOVE 0030000 TO Saldo
    WRITE RegistroCuenta.

    *> Cliente 3: Una empresa (con 12.500,00 EUR)
    MOVE 10003 TO IdCuenta
    MOVE "Tech Solutions " TO Nombre
    MOVE 1250000 TO Saldo
    WRITE RegistroCuenta.

    *> Cerramos la conexión para guardar los datos en el disco
    CLOSE ArchivoCuentas.

    DISPLAY "--- BASE DE DATOS BANCARIA CREADA CON EXITO ---".
    STOP RUN.
