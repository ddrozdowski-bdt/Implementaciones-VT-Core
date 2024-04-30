create or replace PACKAGE        INSUDB.PKG_ENDOSOMASIVOSUMAASEG
AS
   PROCEDURE "COTAS" (SKEY            BATCH_JOB.SKEY%TYPE,
                      NCODERROR   OUT NUMBER,
                      SMSGERROR   OUT VARCHAR2);

   PROCEDURE "MAIN" (SKEY           BATCH_JOB.SKEY%TYPE,
                     NHILO          NUMBER,
                     NCOTA_DESDE    NUMBER,
                     NCOTA_HASTA    NUMBER,
                     NUSERCODE      NUMBER,
                     NDIAS NUMBER);

END PKG_ENDOSOMASIVOSUMAASEG;
/
create or replace PACKAGE BODY        INSUDB.PKG_ENDOSOMASIVOSUMAASEG
AS
   PROCEDURE COTAS (SKEY            BATCH_JOB.SKEY%TYPE,
                    NCODERROR   OUT NUMBER,
                    SMSGERROR   OUT VARCHAR2)
   AS
      CURSOR C_COTAS
      IS
           SELECT   cotas.cota hilo,
                    MIN (cotas.cota_id) desde,
                    MAX (cotas.cota_id) hasta,
                    COUNT (cotas.cota_id) total_hilo
             FROM   (SELECT   datos.cota_id,
                              NTILE (200) OVER (ORDER BY datos.cota_id) AS cota
                       FROM   (  SELECT   nthread cota_id
                                   FROM   timetmp.tmp_vil8040
                                  WHERE   skey = COTAS.SKEY
                               GROUP BY   nthread) datos) cotas
         GROUP BY   cota
         ORDER BY   hilo;
   BEGIN
      NCODERROR := 0;
      SMSGERROR := '';

      FOR V_COTA IN C_COTAS
      LOOP
         INSERT INTO EJECUCION_PROCESOS
           VALUES   (COTAS.SKEY,
                     'ENDOSOMASIVOSUMAASEG',
                     V_COTA.HILO,
                     V_COTA.DESDE,
                     V_COTA.HASTA,
                     V_COTA.TOTAL_HILO,
                     'AP',
                     NULL,
                     NULL);
      END LOOP;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         NCODERROR := SQLCODE;
         SMSGERROR := SUBSTR (SQLERRM, 1, 255);
         ROLLBACK;
   END;

   PROCEDURE MAIN (SKEY           BATCH_JOB.SKEY%TYPE,
                   NHILO          NUMBER,
                   NCOTA_DESDE    NUMBER,
                   NCOTA_HASTA    NUMBER,
                   NUSERCODE      NUMBER,
                   NDIAS NUMBER)
   AS
      CURSOR C
      IS
           SELECT   T.NTHREAD,
                    T.SCERTYPE,
                    T.NBRANCH,
                    T.NPRODUCT,
                    T.NPOLICY,
                    T.NCERTIF,
                    T.DNEXTRECEIP,
                    T.NMODULEC,
                    T.NCOVER,
                    T.NADJUSTMENT,
                    T.NCAPITAL,
                    T.NCAUSE_AMEND,
                    T.NIDSTRUC,
                    T.SBRANCHT
             FROM   TIMETMP.TMP_VIL8040 T
            WHERE       T.SKEY = MAIN.SKEY
                    AND T.NTHREAD >= MAIN.NCOTA_DESDE
                    AND T.NTHREAD <= MAIN.NCOTA_HASTA
         ORDER BY   T.SCERTYPE,
                    T.NBRANCH,
                    T.NPRODUCT,
                    T.NPOLICY,
                    T.NCERTIF;

      CURSOR C_REASYSCOLUMNS (
         SOWNER                     ALL_TABLES.OWNER%TYPE,
         STABLENAME                 VARCHAR2
      )
      IS
         SELECT   COLUMN_NAME
           FROM   ALL_TAB_COLUMNS
          WHERE   ALL_TAB_COLUMNS.TABLE_NAME = C_REASYSCOLUMNS.STABLENAME
                  AND ALL_TAB_COLUMNS.OWNER = C_REASYSCOLUMNS.SOWNER;

      V_NTHREAD                      TIMETMP.TMP_VIL8040.NTHREAD%TYPE;
      V_DEFFECDATE_POLICY_HIS        POLICY_HIS.DEFFECDATE%TYPE;
      V_DEFFECDATE_COVER             COVER.DEFFECDATE%TYPE;
      V_NAMOUNT_AUX                  COVER.NCAPITAL%TYPE;
      V_SPTABLENAME_AUX              TAB_NAME_B.STABNAME%TYPE;
      V_SQUERYTOEXEC                 VARCHAR2 (2000);
      V_DEFFECDATE_PARTICULARTABLE   HOMEOWNER.DEFFECDATE%TYPE;
      V_NRATECOVE_AUX                COVER.NRATECOVE%TYPE;
      V_SSEP                         VARCHAR2 (1);
      V_SSEL                         VARCHAR2 (2000);
      V_SSEL2                        VARCHAR2 (2000);
      V_COLUMN_NAME                  varchar2 (100);
      V_EXISTE_SPECIFIC_RISK_COV     VARCHAR2 (1) := 'N';
      V_NRATE_AUX                    NUMBER (6, 2);
      V_NBRANCH_O                    CERTIFICAT.NBRANCH%TYPE := NULL;
      V_NPRODUCT_O                   CERTIFICAT.NPRODUCT%TYPE := NULL;
      V_NPOLICY_O                    CERTIFICAT.NPOLICY%TYPE := NULL;
      V_NCERTIF_O                    CERTIFICAT.NCERTIF%TYPE := NULL;
      V_NTRANSACTIO_AUX              POLICY.NTRANSACTIO%TYPE;
      V_DEXPIRDAT_AUX                POLICY.DEXPIRDAT%TYPE;
      V_NMOVEMENT_AUX                POLICY_HIS.NMOVEMENT%TYPE;
      V_SSQLERRM                     VARCHAR2 (255);
      V_NOK                          INTEGER := 0;
      V_NCODERROR                    NUMBER (1);
      V_SMSGERROR                    VARCHAR2 (1000);
   --V_NIDCONSEC_AUX                COMMERCIALSTRUCTURE.STRUCEVENT.NIDCONSEC%TYPE;

    -- BDT 20240403 - Declaro variables -TASK 7551-Solucion a Indexaci n de p lizas en interface VIL8040
      NMOVPOLICY_HIS INTEGER := 0;
      DEFFECDATE_COVER_INIHBIR COVER.DEFFECDATE%TYPE;
      NDIAS_INHIBIR INTEGER := 0;
      NCAUSE_AMEND_INHIBIR POLICY_HIS.NCAUSE_AMEND%TYPE;

   BEGIN
      
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY HH24:MI:SS''';

      UPDATE   EJECUCION_PROCESOS
         SET   ESTADO = 'EJ', INICIO_EJECUCION = SYSDATE
       WHERE       HILO = NHILO
               AND PROCESO = 'ENDOSOMASIVOSUMAASEG'
               AND SKEY = MAIN.SKEY;

      COMMIT;

      FOR V IN C
      LOOP
         V_NCODERROR := 0;
         V_SMSGERROR := '';
         V_NTHREAD := V.NTHREAD;

         IF V.SBRANCHT = '1'
         THEN
            --VIDA
            SELECT   DECODE (COUNT ( * ), 0, 1, 0)
              INTO   V_NOK
              FROM   LIFE_COVER
             WHERE       NBRANCH = V.NBRANCH
                     AND NPRODUCT = V.NPRODUCT
                     AND NMODULEC = V.NMODULEC
                     AND NCOVER = V.NCOVER
                     AND DNULLDATE IS NULL;
         ELSIF V.SBRANCHT = '4'
         THEN
            --GENERALES
            SELECT   DECODE (COUNT ( * ), 0, 1, 0)
              INTO   V_NOK
              FROM   GEN_COVER
             WHERE       NBRANCH = V.NBRANCH
                     AND NPRODUCT = V.NPRODUCT
                     AND NMODULEC = V.NMODULEC
                     AND NCOVER = V.NCOVER
                     AND DNULLDATE IS NULL
                     AND (V.NCAPITAL >= NCACALMIN AND V.NCAPITAL <= NCACALMAX);
         ELSE
            V_NOK := 1;
         END IF;

         IF V_NOK = 0
         THEN
            BEGIN
               SELECT   1
                 INTO   V_NOK
                 FROM   POLICY_HIS
                WHERE       SCERTYPE = '2'
                        AND NBRANCH = V.NBRANCH
                        AND NPRODUCT = V.NPRODUCT
                        AND NPOLICY = V.NPOLICY
                        AND NCERTIF = V.NCERTIF
                        AND NTYPE_AMEND = 905
                        AND DEFFECDATE > V.DNEXTRECEIP;

               V_NCODERROR := -1;
               V_SMSGERROR :=
                  'Poliza/Certificado con fecha de endoso anterior al ultimo endoso de suma asegurada realizado.';
            EXCEPTION
               WHEN OTHERS
               THEN
                  V_NOK := 0;
            END;
            
-- BDT 20240403 Control de movimientos - TASK 7551-Solucion a Indexaci n de p lizas en interface VIL8040
            IF V_NOK = 0 THEN
            
                SELECT MAX(DEFFECDATE) 
                INTO DEFFECDATE_COVER_INIHBIR
                FROM COVER 
                WHERE COVER.NBRANCH= V.NBRANCH
                AND COVER.NPRODUCT= V.NPRODUCT
                AND COVER.NPOLICY= V.NPOLICY
                AND COVER.NCERTIF= V.NCERTIF
                AND COVER.DNULLDATE IS NULL
                AND COVER.NCOVER<900;
         
                SELECT COUNT(*)
                INTO NMOVPOLICY_HIS
                FROM POLICY_HIS
                WHERE POLICY_HIS.NBRANCH= V.NBRANCH
                AND POLICY_HIS.NPRODUCT= V.NPRODUCT
                AND POLICY_HIS.NPOLICY= V.NPOLICY
                AND POLICY_HIS.NCERTIF= V.NCERTIF
                AND POLICY_HIS.NMOVEMENT=
                (SELECT MAX(HISTORIA.NMOVEMENT)
                FROM POLICY_HIS HISTORIA
                WHERE POLICY_HIS.SCERTYPE=HISTORIA.SCERTYPE 
                AND POLICY_HIS.NBRANCH = HISTORIA.NBRANCH
                AND POLICY_HIS.NPRODUCT= HISTORIA.NPRODUCT
                AND POLICY_HIS.NPOLICY= HISTORIA.NPOLICY
                AND POLICY_HIS.NCERTIF= HISTORIA.NCERTIF
                AND HISTORIA.NTYPE_HIST IN (11,12)) 
                AND POLICY_HIS.DEFFECDATE= DEFFECDATE_COVER_INIHBIR;
         
         
                IF NMOVPOLICY_HIS<>0 THEN
                    SELECT TO_DATE(SYSDATE)-TO_DATE(DLEDGERDAT) , NCAUSE_AMEND 
                    INTO NDIAS_INHIBIR, NCAUSE_AMEND_INHIBIR
                    FROM POLICY_HIS
                    WHERE POLICY_HIS.NBRANCH= V.NBRANCH
                    AND POLICY_HIS.NPRODUCT= V.NPRODUCT
                    AND POLICY_HIS.NPOLICY= V.NPOLICY
                    AND POLICY_HIS.NCERTIF= V.NCERTIF
                    AND POLICY_HIS.NMOVEMENT=
                    (SELECT MAX(HISTORIA.NMOVEMENT)
                    FROM POLICY_HIS HISTORIA
                    WHERE POLICY_HIS.SCERTYPE=HISTORIA.SCERTYPE 
                    AND POLICY_HIS.NBRANCH = HISTORIA.NBRANCH
                    AND POLICY_HIS.NPRODUCT= HISTORIA.NPRODUCT
                    AND POLICY_HIS.NPOLICY= HISTORIA.NPOLICY
                    AND POLICY_HIS.NCERTIF= HISTORIA.NCERTIF
                    AND HISTORIA.NTYPE_HIST IN (11,12))
                    AND POLICY_HIS.DEFFECDATE= DEFFECDATE_COVER_INIHBIR;
                    
                    
                    IF (NDIAS_INHIBIR <= NDIAS AND NCAUSE_AMEND_INHIBIR<>5)  THEN          
                       V_NCODERROR := -1;
                       V_SMSGERROR :=
                       'Rechazado por endoso reciente - No cambian condiciones';
                       V_NOK := 1;
                    END IF;
                END IF;
            END IF;

            IF V_NOK = 0
            THEN
               BEGIN
                  SELECT   MAX (DEFFECDATE)
                    INTO   V_DEFFECDATE_POLICY_HIS
                    FROM   POLICY_HIS
                   WHERE       SCERTYPE = '2'
                           AND NBRANCH = V.NBRANCH
                           AND NPRODUCT = V.NPRODUCT
                           AND NPOLICY = V.NPOLICY
                           AND NCERTIF = V.NCERTIF
                           AND NTYPE_AMEND = 905;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     V_DEFFECDATE_POLICY_HIS := NULL;
               END;


               BEGIN
                  IF V.DNEXTRECEIP >=
                        NVL (V_DEFFECDATE_POLICY_HIS, '01/01/1900')
                  THEN
                     BEGIN
                        SELECT   DEFFECDATE, NCAPITAL
                          INTO   V_DEFFECDATE_COVER, V_NAMOUNT_AUX
                          FROM   COVER
                         WHERE       SCERTYPE = '2'
                                 AND NBRANCH = V.NBRANCH
                                 AND NPRODUCT = V.NPRODUCT
                                 AND NPOLICY = V.NPOLICY
                                 AND NCERTIF = V.NCERTIF
                                 AND NCOVER = V.NCOVER
                                 AND NMODULEC = V.NMODULEC
                                 AND DEFFECDATE <= V.DNEXTRECEIP
                                 AND (DNULLDATE IS NULL
                                      OR DNULLDATE > V.DNEXTRECEIP);
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           V_DEFFECDATE_COVER := NULL;
                           V_NAMOUNT_AUX := NULL;
                     END;

                     IF V.DNEXTRECEIP <> V_DEFFECDATE_COVER
                     THEN
                        BEGIN
                           UPDATE   COVER
                              SET   DNULLDATE = V.DNEXTRECEIP,
                                    NUSERCODE = MAIN.NUSERCODE,
                                    DCOMPDATE = SYSDATE
                            WHERE       SCERTYPE = '2'
                                    AND NBRANCH = V.NBRANCH
                                    AND NPRODUCT = V.NPRODUCT
                                    AND NPOLICY = V.NPOLICY
                                    AND NCERTIF = V.NCERTIF
                                    AND NCOVER = V.NCOVER
                                    AND NMODULEC = V.NMODULEC
                                    AND DEFFECDATE <= V.DNEXTRECEIP
                                    AND (DNULLDATE IS NULL
                                         OR DNULLDATE > V.DNEXTRECEIP);

                           INSERT INTO COVER (SCERTYPE,
                                              NBRANCH,
                                              NPRODUCT,
                                              NPOLICY,
                                              NCERTIF,
                                              NGROUP_INSU,
                                              NMODULEC,
                                              NCOVER,
                                              DEFFECDATE,
                                              SCLIENT,
                                              NROLE,
                                              NCAPITAL,
                                              SCHANGE,
                                              DCOMPDATE,
                                              SFRANDEDI,
                                              NCURRENCY,
                                              NPREMIUM,
                                              NRATE,
                                              NRATECOVE,
                                              NUSERCODE,
                                              SWAIT_TYPE,
                                              DANIVERSARY,
                                              DSEEKTAR,
                                              NRETARIF,
                                              NRATECOVE_O,
                                              NRECAMOUNT,
                                              NCOMMI_AN,
                                              NRATECOVE_B,
                                              DNULLDATE,
                                              NREVALTYPE)
                              SELECT   SCERTYPE,
                                       NBRANCH,
                                       NPRODUCT,
                                       NPOLICY,
                                       NCERTIF,
                                       NGROUP_INSU,
                                       NMODULEC,
                                       NCOVER,
                                       V.DNEXTRECEIP,
                                       SCLIENT,
                                       NROLE,
                                       V.NCAPITAL,
                                       SCHANGE,
                                       SYSDATE,
                                       SFRANDEDI,
                                       NCURRENCY,
                                       (V.NCAPITAL * NRATECOVE / 1000)
                                          AS NPREMIUM,
                                       NRATE,
                                       NRATECOVE,
                                       NUSERCODE,
                                       SWAIT_TYPE,
                                       DANIVERSARY,
                                       DSEEKTAR,
                                       NRETARIF,
                                       NRATECOVE_O,
                                       NRECAMOUNT,
                                       NCOMMI_AN,
                                       NRATECOVE_B,
                                       NULL,
                                       NREVALTYPE
                                FROM   COVER COV
                               WHERE       SCERTYPE = '2'
                                       AND COV.NBRANCH = V.NBRANCH
                                       AND COV.NPRODUCT = V.NPRODUCT
                                       AND COV.NPOLICY = V.NPOLICY
                                       AND COV.NCERTIF = V.NCERTIF
                                       AND COV.NCOVER = V.NCOVER
                                       AND COV.NMODULEC = V.NMODULEC
                                       AND DNULLDATE = V.DNEXTRECEIP;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              V_NCODERROR := -2;
                              V_SMSGERROR := SUBSTR (SQLERRM, 1, 255);
                        END;
                     ELSE
                        BEGIN
                           UPDATE   COVER
                              SET   NCAPITAL = V.NCAPITAL,
                                    NUSERCODE = MAIN.NUSERCODE,
                                    DCOMPDATE = SYSDATE,
                                    NPREMIUM =
                                       (V.NCAPITAL * NRATECOVE / 1000)
                            /*se agrega actualizacion del npremium*/
                            WHERE       SCERTYPE = '2'
                                    AND NBRANCH = V.NBRANCH
                                    AND NPRODUCT = V.NPRODUCT
                                    AND NPOLICY = V.NPOLICY
                                    AND NCERTIF = V.NCERTIF
                                    AND NCOVER = V.NCOVER
                                    AND NMODULEC = V.NMODULEC
                                    AND DEFFECDATE <= V.DNEXTRECEIP
                                    AND (DNULLDATE IS NULL
                                         OR DNULLDATE > V.DNEXTRECEIP);
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              V_NCODERROR := -3;
                              V_SMSGERROR := SUBSTR (SQLERRM, 1, 255);
                        END;
                     END IF;

                     --BUSCAR TABLA PARTICULAR

                     BEGIN
                        SELECT   TB.STABNAME
                          INTO   V_SPTABLENAME_AUX
                          FROM   TAB_NAME_B TB
                         WHERE   TB.NBRANCH = V.NBRANCH;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           V_SPTABLENAME_AUX := 'NULL';
                     END;

                     V_SQUERYTOEXEC :=
                        'SELECT DEFFECDATE
                          FROM '
                        || V_SPTABLENAME_AUX
                        || '
                         WHERE SCERTYPE = ''2'' 
                         AND NBRANCH = :NBRANCH
                           AND NPRODUCT = :NPRODUCT
                           AND NPOLICY = :NPOLICY
                           AND NCERTIF = :NCERTIF
                            AND DEFFECDATE <= :DEFFECDATE
                                                     AND (DNULLDATE IS NULL
                                                      OR DNULLDATE >:DEFFECDATE)';

                     -- PARTICULAR TABLE
                     BEGIN
                        EXECUTE IMMEDIATE V_SQUERYTOEXEC
                           INTO   V_DEFFECDATE_PARTICULARTABLE
                           USING V.NBRANCH,
                                 V.NPRODUCT,
                                 V.NPOLICY,
                                 V.NCERTIF,
                                 V.DNEXTRECEIP,
                                 V.DNEXTRECEIP;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           V_DEFFECDATE_PARTICULARTABLE := NULL;
                     END;

                     /* se agrega: buscar el nrate para actualizar el npremium en theft*/
                     BEGIN
                        SELECT   NRATECOVE
                          INTO   V_NRATECOVE_AUX
                          FROM   COVER
                         WHERE       SCERTYPE = '2'
                                 AND NBRANCH = V.NBRANCH
                                 AND NPRODUCT = V.NPRODUCT
                                 AND NPOLICY = V.NPOLICY
                                 AND NCERTIF = V.NCERTIF
                                 AND NCOVER = V.NCOVER
                                 AND DEFFECDATE <= V.DNEXTRECEIP
                                 AND (DNULLDATE IS NULL
                                      OR DNULLDATE > V.DNEXTRECEIP);
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           V_NRATECOVE_AUX := 0;
                     END;

                     IF V.DNEXTRECEIP <> V_DEFFECDATE_PARTICULARTABLE
                     THEN
                        BEGIN
                           V_SQUERYTOEXEC :=
                              'UPDATE ' || V_SPTABLENAME_AUX
                              || ' SET DNULLDATE = :DEFFECDATE,
                                                             NUSERCODE = :NUSERCODE,
                                                             DCOMPDATE = SYSDATE
                                                       WHERE SCERTYPE = ''2''
                                                         AND NBRANCH = :NBRANCH
                                                         AND NPRODUCT = :NPRODUCT
                                                         AND NPOLICY = :NPOLICY
                                                         AND NCERTIF  = :NCERTIF
                                                         AND DEFFECDATE <= :DEFFECDATE
                                                         AND (DNULLDATE IS NULL
                                                          OR DNULLDATE > :DEFFECDATE)';

                           EXECUTE IMMEDIATE V_SQUERYTOEXEC
                              USING V.DNEXTRECEIP,
                                    MAIN.NUSERCODE,
                                    V.NBRANCH,
                                    V.NPRODUCT,
                                    V.NPOLICY,
                                    V.NCERTIF,
                                    V.DNEXTRECEIP,
                                    V.DNEXTRECEIP;

                           V_SSEP := ' ';
                           V_SSEL := NULL;
                           V_SSEL2 := NULL;
                OPEN C_REASYSCOLUMNS(UPPER('INSUDB'),
                                                                                                                                                                                                                                                                                                                                                                   TRIM
      (V_SPTABLENAME_AUX));

                           LOOP
                              FETCH C_REASYSCOLUMNS INTO   V_COLUMN_NAME;

                              EXIT WHEN C_REASYSCOLUMNS%NOTFOUND;
                              V_SSEL := V_SSEL || V_SSEP || V_COLUMN_NAME;

                              IF V_COLUMN_NAME = 'DEFFECDATE'
                              THEN
                                 V_SSEL2 :=
                                       V_SSEL2
                                    || V_SSEP
                                    || 'STDATE('''
                                    || DTCHAR (V.DNEXTRECEIP)
                                    || ''')';
                              ELSIF V_COLUMN_NAME = 'DCOMPDATE'
                              THEN
                                 V_SSEL2 :=
                                       V_SSEL2
                                    || V_SSEP
                                    || 'STDATE('''
                                    || DTCHAR (SYSDATE)
                                    || ''')';
                              ELSIF V_COLUMN_NAME = 'DNULLDATE'
                              THEN
                                 V_SSEL2 := V_SSEL2 || V_SSEP || 'NULL';
                              ELSIF V_COLUMN_NAME = 'NCAPITAL'
                              THEN
                                 V_SSEL2 :=
                                    V_SSEL2 || V_SSEP
                                    || REPLACE (
                                          TO_CHAR (NVL (V.NCAPITAL, 0)),
                                          ',',
                                          '.'
                                       );
                              ELSIF V_COLUMN_NAME = 'NPREMIUM'
                              THEN
                                 V_SSEL2 :=
                                    V_SSEL2 || V_SSEP
                                    || REPLACE (
                                          TO_CHAR(NVL (
                                                     (  V.NCAPITAL
                                                      * V_NRATECOVE_AUX
                                                      / 1000),
                                                     0
                                                  )),
                                          ',',
                                          '.'
                                       );
                              ELSIF V_COLUMN_NAME = 'NUSERCODE'
                              THEN
                                 V_SSEL2 :=
                                       V_SSEL2
                                    || V_SSEP
                                    || TO_CHAR (MAIN.NUSERCODE);
                              ELSE
                                 V_SSEL2 := V_SSEL2 || V_SSEP || V_COLUMN_NAME;
                              END IF;

                              V_SSEP := ',';
                           END LOOP;

                           CLOSE C_REASYSCOLUMNS;

                           V_SSEL :=
                                 'INSERT INTO '
                              || V_SPTABLENAME_AUX
                              || '('
                              || V_SSEL
                              || ') ';
                           V_SSEL2 :=
                                 'SELECT /*+ INDEX ( '
                              || V_SPTABLENAME_AUX
                              || ' XPK'
                              || V_SPTABLENAME_AUX
                              || ') */ '
                              || V_SSEL2
                              || ' FROM '
                              || V_SPTABLENAME_AUX
                              || '  WHERE SCERTYPE    = ''2'''
                              || '    AND NBRANCH     = '
                              || TO_CHAR (V.NBRANCH)
                              || '    AND NPRODUCT    = '
                              || TO_CHAR (V.NPRODUCT)
                              || '    AND NPOLICY     = '
                              || TO_CHAR (V.NPOLICY)
                              || '    AND NCERTIF     = '
                              || TO_CHAR (V.NCERTIF)
                              || '    AND DNULLDATE =  TO_DATE('
                              || ''''
                              || TO_CHAR (V.DNEXTRECEIP, 'DD/MM/YYYY')
                              || ''''
                              || ','''
                              || 'DD/MM/YYYY'
                              || ''')';

                           EXECUTE IMMEDIATE (V_SSEL || V_SSEL2);
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              V_NCODERROR := -4;
                              V_SMSGERROR := SUBSTR (SQLERRM, 1, 255);
                        END;
                     ELSE
                        BEGIN
                           V_SQUERYTOEXEC :=
                              'UPDATE ' || V_SPTABLENAME_AUX
                              || ' SET NCAPITAL = :NCAPITAL,
                                                         NUSERCODE = :NUSERCODE,
                                                         DCOMPDATE = SYSDATE,
                                                   NPREMIUM  = (:NCAPITAL * :NRATECOVE_AUX / 1000)   
                                                   WHERE SCERTYPE = ''2''
                                                     AND NBRANCH = :NBRANCH
                                                     AND NPRODUCT = :NPRODUCT
                                                     AND NPOLICY = :NPOLICY
                                                     AND NCERTIF  = :NCERTIF
                                                     AND DEFFECDATE <= :DEFFECDATE
                                                     AND (DNULLDATE IS NULL
                                                     OR DNULLDATE > :DEFFECDATE)';

                           EXECUTE IMMEDIATE V_SQUERYTOEXEC
                              USING V.NCAPITAL,
                                    MAIN.NUSERCODE,
                                    V.NCAPITAL,
                                    MAIN.V_NRATECOVE_AUX,
                                    V.NBRANCH,
                                    V.NPRODUCT,
                                    V.NPOLICY,
                                    V.NCERTIF,
                                    V.DNEXTRECEIP,
                                    V.DNEXTRECEIP;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              V_NCODERROR := -5;
                              V_SMSGERROR := SUBSTR (SQLERRM, 1, 255);
                        END;
                     END IF;

                     BEGIN
                        SELECT   'S'
                          INTO   V_EXISTE_SPECIFIC_RISK_COV
                          FROM   SPECIFIC_RISK_COV
                         WHERE       SCERTYPE = '2'
                                 AND NBRANCH = V.NBRANCH
                                 AND NPRODUCT = V.NPRODUCT
                                 AND NPOLICY = V.NPOLICY
                                 AND NCERTIF = V.NCERTIF
                                 AND NCOVER = V.NCOVER
                                 AND NMODULEC = V.NMODULEC
                                 AND ROWNUM <= 1;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           V_EXISTE_SPECIFIC_RISK_COV := 'N';
                     END;

                     IF V_EXISTE_SPECIFIC_RISK_COV = 'S'
                     THEN
                        V_NRATE_AUX :=
                           NVL (V.NCAPITAL, 1) / NVL (V_NAMOUNT_AUX, 1);

                        BEGIN
                           FOR X
                           IN (SELECT   DEFFECDATE, NITEMRISK
                                 FROM   SPECIFIC_RISK_COV
                                WHERE       SCERTYPE = '2'
                                        AND NBRANCH = V.NBRANCH
                                        AND NPRODUCT = V.NPRODUCT
                                        AND NPOLICY = V.NPOLICY
                                        AND NCERTIF = V.NCERTIF
                                        AND NCOVER = V.NCOVER
                                        AND NMODULEC = V.NMODULEC
                                        AND DEFFECDATE <= V.DNEXTRECEIP
                                        AND (DNULLDATE IS NULL
                                             OR DNULLDATE > V.DNEXTRECEIP))
                           LOOP
                              IF V.DNEXTRECEIP <> X.DEFFECDATE
                              THEN
                                 BEGIN
                                    UPDATE   SPECIFIC_RISK_COV
                                       SET   DNULLDATE = V.DNEXTRECEIP,
                                             NUSERCODE = MAIN.NUSERCODE,
                                             DCOMPDATE = SYSDATE
                                     WHERE       SCERTYPE = '2'
                                             AND NBRANCH = V.NBRANCH
                                             AND NPRODUCT = V.NPRODUCT
                                             AND NPOLICY = V.NPOLICY
                                             AND NCERTIF = V.NCERTIF
                                             AND NCOVER = V.NCOVER
                                             AND NITEMRISK = X.NITEMRISK
                                             AND NMODULEC = V.NMODULEC
                                             AND DEFFECDATE <= V.DNEXTRECEIP
                                             AND (DNULLDATE IS NULL
                                                  OR DNULLDATE >
                                                       V.DNEXTRECEIP);

                                    INSERT INTO SPECIFIC_RISK_COV (SCERTYPE,
                                                                   NBRANCH,
                                                                   NPRODUCT,
                                                                   NPOLICY,
                                                                   NCERTIF,
                                                                   NGROUP_INSU,
                                                                   NMODULEC,
                                                                   NCOVER,
                                                                   SCLIENT,
                                                                   DEFFECDATE,
                                                                   NRISKTYPE,
                                                                   NITEMRISK,
                                                                   NCAPITAL,
                                                                   NCURRENCY,
                                                                   NRESERVERISK,
                                                                   SINDEXCLUDE_RISK,
                                                                   SINDAFFECTED_RISK,
                                                                   SDESCRIPTION,
                                                                   DCOMPDATE,
                                                                   NUSERCODE,
                                                                   DNULLDATE)
                                       SELECT   SCERTYPE,
                                                NBRANCH,
                                                NPRODUCT,
                                                NPOLICY,
                                                NCERTIF,
                                                NGROUP_INSU,
                                                NMODULEC,
                                                NCOVER,
                                                SCLIENT,
                                                V.DNEXTRECEIP,
                                                NRISKTYPE,
                                                NITEMRISK,
                                                NCAPITAL * V_NRATE_AUX,
                                                NCURRENCY,
                                                NRESERVERISK,
                                                SINDEXCLUDE_RISK,
                                                SINDAFFECTED_RISK,
                                                SDESCRIPTION,
                                                SYSDATE,
                                                NUSERCODE,
                                                NULL
                                         FROM   SPECIFIC_RISK_COV COV
                                        WHERE       SCERTYPE = '2'
                                                AND COV.NBRANCH = V.NBRANCH
                                                AND COV.NPRODUCT = V.NPRODUCT
                                                AND COV.NPOLICY = V.NPOLICY
                                                AND COV.NCERTIF = V.NCERTIF
                                                AND COV.NCOVER = V.NCOVER
                                                AND NMODULEC = V.NMODULEC
                                                AND COV.NITEMRISK =
                                                      X.NITEMRISK
                                                AND DNULLDATE = V.DNEXTRECEIP;
                                 EXCEPTION
                                    WHEN OTHERS
                                    THEN
                                       V_NCODERROR := -6;
                                       V_SMSGERROR := SUBSTR (SQLERRM, 1, 255);
                                 END;
                              ELSE
                                 BEGIN
                                    UPDATE   SPECIFIC_RISK_COV
                                       SET   NCAPITAL = NCAPITAL * V_NRATE_AUX,
                                             NUSERCODE = MAIN.NUSERCODE,
                                             DCOMPDATE = SYSDATE
                                     WHERE       SCERTYPE = '2'
                                             AND NBRANCH = V.NBRANCH
                                             AND NPRODUCT = V.NPRODUCT
                                             AND NPOLICY = V.NPOLICY
                                             AND NCERTIF = V.NCERTIF
                                             AND NCOVER = V.NCOVER
                                             AND NMODULEC = V.NMODULEC
                                             AND NITEMRISK = X.NITEMRISK
                                             AND DEFFECDATE <= V.DNEXTRECEIP
                                             AND (DNULLDATE IS NULL
                                                  OR DNULLDATE >
                                                       V.DNEXTRECEIP);
                                 END;
                              END IF;
                           END LOOP;
                        END;
                     END IF;
                  END IF;
               END;

               IF NOT (    NVL (V_NBRANCH_O, 0) = V.NBRANCH
                       AND NVL (V_NPRODUCT_O, 0) = V.NPRODUCT
                       AND NVL (V_NPOLICY_O, 0) = V.NPOLICY
                       AND NVL (V_NCERTIF_O, 0) = V.NCERTIF)
               THEN
                  V_NBRANCH_O := V.NBRANCH;
                  V_NPRODUCT_O := V.NPRODUCT;
                  V_NPOLICY_O := V.NPOLICY;
                  V_NCERTIF_O := V.NCERTIF;

                  /*SE ACTUALIZA EL NUMERO DE TRANSACCION EN EJECUCION EN LA TABLA DE INFORMACION GENERAL DE UNA POLIZA (POLICY.NTRANSACTIO)*/
                  BEGIN
                     SELECT   NTRANSACTIO + 1, DEXPIRDAT
                       INTO   V_NTRANSACTIO_AUX, V_DEXPIRDAT_AUX
                       FROM   POLICY
                      WHERE       SCERTYPE = '2'
                              AND NBRANCH = V.NBRANCH
                              AND NPRODUCT = V.NPRODUCT
                              AND NPOLICY = V.NPOLICY;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        V_DEXPIRDAT_AUX := NULL;
                        V_NTRANSACTIO_AUX := NULL;
                  END;

                  BEGIN
                     UPDATE   POLICY POL
                        SET   POL.NTRANSACTIO = V_NTRANSACTIO_AUX,
                              POL.DCHANGDAT = V.DNEXTRECEIP
                      WHERE       POL.SCERTYPE = '2'
                              AND POL.NBRANCH = V.NBRANCH
                              AND POL.NPRODUCT = V.NPRODUCT
                              AND POL.NPOLICY = V.NPOLICY;
                  END;

                  /*SE AGREGA UN REGISTRO EN LA TABLA DE HISTORIA DE UNA POLIZA (POLICY_HIS) */
                  BEGIN
                     BEGIN
                        SELECT   MAX (NMOVEMENT) + 1
                          INTO   V_NMOVEMENT_AUX
                          FROM   POLICY_HIS
                         WHERE       SCERTYPE = '2'
                                 AND NBRANCH = V.NBRANCH
                                 AND NPRODUCT = V.NPRODUCT
                                 AND NPOLICY = V.NPOLICY
                                 AND NCERTIF = V.NCERTIF;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           V_NMOVEMENT_AUX := 1;
                     END;

                     BEGIN
                        INSERT INTO POLICY_HIS (SCERTYPE,
                                                NBRANCH,
                                                NPRODUCT,
                                                NPOLICY,
                                                NCERTIF,
                                                NMOVEMENT,
                                                NTRANSACTIO,
                                                DCOMPDATE,
                                                NUSERCODE,
                                                NCURRENCY,
                                                DEFFECDATE,
                                                NTYPE_HIST,
                                                DLEDGERDAT,
                                                NTYPE_AMEND,
                                                DNULLDATE,
                                                NCAUSE_AMEND)
                          VALUES   ('2',
                                    V.NBRANCH,
                                    V.NPRODUCT,
                                    V.NPOLICY,
                                    V.NCERTIF,
                                    V_NMOVEMENT_AUX,
                                    V_NTRANSACTIO_AUX,
                                    SYSDATE,
                                    MAIN.NUSERCODE,
                                    1,
                                    V.DNEXTRECEIP,
                                    DECODE (V.NCERTIF, 0, 11, 12),
                                    TRUNC (SYSDATE),
                                    905,
                                    V_DEXPIRDAT_AUX,
                                    V.NCAUSE_AMEND);
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           V_NCODERROR := -7;
                           V_SMSGERROR := SUBSTR (SQLERRM, 1, 255);
                     END;
                  END;
                  /*
                                                   BEGIN
                                    SELECT   MAX (NIDCONSEC) + 1
                                      INTO   V_NIDCONSEC_AUX
                                      FROM   COMMERCIALSTRUCTURE.STRUCEVENT;
                                 EXCEPTION
                                    WHEN OTHERS
                                    THEN
                                       V_NIDCONSEC_AUX := 1;
                                 END;
                  */
                  BEGIN
                     SELECT   MAX (NMOVEMENT)
                       INTO   V_NMOVEMENT_AUX
                       FROM   POLICY_HIS
                      WHERE       SCERTYPE = '2'
                              AND NBRANCH = V.NBRANCH
                              AND NPRODUCT = V.NPRODUCT
                              AND NPOLICY = V.NPOLICY
                              AND NCERTIF = V.NCERTIF
                              AND NTYPE_AMEND = 905
                              AND DEFFECDATE = V.DNEXTRECEIP
                              AND NTYPE_HIST = DECODE (V.NCERTIF, 0, 11, 12)
                              AND NCAUSE_AMEND = V.NCAUSE_AMEND;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        V_NMOVEMENT_AUX := 1;
                  END;

                  BEGIN
                     INSERT INTO COMMERCIALSTRUCTURE.STRUCEVENT (
                                                                    NIDSTRUC,
                                                                    NRECOWNER,
                                                                    NIDCONSEC,
                                                                    DEFFECDATE,
                                                                    SCLIENT,
                                                                    SCERTYPE,
                                                                    NBRANCH,
                                                                    NPRODUCT,
                                                                    NPOLICY,
                                                                    NCERTIF,
                                                                    NMOVEMENT,
                                                                    NCLAIM,
                                                                    NCASE_NUM,
                                                                    NDEMAN_TYPE,
                                                                    NENTRYCHANNEL,
                                                                    NCOMMSET,
                                                                    NPERIOD,
                                                                    SKEY,
                                                                    DCOMPDATE,
                                                                    NUSERCODE
                                )
                       VALUES   (V.NIDSTRUC,
                                 '2',
                                 INSUDB.SEQ_STRUCEVENT_IDCONSEC.NEXTVAL,
                                 V.DNEXTRECEIP,
                                 NULL,                          --SCLIENT_AUX,
                                 '2',
                                 V.NBRANCH,
                                 V.NPRODUCT,
                                 V.NPOLICY,
                                 V.NCERTIF,
                                 V_NMOVEMENT_AUX,
                                 NULL,
                                 NULL,
                                 NULL,
                                 NULL,
                                 NULL,
                                 NULL,
                                 NULL,
                                 SYSDATE,
                                 MAIN.NUSERCODE);
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        V_NCODERROR := -8;
                        V_SMSGERROR := SUBSTR (SQLERRM, 1, 255);
                  END;
               END IF;
            END IF;
         ELSE
            V_NCODERROR := -9;
            V_SMSGERROR :=
               'La suma asegurada no se encuentra entre el minimo y maximo configurado para la cobertura.';
         END IF;

         UPDATE   TIMETMP.TMP_VIL8040
            SET   NCODERROR = V_NCODERROR, SMSGERROR = V_SMSGERROR
          WHERE       SKEY = MAIN.SKEY
                  AND NTHREAD = V.NTHREAD
                  AND NCOVER = V.NCOVER
                  AND NMODULEC = V.NMODULEC;

         COMMIT;
      END LOOP;

      UPDATE   EJECUCION_PROCESOS
         SET   ESTADO = 'OK', FIN_EJECUCION = SYSDATE
       WHERE       HILO = MAIN.NHILO
               AND PROCESO = 'ENDOSOMASIVOSUMAASEG'
               AND SKEY = MAIN.SKEY;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;

         UPDATE   EJECUCION_PROCESOS
            SET   ESTADO = 'ER', FIN_EJECUCION = SYSDATE
          WHERE       HILO = MAIN.NHILO
                  AND PROCESO = 'ENDOSOMASIVOSUMAASEG'
                  AND SKEY = MAIN.SKEY;

         COMMIT;

         V_SSQLERRM := SUBSTR (SQLERRM, 1, 255);

         INSERT INTO TRACE (
                               ID,
                               PROC,
                               NUSERCODE,
                               TEXT
                    )
           VALUES   (
                        TRACE_SEQ.NEXTVAL,
                        'ENDOSOMASIVOSUMAASEG',
                        MAIN.NUSERCODE,
                           'SKEY: '
                        || MAIN.SKEY
                        || ' - HILO: '
                        || MAIN.NHILO
                        || ' - NTHREAD: '
                        || V_NTHREAD
                    );


         INSERT INTO TRACE (ID,
                            PROC,
                            NUSERCODE,
                            TEXT)
           VALUES   (TRACE_SEQ.NEXTVAL,
                     'ENDOSOMASIVOSUMAASEG',
                     MAIN.NUSERCODE,
                     'SQLERRM: ' || V_SSQLERRM);

         COMMIT;
   END;
END PKG_ENDOSOMASIVOSUMAASEG;