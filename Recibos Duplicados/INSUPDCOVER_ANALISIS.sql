create or replace PROCEDURE       INSUDB.INSUPDCOVER
/*---------------------------------------------------------------------------------------*/
/* NOMBRE    : INSUPDCOVER                                                              */
/* OBJETIVO  : ACTUALIZA LA INFORMACION EN LAS TABLAS DE COBERTURAS DE UNA POLIZA        */
/* PARAMETROS:  1 - SCERTYPE     : TIPO DE REGISTRO                                      */
/*              2 - NBRANCH      : CODIGO DEL RAMO                                       */
/*              3 - NPRODUCT     : CODIGO DEL PRODUCTO                                   */
/*              4 - NPOLICY      : NUMERO DE POLIZA                                      */
/*              5 - NCERTIF      : NUMERO DE CERTIFICADO                                 */
/*              6 - NGROUP_INSU  : CODIGO DEL GRUPO ASEGURADO                            */
/*              7 - NMODULEC     : CODIGO DEL MODULO                                     */
/*              8 - NCOVER       : CODIGO DE LA COBERTURA                                */
/*              9 - DEFFECDATE   : FECHA DE EFECTO DE LA TRANSACCION                     */
/*             11 - NCAPITAL     : IMPORTE DE CAPITAL                                    */
/*             12 - NCAPITALI    : IMPORTE DE CAPITAL ASEGURADO INICIAL DE LA COBERTURA  */
/*             13 - SCHANGE      : INDICADOR DE CAMBIO DE LA COBERTURA                   */
/*             14 - NCURRENCY    : CODIGO DE LA MONEDA                                   */
/*             15 - NDISCOUNT    : PORCENTAJE DE DESCUENTO POR CONCEPTO DE FRANQ/DED     */
/*             16 - NFIXAMOUNT   : IMPORTE FIJO DE FRANQUICIA O DEDUCIBLE                */
/*             17 - SFRANDEDI    : CODIGO DEL INDICADOR DE FRANQUICIA O DEDUCIBLE        */
/*             18 - NMAXAMOUNT   : IMPORTE MAXIMO DE FRANQUICIA O DEDUCIBLE              */
/*             19 - SFREE_PREMI  : COBERTURA LIBERADA DEL PAGO DE PRIMAS                 */
/*             20 - NMINAMOUNT   : IMPORTE MINIMO DE FRANQUICIA O DEDUCIBLE              */
/*             21 - NPREMIUM     : IMPORTE DE PRIMA                                      */
/*             22 - NRATE        : PORCENTAJE DE FRANQUICIA/DEDUCIBLE A APLICAR          */
/*             23 - NWAIT_QUAN   : CANTIDAD DE DIAS/HORAS/MESES DEL PLAZO DE ESPERA      */
/*             24 - NRATECOVE    : TASA POR MIL (O/OO) DE CALCULO DE PRIMA DE LA  COB.   */
/*             25 - NUSERCODE    : CODIGO DEL USUARIO                                    */
/*             26 - SWAIT_TYPE   : CODIGO DEL TIPO DE PERIODO DE CARENCIA                */
/*             27 - SFRANCAPL    : INDICADOR DE APLICACION DE FRANQUICIA O DEDUCIBLE     */
/*             28 - NDISC_AMOUN  : IMPORTE DE DESCUENTO POR FRANQUICIA/DEDUCIBLE         */
/*             29 - NACTION      : INDICA LA ACCION A EJECUTAR SOBRE LA TABLA            */
/*             30 - SPOLITYPE    : TIPO DE POLIZA                                        */
/*             31 - NGROUP       : CODIGO DEL GRUPO ASEGURADO                            */
/*             32 - STRANSACTION : TIPO DE TRANSACCION DE POLIZA                         */
/*             33 - DNULLDATE    : FECHA DE ANULACION                                    */
/*             34 - NROLE        : CODIGO DE LA FIGURA                                   */
/*             35 - SCLIENT      : CODIGO DEL CLIENTE                                    */
/*             36 - NCAPITAL_WAIT: IMPORTE DE CAPITA SOLICITADO ASOCIADO AL ASEGURADO    */
/*             37 - NAGEMININS   : EDAD MINIMA DE CONTRATACION PARA LA FIGURA            */
/*             38 - NAGEMAXINS   : EDAD MAXIMA DE CONTRATACION PARA LA FIGURA            */
/*             39 - NAGEMAXPER   : EDAD MAXIMA DE PERMANENCIA                            */
/*             40 - NTYPDURINS   : TIPO DE DURACION DEL SEGURO                           */
/*             41 - NDURINSUR    : DURACION DEL SEGURO                                   */
/*             42 - NTYPDURPAY   : TIPO DE DURACION DE LOS PAGOS                         */
/*             43 - NDURPAY      : DURACION DE LOS PAGOS                                 */
/*             44 - SBRANCHT     : CODIGO DEL RAMO TECNICO                               */
/*             45 - NPRODCLAS    : DURACION DE LOS PAGOS                                 */
/*             46 - DANIVERSARY  : FECHA DE ANIVERSARIO DE LA COBERTURA                  */
/*             47 - DSEEKTAR     : FECHA DE BUSQUEDA DE LA TARIFA                        */
/*             48 - NRETARIF     : TIPO DE RETARIFICACION DE UNA COBERTURA               */
/*             49 - NBRANCH_REI  : RAMO DE REASEGURO ASOCIADO A LA COBERTURA             */
/*             50 - NCAUSEUPD    : CAUSA DE MODIFICACION DE LA COBERTURA                 */
/*             51 - DFER         : FECHA DEL ENDOSO RETROACTIVO                          */
/*             52 - NUPDCOVER    : RETORNA SI LA COBERTURA SE ACTUALIZO                  */
/*             53 - NCOMMIT      : INDICADOR DE COMMIT 1-SI 2-NO                         */
/*             54 - NCAPITAL_O   : CAPITAL ORIGEN CALCULADO                              */
/*             55 - NPREMIUM_O   : PRIMA ORIGEN CALCULADA                                */
/*             56 - NRATECOVE_O  : TASA ORIGEN CALCULADA                                 */
/*                                                                                       */
/* SOURCESAFE INFORMATION                                                                */
/*     $Author:: Jsarabia       $                                                        */
/*     $Date:: 7-08-09 12:23    $                                                        */
/*     $Revision:: 2            $                                                        */
/*---------------------------------------------------------------------------------------*/
    (SCERTYPE      COVER.SCERTYPE%TYPE,
     NBRANCH       COVER.NBRANCH%TYPE,
     NPRODUCT      COVER.NPRODUCT%TYPE,
     NPOLICY       COVER.NPOLICY%TYPE,
     NCERTIF       COVER.NCERTIF%TYPE,
     NGROUP_INSU   COVER.NGROUP_INSU%TYPE,
     NMODULEC      COVER.NMODULEC%TYPE,
     NCOVER        COVER.NCOVER%TYPE,
     DEFFECDATE    COVER.DEFFECDATE%TYPE,
     NCAPITAL      COVER.NCAPITAL%TYPE,
     NCAPITALI     COVER.NCAPITALI%TYPE,
     SCHANGE       COVER.SCHANGE%TYPE,
     NCURRENCY     COVER.NCURRENCY%TYPE,
     NDISCOUNT     COVER.NDISCOUNT%TYPE,
     NFIXAMOUNT    COVER.NFIXAMOUNT%TYPE,
     SFRANDEDI     COVER.SFRANDEDI%TYPE,
     NMAXAMOUNT    COVER.NMAXAMOUNT%TYPE,
     SFREE_PREMI   COVER.SFREE_PREMI%TYPE,
     NMINAMOUNT    COVER.NMINAMOUNT%TYPE,
     NPREMIUM      COVER.NPREMIUM%TYPE,
     NRATE         COVER.NRATE%TYPE,
     NWAIT_QUAN    COVER.NWAIT_QUAN%TYPE,
     NRATECOVE     COVER.NRATECOVE%TYPE,
     NUSERCODE     COVER.NUSERCODE%TYPE,
     SWAIT_TYPE    COVER.SWAIT_TYPE%TYPE,
     SFRANCAPL     COVER.SFRANCAPL%TYPE,
     NDISC_AMOUN   COVER.NDISC_AMOUN%TYPE,
     NACTION       IN OUT INTEGER ,
     SPOLITYPE     POLICY.SPOLITYPE%TYPE,
     NGROUP        COVER.NGROUP_INSU%TYPE,
     STRANSACTION  VARCHAR2  DEFAULT '1',
     DNULLDATE     COVER.DNULLDATE%TYPE DEFAULT NULL,
     NROLE         COVER.NROLE%TYPE,
     SCLIENT       COVER.SCLIENT%TYPE,
     NCAPITAL_WAIT COVER.NCAPITAL_WAIT%TYPE,
     NAGEMININS    COVER.NAGEMININS%TYPE,
     NAGEMAXINS    COVER.NAGEMAXINS%TYPE,
     NAGEMAXPER    COVER.NAGEMAXPER%TYPE,
     NTYPDURINS    COVER.NTYPDURINS%TYPE,
     NDURINSUR     COVER.NDURINSUR%TYPE,
     NTYPDURPAY    COVER.NTYPDURPAY%TYPE,
     NDURPAY       COVER.NDURPAY%TYPE,
     SBRANCHT      PRODMASTER.SBRANCHT%TYPE DEFAULT NULL,
     NPRODCLAS     PRODUCT_LI.NPRODCLAS%TYPE DEFAULT NULL,
     DANIVERSARY   COVER.DANIVERSARY%TYPE DEFAULT NULL,
     DSEEKTAR      COVER.DSEEKTAR%TYPE DEFAULT NULL,
     NRETARIF      COVER.NRETARIF%TYPE DEFAULT NULL,
     NBRANCH_REI   COVER.NBRANCH_REI%TYPE DEFAULT NULL,
     NCAUSEUPD     COVER.NCAUSEUPD%TYPE,
     DFER          COVER.DFER%TYPE,
     NUPDCOVER     OUT SMALLINT,
     NCOMMIT       SMALLINT DEFAULT 1,
     NCAPITAL_O    COVER.NCAPITAL_O%TYPE DEFAULT NULL,
     NPREMIUM_O    COVER.NPREMIUM_O%TYPE DEFAULT NULL,
     NRATECOVE_O   COVER.NRATECOVE_O%TYPE DEFAULT NULL,
     NCAPITAL_REQ  COVER.NCAPITAL_REQ%TYPE DEFAULT NULL,
     NREVALTYPE_A  COVER.NREVALTYPE%TYPE DEFAULT NULL) AUTHID CURRENT_USER AS

     SCLIENT_AUX     ROLES.SCLIENT%TYPE;
     SSEXCLIEN_AUX   ROLES.SSEXCLIEN%TYPE;
     NREVALTYPE_AUX  COVER.NREVALTYPE%TYPE;
     NAGEMAXPERM_AUX GEN_COVER.NAGEMAXPERM%TYPE;
     NAGEMAXPERF_AUX GEN_COVER.NAGEMAXPERM%TYPE;
     NAGEMAXPER_AUX  GEN_COVER.NAGEMAXPERM%TYPE;

    CURSOR C_COVER IS
        SELECT DEFFECDATE   , NCAPITAL   , NCAPITALI,
               SCHANGE      , NCURRENCY  , NDISCOUNT,
               NFIXAMOUNT   , SFRANDEDI  , NMAXAMOUNT,
               SFREE_PREMI  , NMINAMOUNT , NPREMIUM,
               NRATE        , NWAIT_QUAN , NRATECOVE,
               SWAIT_TYPE   , SFRANCAPL  , NDISC_AMOUN,
               NCAPITAL_WAIT, NAGEMININS , NAGEMAXINS,
               NAGEMAXPER   , NTYPDURINS , NDURINSUR,
               NTYPDURPAY   , NDURPAY    , DANIVERSARY,
               DSEEKTAR     , NRETARIF   , ROWID,
               NBRANCH_REI  , NCAUSEUPD  , DFER,
               NCAPITAL_O   , NPREMIUM_O , NRATECOVE_O,
               NCAPITAL_REQ
          FROM COVER
         WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
           AND NBRANCH     = INSUPDCOVER.NBRANCH
           AND NPRODUCT    = INSUPDCOVER.NPRODUCT
           AND NPOLICY     = INSUPDCOVER.NPOLICY
           AND NCERTIF     = INSUPDCOVER.NCERTIF
           AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
           AND NMODULEC    = INSUPDCOVER.NMODULEC
           AND NCOVER      = INSUPDCOVER.NCOVER
           AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
           AND DEFFECDATE <= INSUPDCOVER.DEFFECDATE
           AND (DNULLDATE IS NULL
            OR  DNULLDATE  > INSUPDCOVER.DEFFECDATE);
