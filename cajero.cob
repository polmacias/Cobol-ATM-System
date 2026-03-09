           >>SOURCE FORMAT FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. MotorCajero.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT ArchivoCuentas ASSIGN TO "..\cuentas.dat"
    ORGANIZATION IS INDEXED
    ACCESS MODE IS RANDOM
    RECORD KEY IS IdCuenta
    FILE STATUS IS EstadoArchivo.

    SELECT OPTIONAL ArchivoAuditoria ASSIGN TO "..\historial.txt" *>el optional sirve para que si el archivo no esta creado lo cree
    ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD ArchivoCuentas.
01 RegistroCuenta.
   02 IdCuenta     PIC 9(5).
   02 Nombre       PIC X(15).
   02 Saldo        PIC 9(5)V99.
FD ArchivoAuditoria.
01 RegistroAuditoria.
   02 Aud-Cuenta    PIC 9(5).
   02 FILLER        PIC X(3) VALUE " - ".
   02 Aud-Operacion PIC X(30).
   02 FILLER        PIC X(3) VALUE " - ".
   02 Aud-Dinero    PIC ZZZZ9.99.
   02 FILLER        PIC X(4) VALUE " EUR".

WORKING-STORAGE SECTION.
01 CuentaTeclado   PIC 9(5).
01 TipoOperacion   PIC X(1).
01 DineroTeclado   PIC 9(4).

*> Variables internas del banco
01 DineroOperacion PIC 9(4)V99.
01 SaldoBonito     PIC ZZZZ9.99.
01 EstadoArchivo   PIC X(2).

PROCEDURE DIVISION.
    OPEN I-O ArchivoCuentas.
    OPEN EXTEND ArchivoAuditoria.

    *>  INTERFAZ DEL CAJERO
    DISPLAY "========================================"
    DISPLAY "       BIENVENIDO A POLO ATM    "
    DISPLAY "========================================"

    DISPLAY "1. Introduzca su numero de cuenta (Ej: 10001 o 10002): "
    ACCEPT CuentaTeclado.
    MOVE CuentaTeclado TO IdCuenta.

    DISPLAY "2. Que operacion desea realizar? (I = Ingreso / R = Reintegro): "
    ACCEPT TipoOperacion.

    DISPLAY "3. Introduzca el importe exacto sin decimales (Ej: 0050 para 50 EUR): "
    ACCEPT DineroTeclado.
    MOVE DineroTeclado TO DineroOperacion.

    DISPLAY "Procesando transaccion..."
    DISPLAY "----------------------------------"

    READ ArchivoCuentas
        INVALID KEY
            DISPLAY "Error de seguridad: La cuenta no existe."
        NOT INVALID KEY
            DISPLAY "Bienvenido: " Nombre

            *> Ingresar dinero
            IF TipoOperacion = 'I'
                ADD DineroOperacion TO Saldo
                REWRITE RegistroCuenta
                    INVALID KEY DISPLAY "Error al guardar."
                END-REWRITE
                DISPLAY "El ingreso ha sido un exito."
                MOVE CuentaTeclado TO Aud-Cuenta
                MOVE "EL INGRESO HA SIDO UN EXITO!!" TO Aud-Operacion
                MOVE DineroOperacion TO Aud-Dinero
                WRITE RegistroAuditoria

            *> Retirar dinero
            ELSE
                IF TipoOperacion = 'R'
                    IF Saldo >= DineroOperacion
                        SUBTRACT DineroOperacion FROM Saldo
                        REWRITE RegistroCuenta
                            INVALID KEY DISPLAY "Error al guardar."
                        END-REWRITE
                        DISPLAY "El retiro ha sido un exito."
                        MOVE CuentaTeclado TO Aud-Cuenta
                        MOVE "REINTEGRO EXITOSO" TO Aud-Operacion
                        MOVE DineroOperacion TO Aud-Dinero
                        WRITE RegistroAuditoria
                    ELSE
                        DISPLAY "Operacion denegada: Saldo insuficiente."
                    END-IF
                END-IF
            END-IF

            *>  FIN DE LA TRANSACCION
            MOVE Saldo TO SaldoBonito
            DISPLAY "Tu saldo final es: " SaldoBonito " EUR"
            DISPLAY "DEBUG (Codigo Guardado): " EstadoArchivo

    END-READ.

    CLOSE ArchivoCuentas.
    CLOSE ArchivoAuditoria.
    STOP RUN.
