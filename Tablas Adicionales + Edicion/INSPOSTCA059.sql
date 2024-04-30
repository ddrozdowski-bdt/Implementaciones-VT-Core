create or replace PROCEDURE INSUDB.INSPOSTCA059
/*----------------------------------------------------------------------------*/
/* NOMBRE    : INSPOSTCA059                                                   */
/* OBJETIVO  : ACTUALIZA LA INFORMACI�N DE SPECIFIC_RISK_COV_DET              */
/*                                                                            */
/* PARAMETROS: 1.- NBRANCH    :  RAMO                                         */
/*             2.- NPRODUCT   : PRODUCTO                                      */
/*             3.- NMODULEC   : M�DULO                                        */
/*             5.- NCOVER     : COBERTURA                                     */
/*                                                                            */
/*Sourcesafe Information:                                                     */
/*     $AUTHOR: VROJAS  $                                                     */
/*     $DATE: 08/09/2016$                                                     */
/*     $REVISION: 0 $                                                         */
/*----------------------------------------------------------------------------*/
 (SCERTYPE   SPECIFIC_RISK_COV_DET.SCERTYPE%TYPE,
  NBRANCH    SPECIFIC_RISK_COV_DET.NBRANCH%TYPE,
  NPRODUCT   SPECIFIC_RISK_COV_DET.NPRODUCT%TYPE,
  NPOLICY    SPECIFIC_RISK_COV_DET.NPOLICY%TYPE,
  NCERTIF    SPECIFIC_RISK_COV_DET.NCERTIF%TYPE,
  NGROUP_INSU SPECIFIC_RISK_COV_DET.NGROUP_INSU%TYPE,
  NMODULEC   SPECIFIC_RISK_COV_DET.NMODULEC%TYPE,
  NCOVER     SPECIFIC_RISK_COV_DET.NCOVER%TYPE,
  SCLIENT    SPECIFIC_RISK_COV_DET.SCLIENT%TYPE,
  DEFFECDATE SPECIFIC_RISK_COV_DET.DEFFECDATE%TYPE,
  NRISKTYPE  SPECIFIC_RISK_COV_DET.NRISKTYPE%TYPE,
  NITEMRISK SPECIFIC_RISK_COV_DET.NITEMRISK%TYPE,
  NDEFTYPE  SPECIFIC_RISK_COV_DET.NDEFTYPE%TYPE,
  NVALUELIST  SPECIFIC_RISK_COV_DET.NVALUELIST%TYPE,
  SVALUETEXT  SPECIFIC_RISK_COV_DET.SVALUETEXT%TYPE,
  NVALUENUM  SPECIFIC_RISK_COV_DET.NVALUENUM%TYPE,
  DVALUEDATE  SPECIFIC_RISK_COV_DET.DVALUEDATE%TYPE,
  NUSERCODE  SPECIFIC_RISK_COV_DET.NUSERCODE%TYPE) AUTHID CURRENT_USER AS

    NEXIST INTEGER :=0;
    NCUENTA NUMBER;

BEGIN