-- DDR-26/12/2023-Cursor endosos retroactivos
  CURSOR C_COVER1 IS
        SELECT DEFFECDATE   , NCAPITAL   , NCAPITALI,
               SCHANGE      , NCURRENCY  , NDISCOUNT,
               NFIXAMOUNT   , SFRANDEDI  , NMAXAMOUNT,
               SFREE_PREMI  , NMINAMOUNT , NPREMIUM,
               NRATE        , NWAIT_QUAN , NRATECOVE,
               SWAIT_TYPE   , SFRANCAPL  , NDISC_AMOUN,
               NCAPITAL_WAIT, NAGEMININS , NAGEMAXINS,
               NAGEMAXPER   , NTYPDURINS , NDURINSUR,
               NTYPDURPAY   , NDURPAY    , DANIVERSARY,
               DSEEKTAR     , NRETARIF   , ROWID,
               NBRANCH_REI  , NCAUSEUPD  , DFER,
               NCAPITAL_O   , NPREMIUM_O , NRATECOVE_O,
               NCAPITAL_REQ
          FROM COVER
         WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
           AND NBRANCH     = INSUPDCOVER.NBRANCH
           AND NPRODUCT    = INSUPDCOVER.NPRODUCT
           AND NPOLICY     = INSUPDCOVER.NPOLICY
           AND NCERTIF     = INSUPDCOVER.NCERTIF
           AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
           AND NMODULEC    = INSUPDCOVER.NMODULEC
           AND NCOVER      = INSUPDCOVER.NCOVER
           AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
           AND DEFFECDATE > INSUPDCOVER.DEFFECDATE
           AND DNULLDATE IS NULL;

      
    R_COVER         C_COVER%ROWTYPE;
    NACTION_NULL    INTEGER;
    NEXIST          NUMBER(1);
    BFOUND          BOOLEAN := TRUE;
    SCOVER          VARCHAR2(500);
    SCOVERNEW       VARCHAR2(500);
    NCUENTA NUMBER;
    NCUENTAEFF NUMBER;
-- DDR 20240424
    NTYPE_AMEND NUMBER;
    NCUENTAINSERT NUMBER;



BEGIN

     SCLIENT_AUX := SCLIENT;

    IF NVL(SCLIENT_AUX, ' ') = ' ' THEN

         BEGIN
             SELECT SCLIENT, SSEXCLIEN 
               INTO SCLIENT_AUX, SSEXCLIEN_AUX 
               FROM ROLES
              WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                AND NBRANCH     = INSUPDCOVER.NBRANCH
                AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                AND NPOLICY     = INSUPDCOVER.NPOLICY
                AND NCERTIF     = INSUPDCOVER.NCERTIF
                AND NROLE       = 1
                AND DEFFECDATE <= INSUPDCOVER.DEFFECDATE
                AND (DNULLDATE IS NULL
                 OR DNULLDATE   > INSUPDCOVER.DEFFECDATE);

         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                 NULL;
             WHEN TOO_MANY_ROWS THEN
                 NULL;
             WHEN OTHERS                THEN
                 NULL;
         END;

    END IF;

/*+ SI NO SE INGRESA TIPO DE ACCION, SE DETERMINA ENTRE CREAR O ACTUALIZAR */
    IF NVL(NACTION, 0) = 0 THEN

        IF INSUPDCOVER.DNULLDATE IS NOT NULL THEN
            BEGIN
                SELECT 1
                  INTO NACTION_NULL
                  FROM DUAL
                 WHERE EXISTS(SELECT 1
                                FROM COVER
                               WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                                 AND NBRANCH     = INSUPDCOVER.NBRANCH
                                 AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                                 AND NPOLICY     = INSUPDCOVER.NPOLICY
                                 AND NCERTIF     = INSUPDCOVER.NCERTIF
                                 AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                                 AND NMODULEC    = INSUPDCOVER.NMODULEC
                                 AND NCOVER      = INSUPDCOVER.NCOVER
                                 AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                                 AND DEFFECDATE <= INSUPDCOVER.DNULLDATE
                                 AND (DNULLDATE IS NULL
                                  OR DNULLDATE   > INSUPDCOVER.DNULLDATE)
                                 AND NCURRENCY   = INSUPDCOVER.NCURRENCY);
            EXCEPTION
                WHEN OTHERS THEN
                    NACTION_NULL := 0;
            END;
        ELSE
            BEGIN
                SELECT 1
                  INTO NACTION_NULL
                  FROM DUAL
                 WHERE EXISTS(SELECT 1
                                FROM COVER
                               WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                                 AND NBRANCH     = INSUPDCOVER.NBRANCH
                                 AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                                 AND NPOLICY     = INSUPDCOVER.NPOLICY
                                 AND NCERTIF     = INSUPDCOVER.NCERTIF
                                 AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                                 AND NMODULEC    = INSUPDCOVER.NMODULEC
                                 AND NCOVER      = INSUPDCOVER.NCOVER
                                 AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                                 AND DEFFECDATE <= INSUPDCOVER.DEFFECDATE
                                 AND (DNULLDATE IS NULL
                                  OR DNULLDATE   > INSUPDCOVER.DEFFECDATE)
                                 AND NCURRENCY   = INSUPDCOVER.NCURRENCY);
            EXCEPTION
                WHEN OTHERS THEN
                    NACTION_NULL := 0;
            END;

            IF NVL(NACTION_NULL,0) = 0 THEN
                BEGIN
                    SELECT 4
                      INTO NACTION_NULL
                      FROM DUAL
                     WHERE EXISTS(SELECT 1
                                    FROM COVER
                                   WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                                     AND NBRANCH     = INSUPDCOVER.NBRANCH
                                     AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                                     AND NPOLICY     = INSUPDCOVER.NPOLICY
                                     AND NCERTIF     = INSUPDCOVER.NCERTIF
                                     AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                                     AND NMODULEC   <> INSUPDCOVER.NMODULEC
                                     AND NCOVER      = INSUPDCOVER.NCOVER
                                     AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                                     AND DEFFECDATE  < INSUPDCOVER.DEFFECDATE
                                     AND DNULLDATE  IS NULL
                                     AND NCURRENCY   = INSUPDCOVER.NCURRENCY);
                EXCEPTION
                    WHEN OTHERS THEN
                        NACTION_NULL := 0;
                END;
            END IF;
        END IF;

        IF NACTION_NULL!= 0 THEN
            IF NACTION_NULL = 4 THEN
                NACTION := 4;
            ELSE
                NACTION := 2;
            END IF;
        ELSE
            NACTION := 1;
        END IF;
    END IF;
    
