create or replace PROCEDURE INSUDB.INSPOSTGIL54740
  /*----------------------------------------------------------------------------*/
  /* NOMBRE    : INSPOSTGIL54740                                                */
  /* OBJETIVO  : PERMITE EFECTUAR LA MODIFICACION DE LA INTERMEDIACION Y SUS    */
  /*             ATRIBUTOS EN LOS RECIBOS DE UNA POLIZA. DICHAS MODIFICACIONES  */
  /*            SE HARAN A UNA FECHA DE EFECTO INDICADA EN EL ARCHIVO DE ENTRADA*/
  /*                                                                            */
  /* PARAMETROS: 1.- SKEY         :  CLAVE DEL PROCESO                          */
  /*             2.- NERROR       : NUMERO DE ERROR                             */
  /*             3.- NUSERCODE    : CODIGO USUARIO                              */
  /*             4.- NERROR       :  CODIGO ERROR                               */
  /*             5.- SERRORDESC   : DESCRIPCION DEL ERROR                       */
  /*                                                                            */
  /*Sourcesafe Information:                                                     */
  /*     $AUTHOR: GALICIA  $                                                    */
  /*     $DATE: 19/09/2016$                                                     */
  /*     $REVISION: 29/06/2023 - Mauro Gabbarini $                              */
  /*----------------------------------------------------------------------------*/
(SKEY       T_INTERFACE.SKEY%TYPE,
 NSHEET     MASTERSHEET.NSHEET%TYPE,
 NUSERCODE  MASTERSHEET.NUSERCODE%TYPE,
 NERROR     OUT T_ERR_INTERFACE.NERROR%TYPE,
 SERRORDESC OUT VARCHAR2) AUTHID CURRENT_USER AS

  /*VARIABLES DEL TXT*/
  TYPE RECTMP IS RECORD(
    NBRANCH      TMP_INT54740.NBRANCH%TYPE,
    NPRODUCT     TMP_INT54740.NPRODUCT%TYPE,
    NPOLICY      TMP_INT54740.NPOLICY%TYPE,
    NCERTIF      TMP_INT54740.NCERTIF%TYPE,
    DEFFECDATE   TMP_INT54740.DEFFECDATE%TYPE,
    NMODULEC     TMP_INT54740.NMODULEC%TYPE,
    NCOVER       TMP_INT54740.NCOVER%TYPE,
    NCAPITAL     TMP_INT54740.NCAPITAL%TYPE,
    NCAUSE_AMEND TMP_INT54740.NCAUSE_AMEND%TYPE,
    NIDSTRUC     TMP_INT54740.NIDSTRUC%TYPE,
    NLINE        TMP_INT54740.NLINE%TYPE);

  TYPE TABRECTMP IS TABLE OF RECTMP INDEX BY BINARY_INTEGER;
  RARRRECTMP TABRECTMP;

  -- ver
  /*VARIABLES DE VALIDACIONES*/
  NFIELDCOUNT                INTEGER := 0;
  NCOUNTROW                  T_INTERFACE.NROW%TYPE;
  NROWS                      INTEGER := 0;
  NSEQ                       INTEGER := 0;
  NEXIST_CERTIFICAT          INTEGER := 0;
  NEXIST_COMMERCIALSTRUCTURE INTEGER := 0;
  NEXIST_STRUCCOLLE          INTEGER := 0;
  NEXIST_POLICY_HIS          INTEGER := 0;
  NEXIST_NINFLEVEL           INTEGER := 0;
  NIDCOMPONENT_AUX           COMMERCIALSTRUCTURE.STRUCCOMPONENT.NIDCOMPONENT%TYPE;
  NIDCOMPONENT_AUX_INITIAL   COMMERCIALSTRUCTURE.STRUCCOMPONENT.NIDCOMPONENT%TYPE;
  NINFLEVEL_AUX              COMMERCIALSTRUCTURE.STRUCCOMPDETAILS.NINFLEVEL%TYPE;
  NIDSTRUC_AUX               COMMERCIALSTRUCTURE.STRUCEVENT.NIDSTRUC%TYPE;
  NTYPE_REC_AUX              AGREEMENT.NTYPE_REC%TYPE;
  SBANKINF_IND_AUX           AGREEMENT.SBANKINF_IND%TYPE;
  NCAUSE_AMEND_AUX           POLICY_HIS.NCAUSE_AMEND%TYPE;
  NCOMMERNUM_AUX             CERTIFICAT.NCOMMERNUM%TYPE;
  DEFFECDATE_POLICY_HIS      POLICY_HIS.DEFFECDATE%TYPE;
  SCLIENT_AUX                CERTIFICAT.SCLIENT%TYPE;
  NBANK_CODE_AUX             AGREEMENT.NBANK_CODE%TYPE;
  NCARD_TYPE_AUX             AGREEMENT.NCARD_TYPE%TYPE;
  NEXPCYCLE_AUX              NUMBER(5);
  NEXPIRRULE_AUX             COMMERCIALSTRUCTURE.STRUCCOLLENTITY.NEXPIRRULE%TYPE;
  NWAY_PAY_AUX               CERTIFICAT.NWAY_PAY%TYPE;
  DISSUEDAT_AUX              CERTIFICAT.DISSUEDAT%TYPE;
  NCOD_AGREE_AUX             AGREEMENT.NCOD_AGREE%TYPE;
  NTYP_ACC_AUX               INTEGER := 0;
  NAMOUNT_AUX                COVER.NCAPITAL%TYPE;
  NRATE_AUX                  NUMBER(6,2); --COVER.NRATE%TYPE;
  

  SPTABLENAME_AUX TAB_NAME_B.STABNAME%TYPE;
  SSEP            VARCHAR2(1);
  COLUMN_NAME     varchar2(100);
  CURSOR C_REASYSCOLUMNS(SOWNER ALL_TABLES.OWNER%TYPE, STABLENAME VARCHAR2) IS
    SELECT COLUMN_NAME
      FROM ALL_TAB_COLUMNS
     WHERE ALL_TAB_COLUMNS.TABLE_NAME = C_REASYSCOLUMNS.STABLENAME
       AND ALL_TAB_COLUMNS.OWNER = C_REASYSCOLUMNS.SOWNER;

  --    SCERTYPE_O CERTIFICAT.SCERTYPE%TYPE;
  NBRANCH_O  CERTIFICAT.NBRANCH%TYPE;
  NPRODUCT_O CERTIFICAT.NPRODUCT%TYPE;
  NPOLICY_O  CERTIFICAT.NPOLICY%TYPE;
  NCERTIF_O  CERTIFICAT.NCERTIF%TYPE;

  NIDCONSEC_AUX                COMMERCIALSTRUCTURE.STRUCEVENT.NIDCONSEC%TYPE;
  NTRANSACTIO_AUX              POLICY.NTRANSACTIO%TYPE;
  DEXPIRDAT_AUX                POLICY.DEXPIRDAT%TYPE;
  NMOVEMENT_AUX                POLICY_HIS.NMOVEMENT%TYPE;
  DNEXTRECEIPT_AUX             CERTIFICAT.DNEXTRECEIP%TYPE;
  DEFFECDATE_COVER             COVER.DEFFECDATE%TYPE;
  DEFFECDATE_PARTICULARTABLE   HOMEOWNER.DEFFECDATE%TYPE;
  DEFFECDATE_SPECIFIC_RISK_COV SPECIFIC_RISK_COV.DEFFECDATE%TYPE;
  SPOLITYPE_AUX                POLICY.SPOLITYPE%TYPE;
  NMODULEC_AUX                 COVER.NMODULEC%TYPE;
  NCOVER_AUX                   COVER.NCOVER%TYPE;
  NEXIST_NCAUSE_AMEND          INTEGER := 0;
  NEXIST_NIDSTRUC              INTEGER := 0;
  NEXIST_NCAPITAL              INTEGER := 0;
  NEXIST_CERTIFICADO_VIGENTE   INTEGER := 0;
  BINDICATOR                   BOOLEAN DEFAULT FALSE;
  NRATECOVE_AUX                COVER.NRATECOVE%TYPE;
  SBRANCHT_AUX                 PRODMASTER.SBRANCHT%TYPE;
  SQUERYTOEXEC                 VARCHAR2(2000);
  SSEL                         VARCHAR2(2000);
  SSEL2                        VARCHAR2(2000);
  EXISTE_SPECIFIC_RISK_COV     VARCHAR2(1) := 'N';
  --    NREVALTYPE_AUX            COVER.NREVALTYPE%TYPE;
  -- ver
  
    -- BDT 20240320 Declaro variables - Feature 5163 - Aplicación de revenue en endosos de upgrade/downgrade
  NDIAS INTEGER := 0;
  NMOVPOLICY_HIS INTEGER := 0;
  DEFFECDATE_COVER_INIHBIR COVER.DEFFECDATE%TYPE;
  NDIAS_INHIBIR INTEGER := 0;
  NCAUSE_AMEND_INHIBIR POLICY_HIS.NCAUSE_AMEND%TYPE;
  
  /*VALIDAA EL TIPO DE DATO DE DETERMINADO STRING A NUMBER*/
  FUNCTION IS_NUMBER(STR IN VARCHAR2) RETURN BOOLEAN IS
    DUMMY NUMBER;
  BEGIN
    DUMMY := TO_NUMBER(STR);
    RETURN TRUE;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;

  /*VALIDAA EL TIPO DE DATO DE DETERMINADO STRING A DATE*/
  FUNCTION IS_DATE(STR IN VARCHAR2) RETURN BOOLEAN IS
    DUMMY DATE;
  BEGIN
    DUMMY := TO_DATE(STR, 'DD/MM/YYYY');
    RETURN TRUE;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;

  /*-------------------------------------------------------------------------------*/
