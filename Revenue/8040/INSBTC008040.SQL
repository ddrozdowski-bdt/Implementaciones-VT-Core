create or replace PROCEDURE        INSUDB.INSBTC008040 (
   SKEY             T_INTERFACE.SKEY%TYPE,
   SKEY_INTERNAL    T_INTERFACE.SKEY%TYPE,
   NUSERCODE        CLIENT.NUSERCODE%TYPE,
   NDIAS NUMBER
   
)
   AUTHID CURRENT_USER
AS
   CURSOR C_HILOS (
      P_SKEY                      TMP_VIL8040.SKEY%TYPE,
      P_NUSERCODE                 USERS.NUSERCODE%TYPE,
      P_DIAS                      NUMBER
   )
   IS
        SELECT      'PKG_ENDOSOMASIVOSUMAASEG.MAIN ('''
                 || P_SKEY
                 || ''', '
                 || HILO
                 || ', '
                 || DESDE
                 || ', '
                 || HASTA
                 || ', '
                 || P_NUSERCODE
                 || ', '
                 || P_DIAS                 
                 || ');'
                    COMANDO
          FROM   EJECUCION_PROCESOS
         WHERE   SKEY = P_SKEY AND ESTADO = 'AP'
      ORDER BY   HILO;

   NCODERROR                   NUMBER := 0;
   SMSGERROR                   VARCHAR2 (255) := NULL;
   V_CANTIDAD                  NUMBER := 0;
   V_HILOS_EJECUTADOS          NUMBER := 0;
   NJOB                        BINARY_INTEGER;
   NJOB_RUNNING                NUMBER := 0;
   V_NIDCONSEC_AUX             COMMERCIALSTRUCTURE.STRUCEVENT.NIDCONSEC%TYPE;
   V_SEQ_STRUCEVENT_IDCONSEC   COMMERCIALSTRUCTURE.STRUCEVENT.NIDCONSEC%TYPE;

   V_SKEY_INTERFAZ             T_INTERFACE.SKEY%TYPE;
   NDIAS1 NUMBER;

BEGIN
   NDIAS1:=NDIAS;

   INSERT INTO TRACE (ID,
                      PROC,
                      NUSERCODE,
                      TEXT)
     VALUES   (TRACE_SEQ.NEXTVAL,
               'INSBTC008040',
               3169,
               'SKEY: ' || INSBTC008040.SKEY);

   COMMIT;

   INSERT INTO TRACE (ID,
                      PROC,
                      NUSERCODE,
                      TEXT)
     VALUES   (TRACE_SEQ.NEXTVAL,
               'INSBTC008040',
               3169,
               'SKEY_INTERNAL: ' || INSBTC008040.SKEY_INTERNAL);

   COMMIT;

   VTBATCHPKG.STARTBATCH (SKEY);

   NCODERROR := 0;
   SMSGERROR := NULL;

   INSERT INTO TRACE (ID,
                      PROC,
                      NUSERCODE,
                      TEXT)
     VALUES   (TRACE_SEQ.NEXTVAL,
               'INSBTC008040',
               3169,
               'INICIO: ' || TO_CHAR (SYSDATE, 'DD/MM/YYYY HH24:MM:SS'));

   COMMIT;


   BEGIN
      INSERT INTO TIMETMP.TMP_VIL8040
         SELECT   INSBTC008040.SKEY,
                  ROWNUM,
                  C.SCERTYPE,
                  C.NBRANCH,
                  C.NPRODUCT,
                  C.NPOLICY,
                  C.NCERTIF,
                  C.DDATE_ORIGI,
                  C.DNEXTRECEIP,
                  CO.NMODULEC,
                  CO.NCOVER,
                  DECODE (TIN.NPERCENT, NULL, 1, 2) NADJUSTMENT, -- TIN.NADJUSTMENT,
                  --TIPO AJUSTE (ABSOLUTA O %)
                  DECODE (TIN.NPERCENT, NULL, TIN.NAMOUNT, TIN.NPERCENT)
                     NAMOUNT, --TIN.NAMOUNT,                                         --MONTO
                  DECODE (
                     TIN.NPERCENT,
                     NULL,
                     TIN.NAMOUNT,
                     ( ( (CO.NCAPITAL * TIN.NPERCENT) / 100) + CO.NCAPITAL)
                  ),                                       --CAPITAL A APLICAR
                  CO.NCAPITAL,
                  5 NCAUSE_AMEND, --TIN.NCAUSE_AMEND,                             --CAUSA ENDOSO
                  536 NIDSTRUC,                                --TIN.NIDSTRUC,
                  --ESTRUCTURA COMERCIAL
                  PM.SBRANCHT,
                  NULL,
                  NULL
           FROM   CERTIFICAT C,
                  PRODMASTER PM,
                  COVER CO,
                  CERT_STATUS CS,
                  INDEXCERPOLICY TIN
          WHERE       C.NBRANCH = TIN.NBRANCH
                  AND C.SCERTYPE = 2
                  AND C.NPRODUCT = TIN.NPRODUCT
                  AND C.SCERTYPE = CO.SCERTYPE
                  AND C.NBRANCH = CO.NBRANCH
                  AND C.NPRODUCT = CO.NPRODUCT
                  AND C.NPOLICY = CO.NPOLICY
                  AND C.NCERTIF = CO.NCERTIF
                  AND CO.NMODULEC = TIN.NMODULEC
                  AND CO.NCOVER = TIN.NCOVER
                  AND CO.DNULLDATE IS NULL
                  AND C.NBRANCH = PM.NBRANCH
                  AND C.NPRODUCT = PM.NPRODUCT
                  AND C.SCERTYPE = CS.SCERTYPE
                  AND C.NBRANCH = CS.NBRANCH
                  AND C.NPRODUCT = CS.NPRODUCT
                  AND C.NPOLICY = CS.NPOLICY
                  AND C.NCERTIF = CS.NCERTIF
                  AND C.DCOLLSUS_INI IS NULL
                  AND C.NPAYFREQ = 5
                  AND C.DDATE_ORIGI >= NVL(TIN.DEFFECDATE, C.DDATE_ORIGI)
                  AND C.DDATE_ORIGI <= TIN.DDATETO
                  AND CS.NFACESTATUS = 1
                  AND TIN.SKEY = INSBTC008040.SKEY_INTERNAL;

      INSERT INTO TRACE (
                            ID,
                            PROC,
                            NUSERCODE,
                            TEXT
                 )
        VALUES   (
                     TRACE_SEQ.NEXTVAL,
                     'INSBTC008040',
                     3169,
                     'INFORMACION INSERTADA OK: '
                     || TO_CHAR (SYSDATE, 'DD/MM/YYYY HH24:MM:SS')
                 );

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         NCODERROR := -1;
         SMSGERROR := SUBSTR (SQLERRM, 1, 255);

         INSERT INTO TRACE (
                               ID,
                               PROC,
                               NUSERCODE,
                               TEXT
                    )
           VALUES   (
                        TRACE_SEQ.NEXTVAL,
                        'INSBTC008040',
                        3169,
                           'ERROR INSERTANDO INFORMACION: '
                        || SMSGERROR
                        || ' - '
                        || TO_CHAR (SYSDATE, 'DD/MM/YYYY HH24:MM:SS')
                    );

         COMMIT;
   END;

   IF NCODERROR = 0
   THEN
      INSERT INTO TRACE (
                            ID,
                            PROC,
                            NUSERCODE,
                            TEXT
                 )
        VALUES   (
                     TRACE_SEQ.NEXTVAL,
                     'INSBTC008040',
                     3169,
                     'INICIO ARMADO DE COTAS: '
                     || TO_CHAR (SYSDATE, 'DD/MM/YYYY HH24:MM:SS')
                 );

      COMMIT;

      PKG_ENDOSOMASIVOSUMAASEG.COTAS (INSBTC008040.SKEY,
                                      NCODERROR,
                                      SMSGERROR);

      INSERT INTO TRACE (
                            ID,
                            PROC,
                            NUSERCODE,
                            TEXT
                 )
        VALUES   (
                     TRACE_SEQ.NEXTVAL,
                     'INSBTC008040',
                     3169,
                     'FIN ARMADO DE COTAS: '
                     || TO_CHAR (SYSDATE, 'DD/MM/YYYY HH24:MM:SS')
                 );

      COMMIT;

      IF NCODERROR = 0
      THEN
         BEGIN
            SELECT   MAX (NIDCONSEC) + 1
              INTO   V_NIDCONSEC_AUX
              FROM   COMMERCIALSTRUCTURE.STRUCEVENT;
         EXCEPTION
            WHEN OTHERS
            THEN
               V_NIDCONSEC_AUX := 1;
         END;

         SELECT   INSUDB.SEQ_STRUCEVENT_IDCONSEC.NEXTVAL
           INTO   V_SEQ_STRUCEVENT_IDCONSEC
           FROM   DUAL;

         WHILE V_SEQ_STRUCEVENT_IDCONSEC <= V_NIDCONSEC_AUX
         LOOP
            SELECT   INSUDB.SEQ_STRUCEVENT_IDCONSEC.NEXTVAL
              INTO   V_SEQ_STRUCEVENT_IDCONSEC
              FROM   DUAL;
         END LOOP;

         
         FOR V_HILO IN C_HILOS (INSBTC008040.SKEY, INSBTC008040.NUSERCODE,NDIAS1)
         LOOP
            NJOB := DBMS_SCHEDULER.generate_job_name (NULL);

            DBMS_SCHEDULER.create_job (
               job_name     => INSBTC008040.SKEY || '_' || NJOB,
               job_type     => 'PLSQL_BLOCK',
               job_action   => V_HILO.COMANDO,
               start_date   => SYSTIMESTAMP,
               enabled      => TRUE
            );

            V_HILOS_EJECUTADOS := V_HILOS_EJECUTADOS + 1;
            SLEEP (1);

            SELECT   COUNT ( * )
              INTO   NJOB_RUNNING
              FROM   DBA_SCHEDULER_JOBS
             WHERE   JOB_NAME LIKE INSBTC008040.SKEY || '%'
                     AND STATE = 'RUNNING';

            WHILE NJOB_RUNNING > 35 AND NCODERROR = 0
            LOOP
               SLEEP (2);

               SELECT   COUNT ( * )
                 INTO   NJOB_RUNNING
                 FROM   DBA_SCHEDULER_JOBS
                WHERE   JOB_NAME LIKE INSBTC008040.SKEY || '%'
                        AND STATE = 'RUNNING';

               SELECT   COUNT ( * )
                 INTO   NCODERROR
                 FROM   EJECUCION_PROCESOS
                WHERE       SKEY = INSBTC008040.SKEY
                        AND PROCESO = 'ENDOSOMASIVOSUMAASEG'
                        AND ESTADO IN ('ER');
            END LOOP;

            IF NCODERROR != 0
            THEN
               EXIT;
            END IF;
         END LOOP;

         V_CANTIDAD := 0;

         WHILE V_CANTIDAD != V_HILOS_EJECUTADOS
         LOOP
            SELECT   COUNT ( * )
              INTO   V_CANTIDAD
              FROM   EJECUCION_PROCESOS
             WHERE       SKEY = INSBTC008040.SKEY
                     AND PROCESO = 'ENDOSOMASIVOSUMAASEG'
                     AND ESTADO IN ('OK', 'ER');

            SLEEP (60);
         END LOOP;

         SELECT   COUNT ( * )
           INTO   V_CANTIDAD
           FROM   EJECUCION_PROCESOS
          WHERE       SKEY = INSBTC008040.SKEY
                  AND PROCESO = 'ENDOSOMASIVOSUMAASEG'
                  AND ESTADO IN ('ER');

         IF V_CANTIDAD != 0
         THEN
            NCODERROR := -1;
            SMSGERROR := 'Alguno de los hilos cayo en error.';
            VTBATCHPKG.ENDBATCH (SKEY, VTBATCHPKG.NSTAT_ERR);
         ELSE

            VTBATCHPKG.ENDBATCH (SKEY, VTBATCHPKG.NSTAT_OK);

            --EJECUCIÓN DE REPORTE DE SALIDA
            V_SKEY_INTERFAZ := CREATE_SKEY();
            CREBATCH_JOB(V_SKEY_INTERFAZ, 1402, NUSERCODE, 8040);
            VTBATCHPKG.STARTBATCH(V_SKEY_INTERFAZ);            
            INSUDB."CRET_PARAM_INTERFACE" (V_SKEY_INTERFAZ, 1, SKEY, NUSERCODE);
            INSUDB."CREBATCH_PARAM_VALUE" (V_SKEY_INTERFAZ, 1, 1, 1402, 2, NULL, 1, NUSERCODE);
            INSUDB."CREBATCH_PARAM_VALUE" (V_SKEY_INTERFAZ, 1, 2, 1402, 8040, NULL, 1, NUSERCODE);
            INSUDB."CREBATCH_PARAM_VALUE" (V_SKEY_INTERFAZ, 1, 3, 1402, NUSERCODE, NULL, 1, NUSERCODE);
            INSUDB."CREBATCH_PARAM_VALUE" (V_SKEY_INTERFAZ, 1, 4, 1402, V_SKEY_INTERFAZ, NULL, 1, NUSERCODE);
            INSUDB."CREBATCH_PARAM_VALUE" (V_SKEY_INTERFAZ, 1, 5, 1402, NULL, NULL, 1, NUSERCODE);
            INSUDB."CREBATCH_PARAM_VALUE" (V_SKEY_INTERFAZ, 2, 1, 1402, V_SKEY_INTERFAZ, NULL, 1, NUSERCODE);
            INSBTC01402( '2', 8040, NUSERCODE, V_SKEY_INTERFAZ, NULL);
            --FIN EJECUCIÓN DE REPORTE DE SALIDA
            
         END IF;
      END IF;
   ELSE
      VTBATCHPKG.ENDBATCH (SKEY, VTBATCHPKG.NSTAT_ERR);
   END IF;

   INSERT INTO TRACE (
                         ID,
                         PROC,
                         NUSERCODE,
                         TEXT
              )
     VALUES   (
                  TRACE_SEQ.NEXTVAL,
                  'INSBTC008040',
                  3169,
                     'FIN PROCESO INSBTC008040: '
                  || SMSGERROR
                  || ' - '
                  || TO_CHAR (SYSDATE, 'DD/MM/YYYY HH24:MM:SS')
              );

   COMMIT;
END INSBTC008040;