/*+SE BUSCAN LAS EDADES CONFIGURADAS PARA PRODUCTOS GENERALES*/
    IF SBRANCHT <> '1' THEN 
        BEGIN
            SELECT NVL(NAGEMAXPERM,0),  NVL(NAGEMAXPERF,0)
              INTO NAGEMAXPERM_AUX, NAGEMAXPERF_AUX
              FROM GEN_COVER COV
             WHERE COV.NBRANCH      = INSUPDCOVER.NBRANCH
               AND COV.NPRODUCT     = INSUPDCOVER.NPRODUCT
               AND COV.NMODULEC     = INSUPDCOVER.NMODULEC
               AND COV.NCOVER       = INSUPDCOVER.NCOVER
               AND COV.DEFFECDATE  <= INSUPDCOVER.DEFFECDATE
               AND (COV.DNULLDATE  IS NULL
                OR  COV.DNULLDATE   > INSUPDCOVER.DEFFECDATE);
        EXCEPTION 
            WHEN OTHERS THEN
                   NAGEMAXPERM_AUX := 0;
                   NAGEMAXPERF_AUX := 0;
        END;
           
        IF SSEXCLIEN_AUX = '1' THEN 
            NAGEMAXPER_AUX := NVL(NAGEMAXPERF_AUX,0);
        ELSE
            NAGEMAXPER_AUX := NVL(NAGEMAXPERM_AUX,0);
        END IF;
    ELSE 
        NAGEMAXPER_AUX := NVL(NAGEMAXPER,0);
    END IF;
    
    
/*+SI NO ES MODIFICACION TEMPORAL (POLIZA / CERTIFICADO) */
    IF STRANSACTION NOT IN ('13', '15') THEN
    BEGIN
        IF NACTION = 1 THEN
        
        -- DDR 20240424 ALTA
            SELECT NTYPE_AMEND
            INTO NTYPE_AMEND
            FROM POLICY_HIS
            WHERE SCERTYPE = INSUPDCOVER.SCERTYPE
            AND NBRANCH = INSUPDCOVER.NBRANCH
            AND NPRODUCT = INSUPDCOVER.NPRODUCT
            AND NPOLICY  = INSUPDCOVER.NPOLICY
            AND NCERTIF  = INSUPDCOVER.NCERTIF
            AND NTRANSACTIO=
            (SELECT MAX(NTRANSACTIO)
            FROM POLICY_HIS HISTORIA
            WHERE POLICY_HIS.SCERTYPE = HISTORIA.SCERTYPE
            AND POLICY_HIS.NBRANCH = HISTORIA.NBRANCH
            AND POLICY_HIS.NPRODUCT = HISTORIA.NPRODUCT
            AND POLICY_HIS.NPOLICY  = HISTORIA.NPOLICY
            AND POLICY_HIS.NCERTIF  = HISTORIA.NCERTIF);
            
            IF NTYPE_AMEND=2 THEN
                SELECT COUNT(0) INTO NCUENTAINSERT 
                FROM COVER
                WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                AND NBRANCH     = INSUPDCOVER.NBRANCH
                AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                AND NPOLICY     = INSUPDCOVER.NPOLICY
                AND NCERTIF     = INSUPDCOVER.NCERTIF
                AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                AND NMODULEC    = INSUPDCOVER.NMODULEC
                AND NCOVER      = INSUPDCOVER.NCOVER
                AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                AND DEFFECDATE > INSUPDCOVER.DEFFECDATE
                AND DNULLDATE IS NULL;
                
                IF NCUENTAINSERT<>0 THEN
                
                    INSERT INTO SPECIFIC_RISK_COV_HIS
                    SELECT SPECIFIC_RISK_COV.*,INSUPDCOVER.NUSERCODE,SYSTIMESTAMP,
                    (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_HIS)),0) FROM DUAL) + ROWNUM ,
                    'INSUPDCOVER','INS'
                    FROM SPECIFIC_RISK_COV                               
                    WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                    AND NBRANCH     = INSUPDCOVER.NBRANCH
                    AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                    AND NPOLICY     = INSUPDCOVER.NPOLICY
                    AND NCERTIF     = INSUPDCOVER.NCERTIF
                    AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                    AND NMODULEC    = INSUPDCOVER.NMODULEC
                    AND NCOVER      = INSUPDCOVER.NCOVER
                    AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                    AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;
                    
                    INSERT INTO SPECIFIC_RISK_COV_DET_HIS
                    SELECT SPECIFIC_RISK_COV_DET.*,INSUPDCOVER.NUSERCODE,SYSTIMESTAMP,
                    (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_DET_HIS)),0) FROM DUAL) + ROWNUM ,
                    'INSUPDCOVER','DEL'
                    FROM SPECIFIC_RISK_COV_DET    
                    WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                    AND NBRANCH     = INSUPDCOVER.NBRANCH
                    AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                    AND NPOLICY     = INSUPDCOVER.NPOLICY
                    AND NCERTIF     = INSUPDCOVER.NCERTIF
                    AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                    AND NMODULEC    = INSUPDCOVER.NMODULEC
                    AND NCOVER      = INSUPDCOVER.NCOVER
                    AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                    AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;
        
                    DELETE FROM SPECIFIC_RISK_COV_DET
                    WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                    AND NBRANCH     = INSUPDCOVER.NBRANCH
                    AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                    AND NPOLICY     = INSUPDCOVER.NPOLICY
                    AND NCERTIF     = INSUPDCOVER.NCERTIF
                    AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                    AND NMODULEC    = INSUPDCOVER.NMODULEC
                    AND NCOVER      = INSUPDCOVER.NCOVER
                    AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                    AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;
                    
                    DELETE FROM SPECIFIC_RISK_COV
                    WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                    AND NBRANCH     = INSUPDCOVER.NBRANCH
                    AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                    AND NPOLICY     = INSUPDCOVER.NPOLICY
                    AND NCERTIF     = INSUPDCOVER.NCERTIF
                    AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                    AND NMODULEC    = INSUPDCOVER.NMODULEC
                    AND NCOVER      = INSUPDCOVER.NCOVER
                    AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                    AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;

                    DELETE CLAUSE
                    WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                    AND NBRANCH     = INSUPDCOVER.NBRANCH
                    AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                    AND NPOLICY     = INSUPDCOVER.NPOLICY
                    AND NCERTIF     = INSUPDCOVER.NCERTIF
                    AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                    AND NMODULEC    = INSUPDCOVER.NMODULEC
                    AND NCOVER      = INSUPDCOVER.NCOVER
                    AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX;
                
                    INSERT INTO COVER_HIS
                    SELECT COVER.*,INSUPDCOVER.NUSERCODE,SYSTIMESTAMP,
                    (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM COVER_HIS)),0) FROM DUAL) + ROWNUM ,
                    'INSUPDCOVER','INS'
                    FROM COVER                             
                    WHERE SCERTYPE  = INSUPDCOVER.SCERTYPE
                    AND NBRANCH     = INSUPDCOVER.NBRANCH
                    AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                    AND NPOLICY     = INSUPDCOVER.NPOLICY
                    AND NCERTIF     = INSUPDCOVER.NCERTIF
                    AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                    AND NMODULEC    = INSUPDCOVER.NMODULEC
                    AND NCOVER      = INSUPDCOVER.NCOVER
                    AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                    AND DEFFECDATE >= INSUPDCOVER.DEFFECDATE;
    
                    DELETE COVER 
                    WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                    AND NBRANCH     = INSUPDCOVER.NBRANCH
                    AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                    AND NPOLICY     = INSUPDCOVER.NPOLICY
                    AND NCERTIF     = INSUPDCOVER.NCERTIF
                    AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                    AND NMODULEC    = INSUPDCOVER.NMODULEC
                    AND NCOVER      = INSUPDCOVER.NCOVER
                    AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                    AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;
    
                    UPDATE COVER 
                    SET DNULLDATE = INSUPDCOVER.DEFFECDATE,
                    DCOMPDATE = SYSDATE,
                    NUSERCODE = INSUPDCOVER.NUSERCODE
                    WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                    AND NBRANCH     = INSUPDCOVER.NBRANCH
                    AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                    AND NPOLICY     = INSUPDCOVER.NPOLICY
                    AND NCERTIF     = INSUPDCOVER.NCERTIF
                    AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                    AND NMODULEC    = INSUPDCOVER.NMODULEC
                    AND NCOVER      = INSUPDCOVER.NCOVER
                    AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX                           
                    and DEFFECDATE=
                    (SELECT MAX(COVER_HIS.DEFFECDATE) 
                    FROM COVER COVER_HIS
                    WHERE COVER_HIS.SCERTYPE= COVER.SCERTYPE
                    AND COVER_HIS.NBRANCH= COVER.NBRANCH
                    AND COVER_HIS.NPRODUCT= COVER.NPRODUCT
                    AND COVER_HIS.NPOLICY= COVER.NPOLICY
                    AND COVER_HIS.NCERTIF= COVER.NCERTIF
                    AND COVER_HIS.NMODULEC= COVER.NMODULEC
                    AND COVER_HIS.NCOVER= COVER.NCOVER
                    AND COVER_HIS.DEFFECDATE< INSUPDCOVER.DEFFECDATE);
                END IF;
            END IF;
        
            INSERT INTO COVER(SCERTYPE   , NBRANCH      , NPRODUCT,
                              NPOLICY    , NCERTIF      , NGROUP_INSU,
                              NMODULEC   , NCOVER       , DEFFECDATE,
                              NCAPITALI  , SCHANGE      , DCOMPDATE,
                              NCURRENCY  , NDISCOUNT    , NFIXAMOUNT,
                              SFRANDEDI  , NMAXAMOUNT   , SFREE_PREMI,
                              NMINAMOUNT , NPREMIUM     , NRATE,
                              NWAIT_QUAN , NRATECOVE    , NUSERCODE,
                              SWAIT_TYPE , SFRANCAPL    , NDISC_AMOUN,
                              SCLIENT    , NCAPITAL_WAIT, NAGEMININS,
                              NAGEMAXINS , NAGEMAXPER   , NTYPDURINS,
                              NDURINSUR  , NTYPDURPAY   , NDURPAY,
                              NROLE      , NCAPITAL     , DANIVERSARY,
                              DSEEKTAR   , NRETARIF     , NBRANCH_REI,
                              NCAUSEUPD  , DFER         , NCAPITAL_O,
                              NPREMIUM_O , NRATECOVE_O  , NCAPITAL_REQ,
                              NREVALTYPE)
                       VALUES(SCERTYPE   , NBRANCH      , NPRODUCT,
                              NPOLICY    , NCERTIF      , NGROUP_INSU,
                              NMODULEC   , NCOVER       , DEFFECDATE,
                              NCAPITALI  , SCHANGE      , SYSDATE,
                              NCURRENCY  , NDISCOUNT    , NFIXAMOUNT,
                              SFRANDEDI  , NMAXAMOUNT   , SFREE_PREMI,
                              NMINAMOUNT , NPREMIUM     , NRATE,
                              NWAIT_QUAN , NRATECOVE    , NUSERCODE,
                              SWAIT_TYPE , SFRANCAPL    , NDISC_AMOUN,
                              SCLIENT_AUX    , NCAPITAL_WAIT, NAGEMININS,
                              NAGEMAXINS , NAGEMAXPER_AUX   , NTYPDURINS,
                              NDURINSUR  , NTYPDURPAY   , NDURPAY,
                              NROLE      , NCAPITAL     , DANIVERSARY,
                              DSEEKTAR   , NRETARIF     , NBRANCH_REI,
                              NCAUSEUPD  , DFER         , NCAPITAL_O,
                              NPREMIUM_O , NRATECOVE_O  , NCAPITAL_REQ,
                              NREVALTYPE_A);