BEGIN

-- BDT 20240320 Tomo cantidad de días del parámetro - Feature 5163 - Aplicación de revenue en endosos de upgrade/downgrade

    SELECT NVL(SVALUE,0)
    INTO   NDIAS
    FROM   T_PARAM_INTERFACE
    WHERE   SKEY = INSPOSTGIL54740.SKEY 
    AND NFIELD = 11;

  BEGIN
    --        DELETE TIMETMP.TMP_INT54740;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE TIMETMP.TMP_INT54740 ';
  END;

  /*SE VERIFICA CUANTOS REGISTROS DISTINTOS EXISTEN PARA LA LLAVE EN TRATAMIENTO*/
  BEGIN
    SELECT MAX(NROW)
      INTO NCOUNTROW
      FROM T_INTERFACE
     WHERE SKEY = INSPOSTGIL54740.SKEY;
  END;

  BEGIN
    FOR R_REG IN 1 .. NCOUNTROW LOOP
      NROWS := NROWS + 1;
    
      --        SE LEE T_INTERFACE PARA LLENAR LA TABLA ARREGLO
      FOR R_REG_IN IN (SELECT NCOLUMN, SVALUE
                         FROM T_INTERFACE
                        WHERE SKEY = INSPOSTGIL54740.SKEY
                          AND NROW = INSPOSTGIL54740.NROWS
                        ORDER BY NCOLUMN ASC) LOOP
        --CRETRACE2('CARGAR ARREGLO '||INSPOSTGIL54740.NROWS,2311,'NCOLUMN='||R_REG_IN.NCOLUMN||' '||'SVALUE='||R_REG_IN.SVALUE);
        CASE R_REG_IN.NCOLUMN
          WHEN 1 THEN
            RARRRECTMP(NROWS).NBRANCH := NVL(TRIM(R_REG_IN.SVALUE), 0);
          WHEN 2 THEN
            RARRRECTMP(NROWS).NPRODUCT := NVL(TRIM(R_REG_IN.SVALUE), 0);
          WHEN 3 THEN
            RARRRECTMP(NROWS).NPOLICY := NVL(TRIM(R_REG_IN.SVALUE), 0);
          WHEN 4 THEN
            RARRRECTMP(NROWS).NCERTIF := NVL(TRIM(R_REG_IN.SVALUE), 0);
          WHEN 5 THEN
            IF LENGTH(TRIM(R_REG_IN.SVALUE)) = 8 AND
               (R_REG_IN.SVALUE <> '00000000' OR
                TRIM(R_REG_IN.SVALUE) <> '') THEN
              RARRRECTMP(NROWS).DEFFECDATE := TO_DATE(TRIM(R_REG_IN.SVALUE),
                                                      'DD/MM/YYYY');
            
            ELSE
              RARRRECTMP(NROWS).DEFFECDATE := NULL;
            
            END IF;
          
          WHEN 6 THEN
            RARRRECTMP(NROWS).NMODULEC := NVL(TRIM(R_REG_IN.SVALUE), 0);
          WHEN 7 THEN
            RARRRECTMP(NROWS).NCOVER := NVL(TRIM(R_REG_IN.SVALUE), 0);
          WHEN 8 THEN
            RARRRECTMP(NROWS).NCAPITAL := NVL(TRIM(R_REG_IN.SVALUE), 0);
          WHEN 9 THEN
            RARRRECTMP(NROWS).NCAUSE_AMEND := NVL(TRIM(R_REG_IN.SVALUE), 0);
          WHEN 10 THEN
            RARRRECTMP(NROWS).NIDSTRUC := NVL(TRIM(R_REG_IN.SVALUE), 0);
          ELSE
            RARRRECTMP(NROWS).NLINE := TRIM(R_REG_IN.SVALUE);
        END CASE;
      
        RARRRECTMP(NROWS).NLINE := NROWS;
 
      END LOOP;
    END LOOP;
  
  END;

  /*SE VALIDAN LOS CAMPOS INCLUIDOS EN EL ARCHIVO*/
  BEGIN
  
    FOR NDUMMY IN RARRRECTMP.FIRST .. RARRRECTMP.LAST LOOP
      --             SE GUARDAN LOS DATOS 
      --             --CRETRACE2('INSPOSTGIL54043 174',2428,'RARRRECTMP(NDUMMY).NPOLICY '||RARRRECTMP(NDUMMY).NPOLICY);
      NSEQ := NSEQ + 1;
      BEGIN
       
        INSERT INTO TIMETMP.TMP_INT54740
          (SKEY,
           NSEQ,
           SSUCESSFUL,
           NBRANCH,
           NPRODUCT,
           NPOLICY,
           NCERTIF,
           DEFFECDATE,
           NMODULEC,
           NCOVER,
           NCAPITAL,
           NCAUSE_AMEND,
           NIDSTRUC,
           SERROR,
           NLINE,
           NINDICATOR)
        VALUES
          (INSPOSTGIL54740.SKEY,
           INSPOSTGIL54740.NSEQ,
           NULL,
           RARRRECTMP          (NDUMMY).NBRANCH,
           RARRRECTMP          (NDUMMY).NPRODUCT,
           RARRRECTMP          (NDUMMY).NPOLICY,
           RARRRECTMP          (NDUMMY).NCERTIF,
           RARRRECTMP          (NDUMMY).DEFFECDATE,
           RARRRECTMP          (NDUMMY).NMODULEC,
           RARRRECTMP          (NDUMMY).NCOVER,
           RARRRECTMP          (NDUMMY).NCAPITAL,
           RARRRECTMP          (NDUMMY).NCAUSE_AMEND,
           RARRRECTMP          (NDUMMY).NIDSTRUC,
           '',
           RARRRECTMP          (NDUMMY).NLINE,
           NULL);
      
      END;
    END LOOP;
    --            --CRETRACE2('INSPOSTGIL54043 193',2428,'RARRRECTMP(NDUMMY).NPOLICY ');
  
    NSEQ := 0;
  
    NBRANCH_O  := NULL;
    NPRODUCT_O := NULL;
    NPOLICY_O  := NULL;
    NCERTIF_O  := NULL;
    /*SE RECORREN LOS DISTINTOS REGISTROS DE LA TABLA PARA VALIDARLOS*/
    FOR R_REG IN (SELECT SKEY,
                         NSEQ,
                         SSUCESSFUL,
                         NBRANCH,
                         NPRODUCT,
                         NPOLICY,
                         NCERTIF,
                         DEFFECDATE,
                         NMODULEC,
                         NCOVER,
                         NCAPITAL,
                         NCAUSE_AMEND,
                         NIDSTRUC,
                         SERROR,
                         NLINE,
                         NINDICATOR
                    FROM TIMETMP.TMP_INT54740
                   WHERE SKEY = INSPOSTGIL54740.SKEY
                     AND NINDICATOR IS NULL
                   ORDER BY NBRANCH, NPOLICY, NCERTIF) LOOP
      --CRETRACE2('INSPOSTGIL54043 206',2428,'INSPOSTGIL54740.SKEY '||INSPOSTGIL54740.SKEY);
    
      /*RAMO*/
      IF IS_NUMBER(R_REG.NBRANCH) AND R_REG.NBRANCH = 0 THEN
        NSEQ := NSEQ + 1;
    
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Ramo: Debe estar lleno.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      ELSIF NOT IS_NUMBER(R_REG.NBRANCH) THEN
        NSEQ := NSEQ + 1;
     
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Ramo: Valor no numerico.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      END IF;
    
      /*PRODUCTO*/
      --             --CRETRACE2('INSPOSTGIL54043 249',2428,'R_REG.NPRODUCT '||R_REG.NPRODUCT);
      IF IS_NUMBER(R_REG.NPRODUCT) AND R_REG.NPRODUCT = 0 THEN
        NSEQ := NSEQ + 1;
     
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Producto: Debe estar lleno.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      ELSIF NOT IS_NUMBER(R_REG.NPRODUCT) THEN
        NSEQ := NSEQ + 1;
    
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Producto:  Valor no numerico',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      END IF;
    
      /*POLIZA*/
      --             --CRETRACE2('INSPOSTGIL54043 291',2428,'R_REG.NPOLICY '||R_REG.NPOLICY);
      IF IS_NUMBER(R_REG.NPOLICY) AND R_REG.NPOLICY = 0 THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Poliza: Debe estar lleno. ',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      ELSIF NOT IS_NUMBER(R_REG.NPOLICY) THEN
        NSEQ := NSEQ + 1;
     
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Poliza: Valor no numerico.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      END IF;
    
      /*CERTIFICADO*/
      --             --CRETRACE2('INSPOSTGIL54043 333',2428,'R_REG.NCERTIF '||R_REG.NCERTIF);
      IF IS_NUMBER(R_REG.NCERTIF) AND R_REG.NCERTIF < 0 THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Certificado: Debe estar lleno.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      ELSIF NOT IS_NUMBER(R_REG.NCERTIF) THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Certificado: Valor no numerico',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      END IF;
    
      /*FECHA DE EFECTO*/
      ----CRETRACE2('INSPOSTGIL54043 375',24281,'R_REG.DEFFECDATE '||R_REG.DEFFECDATE);
      IF NOT IS_DATE(TO_CHAR(R_REG.DEFFECDATE)) THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Fecha de efecto: Valor no tipo fecha',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      END IF;
    
      /*FECHA DE EFECTO*/
      BEGIN
        NSEQ := NSEQ + 1;
        
        BEGIN
          SELECT 1
            INTO NEXIST_POLICY_HIS
            FROM POLICY_HIS
           WHERE SCERTYPE = '2'
             AND NBRANCH = R_REG.NBRANCH
             AND NPRODUCT = R_REG.NPRODUCT
             AND NPOLICY = R_REG.NPOLICY
             AND NCERTIF = R_REG.NCERTIF
             AND NTYPE_AMEND = 905
             AND DEFFECDATE > R_REG.DEFFECDATE;
        EXCEPTION
          WHEN OTHERS THEN
            NEXIST_POLICY_HIS := 0;
        END;
        --                --CRETRACE2('INSPOSTGIL54043 661',2428,'NEXIST_POLICY_HIS '||NEXIST_POLICY_HIS);
        IF NEXIST_POLICY_HIS = 1 THEN
          
          BEGIN
            INSERT INTO TIMETMP.TMP_INT54740
              (SKEY,
               NSEQ,
               SSUCESSFUL,
               NBRANCH,
               NPRODUCT,
               NPOLICY,
               NCERTIF,
               DEFFECDATE,
               NMODULEC,
               NCOVER,
               NCAPITAL,
               NCAUSE_AMEND,
               NIDSTRUC,
               SERROR,
               NLINE,
               NINDICATOR)
            VALUES
              (INSPOSTGIL54740.SKEY,
               INSPOSTGIL54740.NSEQ,
               'FALLIDO',
               R_REG.NBRANCH,
               R_REG.NPRODUCT,
               R_REG.NPOLICY,
               R_REG.NCERTIF,
               R_REG.DEFFECDATE,
               R_REG.NMODULEC,
               R_REG.NCOVER,
               R_REG.NCAPITAL,
               R_REG.NCAUSE_AMEND,
               R_REG.NIDSTRUC,
               'Poliza/Certificado con fecha de endoso anterior al ultimo endoso de suma asegurada realizado.',
               R_REG.NLINE,
               1);
          END;
          BINDICATOR := TRUE;
        END IF;
      END;
    
      /*FECHA DE NEXTRECEIPT*/
      BEGIN
        NSEQ := NSEQ + 1;
        
        BEGIN
          SELECT DNEXTRECEIP
            INTO DNEXTRECEIPT_AUX
            FROM CERTIFICAT
           WHERE SCERTYPE = '2'
             AND NBRANCH = R_REG.NBRANCH
             AND NPRODUCT = R_REG.NPRODUCT
             AND NPOLICY = R_REG.NPOLICY
             AND NCERTIF = R_REG.NCERTIF;
          -- AND NTYPE_AMEND = 905
          -- AND DEFFECDATE > R_REG.DEFFECDATE;
        EXCEPTION
          WHEN OTHERS THEN
            DNEXTRECEIPT_AUX := NULL;
        END;
        --                --CRETRACE2('INSPOSTGIL54043 661',2428,'NEXIST_POLICY_HIS '||NEXIST_POLICY_HIS);
        IF DNEXTRECEIPT_AUX <> R_REG.DEFFECDATE THEN
          
          BEGIN
            INSERT INTO TIMETMP.TMP_INT54740
              (SKEY,
               NSEQ,
               SSUCESSFUL,
               NBRANCH,
               NPRODUCT,
               NPOLICY,
               NCERTIF,
               DEFFECDATE,
               NMODULEC,
               NCOVER,
               NCAPITAL,
               NCAUSE_AMEND,
               NIDSTRUC,
               SERROR,
               NLINE,
               NINDICATOR)
            VALUES
              (INSPOSTGIL54740.SKEY,
               INSPOSTGIL54740.NSEQ,
               'FALLIDO',
               R_REG.NBRANCH,
               R_REG.NPRODUCT,
               R_REG.NPOLICY,
               R_REG.NCERTIF,
               R_REG.DEFFECDATE,
               R_REG.NMODULEC,
               R_REG.NCOVER,
               R_REG.NCAPITAL,
               R_REG.NCAUSE_AMEND,
               R_REG.NIDSTRUC,
               'Certificado con fecha nreceipt distinta a fecha de efecto.',
               R_REG.NLINE,
               1);
          END;
          BINDICATOR := TRUE;
        END IF;
      END;
    
      /*MODULO*/
      IF IS_NUMBER(R_REG.NMODULEC) AND R_REG.NMODULEC = 0 THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Modulo: Debe estar lleno.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      ELSIF NOT IS_NUMBER(R_REG.NMODULEC) THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Modulo: Valor no numerico.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      END IF;
    
      /*COBERTURA*/
      IF IS_NUMBER(R_REG.NCOVER) AND R_REG.NCOVER = 0 THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Cobertura: Debe estar lleno.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      ELSIF NOT IS_NUMBER(R_REG.NCOVER) THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Cobertura: Valor no numerico.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      END IF;
    
      /*SUMA ASEGURADA*/
      IF IS_NUMBER(R_REG.NCAPITAL) AND R_REG.NCAPITAL = 0 THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Suma Asegurada: Debe estar lleno.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      ELSIF NOT IS_NUMBER(R_REG.NCAPITAL) THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Suma Asegurada: Valor no numerico.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      END IF;
    
      --           /*CAUSA DE ENDOSO*/
      ----           --CRETRACE2('INSPOSTGIL54043 483',2428,'R_REG.NCAUSE_AMEND '||R_REG.NCAUSE_AMEND);
      IF IS_NUMBER(R_REG.NCAUSE_AMEND) AND R_REG.NCAUSE_AMEND <= 0 THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Causa de endoso: Debe estar lleno.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      ELSIF NOT IS_NUMBER(R_REG.NCAUSE_AMEND) THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Causa de endoso: Valor no numerico',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      END IF;
    
      /*ESTRUCTURA DE GESTION*/
      ----             --CRETRACE2('INSPOSTGIL54043 525',2428,'R_REG.NIDSTRUC '||R_REG.NIDSTRUC);
      IF IS_NUMBER(R_REG.NIDSTRUC) AND R_REG.NIDSTRUC <= 0 THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Estructura de gestion: Debe estar lleno.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      ELSIF NOT IS_NUMBER(R_REG.NIDSTRUC) THEN
        NSEQ := NSEQ + 1;
        
        BEGIN
          INSERT INTO TIMETMP.TMP_INT54740
            (SKEY,
             NSEQ,
             SSUCESSFUL,
             NBRANCH,
             NPRODUCT,
             NPOLICY,
             NCERTIF,
             DEFFECDATE,
             NMODULEC,
             NCOVER,
             NCAPITAL,
             NCAUSE_AMEND,
             NIDSTRUC,
             SERROR,
             NLINE,
             NINDICATOR)
          VALUES
            (INSPOSTGIL54740.SKEY,
             INSPOSTGIL54740.NSEQ,
             'FALLIDO',
             R_REG.NBRANCH,
             R_REG.NPRODUCT,
             R_REG.NPOLICY,
             R_REG.NCERTIF,
             R_REG.DEFFECDATE,
             R_REG.NMODULEC,
             R_REG.NCOVER,
             R_REG.NCAPITAL,
             R_REG.NCAUSE_AMEND,
             R_REG.NIDSTRUC,
             'Estructura de gestion: Valor no numerico.',
             R_REG.NLINE,
             1);
        END;
        BINDICATOR := TRUE;
      END IF;
    
      /*POLIZA COLECTIVA CERTIFICADO 0*/
      BEGIN
        NSEQ := NSEQ + 1;
        
        BEGIN
          SELECT SPOLITYPE
            INTO SPOLITYPE_AUX
            FROM POLICY
           WHERE SCERTYPE = '2'
             AND NBRANCH = R_REG.NBRANCH
             AND NPRODUCT = R_REG.NPRODUCT
             AND NPOLICY = R_REG.NPOLICY;
          --AND NCERTIF = R_REG.NCERTIF
          --AND NTYPE_AMEND = 905
          --AND DEFFECDATE > R_REG.DEFFECDATE;
        EXCEPTION
          WHEN OTHERS THEN
            SPOLITYPE_AUX := 0;
        END;
        --                --CRETRACE2('INSPOSTGIL54043 661',2428,'NEXIST_POLICY_HIS '||NEXIST_POLICY_HIS);
        IF SPOLITYPE_AUX = 2 AND R_REG.NCERTIF = 0 THEN
          
          BEGIN
            INSERT INTO TIMETMP.TMP_INT54740
              (SKEY,
               NSEQ,
               SSUCESSFUL,
               NBRANCH,
               NPRODUCT,
               NPOLICY,
               NCERTIF,
               DEFFECDATE,
               NMODULEC,
               NCOVER,
               NCAPITAL,
               NCAUSE_AMEND,
               NIDSTRUC,
               SERROR,
               NLINE,
               NINDICATOR)
            VALUES
              (INSPOSTGIL54740.SKEY,
               INSPOSTGIL54740.NSEQ,
               'FALLIDO',
               R_REG.NBRANCH,
               R_REG.NPRODUCT,
               R_REG.NPOLICY,
               R_REG.NCERTIF,
               R_REG.DEFFECDATE,
               R_REG.NMODULEC,
               R_REG.NCOVER,
               R_REG.NCAPITAL,
               R_REG.NCAUSE_AMEND,
               R_REG.NIDSTRUC,
               'Poliza Colectiva no se puede endosar el certificado 0.',
               R_REG.NLINE,
               1);
          END;
          BINDICATOR := TRUE;
        END IF;
      END;
    
      /*MODULO*/
      BEGIN
        NSEQ := NSEQ + 1;
        
        BEGIN
          SELECT NMODULEC
            INTO NMODULEC_AUX
            FROM COVER
           WHERE SCERTYPE = '2'
             AND NBRANCH = R_REG.NBRANCH
             AND NPRODUCT = R_REG.NPRODUCT
             AND NPOLICY = R_REG.NPOLICY
             AND NCERTIF = R_REG.NCERTIF
             AND NCOVER = R_REG.NCOVER
             AND DEFFECDATE <= R_REG.DEFFECDATE
             AND (DNULLDATE IS NULL OR DNULLDATE > R_REG.DEFFECDATE);
          --AND NTYPE_AMEND = 905
          --AND DEFFECDATE > R_REG.DEFFECDATE;
        EXCEPTION
          WHEN OTHERS THEN
            NMODULEC_AUX := 0;
        END;
        --                --CRETRACE2('INSPOSTGIL54043 661',2428,'NEXIST_POLICY_HIS '||NEXIST_POLICY_HIS);
        IF NMODULEC_AUX <> R_REG.NMODULEC THEN
          
          BEGIN
            INSERT INTO TIMETMP.TMP_INT54740
              (SKEY,
               NSEQ,
               SSUCESSFUL,
               NBRANCH,
               NPRODUCT,
               NPOLICY,
               NCERTIF,
               DEFFECDATE,
               NMODULEC,
               NCOVER,
               NCAPITAL,
               NCAUSE_AMEND,
               NIDSTRUC,
               SERROR,
               NLINE,
               NINDICATOR)
            VALUES
              (INSPOSTGIL54740.SKEY,
               INSPOSTGIL54740.NSEQ,
               'FALLIDO',
               R_REG.NBRANCH,
               R_REG.NPRODUCT,
               R_REG.NPOLICY,
               R_REG.NCERTIF,
               R_REG.DEFFECDATE,
               R_REG.NMODULEC,
               R_REG.NCOVER,
               R_REG.NCAPITAL,
               R_REG.NCAUSE_AMEND,
               R_REG.NIDSTRUC,
               'El modulo no es el configurado.',
               R_REG.NLINE,
               1);
          END;
          BINDICATOR := TRUE;
        END IF;
      END;
    
      /*COBERTURA*/
      BEGIN
        NSEQ := NSEQ + 1;
        
        BEGIN
          SELECT NCOVER
            INTO NCOVER_AUX
            FROM COVER
           WHERE SCERTYPE = '2'
             AND NBRANCH = R_REG.NBRANCH
             AND NPRODUCT = R_REG.NPRODUCT
             AND NPOLICY = R_REG.NPOLICY
             AND NCERTIF = R_REG.NCERTIF
             AND NCOVER = R_REG.NCOVER
             AND DEFFECDATE <= R_REG.DEFFECDATE
             AND (DNULLDATE IS NULL OR DNULLDATE > R_REG.DEFFECDATE);
          --AND NTYPE_AMEND = 905
          --AND DEFFECDATE > R_REG.DEFFECDATE;
        EXCEPTION
          WHEN OTHERS THEN
            NCOVER_AUX := 0;
        END;
        --                --CRETRACE2('INSPOSTGIL54043 661',2428,'NEXIST_POLICY_HIS '||NEXIST_POLICY_HIS);
        IF NCOVER_AUX <> R_REG.NCOVER THEN
          
          BEGIN
            INSERT INTO TIMETMP.TMP_INT54740
              (SKEY,
               NSEQ,
               SSUCESSFUL,
               NBRANCH,
               NPRODUCT,
               NPOLICY,
               NCERTIF,
               DEFFECDATE,
               NMODULEC,
               NCOVER,
               NCAPITAL,
               NCAUSE_AMEND,
               NIDSTRUC,
               SERROR,
               NLINE,
               NINDICATOR)
            VALUES
              (INSPOSTGIL54740.SKEY,
               INSPOSTGIL54740.NSEQ,
               'FALLIDO',
               R_REG.NBRANCH,
               R_REG.NPRODUCT,
               R_REG.NPOLICY,
               R_REG.NCERTIF,
               R_REG.DEFFECDATE,
               R_REG.NMODULEC,
               R_REG.NCOVER,
               R_REG.NCAPITAL,
               R_REG.NCAUSE_AMEND,
               R_REG.NIDSTRUC,
               'La cobertura no es la configurada.',
               R_REG.NLINE,
               1);
          END;
          BINDICATOR := TRUE;
        END IF;
      END;
    
      /*CERTIFICADO VIGENTE*/
      BEGIN
        NSEQ := NSEQ + 1;
        
        BEGIN
          SELECT 1
            INTO NEXIST_CERTIFICADO_VIGENTE
            FROM CERTIFICAT
           WHERE SCERTYPE = '2'
             AND NBRANCH = R_REG.NBRANCH
             AND NPRODUCT = R_REG.NPRODUCT
             AND NPOLICY = R_REG.NPOLICY
             AND NCERTIF = R_REG.NCERTIF
             AND SSTATUSVA IN (4, 5);
          --                       AND NTYPE_AMEND = 905
          --                       AND DEFFECDATE > R_REG.DEFFECDATE;
        EXCEPTION
          WHEN OTHERS THEN
            NEXIST_CERTIFICADO_VIGENTE := 0;
        END;
        --                --CRETRACE2('INSPOSTGIL54043 661',2428,'NEXIST_POLICY_HIS '||NEXIST_POLICY_HIS);
        IF NEXIST_CERTIFICADO_VIGENTE <> 1 THEN
          
          BEGIN
            INSERT INTO TIMETMP.TMP_INT54740
              (SKEY,
               NSEQ,
               SSUCESSFUL,
               NBRANCH,
               NPRODUCT,
               NPOLICY,
               NCERTIF,
               DEFFECDATE,
               NMODULEC,
               NCOVER,
               NCAPITAL,
               NCAUSE_AMEND,
               NIDSTRUC,
               SERROR,
               NLINE,
               NINDICATOR)
            VALUES
              (INSPOSTGIL54740.SKEY,
               INSPOSTGIL54740.NSEQ,
               'FALLIDO',
               R_REG.NBRANCH,
               R_REG.NPRODUCT,
               R_REG.NPOLICY,
               R_REG.NCERTIF,
               R_REG.DEFFECDATE,
               R_REG.NMODULEC,
               R_REG.NCOVER,
               R_REG.NCAPITAL,
               R_REG.NCAUSE_AMEND,
               R_REG.NIDSTRUC,
               'El certificado no esta vigente.',
               R_REG.NLINE,
               1);
          END;
          BINDICATOR := TRUE;
        END IF;
      END;
    
      /*CAUSA*/
      BEGIN
        NSEQ := NSEQ + 1;
        
        BEGIN
          SELECT 1
            INTO NEXIST_NCAUSE_AMEND
            FROM cAUSE_AMEND
           WHERE NCAUSE_AMEND = R_REG.NCAUSE_AMEND
                --                       AND NPOLICY = R_REG.NPOLICY
                --                       AND NCERTIF = R_REG.NCERTIF
             AND NTYPE_AMEND = 905;
          --                       AND DEFFECDATE > R_REG.DEFFECDATE;
        EXCEPTION
          WHEN OTHERS THEN
            NEXIST_NCAUSE_AMEND := 0;
        END;
        --                --CRETRACE2('INSPOSTGIL54043 661',2428,'NEXIST_POLICY_HIS '||NEXIST_POLICY_HIS);
        IF NEXIST_NCAUSE_AMEND <> 1 THEN
          
          BEGIN
            INSERT INTO TIMETMP.TMP_INT54740
              (SKEY,
               NSEQ,
               SSUCESSFUL,
               NBRANCH,
               NPRODUCT,
               NPOLICY,
               NCERTIF,
               DEFFECDATE,
               NMODULEC,
               NCOVER,
               NCAPITAL,
               NCAUSE_AMEND,
               NIDSTRUC,
               SERROR,
               NLINE,
               NINDICATOR)
            VALUES
              (INSPOSTGIL54740.SKEY,
               INSPOSTGIL54740.NSEQ,
               'FALLIDO',
               R_REG.NBRANCH,
               R_REG.NPRODUCT,
               R_REG.NPOLICY,
               R_REG.NCERTIF,
               R_REG.DEFFECDATE,
               R_REG.NMODULEC,
               R_REG.NCOVER,
               R_REG.NCAPITAL,
               R_REG.NCAUSE_AMEND,
               R_REG.NIDSTRUC,
               'El motivo no existe.',
               R_REG.NLINE,
               1);
          END;
          BINDICATOR := TRUE;
        END IF;
      END;
    
      /*ESTRUCTURA COMERCIAL*/
      BEGIN
        NSEQ := NSEQ + 1;
        
        BEGIN
          SELECT 1
            INTO NEXIST_NIDSTRUC
            FROM COMMERCIALSTRUCTURE.COMMERCIALSTRUCTURES CM
           INNER JOIN COMMERCIALSTRUCTURE.STRUCPRODUCTS SP
              ON CM.NIDSTRUC = SP.NIDSTRUC
           WHERE CM.NIDSTRUC = R_REG.NIDSTRUC
             and SP.NMODULE = R_REG.NMODULEC
             AND SP.NBRANCH = R_REG.NBRANCH
             AND SP.NPRODUCT = R_REG.NPRODUCT;
        EXCEPTION
          WHEN OTHERS THEN
            NEXIST_NIDSTRUC := 0;
        END;
        --                --CRETRACE2('INSPOSTGIL54043 661',2428,'NEXIST_POLICY_HIS '||NEXIST_POLICY_HIS);
        IF NEXIST_NIDSTRUC <> 1 THEN
          
          BEGIN
            INSERT INTO TIMETMP.TMP_INT54740
              (SKEY,
               NSEQ,
               SSUCESSFUL,
               NBRANCH,
               NPRODUCT,
               NPOLICY,
               NCERTIF,
               DEFFECDATE,
               NMODULEC,
               NCOVER,
               NCAPITAL,
               NCAUSE_AMEND,
               NIDSTRUC,
               SERROR,
               NLINE,
               NINDICATOR)
            VALUES
              (INSPOSTGIL54740.SKEY,
               INSPOSTGIL54740.NSEQ,
               'FALLIDO',
               R_REG.NBRANCH,
               R_REG.NPRODUCT,
               R_REG.NPOLICY,
               R_REG.NCERTIF,
               R_REG.DEFFECDATE,
               R_REG.NMODULEC,
               R_REG.NCOVER,
               R_REG.NCAPITAL,
               R_REG.NCAUSE_AMEND,
               R_REG.NIDSTRUC,
               'La estructura comercial no corresponde al producto.',
               R_REG.NLINE,
               1);
          END;
          BINDICATOR := TRUE;
        END IF;
      END;
    
      BEGIN
        SELECT PM.SBRANCHT
          INTO SBRANCHT_AUX
          FROM PRODMASTER PM
         WHERE PM.NBRANCH = R_REG.NBRANCH
           AND PM.NPRODUCT = R_REG.NPRODUCT;
      EXCEPTION
        WHEN OTHERS THEN
          SBRANCHT_AUX := 0;
      END;        
    
      /*SUMA ASEGURADA*/
      BEGIN
        NSEQ := NSEQ + 1;
        IF SBRANCHT_AUX = '1' THEN
          --VIDA          
          BEGIN
            SELECT 1
              INTO NEXIST_NCAPITAL
              FROM LIFE_COVER
             WHERE NBRANCH = R_REG.NBRANCH
               AND NPRODUCT = R_REG.NPRODUCT
               AND NMODULEC = R_REG.NMODULEC
               AND NCOVER = R_REG.NCOVER
               AND DNULLDATE IS NULL;
          EXCEPTION
            WHEN OTHERS THEN
              NEXIST_NCAPITAL := 0;
          END;
        ELSIF SBRANCHT_AUX = '4' THEN
          --GENERALES          
          BEGIN
            SELECT 1
              INTO NEXIST_NCAPITAL
              FROM GEN_COVER
             WHERE NBRANCH = R_REG.NBRANCH
               AND NPRODUCT = R_REG.NPRODUCT
               AND NMODULEC = R_REG.NMODULEC
               AND NCOVER = R_REG.NCOVER
               AND DNULLDATE IS NULL
               AND (R_REG.NCAPITAL >= NCACALMIN AND
                   R_REG.NCAPITAL <= NCACALMAX);
          EXCEPTION
            WHEN OTHERS THEN
              NEXIST_NCAPITAL := 0;
          END;
        
        ELSE
          NEXIST_NCAPITAL := 0;
        END IF;
      
        --                --CRETRACE2('INSPOSTGIL54043 661',2428,'NEXIST_POLICY_HIS '||NEXIST_POLICY_HIS);
        IF NEXIST_NCAPITAL <> 1 THEN          
          BEGIN
            INSERT INTO TIMETMP.TMP_INT54740
              (SKEY,
               NSEQ,
               SSUCESSFUL,
               NBRANCH,
               NPRODUCT,
               NPOLICY,
               NCERTIF,
               DEFFECDATE,
               NMODULEC,
               NCOVER,
               NCAPITAL,
               NCAUSE_AMEND,
               NIDSTRUC,
               SERROR,
               NLINE,
               NINDICATOR)
            VALUES
              (INSPOSTGIL54740.SKEY,
               INSPOSTGIL54740.NSEQ,
               'FALLIDO',
               R_REG.NBRANCH,
               R_REG.NPRODUCT,
               R_REG.NPOLICY,
               R_REG.NCERTIF,
               R_REG.DEFFECDATE,
               R_REG.NMODULEC,
               R_REG.NCOVER,
               R_REG.NCAPITAL,
               R_REG.NCAUSE_AMEND,
               R_REG.NIDSTRUC,
               'La suma asegurada no se encuentra entre el minimo y maximo configurado para la cobertura.',
               R_REG.NLINE,
               1);
          END;
          BINDICATOR := TRUE;
        END IF;
      END;
    
      /*------------DE NO EXISTIR ERRORES----------------------*/