-- DDR-05/01/2024-Proceso para endosos retroactivos
    SELECT COUNT(0) INTO NCUENTA 
    FROM SPECIFIC_RISK_COV_DET
    WHERE SCERTYPE     = INSPOSTCA059.SCERTYPE
    AND NBRANCH      = INSPOSTCA059.NBRANCH
    AND NPRODUCT     = INSPOSTCA059.NPRODUCT
    AND NPOLICY      = INSPOSTCA059.NPOLICY
    AND NCERTIF      = INSPOSTCA059.NCERTIF
    AND NGROUP_INSU  = INSPOSTCA059.NGROUP_INSU
    AND NMODULEC     = INSPOSTCA059.NMODULEC
    AND NCOVER      = INSPOSTCA059.NCOVER
    AND SCLIENT     = INSPOSTCA059.SCLIENT   
    AND NITEMRISK   =INSPOSTCA059.NITEMRISK        
    AND NDEFTYPE    = INSPOSTCA059.NDEFTYPE
    AND DEFFECDATE > INSPOSTCA059.DEFFECDATE
    AND DNULLDATE IS NULL;

    BEGIN
    IF NCUENTA=0 THEN    
        SELECT 1
          INTO NEXIST
          FROM SPECIFIC_RISK_COV_DET
         WHERE SCERTYPE    = INSPOSTCA059.SCERTYPE
           AND NBRANCH     = INSPOSTCA059.NBRANCH
           AND NPRODUCT    = INSPOSTCA059.NPRODUCT
           AND NPOLICY     = INSPOSTCA059.NPOLICY
           AND NCERTIF     = INSPOSTCA059.NCERTIF
           AND NGROUP_INSU = INSPOSTCA059.NGROUP_INSU
           AND NMODULEC    = INSPOSTCA059.NMODULEC
           AND NCOVER      = INSPOSTCA059.NCOVER
           AND SCLIENT     = INSPOSTCA059.SCLIENT
           AND DEFFECDATE <= INSPOSTCA059.DEFFECDATE
           AND (DNULLDATE IS NULL
            OR  DNULLDATE  > INSPOSTCA059.DEFFECDATE)
           AND NRISKTYPE   = INSPOSTCA059.NRISKTYPE
           AND NITEMRISK   = INSPOSTCA059.NITEMRISK
           AND NDEFTYPE    = INSPOSTCA059.NDEFTYPE;
    ELSE
        SELECT 1
          INTO NEXIST
          FROM SPECIFIC_RISK_COV_DET
         WHERE SCERTYPE    = INSPOSTCA059.SCERTYPE
           AND NBRANCH     = INSPOSTCA059.NBRANCH
           AND NPRODUCT    = INSPOSTCA059.NPRODUCT
           AND NPOLICY     = INSPOSTCA059.NPOLICY
           AND NCERTIF     = INSPOSTCA059.NCERTIF
           AND NGROUP_INSU = INSPOSTCA059.NGROUP_INSU
           AND NMODULEC    = INSPOSTCA059.NMODULEC
           AND NCOVER      = INSPOSTCA059.NCOVER
           AND SCLIENT     = INSPOSTCA059.SCLIENT
           AND DEFFECDATE > INSPOSTCA059.DEFFECDATE
           AND DNULLDATE IS NULL;
    END IF;
    EXCEPTION WHEN OTHERS THEN
        NEXIST :=0;
    END;

    IF NEXIST = 1 THEN
        IF NCUENTA=0 THEN
            -- DDR-12/04/2024-Edicion  
		
			INSERT INTO SPECIFIC_RISK_COV_DET_HIS
			SELECT SPECIFIC_RISK_COV_DET.*,INSPOSTCA059.NUSERCODE,SYSTIMESTAMP,
			(SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_DET_HIS)),0) FROM DUAL) + ROWNUM ,
			'INSPOSTCA059','DEL'
			FROM SPECIFIC_RISK_COV_DET                            
			WHERE SCERTYPE    = INSPOSTCA059.SCERTYPE
			AND NBRANCH     = INSPOSTCA059.NBRANCH
			AND NPRODUCT    = INSPOSTCA059.NPRODUCT
			AND NPOLICY     = INSPOSTCA059.NPOLICY
			AND NCERTIF     = INSPOSTCA059.NCERTIF
			AND NGROUP_INSU = INSPOSTCA059.NGROUP_INSU
			AND NMODULEC    = INSPOSTCA059.NMODULEC
			AND NCOVER      = INSPOSTCA059.NCOVER
			AND SCLIENT     = INSPOSTCA059.SCLIENT
			AND DEFFECDATE <= INSPOSTCA059.DEFFECDATE
			AND (DNULLDATE IS NULL
			OR  DNULLDATE  > INSPOSTCA059.DEFFECDATE)
			AND NRISKTYPE   = INSPOSTCA059.NRISKTYPE
			AND NITEMRISK   = INSPOSTCA059.NITEMRISK
			AND NDEFTYPE    = INSPOSTCA059.NDEFTYPE;
		
            UPDATE SPECIFIC_RISK_COV_DET SET NVALUELIST = INSPOSTCA059.NVALUELIST,
                                             SVALUETEXT = INSPOSTCA059.SVALUETEXT,
                                             NVALUENUM = INSPOSTCA059.NVALUENUM,
                                             DVALUEDATE = INSPOSTCA059.DVALUEDATE,
                                             DCOMPDATE = SYSDATE,
                                             NUSERCODE = INSPOSTCA059.NUSERCODE
            WHERE SCERTYPE    = INSPOSTCA059.SCERTYPE
              AND NBRANCH     = INSPOSTCA059.NBRANCH
              AND NPRODUCT    = INSPOSTCA059.NPRODUCT
              AND NPOLICY     = INSPOSTCA059.NPOLICY
              AND NCERTIF     = INSPOSTCA059.NCERTIF
              AND NGROUP_INSU = INSPOSTCA059.NGROUP_INSU
              AND NMODULEC    = INSPOSTCA059.NMODULEC
              AND NCOVER      = INSPOSTCA059.NCOVER
              AND SCLIENT     = INSPOSTCA059.SCLIENT
              AND DEFFECDATE <= INSPOSTCA059.DEFFECDATE
              AND (DNULLDATE IS NULL
               OR  DNULLDATE  > INSPOSTCA059.DEFFECDATE)
              AND NRISKTYPE   = INSPOSTCA059.NRISKTYPE
              AND NITEMRISK   = INSPOSTCA059.NITEMRISK
              AND NDEFTYPE    = INSPOSTCA059.NDEFTYPE;
			  
			  
        ELSE
             -- DDR-05/01/2024-Proceso para endosos retroactivos
                INSERT INTO SPECIFIC_RISK_COV_DET_HIS
                SELECT SPECIFIC_RISK_COV_DET.*,INSPOSTCA059.NUSERCODE,SYSTIMESTAMP,
                (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_DET_HIS)),0) FROM DUAL) + ROWNUM ,
                'INSPOSTCA059','DEL'
                FROM SPECIFIC_RISK_COV_DET                            
                WHERE SCERTYPE  = INSPOSTCA059.SCERTYPE
                AND NBRANCH     = INSPOSTCA059.NBRANCH
                AND NPRODUCT    = INSPOSTCA059.NPRODUCT
                AND NPOLICY     = INSPOSTCA059.NPOLICY
                AND NCERTIF     = INSPOSTCA059.NCERTIF
                AND NGROUP_INSU = INSPOSTCA059.NGROUP_INSU
                AND NMODULEC    = INSPOSTCA059.NMODULEC
                AND NCOVER      = INSPOSTCA059.NCOVER
                AND SCLIENT     = INSPOSTCA059.SCLIENT
                AND NITEMRISK   = INSPOSTCA059.NITEMRISK
                AND DEFFECDATE >= INSPOSTCA059.DEFFECDATE
                AND NDEFTYPE    = INSPOSTCA059.NDEFTYPE;

                DELETE SPECIFIC_RISK_COV_DET
                WHERE SCERTYPE    = INSPOSTCA059.SCERTYPE
                AND NBRANCH     = INSPOSTCA059.NBRANCH
                AND NPRODUCT    = INSPOSTCA059.NPRODUCT
                AND NPOLICY     = INSPOSTCA059.NPOLICY
                AND NCERTIF     = INSPOSTCA059.NCERTIF
                AND NGROUP_INSU = INSPOSTCA059.NGROUP_INSU
                AND NMODULEC    = INSPOSTCA059.NMODULEC
                AND NCOVER      = INSPOSTCA059.NCOVER
                AND SCLIENT     = INSPOSTCA059.SCLIENT
                AND NITEMRISK   = INSPOSTCA059.NITEMRISK
                AND DEFFECDATE > INSPOSTCA059.DEFFECDATE
                AND NDEFTYPE    = INSPOSTCA059.NDEFTYPE;

                UPDATE SPECIFIC_RISK_COV_DET 
                SET DNULLDATE = INSPOSTCA059.DEFFECDATE,
                DCOMPDATE = SYSDATE,
                NUSERCODE = INSPOSTCA059.NUSERCODE
                WHERE SCERTYPE    = INSPOSTCA059.SCERTYPE
                AND NBRANCH     = INSPOSTCA059.NBRANCH
                AND NPRODUCT    = INSPOSTCA059.NPRODUCT
                AND NPOLICY     = INSPOSTCA059.NPOLICY
                AND NCERTIF     = INSPOSTCA059.NCERTIF
                AND NGROUP_INSU = INSPOSTCA059.NGROUP_INSU
                AND NMODULEC    = INSPOSTCA059.NMODULEC
                AND NCOVER      = INSPOSTCA059.NCOVER
                AND NITEMRISK   = INSPOSTCA059.NITEMRISK
                AND SCLIENT     = INSPOSTCA059.SCLIENT
				AND NDEFTYPE    = INSPOSTCA059.NDEFTYPE
                and DEFFECDATE=
                (SELECT MAX(SPECIFIC_RISK_COV_DET_HIS.DEFFECDATE) 
                FROM SPECIFIC_RISK_COV_DET SPECIFIC_RISK_COV_DET_HIS
                WHERE SPECIFIC_RISK_COV_DET_HIS.SCERTYPE= SPECIFIC_RISK_COV_DET.SCERTYPE
                AND SPECIFIC_RISK_COV_DET_HIS.NBRANCH= SPECIFIC_RISK_COV_DET.NBRANCH
                AND SPECIFIC_RISK_COV_DET_HIS.NPRODUCT= SPECIFIC_RISK_COV_DET.NPRODUCT
                AND SPECIFIC_RISK_COV_DET_HIS.NPOLICY= SPECIFIC_RISK_COV_DET.NPOLICY
                AND SPECIFIC_RISK_COV_DET_HIS.NCERTIF= SPECIFIC_RISK_COV_DET.NCERTIF
                AND SPECIFIC_RISK_COV_DET_HIS.NMODULEC= SPECIFIC_RISK_COV_DET.NMODULEC
                AND SPECIFIC_RISK_COV_DET_HIS.NCOVER= SPECIFIC_RISK_COV_DET.NCOVER
                AND SPECIFIC_RISK_COV_DET_HIS.SCLIENT= SPECIFIC_RISK_COV_DET.SCLIENT
                AND SPECIFIC_RISK_COV_DET_HIS.NITEMRISK= SPECIFIC_RISK_COV_DET.NITEMRISK
				AND SPECIFIC_RISK_COV_DET_HIS.NDEFTYPE= SPECIFIC_RISK_COV_DET.NDEFTYPE
                AND SPECIFIC_RISK_COV_DET_HIS.DEFFECDATE< INSPOSTCA059.DEFFECDATE);

                UPDATE SPECIFIC_RISK_COV_DET
                SET DNULLDATE = NULL,
                DCOMPDATE = SYSDATE,
                NUSERCODE = INSPOSTCA059.NUSERCODE
                WHERE SCERTYPE    = INSPOSTCA059.SCERTYPE
                AND NBRANCH     = INSPOSTCA059.NBRANCH
                AND NPRODUCT    = INSPOSTCA059.NPRODUCT
                AND NPOLICY     = INSPOSTCA059.NPOLICY
                AND NCERTIF     = INSPOSTCA059.NCERTIF
                AND NGROUP_INSU = INSPOSTCA059.NGROUP_INSU
                AND NMODULEC    = INSPOSTCA059.NMODULEC
                AND NCOVER      = INSPOSTCA059.NCOVER
                AND SCLIENT     = INSPOSTCA059.SCLIENT
                AND NITEMRISK   = INSPOSTCA059.NITEMRISK
                AND DEFFECDATE = INSPOSTCA059.DEFFECDATE
				AND NDEFTYPE    = INSPOSTCA059.NDEFTYPE;
        END IF;
    ELSE
        INSERT INTO INSUDB.SPECIFIC_RISK_COV_DET (SCERTYPE,   NBRANCH,    NPRODUCT,
                                                  NPOLICY,    NCERTIF,    NGROUP_INSU,
                                                  NMODULEC,   NCOVER,     SCLIENT,
                                                  DEFFECDATE, NRISKTYPE,  NITEMRISK,
                                                  NDEFTYPE,   NVALUELIST, SVALUETEXT,
                                                  NVALUENUM,  DVALUEDATE, DNULLDATE,
                                                  DCOMPDATE,  NUSERCODE)
         VALUES (INSPOSTCA059.SCERTYPE,   INSPOSTCA059.NBRANCH,    INSPOSTCA059.NPRODUCT,
                 INSPOSTCA059.NPOLICY,    INSPOSTCA059.NCERTIF,    INSPOSTCA059.NGROUP_INSU,
                 INSPOSTCA059.NMODULEC,   INSPOSTCA059.NCOVER,     INSPOSTCA059.SCLIENT,
                 INSPOSTCA059.DEFFECDATE, INSPOSTCA059.NRISKTYPE,  INSPOSTCA059.NITEMRISK,
                 INSPOSTCA059.NDEFTYPE,   INSPOSTCA059.NVALUELIST, INSPOSTCA059.SVALUETEXT,
                 INSPOSTCA059.NVALUENUM,  INSPOSTCA059.DVALUEDATE, NULL,
                 SYSDATE,                 INSPOSTCA059.NUSERCODE);
    END IF;

    COMMIT;
END;