/*+ SI LA ACCION ES ACTUALIZAR */
        ELSIF NACTION IN (2,4) THEN
		-- DDR-26/12/2023-Verifico si es un endoso reatroactivo
        SELECT COUNT(0) INTO NCUENTA 
        FROM COVER
         WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
           AND NBRANCH     = INSUPDCOVER.NBRANCH
           AND NPRODUCT    = INSUPDCOVER.NPRODUCT
           AND NPOLICY     = INSUPDCOVER.NPOLICY
           AND NCERTIF     = INSUPDCOVER.NCERTIF
           AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
           AND NMODULEC    = INSUPDCOVER.NMODULEC
           AND NCOVER      = INSUPDCOVER.NCOVER
           AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
           AND DEFFECDATE > INSUPDCOVER.DEFFECDATE
           AND DNULLDATE IS NULL;
        
            IF  NCUENTA=0 THEN
                OPEN C_COVER;
                FETCH C_COVER
                INTO R_COVER;
                BFOUND := C_COVER%FOUND;
                CLOSE C_COVER;
            ELSE
				-- DDR-26/12/2023-Utilizo cursor de endosos retroactivos
                OPEN C_COVER1;
                FETCH C_COVER1
                INTO R_COVER;
                BFOUND := C_COVER1%FOUND;
                CLOSE C_COVER1;
            END IF;
            SCOVER    := NVL(TO_CHAR(R_COVER.NCAPITAL), '*')||NVL(TO_CHAR(R_COVER.NCAPITALI), '*')||NVL(R_COVER.SCHANGE, '*')||NVL(R_COVER.SFRANDEDI, '*')||NVL(TO_CHAR(R_COVER.NCURRENCY), '*')||NVL(TO_CHAR(R_COVER.NDISCOUNT), '*')||NVL(TO_CHAR(R_COVER.NFIXAMOUNT), '*')||NVL(TO_CHAR(R_COVER.NMAXAMOUNT), '*')||NVL(R_COVER.SFREE_PREMI, '*')||NVL(TO_CHAR(R_COVER.NMINAMOUNT), '*')||NVL(TO_CHAR(R_COVER.NPREMIUM), '*')||NVL(TO_CHAR(R_COVER.NRATE), '*')||NVL(TO_CHAR(R_COVER.NWAIT_QUAN), '*')||NVL(TO_CHAR(R_COVER.NRATECOVE), '*')||NVL(R_COVER.SWAIT_TYPE, '*')||NVL(R_COVER.SFRANCAPL, '*')||NVL(TO_CHAR(R_COVER.NDISC_AMOUN), '*')||NVL(TO_CHAR(R_COVER.NTYPDURINS), '*')||NVL(TO_CHAR(R_COVER.NDURINSUR), '*')||NVL(TO_CHAR(NVL(R_COVER.NAGEMININS, 0)), '*')||NVL(TO_CHAR(NVL(R_COVER.NAGEMAXINS, 0)), '*')||NVL(TO_CHAR(NVL(R_COVER.NAGEMAXPER, 0)), '*')||NVL(TO_CHAR(R_COVER.NTYPDURPAY), '*')||NVL(TO_CHAR(R_COVER.NDURPAY), '*')||NVL(TO_CHAR(R_COVER.NCAUSEUPD), '*')||NVL(TO_CHAR(R_COVER.NCAPITAL_WAIT), '*')||NVL(TO_CHAR(R_COVER.DANIVERSARY), '*')||NVL(TO_CHAR(R_COVER.DSEEKTAR), '*')||NVL(TO_CHAR(R_COVER.DFER), '*')||NVL(TO_CHAR(R_COVER.NBRANCH_REI), '*')||NVL(TO_CHAR(R_COVER.NRETARIF), '*');
            SCOVERNEW := NVL(TO_CHAR(NCAPITAL), '*')||NVL(TO_CHAR(NCAPITALI), '*')||NVL(SCHANGE, '*')||NVL(SFRANDEDI, '*')||NVL(TO_CHAR(NCURRENCY), '*')||NVL(TO_CHAR(NDISCOUNT), '*')||NVL(TO_CHAR(NFIXAMOUNT), '*')||NVL(TO_CHAR(NMAXAMOUNT), '*')||NVL(SFREE_PREMI, '*')||NVL(TO_CHAR(NMINAMOUNT), '*')||NVL(TO_CHAR(NPREMIUM), '*')||NVL(TO_CHAR(NRATE), '*')||NVL(TO_CHAR(NWAIT_QUAN), '*')||NVL(TO_CHAR(NRATECOVE), '*')||NVL(SWAIT_TYPE, '*')||NVL(SFRANCAPL, '*')||NVL(TO_CHAR(NDISC_AMOUN), '*')||NVL(TO_CHAR(NTYPDURINS), '*')||NVL(TO_CHAR(NDURINSUR), '*')||NVL(TO_CHAR(NVL(NAGEMININS, 0)), '*')||NVL(TO_CHAR(NVL(NAGEMAXINS, 0)), '*')||NVL(TO_CHAR(NVL(NAGEMAXPER, 0)), '*')||NVL(TO_CHAR(NTYPDURPAY), '*')||NVL(TO_CHAR(NDURPAY), '*')||NVL(TO_CHAR(NCAUSEUPD), '*')||NVL(TO_CHAR(NCAPITAL_WAIT), '*')||NVL(TO_CHAR(DANIVERSARY), '*')||NVL(TO_CHAR(DSEEKTAR), '*')||NVL(TO_CHAR(DFER), '*')||NVL(TO_CHAR(NBRANCH_REI), '*')||NVL(TO_CHAR(NRETARIF), '*');
            BFOUND := SCOVER <> SCOVERNEW;