-- BDT 20240320 Control de movimientos - Feature 5163 - Aplicación de revenue en endosos de upgrade/downgrade

        SELECT MAX(DEFFECDATE) 
        INTO DEFFECDATE_COVER_INIHBIR
        FROM COVER 
        WHERE COVER.NBRANCH= R_REG.NBRANCH
        AND COVER.NPRODUCT= R_REG.NPRODUCT
        AND COVER.NPOLICY= R_REG.NPOLICY
        AND COVER.NCERTIF= R_REG.NCERTIF
        AND COVER.DNULLDATE IS NULL
        AND COVER.NCOVER<900;
 
        SELECT COUNT(*)
        INTO NMOVPOLICY_HIS
        FROM POLICY_HIS
        WHERE POLICY_HIS.NBRANCH= R_REG.NBRANCH
        AND POLICY_HIS.NPRODUCT= R_REG.NPRODUCT
        AND POLICY_HIS.NPOLICY= R_REG.NPOLICY
        AND POLICY_HIS.NCERTIF= R_REG.NCERTIF
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
            WHERE POLICY_HIS.NBRANCH= R_REG.NBRANCH
            AND POLICY_HIS.NPRODUCT= R_REG.NPRODUCT
            AND POLICY_HIS.NPOLICY= R_REG.NPOLICY
            AND POLICY_HIS.NCERTIF= R_REG.NCERTIF
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
              BEGIN
                INSERT INTO TIMETMP.TMP_INT54740
                  (SKEY,
                   NSEQ,
                   SSUCESSFUL,
                   NBRANCH,
                   NPRODUCT,
                   NPOLICY,
                   NCERTIF,
                   DEFFECDATE,
                   NMODULEC,
                   NCOVER,
                   NCAPITAL,
                   NCAUSE_AMEND,
                   NIDSTRUC,
                   SERROR,
                   NLINE,
                   NINDICATOR)
                VALUES
                  (INSPOSTGIL54740.SKEY,
                   INSPOSTGIL54740.NSEQ,
                   'FALLIDO',
                   R_REG.NBRANCH,
                   R_REG.NPRODUCT,
                   R_REG.NPOLICY,
                   R_REG.NCERTIF,
                   R_REG.DEFFECDATE,
                   R_REG.NMODULEC,
                   R_REG.NCOVER,
                   R_REG.NCAPITAL,
                   R_REG.NCAUSE_AMEND,
                   R_REG.NIDSTRUC,
                   'Rechazado por endoso reciente - No cambian condiciones',
                   R_REG.NLINE,
                   1);
              END;
              BINDICATOR := TRUE;
            END IF;
        END IF;
	  IF NOT BINDICATOR THEN        
        /*EN CASO DE QUE LA FECHA DE EFECTO SEA POSTERIOR A LA ULTIMA FECHA DEL TIPO DE ENDOSO ?CAMBIO DE SUMA ASEGURADA?*/
        --  BEGIN
        BEGIN
          SELECT MAX(DEFFECDATE)
            INTO DEFFECDATE_POLICY_HIS
            FROM POLICY_HIS
           WHERE SCERTYPE = '2'
             AND NBRANCH = R_REG.NBRANCH
             AND NPRODUCT = R_REG.NPRODUCT
             AND NPOLICY = R_REG.NPOLICY
             AND NCERTIF = R_REG.NCERTIF
             AND NTYPE_AMEND = 905;
        EXCEPTION
          WHEN OTHERS THEN
            DEFFECDATE_POLICY_HIS := NULL;
        END;
        --CRETRACE2('INSPOSTGIL54043 1311',2428,'DEFFECDATE_POLICY_HIS '||DEFFECDATE_POLICY_HIS);
        BEGIN
          IF R_REG.DEFFECDATE >= NVL(DEFFECDATE_POLICY_HIS, '01/01/1900') THEN 
            -- COVER
            --theft
            --specific_risk_cov
          
            BEGIN
              SELECT DEFFECDATE, NCAPITAL
                INTO DEFFECDATE_COVER, NAMOUNT_AUX
                FROM COVER
               WHERE SCERTYPE = '2'
                 AND NBRANCH = R_REG.NBRANCH
                 AND NPRODUCT = R_REG.NPRODUCT
                 AND NPOLICY = R_REG.NPOLICY
                 AND NCERTIF = R_REG.NCERTIF
                 AND NCOVER = R_REG.NCOVER
                 AND NMODULEC = R_REG.NMODULEC
                 AND DEFFECDATE <= R_REG.DEFFECDATE
                 AND (DNULLDATE IS NULL OR DNULLDATE > R_REG.DEFFECDATE);
              --AND NTYPE_AMEND = 905;
            EXCEPTION
              WHEN OTHERS THEN
                DEFFECDATE_COVER := NULL;
                NAMOUNT_AUX      := NULL;
            END;
            --CRETRACE2('INSPOSTGIL54043 1311',2428,'DEFFECDATE_COVER '||DEFFECDATE_COVER);
          
            IF R_REG.DEFFECDATE <> DEFFECDATE_COVER THEN
              
              BEGIN
              
                UPDATE COVER
                   SET DNULLDATE = R_REG.DEFFECDATE,
                       NUSERCODE = INSPOSTGIL54740.NUSERCODE,
                       DCOMPDATE = SYSDATE
                 WHERE SCERTYPE = '2'
                   AND NBRANCH = R_REG.NBRANCH
                   AND NPRODUCT = R_REG.NPRODUCT
                   AND NPOLICY = R_REG.NPOLICY
                   AND NCERTIF = R_REG.NCERTIF
                   AND NCOVER = R_REG.NCOVER
                   AND NMODULEC = R_REG.NMODULEC
                   AND DEFFECDATE <= R_REG.DEFFECDATE
                   AND (DNULLDATE IS NULL OR DNULLDATE > R_REG.DEFFECDATE);
              
                INSERT INTO COVER
                  (SCERTYPE,
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
                  SELECT SCERTYPE,
                         NBRANCH,
                         NPRODUCT,
                         NPOLICY,
                         NCERTIF,
                         NGROUP_INSU,
                         NMODULEC,
                         NCOVER,
                         R_REG.DEFFECDATE,
                         SCLIENT,
                         NROLE,
                         R_REG.NCAPITAL,
                         SCHANGE,
                         SYSDATE,
                         SFRANDEDI,
                         NCURRENCY,
                         (R_REG.NCAPITAL * NRATECOVE / 1000) AS NPREMIUM,
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
                    FROM COVER COV
                   WHERE SCERTYPE = '2'
                     AND COV.NBRANCH = R_REG.NBRANCH
                     AND COV.NPRODUCT = R_REG.NPRODUCT
                     AND COV.NPOLICY = R_REG.NPOLICY
                     AND COV.NCERTIF = R_REG.NCERTIF
                     AND COV.NCOVER = R_REG.NCOVER
                     AND COV.NMODULEC = R_REG.NMODULEC
                     AND DNULLDATE = R_REG.DEFFECDATE;
              
              END;
              --CRETRACE2('INSPOSTGIL54043 1311',2428,'entro 1');
            ELSE
              
              BEGIN
                --CRETRACE2('INSPOSTGIL54043 1311',2428,'R_REG.NCAPITAL '||R_REG.NCAPITAL);
                UPDATE COVER
                   SET NCAPITAL  = R_REG.NCAPITAL,
                       NUSERCODE = INSPOSTGIL54740.NUSERCODE,
                       DCOMPDATE = SYSDATE,
                       NPREMIUM =
                       (R_REG.NCAPITAL * NRATECOVE / 1000) /*se agrega actualizacion del npremium*/
                 WHERE SCERTYPE = '2'
                   AND NBRANCH = R_REG.NBRANCH
                   AND NPRODUCT = R_REG.NPRODUCT
                   AND NPOLICY = R_REG.NPOLICY
                   AND NCERTIF = R_REG.NCERTIF
                   AND NCOVER = R_REG.NCOVER
                   AND NMODULEC = R_REG.NMODULEC
                   AND DEFFECDATE <= R_REG.DEFFECDATE
                   AND (DNULLDATE IS NULL OR DNULLDATE > R_REG.DEFFECDATE);
              END;
            
            END IF;
          
            --BUSCAR TABLA PARTICULAR
          
            BEGIN
              SELECT TB.STABNAME
                INTO SPTABLENAME_AUX
                FROM TAB_NAME_B TB
               WHERE TB.NBRANCH = R_REG.NBRANCH;
            EXCEPTION
              WHEN OTHERS THEN
                SPTABLENAME_AUX := 'NULL';
            END;          
          
            SQUERYTOEXEC := 'SELECT DEFFECDATE
                          FROM ' ||
                            SPTABLENAME_AUX || '
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
              EXECUTE IMMEDIATE SQUERYTOEXEC
                INTO DEFFECDATE_PARTICULARTABLE
                USING R_REG.NBRANCH, R_REG.NPRODUCT, R_REG.NPOLICY, R_REG.NCERTIF, R_REG.DEFFECDATE, R_REG.DEFFECDATE;
                        
              /*SELECT DEFFECDATE
               INTO DEFFECDATE_PARTICULARTABLE
               FROM THEFT
              WHERE SCERTYPE = '2'
                AND NBRANCH = R_REG.NBRANCH
                AND NPRODUCT = R_REG.NPRODUCT
                AND NPOLICY = R_REG.NPOLICY
                AND NCERTIF = R_REG.NCERTIF
                 AND DEFFECDATE <= R_REG.DEFFECDATE
                                          AND (DNULLDATE IS NULL
                                           OR DNULLDATE > R_REG.DEFFECDATE);*/
              --AND NTYPE_AMEND = 905;
            EXCEPTION
              WHEN OTHERS THEN
                DEFFECDATE_PARTICULARTABLE := NULL;
            END;
            --CRETRACE2('INSPOSTGIL54043 1311',2428,'R_REG.DEFFECDATE_PARTICULARTABLE '||DEFFECDATE_PARTICULARTABLE);
          
            /* se agrega: buscar el nrate para actualizar el npremium en theft*/
            
            BEGIN
              SELECT NRATECOVE
                INTO NRATECOVE_AUX
                FROM COVER
               WHERE SCERTYPE = '2'
                 AND NBRANCH = R_REG.NBRANCH
                 AND NPRODUCT = R_REG.NPRODUCT
                 AND NPOLICY = R_REG.NPOLICY
                 AND NCERTIF = R_REG.NCERTIF
                 AND NCOVER = R_REG.NCOVER
                 AND DEFFECDATE <= R_REG.DEFFECDATE
                 AND (DNULLDATE IS NULL OR DNULLDATE > R_REG.DEFFECDATE);
              --AND NTYPE_AMEND = 905;
            EXCEPTION
              WHEN OTHERS THEN
                NRATECOVE_AUX := 0;
            END;
          
            IF R_REG.DEFFECDATE <> DEFFECDATE_PARTICULARTABLE THEN
              
              BEGIN
              
                SQUERYTOEXEC := 'UPDATE ' || SPTABLENAME_AUX ||
                                ' SET DNULLDATE = :DEFFECDATE,
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
              
                EXECUTE IMMEDIATE SQUERYTOEXEC
                  USING R_REG.DEFFECDATE, INSPOSTGIL54740.NUSERCODE, R_REG.NBRANCH, R_REG.NPRODUCT, R_REG.NPOLICY, R_REG.NCERTIF, R_REG.DEFFECDATE, R_REG.DEFFECDATE;
              
                SSEP  := ' ';
                SSEL  := NULL;
                SSEL2 := NULL;
                OPEN C_REASYSCOLUMNS(UPPER('INSUDB'),
                                     TRIM(SPTABLENAME_AUX));
                LOOP
                  FETCH C_REASYSCOLUMNS
                    INTO COLUMN_NAME;
                  EXIT WHEN C_REASYSCOLUMNS%NOTFOUND;
                  SSEL := SSEL || SSEP || COLUMN_NAME;
                  IF COLUMN_NAME = 'DEFFECDATE' THEN
                    SSEL2 := SSEL2 || SSEP || 'STDATE(''' ||
                             DTCHAR(R_REG.DEFFECDATE) || ''')';
                  ELSIF COLUMN_NAME = 'DCOMPDATE' THEN
                    SSEL2 := SSEL2 || SSEP || 'STDATE(''' ||
                             DTCHAR(SYSDATE) || ''')';
                  ELSIF COLUMN_NAME = 'DNULLDATE' THEN
                    SSEL2 := SSEL2 || SSEP || 'NULL';
                  ELSIF COLUMN_NAME = 'NCAPITAL' THEN
                    SSEL2 := SSEL2 || SSEP ||
                             REPLACE(TO_CHAR(NVL(R_REG.NCAPITAL, 0)),
                                     ',',
                                     '.');
                  ELSIF COLUMN_NAME = 'NPREMIUM' THEN
                    SSEL2 := SSEL2 || SSEP || REPLACE(TO_CHAR(NVL((R_REG.NCAPITAL *
                                                                  NRATECOVE_AUX / 1000),
                                                                  0)),
                                                      ',',
                                                      '.');
                  ELSIF COLUMN_NAME = 'NUSERCODE' THEN
                    SSEL2 := SSEL2 || SSEP ||
                             TO_CHAR(INSPOSTGIL54740.NUSERCODE);
                  ELSE
                    SSEL2 := SSEL2 || SSEP || COLUMN_NAME;
                  END IF;
                  SSEP := ',';
                END LOOP;
                CLOSE C_REASYSCOLUMNS;
              
                SSEL  := 'INSERT INTO ' || SPTABLENAME_AUX || '(' || SSEL || ') ';
                SSEL2 := 'SELECT /*+ INDEX ( ' || SPTABLENAME_AUX || ' XPK' ||
                         SPTABLENAME_AUX || ') */ ' || SSEL2 || ' FROM ' ||
                         SPTABLENAME_AUX || '  WHERE SCERTYPE    = ''2''' ||
                         '    AND NBRANCH     = ' || TO_CHAR(R_REG.NBRANCH) ||
                         '    AND NPRODUCT    = ' ||
                         TO_CHAR(R_REG.NPRODUCT) ||
                         '    AND NPOLICY     = ' || TO_CHAR(R_REG.NPOLICY) ||
                         '    AND NCERTIF     = ' || TO_CHAR(R_REG.NCERTIF) ||
                         '    AND DNULLDATE =  TO_DATE(' || '''' ||
                         TO_CHAR(R_REG.DEFFECDATE, 'DD/MM/YYYY') || '''' ||
                         ',''' || 'DD/MM/YYYY' || ''')';
              
                EXECUTE IMMEDIATE (SSEL || SSEL2);
              
                /*
                
                   INSERT INTO THEFT (SCERTYPE, NBRANCH, NPRODUCT, NPOLICY, NCERTIF, DEFFECDATE, NCAPITAL, NAREA, NBUSSTREND, NCATEGORY, DCOMPDATE, DEXPIRDAT,
                   NRISKCLASS, DISSUEDAT, NNULLCODE, NINSURED, NPREMIUM, NGROUP, DSTARTDATE, SCLIENT, NTRANSACTIO, NUSERCODE,
                   NEMPLOYEES, NUBICATION, NVIGILANCE, NSITUATION, SCOMPLCOD, SDESCBUSSI, NCONSTCAT, NCODKIND, NBUSINESSTY, NCOMMERGRP,
                   NPAYFREQ, SPREBILLING,DNULLDATE)
                   SELECT SCERTYPE, NBRANCH, NPRODUCT, NPOLICY, NCERTIF, R_REG.DEFFECDATE, R_REG.NCAPITAL, NAREA, NBUSSTREND, NCATEGORY, SYSDATE, DEXPIRDAT,
                   NRISKCLASS, DISSUEDAT, NNULLCODE, NINSURED, (R_REG.NCAPITAL * NRATECOVE_AUX / 1000)  AS NPREMIUM, NGROUP, DSTARTDATE, SCLIENT, NTRANSACTIO, NUSERCODE,
                   NEMPLOYEES, NUBICATION, NVIGILANCE, NSITUATION, SCOMPLCOD, SDESCBUSSI, NCONSTCAT, NCODKIND, NBUSINESSTY, NCOMMERGRP,
                   NPAYFREQ, SPREBILLING,NULL
                                       FROM THEFT COV WHERE SCERTYPE = '2'
                                              AND COV.NBRANCH = R_REG.NBRANCH
                                                                        AND COV.NPRODUCT = R_REG.NPRODUCT
                                                                        AND COV.NPOLICY = R_REG.NPOLICY
                                                                        AND COV.NCERTIF  = R_REG.NCERTIF
                                                                        AND DNULLDATE = R_REG.DEFFECDATE;   
                */
                --                    exception when others then
                --                            cretrace ('ERRORES',19494,'THEFT '|| R_REG.NCERTIF||' R_REG.DEFFECDATE '||R_REG.DEFFECDATE); 
                --                            rollback;
              END;
            
            ELSE              
              --CRETRACE2('INSPOSTGIL54043 1311',2428,'NRATECOVE_AUX '||NRATECOVE_AUX|| (R_REG.NCAPITAL * NRATECOVE_AUX / 1000));
            
              BEGIN
              
                SQUERYTOEXEC := 'UPDATE ' || SPTABLENAME_AUX ||
                                ' SET NCAPITAL = :NCAPITAL,
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
              
                EXECUTE IMMEDIATE SQUERYTOEXEC
                  USING R_REG.NCAPITAL, INSPOSTGIL54740.NUSERCODE, R_REG.NCAPITAL, INSPOSTGIL54740.NRATECOVE_AUX, R_REG.NBRANCH, R_REG.NPRODUCT, R_REG.NPOLICY, R_REG.NCERTIF, R_REG.DEFFECDATE, R_REG.DEFFECDATE;
              
                /*
                UPDATE THEFT SET NCAPITAL = R_REG.NCAPITAL,
                                                    NUSERCODE = INSPOSTGIL54740.NUSERCODE,
                                                    DCOMPDATE = SYSDATE,
                                              NPREMIUM  = (R_REG.NCAPITAL * NRATECOVE_AUX / 1000)     --se agrega actualizacion del premium
                                              WHERE SCERTYPE = '2'
                                                AND NBRANCH = R_REG.NBRANCH
                                                AND NPRODUCT = R_REG.NPRODUCT
                                                AND NPOLICY = R_REG.NPOLICY
                                                AND NCERTIF  = R_REG.NCERTIF
                                                AND DEFFECDATE <= R_REG.DEFFECDATE
                                                AND (DNULLDATE IS NULL
                                                OR DNULLDATE > R_REG.DEFFECDATE);   
                                                */
                --                                                     exception when others then
                --                            cretrace ('ERRORES',19494,'THEFT U '|| R_REG.NCERTIF||' R_REG.DEFFECDATE '||R_REG.DEFFECDATE); 
                --                            rollback;
              END;
            
            END IF; 
          
            BEGIN
              SELECT 'S'
                INTO EXISTE_SPECIFIC_RISK_COV
                FROM SPECIFIC_RISK_COV
               WHERE SCERTYPE = '2'
                 AND NBRANCH = R_REG.NBRANCH
                 AND NPRODUCT = R_REG.NPRODUCT
                 AND NPOLICY = R_REG.NPOLICY
                 AND NCERTIF = R_REG.NCERTIF
                 AND NCOVER = R_REG.NCOVER
                 AND NMODULEC = R_REG.NMODULEC
                 AND ROWNUM <= 1;
            EXCEPTION
              WHEN OTHERS THEN
                EXISTE_SPECIFIC_RISK_COV := 'N';
            END;
          
            IF EXISTE_SPECIFIC_RISK_COV = 'S' THEN
              NRATE_AUX := NVL(R_REG.NCAPITAL, 1) / NVL(NAMOUNT_AUX, 1);
              
              BEGIN
                FOR X IN (SELECT DEFFECDATE, NITEMRISK
                            FROM SPECIFIC_RISK_COV
                           WHERE SCERTYPE = '2'
                             AND NBRANCH = R_REG.NBRANCH
                             AND NPRODUCT = R_REG.NPRODUCT
                             AND NPOLICY = R_REG.NPOLICY
                             AND NCERTIF = R_REG.NCERTIF
                             AND NCOVER = R_REG.NCOVER
                             AND NMODULEC = R_REG.NMODULEC
                             AND DEFFECDATE <= R_REG.DEFFECDATE
                             AND (DNULLDATE IS NULL OR
                                 DNULLDATE > R_REG.DEFFECDATE)) LOOP
                
                  IF R_REG.DEFFECDATE <> X.DEFFECDATE THEN
                    
                    BEGIN
                    
                      UPDATE SPECIFIC_RISK_COV
                         SET DNULLDATE = R_REG.DEFFECDATE,
                             NUSERCODE = INSPOSTGIL54740.NUSERCODE,
                             DCOMPDATE = SYSDATE
                       WHERE SCERTYPE = '2'
                         AND NBRANCH = R_REG.NBRANCH
                         AND NPRODUCT = R_REG.NPRODUCT
                         AND NPOLICY = R_REG.NPOLICY
                         AND NCERTIF = R_REG.NCERTIF
                         AND NCOVER = R_REG.NCOVER
                         AND NITEMRISK = X.NITEMRISK
                         AND NMODULEC = R_REG.NMODULEC
                         AND DEFFECDATE <= R_REG.DEFFECDATE
                         AND (DNULLDATE IS NULL OR
                             DNULLDATE > R_REG.DEFFECDATE);
                    
                      INSERT INTO SPECIFIC_RISK_COV
                        (SCERTYPE,
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
                        SELECT SCERTYPE,
                               NBRANCH,
                               NPRODUCT,
                               NPOLICY,
                               NCERTIF,
                               NGROUP_INSU,
                               NMODULEC,
                               NCOVER,
                               SCLIENT,
                               R_REG.DEFFECDATE,
                               NRISKTYPE,
                               NITEMRISK,
                               NCAPITAL * NRATE_AUX,
                               NCURRENCY,
                               NRESERVERISK,
                               SINDEXCLUDE_RISK,
                               SINDAFFECTED_RISK,
                               SDESCRIPTION,
                               SYSDATE,
                               NUSERCODE,
                               NULL
                          FROM SPECIFIC_RISK_COV COV
                         WHERE SCERTYPE = '2'
                           AND COV.NBRANCH = R_REG.NBRANCH
                           AND COV.NPRODUCT = R_REG.NPRODUCT
                           AND COV.NPOLICY = R_REG.NPOLICY
                           AND COV.NCERTIF = R_REG.NCERTIF
                           AND COV.NCOVER = R_REG.NCOVER
                           AND NMODULEC = R_REG.NMODULEC
                           AND COV.NITEMRISK = X.NITEMRISK
                           AND DNULLDATE = R_REG.DEFFECDATE;
                    
                      --                        exception when others then
                      --                            cretrace ('ERRORES',19494,'SPECIFIC_RISK_COV '|| R_REG.NCERTIF||' R_REG.DEFFECDATE '||R_REG.DEFFECDATE); 
                      --                            rollback;
                    
                    END;
                  
                  ELSE                    
                  
                    BEGIN
                      UPDATE SPECIFIC_RISK_COV
                         SET NCAPITAL  = NCAPITAL * NRATE_AUX,
                             NUSERCODE = INSPOSTGIL54740.NUSERCODE,
                             DCOMPDATE = SYSDATE
                       WHERE SCERTYPE = '2'
                         AND NBRANCH = R_REG.NBRANCH
                         AND NPRODUCT = R_REG.NPRODUCT
                         AND NPOLICY = R_REG.NPOLICY
                         AND NCERTIF = R_REG.NCERTIF
                         AND NCOVER = R_REG.NCOVER
                         AND NMODULEC = R_REG.NMODULEC
                         AND NITEMRISK = X.NITEMRISK
                         AND DEFFECDATE <= R_REG.DEFFECDATE
                         AND (DNULLDATE IS NULL OR
                             DNULLDATE > R_REG.DEFFECDATE);
                    
                      --                                                      exception when others then
                      --                            cretrace ('ERRORES',19494,'SPECIFIC_RISK_COV u '|| R_REG.NCERTIF||' R_REG.DEFFECDATE '||R_REG.DEFFECDATE); 
                      --                            rollback;
                    END;
                  
                  END IF;
                
                END LOOP;
              END;
            
            END IF;
          END IF;
        END;
      
        IF NVL(NBRANCH_O, 0) <> R_REG.NBRANCH OR
           NVL(NPRODUCT_O, 0) <> R_REG.NPRODUCT OR
           NVL(NPOLICY_O, 0) <> R_REG.NPOLICY OR
           NVL(NCERTIF_O, 0) <> R_REG.NCERTIF THEN
        
          NBRANCH_O  := R_REG.NBRANCH;
          NPRODUCT_O := R_REG.NPRODUCT;
          NPOLICY_O  := R_REG.NPOLICY;
          NCERTIF_O  := R_REG.NCERTIF;
          
          /*SE ACTUALIZA EL NUMERO DE TRANSACCION EN EJECUCION EN LA TABLA DE INFORMACION GENERAL DE UNA POLIZA (POLICY.NTRANSACTIO)*/
          BEGIN
            SELECT NTRANSACTIO + 1, DEXPIRDAT
              INTO NTRANSACTIO_AUX, DEXPIRDAT_AUX
              FROM POLICY
             WHERE SCERTYPE = '2'
               AND NBRANCH = R_REG.NBRANCH
               AND NPRODUCT = R_REG.NPRODUCT
               AND NPOLICY = R_REG.NPOLICY;
          EXCEPTION
            WHEN OTHERS THEN
              DEXPIRDAT_AUX   := NULL;
              NTRANSACTIO_AUX := NULL;
          END;
          --CRETRACE2('INSPOSTGIL54043 1311',2428,'NTRANSACTIO_AUX '||NTRANSACTIO_AUX);
          
          BEGIN
            UPDATE POLICY POL
               SET POL.NTRANSACTIO = NTRANSACTIO_AUX,
                   POL.DCHANGDAT   = R_REG.DEFFECDATE
             WHERE POL.SCERTYPE = '2'
               AND POL.NBRANCH = R_REG.NBRANCH
               AND POL.NPRODUCT = R_REG.NPRODUCT
               AND POL.NPOLICY = R_REG.NPOLICY;
          END;
          
          /*SE AGREGA UN REGISTRO EN LA TABLA DE HISTORIA DE UNA POLIZA (POLICY_HIS) */
          BEGIN
            BEGIN
              SELECT MAX(NMOVEMENT) + 1
                INTO NMOVEMENT_AUX
                FROM POLICY_HIS
               WHERE SCERTYPE = '2'
                 AND NBRANCH = R_REG.NBRANCH
                 AND NPRODUCT = R_REG.NPRODUCT
                 AND NPOLICY = R_REG.NPOLICY
                 AND NCERTIF = R_REG.NCERTIF;
            EXCEPTION
              WHEN OTHERS THEN
                --                         --CRETRACE2('INSPOSTGIL54740 1864',2428,'R_REG.NPOLICY'||R_REG.NPOLICY);
                NMOVEMENT_AUX := 1;
            END;
            
            BEGIN
              INSERT INTO POLICY_HIS
                (SCERTYPE,
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
              VALUES
                ('2',
                 R_REG.NBRANCH,
                 R_REG.NPRODUCT,
                 R_REG.NPOLICY,
                 R_REG.NCERTIF,
                 NMOVEMENT_AUX,
                 NTRANSACTIO_AUX,
                 SYSDATE,
                 INSPOSTGIL54740.NUSERCODE,
                 1,
                 R_REG.DEFFECDATE,
                 DECODE(R_REG.NCERTIF, 0, 11, 12),
                 TRUNC(SYSDATE),
                 905,
                 DEXPIRDAT_AUX,
                 R_REG.NCAUSE_AMEND);
            
              --                                                 exception when others then
              --                            cretrace ('ERRORES',19494,'POLICY_HIS '|| R_REG.NCERTIF||' R_REG.DEFFECDATE '||R_REG.DEFFECDATE||' NTRANSACTIO_AUX '||NTRANSACTIO_AUX||  ' NMOVEMENT_AUX '||NMOVEMENT_AUX|| ' R_REG.NCAUSE_AMEND '||R_REG.NCAUSE_AMEND); 
              --                            rollback;
            END;
          END;
          
          /*SE AGREGA UN REGISTRO EN LA TABLA DE ESTRUCTURA COMERCIALES APLICADAS POR EVENTO (STRUCEVENT) */
          BEGIN
            -- WALTER
            BEGIN
              SELECT MAX(NIDCONSEC) + 1
                INTO NIDCONSEC_AUX
                FROM COMMERCIALSTRUCTURE.STRUCEVENT;
            EXCEPTION
              WHEN OTHERS THEN
                NIDCONSEC_AUX := 1;
            END;
            
            BEGIN
              INSERT INTO COMMERCIALSTRUCTURE.STRUCEVENT
                (NIDSTRUC,
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
                 NUSERCODE)
              VALUES
                (R_REG.NIDSTRUC,
                 '2',
                 NIDCONSEC_AUX,
                 R_REG.DEFFECDATE,
                 SCLIENT_AUX,
                 '2',
                 R_REG.NBRANCH,
                 R_REG.NPRODUCT,
                 R_REG.NPOLICY,
                 R_REG.NCERTIF,
                 NMOVEMENT_AUX,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 SYSDATE,
                 INSPOSTGIL54740.NUSERCODE);
            
              --                                                                     exception when others then
              --                            cretrace ('ERRORES',19494,'COMMERCIALSTRUCTURE '|| R_REG.NCERTIF||' R_REG.DEFFECDATE '||R_REG.DEFFECDATE); 
              --                            rollback;
            END;
          
          END;
        
        END IF;
      
      END IF;
    
      --             CRETRACE('ALGO',6532,'certificado'||R_REG.ncertif||' NIDCONSEC_AUX '||NIDCONSEC_AUX||' NMOVEMENT_AUX '||NMOVEMENT_AUX);
    
      BINDICATOR := FALSE;
    END LOOP;
    
    BEGIN
      UPDATE TIMETMP.TMP_INT54740
         SET NINDICATOR = 2
       WHERE SKEY = INSPOSTGIL54740.SKEY
         AND NVL(NINDICATOR, 0) = 0;
    END;
  END;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    rollback;
    NERROR     := -1;
    SERRORDESC := 'Error en el Proceso INSPOSTGIL54740: ' || SQLERRM;
  
    CRET_ERR_INTERFACE(SKEY,
                       0,
                       0,
                       SQLCODE,
                       SERRORDESC,
                       NULL,
                       NULL,
                       NULL,
                       NULL,
                       NULL,
                       NULL,
                       NULL,
                       NUSERCODE);
  
    CRETRACE2('INSPOSTGIL54740',
              1,
              'ERROR: ' || SYS.DBMS_UTILITY.format_error_stack ||
              ' BACKTRACE: ' || SYS.DBMS_UTILITY.format_error_backtrace ||
              ' FORMAT_CALL_STACK: ' || SYS.DBMS_UTILITY.format_call_stack);
  
END INSPOSTGIL54740;