/*+ SI EXISTE UN REGISTRO CON FECHA DE EFECTO IGUAL A LA FECHA RECIBIDA COMO PARAMETRO, */
/*+ SE ACTUALIZA EL MISMO REGISTRO */
            IF BFOUND OR NACTION = 4 THEN
                IF NACTION <> 4 THEN
                    IF TO_CHAR(R_COVER.DEFFECDATE, 'YYYYMMDD') = TO_CHAR(DEFFECDATE, 'YYYYMMDD') THEN
                    
                        
                        UPDATE COVER SET NCAPITAL      = INSUPDCOVER.NCAPITAL,
                                         NCAPITAL_WAIT = INSUPDCOVER.NCAPITAL_WAIT,
                                         NCAPITALI     = INSUPDCOVER.NCAPITALI,
                                         SCHANGE       = INSUPDCOVER.SCHANGE,
                                         DCOMPDATE     = SYSDATE,
                                         NCURRENCY     = INSUPDCOVER.NCURRENCY,
                                         NDISCOUNT     = INSUPDCOVER.NDISCOUNT,
                                         NFIXAMOUNT    = INSUPDCOVER.NFIXAMOUNT,
                                         SFRANDEDI     = INSUPDCOVER.SFRANDEDI,
                                         NMAXAMOUNT    = INSUPDCOVER.NMAXAMOUNT,
                                         SFREE_PREMI   = INSUPDCOVER.SFREE_PREMI,
                                         NMINAMOUNT    = INSUPDCOVER.NMINAMOUNT,
                                         NPREMIUM      = INSUPDCOVER.NPREMIUM,
                                         NRATE         = INSUPDCOVER.NRATE,
                                         NWAIT_QUAN    = INSUPDCOVER.NWAIT_QUAN,
                                         NRATECOVE     = NVL(INSUPDCOVER.NRATECOVE, COVER.NRATECOVE ),
                                         NUSERCODE     = INSUPDCOVER.NUSERCODE,
                                         SWAIT_TYPE    = INSUPDCOVER.SWAIT_TYPE,
                                         SFRANCAPL     = INSUPDCOVER.SFRANCAPL,
                                         NDISC_AMOUN   = INSUPDCOVER.NDISC_AMOUN,
                                         DANIVERSARY   = INSUPDCOVER.DANIVERSARY,
                                         DSEEKTAR      = INSUPDCOVER.DSEEKTAR,
                                         NRETARIF      = INSUPDCOVER.NRETARIF,
                                         NBRANCH_REI   = INSUPDCOVER.NBRANCH_REI,
                                         NCAUSEUPD     = INSUPDCOVER.NCAUSEUPD,
                                         DFER          = INSUPDCOVER.DFER,
                                         NCAPITAL_O    = INSUPDCOVER.NCAPITAL_O,
                                         NPREMIUM_O    = INSUPDCOVER.NPREMIUM_O,
                                         NRATECOVE_O   = INSUPDCOVER.NRATECOVE_O,
                                         NAGEMININS    = INSUPDCOVER.NAGEMININS,
                                         NAGEMAXINS    = INSUPDCOVER.NAGEMAXINS,
                                         NAGEMAXPER    = INSUPDCOVER.NAGEMAXPER,
                                         NCAPITAL_REQ  = INSUPDCOVER.NCAPITAL_REQ,
                                         NREVALTYPE    = NVL(INSUPDCOVER.NREVALTYPE_A,  COVER.NREVALTYPE)
                         WHERE ROWID = R_COVER.ROWID;
                    ELSE

                    IF NVL(NREVALTYPE_A,999) = 999 THEN
                    BEGIN
                        SELECT NREVALTYPE
                          INTO NREVALTYPE_AUX
                          FROM (SELECT NREVALTYPE
                                  FROM COVER
                                 WHERE SCERTYPE = INSUPDCOVER.SCERTYPE
                                   AND NBRANCH = INSUPDCOVER.NBRANCH
                                   AND NPRODUCT = INSUPDCOVER.NPRODUCT
                                   AND NPOLICY = INSUPDCOVER.NPOLICY
                                   AND NCERTIF = INSUPDCOVER.NCERTIF
                                   AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                                   AND NMODULEC = INSUPDCOVER.NMODULEC
                                   AND NCOVER = INSUPDCOVER.NCOVER
                                   AND SCLIENT = INSUPDCOVER.SCLIENT
                                   AND (DNULLDATE IS NULL OR DNULLDATE <= INSUPDCOVER.DEFFECDATE)
                                 ORDER BY DEFFECDATE DESC)
                          WHERE ROWNUM < 2 ;
                        EXCEPTION
                            WHEN OTHERS THEN
                                NREVALTYPE_AUX := NULL;
                    END;

                    END IF;

/*+ SI LA ACTUALIZACION ES A UNA FECHA POSTERIOR AL ULTIMO REGISTRO EN TABLA, SE ANULA EL REGISTRO Y SE CREA UNO NUEVO */
                        IF NCUENTA=0 THEN
                            
                            UPDATE COVER SET DNULLDATE = INSUPDCOVER.DEFFECDATE,
                                             DCOMPDATE = SYSDATE,
                                             NUSERCODE = INSUPDCOVER.NUSERCODE
                            WHERE ROWID = R_COVER.ROWID;                       
                         ELSE
							-- DDR-26/12/2023-Proceso para endosos retroactivos
                            INSERT INTO COVER_HIS
                            SELECT COVER.*,INSUPDCOVER.NUSERCODE,SYSTIMESTAMP,
                            (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM COVER_HIS)),0) FROM DUAL) + ROWNUM ,
                            'INSUPDCOVER','DEL'
                            FROM COVER                             
                            WHERE SCERTYPE  = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                            AND DEFFECDATE >= INSUPDCOVER.DEFFECDATE;

                            DELETE COVER 
                            WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                            AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;

                            UPDATE COVER 
                            SET DNULLDATE = INSUPDCOVER.DEFFECDATE,
                            DCOMPDATE = SYSDATE,
                            NUSERCODE = INSUPDCOVER.NUSERCODE
                            WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX                           
                            and DEFFECDATE=
                            (SELECT MAX(COVER_HIS.DEFFECDATE) 
                            FROM COVER COVER_HIS
                            WHERE COVER_HIS.SCERTYPE= COVER.SCERTYPE
                            AND COVER_HIS.NBRANCH= COVER.NBRANCH
                            AND COVER_HIS.NPRODUCT= COVER.NPRODUCT
                            AND COVER_HIS.NPOLICY= COVER.NPOLICY
                            AND COVER_HIS.NCERTIF= COVER.NCERTIF
                            AND COVER_HIS.NMODULEC= COVER.NMODULEC
                            AND COVER_HIS.NCOVER= COVER.NCOVER
                            AND COVER_HIS.DEFFECDATE< INSUPDCOVER.DEFFECDATE);

                            UPDATE COVER
                            SET DNULLDATE = NULL,
                            DCOMPDATE = SYSDATE,
                            NUSERCODE = INSUPDCOVER.NUSERCODE,
                            NCAPITAL = INSUPDCOVER.NCAPITAL,
                            -- DDR 20240228
                            NPREMIUM = INSUPDCOVER.NPREMIUM
                            WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                            AND DEFFECDATE = INSUPDCOVER.DEFFECDATE;
                        END IF;
                        
                        IF NCUENTA=0 THEN
                                INSERT INTO COVER(SCERTYPE   , NBRANCH      , NPRODUCT,
                                          NPOLICY    , NCERTIF      , NGROUP_INSU,
                                          NMODULEC   , NCOVER       , DEFFECDATE,
                                          NCAPITALI  , SCHANGE      , DCOMPDATE,
                                          NCURRENCY  , NDISCOUNT    , NFIXAMOUNT,
                                          SFRANDEDI  , NMAXAMOUNT   , SFREE_PREMI,
                                          NMINAMOUNT , NPREMIUM     , NRATE,
                                          NWAIT_QUAN , NRATECOVE    , NUSERCODE,
                                          SWAIT_TYPE , SFRANCAPL    , NDISC_AMOUN,
                                          SCLIENT    , NCAPITAL_WAIT, NAGEMININS,
                                          NAGEMAXINS , NAGEMAXPER   , NTYPDURINS,
                                          NDURINSUR  , NTYPDURPAY   , NDURPAY,
                                          NROLE      , NCAPITAL     , DANIVERSARY,
                                          DSEEKTAR   , NRETARIF     , NBRANCH_REI,
                                          NCAUSEUPD  , DFER         , NCAPITAL_O,
                                          NPREMIUM_O , NRATECOVE_O  , NCAPITAL_REQ,
                                          NREVALTYPE)
                                   VALUES(SCERTYPE   , NBRANCH      , NPRODUCT,
                                          NPOLICY    , NCERTIF      , NGROUP_INSU,
                                          NMODULEC   , NCOVER       , DEFFECDATE,
                                          NCAPITALI  , SCHANGE      , SYSDATE,
                                          NCURRENCY  , NDISCOUNT    , NFIXAMOUNT,
                                          SFRANDEDI  , NMAXAMOUNT   , SFREE_PREMI,
                                          NMINAMOUNT , NPREMIUM     , NRATE,
                                          NWAIT_QUAN , NRATECOVE    , NUSERCODE,
                                          SWAIT_TYPE , SFRANCAPL    , NDISC_AMOUN,
                                          SCLIENT_AUX    , NCAPITAL_WAIT, NAGEMININS,
                                          NAGEMAXINS , NAGEMAXPER_AUX   , NTYPDURINS,
                                          NDURINSUR  , NTYPDURPAY   , NDURPAY,
                                          NROLE      , NCAPITAL     , DANIVERSARY,
                                          DSEEKTAR   , NRETARIF     , NBRANCH_REI,
                                          NCAUSEUPD  , DFER         , NCAPITAL_O,
                                          NPREMIUM_O , NRATECOVE_O  , NCAPITAL_REQ,
                                          --NREVALTYPE_A); --NVL(NREVALTYPE_A,NREVALTYPE_AUX)); --dz NREVALTYPE_A viene vacio
                                          NVL(NREVALTYPE_A,NREVALTYPE_AUX)); --SE VUELVE A AGREGAR NVL
                                ELSE
										-- DDR-26/12/2023-Verifico si hay un endoso retroactivo a la misma fecha 
                                        SELECT COUNT(0) INTO NCUENTAEFF FROM COVER 
                                        WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                                        AND NBRANCH     = INSUPDCOVER.NBRANCH
                                        AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                                        AND NPOLICY     = INSUPDCOVER.NPOLICY
                                        AND NCERTIF     = INSUPDCOVER.NCERTIF
                                        AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                                        AND NMODULEC    = INSUPDCOVER.NMODULEC
                                        AND NCOVER      = INSUPDCOVER.NCOVER
                                        AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                                        AND DEFFECDATE = INSUPDCOVER.DEFFECDATE;
                                        IF NCUENTAEFF=0 THEN
                                            INSERT INTO COVER(SCERTYPE   , NBRANCH      , NPRODUCT,
                                            NPOLICY    , NCERTIF      , NGROUP_INSU,
                                            NMODULEC   , NCOVER       , DEFFECDATE,
                                            NCAPITALI  , SCHANGE      , DCOMPDATE,
                                            NCURRENCY  , NDISCOUNT    , NFIXAMOUNT,
                                            SFRANDEDI  , NMAXAMOUNT   , SFREE_PREMI,
                                            NMINAMOUNT , NPREMIUM     , NRATE,
                                            NWAIT_QUAN , NRATECOVE    , NUSERCODE,
                                            SWAIT_TYPE , SFRANCAPL    , NDISC_AMOUN,
                                            SCLIENT    , NCAPITAL_WAIT, NAGEMININS,
                                            NAGEMAXINS , NAGEMAXPER   , NTYPDURINS,
                                            NDURINSUR  , NTYPDURPAY   , NDURPAY,
                                            NROLE      , NCAPITAL     , DANIVERSARY,
                                            DSEEKTAR   , NRETARIF     , NBRANCH_REI,
                                            NCAUSEUPD  , DFER         , NCAPITAL_O,
                                            NPREMIUM_O , NRATECOVE_O  , NCAPITAL_REQ,
                                            NREVALTYPE)
                                            VALUES(SCERTYPE   , NBRANCH      , NPRODUCT,
                                            NPOLICY    , NCERTIF      , NGROUP_INSU,
                                            NMODULEC   , NCOVER       , DEFFECDATE,
                                            NCAPITALI  , SCHANGE      , SYSDATE,
                                            NCURRENCY  , NDISCOUNT    , NFIXAMOUNT,
                                            SFRANDEDI  , NMAXAMOUNT   , SFREE_PREMI,
                                            NMINAMOUNT , NPREMIUM     , NRATE,
                                            NWAIT_QUAN , NRATECOVE    , NUSERCODE,
                                            SWAIT_TYPE , SFRANCAPL    , NDISC_AMOUN,
                                            SCLIENT_AUX    , NCAPITAL_WAIT, NAGEMININS,
                                            NAGEMAXINS , NAGEMAXPER_AUX   , NTYPDURINS,
                                            NDURINSUR  , NTYPDURPAY   , NDURPAY,
                                            NROLE      , NCAPITAL     , DANIVERSARY,
                                            DSEEKTAR   , NRETARIF     , NBRANCH_REI,
                                            NCAUSEUPD  , DFER         , NCAPITAL_O,
                                            NPREMIUM_O , NRATECOVE_O  , NCAPITAL_REQ,
                                            --NREVALTYPE_A); --NVL(NREVALTYPE_A,NREVALTYPE_AUX)); --dz NREVALTYPE_A viene vacio
                                            NVL(NREVALTYPE_A,NREVALTYPE_AUX)); --SE VUELVE A AGREGAR NVL
                                        END IF;
                                END IF;
                        END IF;
                ELSE
                    IF SBRANCHT = '1' THEN
                        UPDATE COVER SET DNULLDATE = INSUPDCOVER.DEFFECDATE,
                                         DCOMPDATE = SYSDATE,
                                         NUSERCODE = INSUPDCOVER.NUSERCODE
                         WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                           AND NBRANCH     = INSUPDCOVER.NBRANCH
                           AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                           AND NPOLICY     = INSUPDCOVER.NPOLICY
                           AND NCERTIF     = INSUPDCOVER.NCERTIF
                           AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                           AND NMODULEC   <> INSUPDCOVER.NMODULEC
                           AND NCOVER      = INSUPDCOVER.NCOVER
                           AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                           AND DEFFECDATE  < INSUPDCOVER.DEFFECDATE
                           AND DNULLDATE  IS NULL
                           AND NCURRENCY   = INSUPDCOVER.NCURRENCY;
                    END IF;

                    INSERT INTO COVER(SCERTYPE   , NBRANCH      , NPRODUCT,
                                      NPOLICY    , NCERTIF      , NGROUP_INSU,
                                      NMODULEC   , NCOVER       , DEFFECDATE,
                                      NCAPITALI  , SCHANGE      , DCOMPDATE,
                                      NCURRENCY  , NDISCOUNT    , NFIXAMOUNT,
                                      SFRANDEDI  , NMAXAMOUNT   , SFREE_PREMI,
                                      NMINAMOUNT , NPREMIUM     , NRATE,
                                      NWAIT_QUAN , NRATECOVE    , NUSERCODE,
                                      SWAIT_TYPE , SFRANCAPL    , NDISC_AMOUN,
                                      SCLIENT    , NCAPITAL_WAIT, NAGEMININS,
                                      NAGEMAXINS , NAGEMAXPER   , NTYPDURINS,
                                      NDURINSUR  , NTYPDURPAY   , NDURPAY,
                                      NROLE      , NCAPITAL     , DANIVERSARY,
                                      DSEEKTAR   , NRETARIF     , NBRANCH_REI,
                                      NCAUSEUPD  , DFER         , NCAPITAL_O,
                                      NPREMIUM_O , NRATECOVE_O  , NCAPITAL_REQ,
                                      NREVALTYPE)
                               VALUES(SCERTYPE   , NBRANCH      , NPRODUCT,
                                      NPOLICY    , NCERTIF      , NGROUP_INSU,
                                      NMODULEC   , NCOVER       , DEFFECDATE,
                                      NCAPITALI  , SCHANGE      , SYSDATE,
                                      NCURRENCY  , NDISCOUNT    , NFIXAMOUNT,
                                      SFRANDEDI  , NMAXAMOUNT   , SFREE_PREMI,
                                      NMINAMOUNT , NPREMIUM     , NRATE,
                                      NWAIT_QUAN , NRATECOVE    , NUSERCODE,
                                      SWAIT_TYPE , SFRANCAPL    , NDISC_AMOUN,
                                      SCLIENT_AUX    , NCAPITAL_WAIT, NAGEMININS,
                                      NAGEMAXINS , NAGEMAXPER_AUX   , NTYPDURINS,
                                      NDURINSUR  , NTYPDURPAY   , NDURPAY,
                                      NROLE      , NCAPITAL     , DANIVERSARY,
                                      DSEEKTAR   , NRETARIF     , NBRANCH_REI,
                                      NCAUSEUPD  , DFER         , NCAPITAL_O,
                                      NPREMIUM_O , NRATECOVE_O  , NCAPITAL_REQ,
                                      NREVALTYPE_A);
                END IF;
            END IF;

/*+ SI LA ACCION ES ELIMINAR */
        ELSIF NACTION = 3 THEN
            OPEN C_COVER;
            FETCH C_COVER
             INTO R_COVER;
            BFOUND := C_COVER%FOUND;
            CLOSE C_COVER;
/*+ SI EXISTE UN REGISTRO CON FECHA DE EFECTO IGUAL A LA FECHA RECIBIDA COMO PAR METRO, */
/*+ SE ACTUALIZA EL MISMO REGISTRO */
            IF BFOUND THEN

                IF TO_CHAR(R_COVER.DEFFECDATE, 'YYYYMMDD') = TO_CHAR(DEFFECDATE, 'YYYYMMDD') THEN
/*+ SE ELIMINAN LOS REGISTROS DE LAS TABLAS HIJAS*/
                    IF SPOLITYPE = '1' OR
                       NCERTIF   >  0  THEN

/*+ SE ELIMINAN LOS REGISTROS DE TABLAS RELACIONADAS POR LA COBERTURA         */
                        INSRELDEL_COVER(SCERTYPE , NBRANCH    , NPRODUCT,
                                        NPOLICY  , NCERTIF    , NGROUP_INSU,
                                        NMODULEC , NCOVER     , DEFFECDATE,
                                        NCAPITAL , NPREMIUM   , NRATECOVE,
                                        NUSERCODE, NACTION    , STRANSACTION,
                                        DNULLDATE, NROLE      , SCLIENT_AUX,
                                        SBRANCHT , NPRODCLAS  , NCOMMIT);
                    END IF;
                    
                    
                    -- DDR-12/04/2024 - Pasaje a histórico de cobertura
                    INSERT INTO COVER_HIS
                    SELECT COVER.*,INSUPDCOVER.NUSERCODE,SYSTIMESTAMP,
                    (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM COVER_HIS)),0) FROM DUAL) + ROWNUM ,
                    'INSUPDCOVER','DELETE' 
                    FROM COVER                             
                    WHERE ROWID = R_COVER.ROWID;

/*+ SE ELIMINAN EL REGISTRO DE LA TABLA MADRE*/
                    DELETE COVER
                    WHERE ROWID = R_COVER.ROWID;           

                -- DDR 20240307
                    SELECT COUNT(0) 
                    INTO NCUENTA 
                    FROM COVER
                    WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                    AND NBRANCH     = INSUPDCOVER.NBRANCH
                    AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                    AND NPOLICY     = INSUPDCOVER.NPOLICY
                    AND NCERTIF     = INSUPDCOVER.NCERTIF
                    AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                    AND NMODULEC    = INSUPDCOVER.NMODULEC
                    AND NCOVER      = INSUPDCOVER.NCOVER
                    AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                    AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;                     
                     
                    IF NCUENTA<>0 THEN
                            INSERT INTO COVER_HIS
                            SELECT COVER.*,INSUPDCOVER.NUSERCODE,SYSTIMESTAMP,
                            (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM COVER_HIS)),0) FROM DUAL) + ROWNUM ,
                            'INSUPDCOVER','DEL' 
                            FROM COVER                             
                            WHERE SCERTYPE  = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                            AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;

                            INSERT INTO SPECIFIC_RISK_COV_HIS
                            SELECT SPECIFIC_RISK_COV.*,INSUPDCOVER.NUSERCODE,SYSTIMESTAMP,
                            (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_HIS)),0) FROM DUAL) + ROWNUM ,
                            'INSUPDCOVER','DEL'
                            FROM SPECIFIC_RISK_COV                               
                            WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                            AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;
                            
                            INSERT INTO SPECIFIC_RISK_COV_DET_HIS
                            SELECT SPECIFIC_RISK_COV_DET.*,INSUPDCOVER.NUSERCODE,SYSTIMESTAMP,
                            (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_DET_HIS)),0) FROM DUAL) + ROWNUM ,
                            'INSUPDCOVER','DEL'
                            FROM SPECIFIC_RISK_COV_DET    
                            WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                            AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;
                
                            DELETE FROM SPECIFIC_RISK_COV_DET
                            WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                            AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;
                            
                            DELETE FROM SPECIFIC_RISK_COV
                            WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                            AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;

                            DELETE CLAUSE
                            WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX;

                            DELETE COVER 
                            WHERE SCERTYPE    = INSUPDCOVER.SCERTYPE
                            AND NBRANCH     = INSUPDCOVER.NBRANCH
                            AND NPRODUCT    = INSUPDCOVER.NPRODUCT
                            AND NPOLICY     = INSUPDCOVER.NPOLICY
                            AND NCERTIF     = INSUPDCOVER.NCERTIF
                            AND NGROUP_INSU = INSUPDCOVER.NGROUP_INSU
                            AND NMODULEC    = INSUPDCOVER.NMODULEC
                            AND NCOVER      = INSUPDCOVER.NCOVER
                            AND SCLIENT     = INSUPDCOVER.SCLIENT_AUX
                            AND DEFFECDATE > INSUPDCOVER.DEFFECDATE;
                            
                            
                    END IF;
                    
                     
                ELSE
/*+EN CASO DE ANULACION SE MARCA LA CAUSA POR SI FUE A RAIZ DE EXCLUSION DE ASEGURADO */
                    UPDATE COVER SET NCAUSEUPD = INSUPDCOVER.NCAUSEUPD,
                                     DNULLDATE = INSUPDCOVER.DEFFECDATE,
                                     DCOMPDATE = SYSDATE,
                                     NUSERCODE = INSUPDCOVER.NUSERCODE
                     WHERE ROWID = R_COVER.ROWID;
                END IF;
            END IF;
        END IF;
    END;

/*+ ES MODIFICACION TEMPORAL DE POLIZA O CERTIFICADO */
    ELSE
        IF NACTION = 1 THEN
            INSERT INTO COVER(SCERTYPE   , NBRANCH   , NPRODUCT,
                              NPOLICY    , NCERTIF   , NGROUP_INSU,
                              NMODULEC   , NCOVER    , DEFFECDATE,
                              NCAPITALI  , SCHANGE   , DCOMPDATE,
                              NCURRENCY  , NDISCOUNT , NFIXAMOUNT,
                              SFRANDEDI  , NMAXAMOUNT, SFREE_PREMI,
                              NMINAMOUNT , NPREMIUM  , NRATE,
                              NWAIT_QUAN , NRATECOVE , NUSERCODE,
                              SWAIT_TYPE , SFRANCAPL , NDISC_AMOUN,
                              DNULLDATE  , SCLIENT   , NCAPITAL_WAIT,
                              NAGEMININS , NAGEMAXINS, NAGEMAXPER,
                              NTYPDURINS , NDURINSUR , NTYPDURPAY,
                              NDURPAY    , NROLE     , NCAPITAL,
                              DANIVERSARY, DSEEKTAR  , NRETARIF,
                              NBRANCH_REI, NCAUSEUPD , DFER,
                              NCAPITAL_O , NPREMIUM_O, NRATECOVE_O,
                              NCAPITAL_REQ,NREVALTYPE)
                      VALUES (SCERTYPE   , NBRANCH   , NPRODUCT,
                              NPOLICY    , NCERTIF   , NGROUP_INSU,
                              NMODULEC   , NCOVER    , DEFFECDATE,
                              NCAPITALI  , SCHANGE   , SYSDATE,
                              NCURRENCY  , NDISCOUNT , NFIXAMOUNT,
                              SFRANDEDI  , NMAXAMOUNT, SFREE_PREMI,
                              NMINAMOUNT , NPREMIUM  , NRATE,
                              NWAIT_QUAN , NRATECOVE , NUSERCODE,
                              SWAIT_TYPE , SFRANCAPL , NDISC_AMOUN,
                              DNULLDATE  , SCLIENT_AUX   , NCAPITAL_WAIT,
                              NAGEMININS , NAGEMAXINS, NAGEMAXPER_AUX,
                              NTYPDURINS , NDURINSUR , NTYPDURPAY,
                              NDURPAY    , NROLE     , NCAPITAL,
                              DANIVERSARY, DSEEKTAR  , NRETARIF,
                              NBRANCH_REI, NCAUSEUPD , DFER,
                              NCAPITAL_O , NPREMIUM_O, NRATECOVE_O,
                              NCAPITAL_REQ, NREVALTYPE_A);
/*+ SI LA ACCION ES ACTUALIZAR */
        ELSIF NACTION = 2 THEN
            OPEN C_COVER;
            FETCH C_COVER
             INTO R_COVER;
            BFOUND := C_COVER%FOUND;
            CLOSE C_COVER;
            SCOVER := NVL(TO_CHAR(R_COVER.NCAPITAL), '*')||NVL(TO_CHAR(R_COVER.NCAPITALI), '*')||NVL(R_COVER.SCHANGE, '*')||NVL(R_COVER.SFRANDEDI, '*')||NVL(TO_CHAR(R_COVER.NCURRENCY), '*')||NVL(TO_CHAR(R_COVER.NDISCOUNT), '*')||NVL(TO_CHAR(R_COVER.NFIXAMOUNT), '*')||NVL(TO_CHAR(R_COVER.NMAXAMOUNT), '*')||NVL(R_COVER.SFREE_PREMI, '*')||NVL(TO_CHAR(R_COVER.NMINAMOUNT), '*')||NVL(TO_CHAR(R_COVER.NPREMIUM), '*')||NVL(TO_CHAR(R_COVER.NRATE), '*')||NVL(TO_CHAR(R_COVER.NWAIT_QUAN), '*')||NVL(TO_CHAR(R_COVER.NRATECOVE), '*')||NVL(R_COVER.SWAIT_TYPE, '*')||NVL(R_COVER.SFRANCAPL, '*')||NVL(TO_CHAR(R_COVER.NDISC_AMOUN), '*')||NVL(TO_CHAR(R_COVER.NTYPDURINS), '*')||NVL(TO_CHAR(R_COVER.NDURINSUR), '*')||NVL(TO_CHAR(R_COVER.NAGEMININS), '*')||NVL(TO_CHAR(R_COVER.NAGEMAXINS), '*')||NVL(TO_CHAR(R_COVER.NAGEMAXPER), '*')||NVL(TO_CHAR(R_COVER.NTYPDURPAY), '*')||NVL(TO_CHAR(R_COVER.NDURPAY), '*')||NVL(TO_CHAR(R_COVER.NCAUSEUPD), '*')||NVL(TO_CHAR(R_COVER.NCAPITAL_WAIT), '*')||NVL(TO_CHAR(R_COVER.DANIVERSARY), '*')||NVL(TO_CHAR(R_COVER.DSEEKTAR), '*')||NVL(TO_CHAR(R_COVER.DFER), '*')||NVL(TO_CHAR(R_COVER.NBRANCH_REI), '*')||NVL(TO_CHAR(R_COVER.NRETARIF), '*');
            SCOVERNEW := NVL(TO_CHAR(NCAPITAL), '*')||NVL(TO_CHAR(NCAPITALI), '*')||NVL(SCHANGE, '*')||NVL(SFRANDEDI, '*')||NVL(TO_CHAR(NCURRENCY), '*')||NVL(TO_CHAR(NDISCOUNT), '*')||NVL(TO_CHAR(NFIXAMOUNT), '*')||NVL(TO_CHAR(NMAXAMOUNT), '*')||NVL(SFREE_PREMI, '*')||NVL(TO_CHAR(NMINAMOUNT), '*')||NVL(TO_CHAR(NPREMIUM), '*')||NVL(TO_CHAR(NRATE), '*')||NVL(TO_CHAR(NWAIT_QUAN), '*')||NVL(TO_CHAR(NRATECOVE), '*')||NVL(SWAIT_TYPE, '*')||NVL(SFRANCAPL, '*')||NVL(TO_CHAR(NDISC_AMOUN), '*')||NVL(TO_CHAR(NTYPDURINS), '*')||NVL(TO_CHAR(NDURINSUR), '*')||NVL(TO_CHAR(NAGEMININS), '*')||NVL(TO_CHAR(NAGEMAXINS), '*')||NVL(TO_CHAR(NAGEMAXPER), '*')||NVL(TO_CHAR(NTYPDURPAY), '*')||NVL(TO_CHAR(NDURPAY), '*')||NVL(TO_CHAR(NCAUSEUPD), '*')||NVL(TO_CHAR(NCAPITAL_WAIT), '*')||NVL(TO_CHAR(DANIVERSARY), '*')||NVL(TO_CHAR(DSEEKTAR), '*')||NVL(TO_CHAR(DFER), '*')||NVL(TO_CHAR(NBRANCH_REI), '*')||NVL(TO_CHAR(NRETARIF), '*');
            BFOUND := SCOVER <> SCOVERNEW;

/*+ SI EXISTE UN REGISTRO CON FECHA DE EFECTO IGUAL A LA FECHA RECIBIDA COMO PARAMETRO, */
/*+ SE ACTUALIZA EL MISMO REGISTRO */
            IF BFOUND THEN
                
                UPDATE COVER SET DNULLDATE = INSUPDCOVER.DEFFECDATE,
                                 DCOMPDATE = SYSDATE,
                                 NUSERCODE = INSUPDCOVER.NUSERCODE
                 WHERE ROWID = R_COVER.ROWID;
                INSERT INTO COVER(SCERTYPE   , NBRANCH   , NPRODUCT,
                                  NPOLICY    , NCERTIF   , NGROUP_INSU,
                                  NMODULEC   , NCOVER    , DEFFECDATE,
                                  NCAPITALI  , SCHANGE   , DCOMPDATE,
                                  NCURRENCY  , NDISCOUNT , NFIXAMOUNT,
                                  SFRANDEDI  , NMAXAMOUNT, SFREE_PREMI,
                                  NMINAMOUNT , NPREMIUM  , NRATE,
                                  NWAIT_QUAN , NRATECOVE , NUSERCODE,
                                  SWAIT_TYPE , SFRANCAPL , NDISC_AMOUN,
                                  DNULLDATE  , SCLIENT   , NCAPITAL_WAIT,
                                  NAGEMININS , NAGEMAXINS, NAGEMAXPER,
                                  NTYPDURINS , NDURINSUR , NTYPDURPAY,
                                  NDURPAY    , NROLE     , NCAPITAL,
                                  DANIVERSARY, DSEEKTAR  , NRETARIF,
                                  NBRANCH_REI, NCAUSEUPD , DFER,
                                  NCAPITAL_O , NPREMIUM_O, NRATECOVE_O,
                                  NCAPITAL_REQ,NREVALTYPE)
                           VALUES(SCERTYPE   , NBRANCH   , NPRODUCT,
                                  NPOLICY    , NCERTIF   , NGROUP_INSU,
                                  NMODULEC   , NCOVER    , DEFFECDATE,
                                  NCAPITALI  , SCHANGE   , SYSDATE,
                                  NCURRENCY  , NDISCOUNT , NFIXAMOUNT,
                                  SFRANDEDI  , NMAXAMOUNT, SFREE_PREMI,
                                  NMINAMOUNT , NPREMIUM  , NRATE,
                                  NWAIT_QUAN , NRATECOVE , NUSERCODE,
                                  SWAIT_TYPE , SFRANCAPL , NDISC_AMOUN,
                                  DNULLDATE  , SCLIENT_AUX   , NCAPITAL_WAIT,
                                  NAGEMININS , NAGEMAXINS, NAGEMAXPER_AUX,
                                  NTYPDURINS , NDURINSUR , NTYPDURPAY,
                                  NDURPAY    , NROLE     , NCAPITAL,
                                  DANIVERSARY, DSEEKTAR  , NRETARIF,
                                  NBRANCH_REI, NCAUSEUPD , DFER,
                                  NCAPITAL_O , NPREMIUM_O, NRATECOVE_O,
                                  NCAPITAL_REQ,NREVALTYPE_A);

                INSERT INTO COVER(SCERTYPE   , NBRANCH      , NPRODUCT,
                                  NPOLICY    , NCERTIF      , NGROUP_INSU,
                                  NMODULEC   , NCOVER       , DEFFECDATE,
                                  NCAPITALI  , SCHANGE      , DCOMPDATE,
                                  NCURRENCY  , NDISCOUNT    , NFIXAMOUNT,
                                  SFRANDEDI  , NMAXAMOUNT   , SFREE_PREMI,
                                  NMINAMOUNT , NPREMIUM     , NRATE,
                                  NWAIT_QUAN , NRATECOVE    , NUSERCODE,
                                  SWAIT_TYPE , SFRANCAPL    , NDISC_AMOUN,
                                  SCLIENT    , NCAPITAL_WAIT, NAGEMININS,
                                  NAGEMAXINS , NAGEMAXPER   , NTYPDURINS,
                                  NDURINSUR  , NTYPDURPAY   , NDURPAY,
                                  NROLE      , NCAPITAL     , DANIVERSARY,
                                  DSEEKTAR   , NRETARIF     , NBRANCH_REI,
                                  NCAUSEUPD  , DFER         , NCAPITAL_O,
                                  NPREMIUM_O , NRATECOVE_O  , NCAPITAL_REQ,
                                  NREVALTYPE)
                          VALUES (SCERTYPE          , NBRANCH              , NPRODUCT,
                                  NPOLICY           , NCERTIF              , NGROUP_INSU,
                                  NMODULEC          , NCOVER               , DNULLDATE,
                                  R_COVER.NCAPITALI , R_COVER.SCHANGE      , SYSDATE,
                                  R_COVER.NCURRENCY , R_COVER.NDISCOUNT    , R_COVER.NFIXAMOUNT,
                                  R_COVER.SFRANDEDI , R_COVER.NMAXAMOUNT   , R_COVER.SFREE_PREMI,
                                  R_COVER.NMINAMOUNT, R_COVER.NPREMIUM     , R_COVER.NRATE,
                                  R_COVER.NWAIT_QUAN, R_COVER.NRATECOVE    , NUSERCODE,
                                  R_COVER.SWAIT_TYPE, R_COVER.SFRANCAPL    , R_COVER.NDISC_AMOUN,
                                  SCLIENT_AUX           , R_COVER.NCAPITAL_WAIT, R_COVER.NAGEMININS,
                                  R_COVER.NAGEMAXINS, NAGEMAXPER_AUX   , R_COVER.NTYPDURINS,
                                  R_COVER.NDURINSUR , R_COVER.NTYPDURPAY   , R_COVER.NDURPAY,
                                  NROLE             , R_COVER.NCAPITAL     , R_COVER.DANIVERSARY,
                                  R_COVER.DSEEKTAR  , R_COVER.NRETARIF     , R_COVER.NBRANCH_REI,
                                  R_COVER.NCAUSEUPD , R_COVER.DFER         , R_COVER.NCAPITAL_O,
                                  R_COVER.NPREMIUM_O, R_COVER.NRATECOVE_O  , R_COVER.NCAPITAL_REQ,
                                  NREVALTYPE_A);
            END IF;

/*+ SI LA ACCION ES ELIMINAR */
        ELSIF NACTION = 3 THEN
            OPEN C_COVER;
            FETCH C_COVER
             INTO R_COVER;
            BFOUND := C_COVER%FOUND;
            CLOSE C_COVER;
            IF BFOUND THEN
                UPDATE COVER SET NCAUSEUPD = INSUPDCOVER.NCAUSEUPD,
                                 DNULLDATE = INSUPDCOVER.DEFFECDATE,
                                 DCOMPDATE = SYSDATE,
                                 NUSERCODE = INSUPDCOVER.NUSERCODE
                 WHERE ROWID = R_COVER.ROWID;
                INSERT INTO COVER(SCERTYPE   , NBRANCH      , NPRODUCT,
                                  NPOLICY    , NCERTIF      , NGROUP_INSU,
                                  NMODULEC   , NCOVER       , DEFFECDATE,
                                  NCAPITALI  , SCHANGE      , DCOMPDATE,
                                  NCURRENCY  , NDISCOUNT    , NFIXAMOUNT,
                                  SFRANDEDI  , NMAXAMOUNT   , SFREE_PREMI,
                                  NMINAMOUNT , NPREMIUM     , NRATE,
                                  NWAIT_QUAN , NRATECOVE    , NUSERCODE,
                                  SWAIT_TYPE , SFRANCAPL    , NDISC_AMOUN,
                                  SCLIENT    , NCAPITAL_WAIT, NAGEMININS,
                                  NAGEMAXINS , NAGEMAXPER   , NTYPDURINS,
                                  NDURINSUR  , NTYPDURPAY   , NDURPAY,
                                  NROLE      , NCAPITAL     , DANIVERSARY,
                                  DSEEKTAR   , NRETARIF     , NBRANCH_REI,
                                  NCAUSEUPD  , DFER         , NCAPITAL_O,
                                  NPREMIUM_O , NRATECOVE_O  , NCAPITAL_REQ,
                                  NREVALTYPE)
                          VALUES (SCERTYPE          , NBRANCH              , NPRODUCT,
                                  NPOLICY           , NCERTIF              , NGROUP_INSU,
                                  NMODULEC          , NCOVER               , DNULLDATE,
                                  R_COVER.NCAPITALI , R_COVER.SCHANGE      , SYSDATE,
                                  R_COVER.NCURRENCY , R_COVER.NDISCOUNT    , R_COVER.NFIXAMOUNT,
                                  R_COVER.SFRANDEDI , R_COVER.NMAXAMOUNT   , R_COVER.SFREE_PREMI,
                                  R_COVER.NMINAMOUNT, R_COVER.NPREMIUM     , R_COVER.NRATE,
                                  R_COVER.NWAIT_QUAN, R_COVER.NRATECOVE    , NUSERCODE,
                                  R_COVER.SWAIT_TYPE, R_COVER.SFRANCAPL    , R_COVER.NDISC_AMOUN,
                                  SCLIENT_AUX           , R_COVER.NCAPITAL_WAIT, R_COVER.NAGEMININS,
                                  R_COVER.NAGEMAXINS, NAGEMAXPER_AUX   , R_COVER.NTYPDURINS,
                                  R_COVER.NDURINSUR , R_COVER.NTYPDURPAY   , R_COVER.NDURPAY,
                                  NROLE             , R_COVER.NCAPITAL     , R_COVER.DANIVERSARY,
                                  R_COVER.DSEEKTAR  , R_COVER.NRETARIF     , R_COVER.NBRANCH_REI,
                                  R_COVER.NCAUSEUPD , R_COVER.DFER         , R_COVER.NCAPITAL_O,
                                  R_COVER.NPREMIUM_O, R_COVER.NRATECOVE_O  , R_COVER.NCAPITAL_REQ,
                                  NREVALTYPE_A);
            END IF;
        END IF;
    END IF;

    IF BFOUND THEN
        NUPDCOVER := 1;
    ELSE
        NUPDCOVER := 2;
    END IF;

    IF NCOMMIT = 1 THEN
        COMMIT;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20000, 'INSUPDCOVER::' || NMODULEC   || ', '
                                                        || NCOVER     || ', '
                                                        || DEFFECDATE || ', '
                                                        || NROLE      || ', '
                                                        || SCLIENT_AUX    || ', '
                                                        || NACTION    || '::', TRUE);
END INSUPDCOVER;