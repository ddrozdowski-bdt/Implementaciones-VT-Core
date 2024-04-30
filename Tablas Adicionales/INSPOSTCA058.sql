create or replace PROCEDURE INSUDB.INSPOSTCA058
/*----------------------------------------------------------------------------------*/
/* NOMBRE    : INSPOSTCA058                                                         */
/* OBJETIVO  : ACTUALIZA LA TABLA DE RIESGOS ESPECÍFICOS POR COBERTURA              */
/* PARAMETROS:  1 - SCERTYPE    : TIPO DE REGISTRO                                  */
/*              2 - NBRANCH     : CODIGO DEL RAMO                                   */
/*              3 - NPRODUCT    : CODIGO DEL PRODUCTO                               */
/*              4 - NPOLICY     : NUMERO DE POLIZA                                  */
/*              5 - NCERTIF     : NUMERO DE CERTIFICADO                             */
/*              6 - NGROUP_INSU : CODIGO DEL GRUPO ASEGURADO                        */
/*              7 - NMODULEC    : CODIGO DEL MODULO                                 */
/*              8 - NCOVER      : CODIGO DE LA COBERTURA                            */
/*              9 - SCLIENT     : CODIGO DEL CLIENTE                                */
/*             10 - DEFFECDATE  : FECHA DE EFECTO DE LA TRANSACCION                 */
/*             11 - NRISKTYPE   : TIPO DE RIESGO                                    */
/*             12 - NITEMRISK   : CÓDIGO DEL RIESGO                                 */
/*             13 - NCAPITAL    : CAPITAL DEL RIESGO ESPECÍFICO                     */
/*             14 - NCURRENCY   : MONEDA DE LA COBERTURA                            */
/*             15 - SDESCRIPTION: DESCRIPCIÓN DE RIESGO ESPECÍFICO                  */
/*             16 - NRESERVERISK: MONTO DE RESERVA                                   */
/*             17 - SINDEXCLUDE_RISK: INDICADOR DE EXCLUSIÓN DE RIESGO POR SINIESTRO */
/*             18 - SINDAFFECTED_RISK: INDICADOR DE RIESGO AFECTADO POR UN SINIESTRO */
/*             19 - NUSERCODE   : CÓDIGO DEL USUARIO QUE CREA/ACTUALIZA EL REGISTRO  */
/*             20 - SACTION     : ACCIÓN QUE SE REALIZA SOBRE LA INFORMACIÓN         */
/*                                                                                   */
/* SOURCESAFE INFORMATION                                                            */
/*     $Author: rmujica $*/
/*     $Date: 24/10/2016 $*/
/*     $Revision: 2 $*/
/*----------------------------------------------------------------------------------*/
(SCERTYPE          SPECIFIC_RISK_COV.SCERTYPE%TYPE,
 NBRANCH           SPECIFIC_RISK_COV.NBRANCH%TYPE,
 NPRODUCT          SPECIFIC_RISK_COV.NPRODUCT%TYPE,
 NPOLICY           SPECIFIC_RISK_COV.NPOLICY%TYPE,
 NCERTIF           SPECIFIC_RISK_COV.NCERTIF%TYPE,
 NGROUP_INSU       SPECIFIC_RISK_COV.NGROUP_INSU%TYPE,
 NMODULEC          SPECIFIC_RISK_COV.NMODULEC%TYPE,
 NCOVER            SPECIFIC_RISK_COV.NCOVER%TYPE, 
 SCLIENT           SPECIFIC_RISK_COV.SCLIENT%TYPE,
 DEFFECDATE        SPECIFIC_RISK_COV.DEFFECDATE%TYPE,
 NRISKTYPE         SPECIFIC_RISK_COV.NRISKTYPE%TYPE,
 NITEMRISK         SPECIFIC_RISK_COV.NITEMRISK%TYPE,
 NCAPITAL          SPECIFIC_RISK_COV.NCAPITAL%TYPE,
 NCURRENCY         SPECIFIC_RISK_COV.NCURRENCY%TYPE,
 SDESCRIPTION      SPECIFIC_RISK_COV.SDESCRIPTION%TYPE,
 NRESERVERISK      SPECIFIC_RISK_COV.NRESERVERISK%TYPE,
 SINDEXCLUDE_RISK  SPECIFIC_RISK_COV.SINDEXCLUDE_RISK%TYPE, 
 SINDAFFECTED_RISK SPECIFIC_RISK_COV.SINDAFFECTED_RISK%TYPE,
 NUSERCODE         SPECIFIC_RISK_COV.NUSERCODE%TYPE,
 SACTION           VARCHAR2) AUTHID CURRENT_USER AS

    NEXISTS         INTEGER;
    NINTEMRISK_AUX  SPECIFIC_RISK_COV.NITEMRISK%TYPE;
    DEFFECDATE_AUX  SPECIFIC_RISK_COV.DEFFECDATE%TYPE;
    SINSERT         CHAR;
    NCUENTA         NUMBER;
    NEXIST INTEGER :=0;
    
BEGIN
  -- BDT-05/01/2024-Proceso para endosos retroactivos
    SELECT COUNT(0) INTO NCUENTA 
    FROM SPECIFIC_RISK_COV
    WHERE SCERTYPE     = INSPOSTCA058.SCERTYPE
    AND NBRANCH      = INSPOSTCA058.NBRANCH
    AND NPRODUCT     = INSPOSTCA058.NPRODUCT
    AND NPOLICY      = INSPOSTCA058.NPOLICY
    AND NCERTIF      = INSPOSTCA058.NCERTIF
    AND NGROUP_INSU  = INSPOSTCA058.NGROUP_INSU
    AND NMODULEC     = INSPOSTCA058.NMODULEC
    AND NCOVER      = INSPOSTCA058.NCOVER
    AND SCLIENT     = INSPOSTCA058.SCLIENT   
    AND NITEMRISK   =INSPOSTCA058.NITEMRISK
    AND DEFFECDATE > INSPOSTCA058.DEFFECDATE
    AND DNULLDATE IS NULL;

    
   
    SINSERT := '2';
    IF SACTION = 'UPDDESCRIPT' THEN
/*+ CUANDO SE ACEPTA LA TRANSACCIÓN CA059 (DETALLE DEL RIESGO ESPECÍFICO), SE ACTUALIZA LA DESCRIPCIÓN DEL RIESGO */

        
        UPDATE SPECIFIC_RISK_COV
           SET SDESCRIPTION = INSPOSTCA058.SDESCRIPTION,
               DCOMPDATE    = SYSDATE,
               NUSERCODE    = INSPOSTCA058.NUSERCODE
         WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE   
           AND NBRANCH     = INSPOSTCA058.NBRANCH    
           AND NPRODUCT    = INSPOSTCA058.NPRODUCT    
           AND NPOLICY     = INSPOSTCA058.NPOLICY    
           AND NCERTIF     = INSPOSTCA058.NCERTIF
           AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
           AND NMODULEC    = INSPOSTCA058.NMODULEC   
           AND NCOVER      = INSPOSTCA058.NCOVER
           AND SCLIENT     = INSPOSTCA058.SCLIENT   
           AND DEFFECDATE <= INSPOSTCA058.DEFFECDATE
           AND NRISKTYPE   = INSPOSTCA058.NRISKTYPE            
           AND NITEMRISK   = INSPOSTCA058.NITEMRISK
           AND (DNULLDATE  > INSPOSTCA058.DEFFECDATE
            OR  DNULLDATE IS NULL);
    ELSE
        IF SACTION = 'ADD' THEN
            BEGIN
/*+ SE TOMA EL ÚLTIMO CÓDIGO DE RIESGO REGISTRADO */
                SELECT NVL(MAX(NITEMRISK), 0) + 1
                  INTO NINTEMRISK_AUX
                  FROM SPECIFIC_RISK_COV
                 WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                   AND NBRANCH     = INSPOSTCA058.NBRANCH
                   AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                   AND NPOLICY     = INSPOSTCA058.NPOLICY
                   AND NCERTIF     = INSPOSTCA058.NCERTIF
                   AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                   AND NMODULEC    = INSPOSTCA058.NMODULEC
                   AND NCOVER      = INSPOSTCA058.NCOVER 
                   AND SCLIENT     = INSPOSTCA058.SCLIENT
                   AND NRISKTYPE   = INSPOSTCA058.NRISKTYPE;
            EXCEPTION
                WHEN OTHERS THEN
                    RAISE;
            END;
            SINSERT := '1';
        ELSE
            BEGIN
                NINTEMRISK_AUX := INSPOSTCA058.NITEMRISK;
                IF NCUENTA=0 THEN                
                    SELECT DEFFECDATE
                    INTO INSPOSTCA058.DEFFECDATE_AUX
                    FROM SPECIFIC_RISK_COV 
                    WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE   
                    AND NBRANCH     = INSPOSTCA058.NBRANCH    
                    AND NPRODUCT    = INSPOSTCA058.NPRODUCT    
                    AND NPOLICY     = INSPOSTCA058.NPOLICY    
                    AND NCERTIF     = INSPOSTCA058.NCERTIF
                    AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                    AND NMODULEC    = INSPOSTCA058.NMODULEC   
                    AND NCOVER      = INSPOSTCA058.NCOVER
                    AND SCLIENT     = INSPOSTCA058.SCLIENT   
                    AND DEFFECDATE <= INSPOSTCA058.DEFFECDATE
                    AND NRISKTYPE   = INSPOSTCA058.NRISKTYPE            
                    AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                    AND (DNULLDATE  > INSPOSTCA058.DEFFECDATE
                    OR  DNULLDATE IS NULL);
                ELSE
                    SELECT DEFFECDATE
                    INTO INSPOSTCA058.DEFFECDATE_AUX
                    FROM SPECIFIC_RISK_COV 
                    WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE   
                    AND NBRANCH     = INSPOSTCA058.NBRANCH    
                    AND NPRODUCT    = INSPOSTCA058.NPRODUCT    
                    AND NPOLICY     = INSPOSTCA058.NPOLICY    
                    AND NCERTIF     = INSPOSTCA058.NCERTIF
                    AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                    AND NMODULEC    = INSPOSTCA058.NMODULEC   
                    AND NCOVER      = INSPOSTCA058.NCOVER
                    AND SCLIENT     = INSPOSTCA058.SCLIENT                     
                    AND NRISKTYPE   = INSPOSTCA058.NRISKTYPE            
                    AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                    AND DEFFECDATE > INSPOSTCA058.DEFFECDATE
                    AND DNULLDATE IS NULL;                
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
                WHEN OTHERS THEN
                    RAISE;
            END;

            
            IF INSPOSTCA058.DEFFECDATE_AUX = DEFFECDATE THEN
/*+ A LA MISMA FECHA, DEPENDIENDO DE LA ACCIÓN, SE ELIMINA O ACTUALIZA EL REGISTRO */
                IF SACTION = 'DEL' THEN
                
                   IF NCUENTA=0 THEN                
                --CRETRACE2('INSPOSTCA058',1215,'SACTION: '|| SACTION ||'-SCERTYPE: '|| INSPOSTCA058.SCERTYPE ||'-NBRANCH: ' ||INSPOSTCA058.NBRANCH ||'-NPRODUCT: ' ||INSPOSTCA058.NPRODUCT ||'-NPOLICY: ' ||INSPOSTCA058.NPOLICY ||'-NGROUP_INSU: ' ||INSPOSTCA058.NGROUP_INSU ||'-NCERTIF: - ' ||INSPOSTCA058.NCERTIF ||'-NMODULEC: ' ||INSPOSTCA058.NMODULEC ||'-NCOVER: ' ||INSPOSTCA058.NCOVER ||'-SCLIENT: ' ||INSPOSTCA058.SCLIENT ||'-DEFFECDATE: ' ||INSPOSTCA058.DEFFECDATE ||'-NRISKTYPE: ' ||INSPOSTCA058.NRISKTYPE ||'-NITEMRISK: ' || INSPOSTCA058.NITEMRISK || '-DNULLDATE :' || INSPOSTCA058.DEFFECDATE);
                
                    DELETE FROM SPECIFIC_RISK_COV_DET
                     WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE   
                       AND NBRANCH     = INSPOSTCA058.NBRANCH    
                       AND NPRODUCT    = INSPOSTCA058.NPRODUCT    
                       AND NPOLICY     = INSPOSTCA058.NPOLICY    
                       AND NCERTIF     = INSPOSTCA058.NCERTIF
                       AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                       AND NMODULEC    = INSPOSTCA058.NMODULEC   
                       AND NCOVER      = INSPOSTCA058.NCOVER
                       AND SCLIENT     = INSPOSTCA058.SCLIENT   
                       AND DEFFECDATE <= INSPOSTCA058.DEFFECDATE
                       AND NRISKTYPE   = INSPOSTCA058.NRISKTYPE            
                       AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                       AND (DNULLDATE  > INSPOSTCA058.DEFFECDATE
                        OR  DNULLDATE IS NULL);
                        
                    DELETE FROM SPECIFIC_RISK_COV
                     WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE   
                       AND NBRANCH     = INSPOSTCA058.NBRANCH    
                       AND NPRODUCT    = INSPOSTCA058.NPRODUCT    
                       AND NPOLICY     = INSPOSTCA058.NPOLICY    
                       AND NCERTIF     = INSPOSTCA058.NCERTIF
                       AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                       AND NMODULEC    = INSPOSTCA058.NMODULEC   
                       AND NCOVER      = INSPOSTCA058.NCOVER
                       AND SCLIENT     = INSPOSTCA058.SCLIENT   
                       AND DEFFECDATE <= INSPOSTCA058.DEFFECDATE
                       AND NRISKTYPE   = INSPOSTCA058.NRISKTYPE            
                       AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                       AND (DNULLDATE  > INSPOSTCA058.DEFFECDATE
                        OR  DNULLDATE IS NULL);
                    ELSE
                      INSERT INTO SPECIFIC_RISK_COV_DET_HIS
                        SELECT SPECIFIC_RISK_COV_DET.*,INSPOSTCA058.NUSERCODE,SYSTIMESTAMP,
                        (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_DET_HIS)),0) FROM DUAL) + ROWNUM ,
                        'INSPOSTCA058','DEL'
                        FROM SPECIFIC_RISK_COV_DET                            
                        WHERE SCERTYPE  = INSPOSTCA058.SCERTYPE
                        AND NBRANCH     = INSPOSTCA058.NBRANCH
                        AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                        AND NPOLICY     = INSPOSTCA058.NPOLICY
                        AND NCERTIF     = INSPOSTCA058.NCERTIF
                        AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                        AND NMODULEC    = INSPOSTCA058.NMODULEC
                        AND NCOVER      = INSPOSTCA058.NCOVER
                        AND SCLIENT     = INSPOSTCA058.SCLIENT
                        AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                        AND DEFFECDATE >= INSPOSTCA058.DEFFECDATE;
        
                        DELETE SPECIFIC_RISK_COV_DET
                        WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                        AND NBRANCH     = INSPOSTCA058.NBRANCH
                        AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                        AND NPOLICY     = INSPOSTCA058.NPOLICY
                        AND NCERTIF     = INSPOSTCA058.NCERTIF
                        AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                        AND NMODULEC    = INSPOSTCA058.NMODULEC
                        AND NCOVER      = INSPOSTCA058.NCOVER
                        AND SCLIENT     = INSPOSTCA058.SCLIENT
                        AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                        AND DEFFECDATE >= INSPOSTCA058.DEFFECDATE;
                        
                        INSERT INTO SPECIFIC_RISK_COV_HIS
                        SELECT SPECIFIC_RISK_COV.*,INSPOSTCA058.NUSERCODE,SYSTIMESTAMP,
                        (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_HIS)),0) FROM DUAL) + ROWNUM ,
                        'INSPOSTCA058','DEL'
                        FROM SPECIFIC_RISK_COV                             
                        WHERE SCERTYPE  = INSPOSTCA058.SCERTYPE
                        AND NBRANCH     = INSPOSTCA058.NBRANCH
                        AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                        AND NPOLICY     = INSPOSTCA058.NPOLICY
                        AND NCERTIF     = INSPOSTCA058.NCERTIF
                        AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                        AND NMODULEC    = INSPOSTCA058.NMODULEC
                        AND NCOVER      = INSPOSTCA058.NCOVER
                        AND SCLIENT     = INSPOSTCA058.SCLIENT
                        AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                        AND DEFFECDATE >= INSPOSTCA058.DEFFECDATE;

                        DELETE SPECIFIC_RISK_COV 
                        WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                        AND NBRANCH     = INSPOSTCA058.NBRANCH
                        AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                        AND NPOLICY     = INSPOSTCA058.NPOLICY
                        AND NCERTIF     = INSPOSTCA058.NCERTIF
                        AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                        AND NMODULEC    = INSPOSTCA058.NMODULEC
                        AND NCOVER      = INSPOSTCA058.NCOVER
                        AND SCLIENT     = INSPOSTCA058.SCLIENT
                        AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                        AND DEFFECDATE >= INSPOSTCA058.DEFFECDATE;

                        UPDATE SPECIFIC_RISK_COV 
                        SET DNULLDATE = INSPOSTCA058.DEFFECDATE,
                        DCOMPDATE = SYSDATE,
                        NUSERCODE = INSPOSTCA058.NUSERCODE
                        WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                        AND NBRANCH     = INSPOSTCA058.NBRANCH
                        AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                        AND NPOLICY     = INSPOSTCA058.NPOLICY
                        AND NCERTIF     = INSPOSTCA058.NCERTIF
                        AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                        AND NMODULEC    = INSPOSTCA058.NMODULEC
                        AND NCOVER      = INSPOSTCA058.NCOVER
                        AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                        AND SCLIENT     = INSPOSTCA058.SCLIENT                           
                        and DEFFECDATE=
                        (SELECT MAX(SPECIFIC_RISK_COV_HIS.DEFFECDATE) 
                        FROM SPECIFIC_RISK_COV SPECIFIC_RISK_COV_HIS
                        WHERE SPECIFIC_RISK_COV_HIS.SCERTYPE= SPECIFIC_RISK_COV.SCERTYPE
                        AND SPECIFIC_RISK_COV_HIS.NBRANCH= SPECIFIC_RISK_COV.NBRANCH
                        AND SPECIFIC_RISK_COV_HIS.NPRODUCT= SPECIFIC_RISK_COV.NPRODUCT
                        AND SPECIFIC_RISK_COV_HIS.NPOLICY= SPECIFIC_RISK_COV.NPOLICY
                        AND SPECIFIC_RISK_COV_HIS.NCERTIF= SPECIFIC_RISK_COV.NCERTIF
                        AND SPECIFIC_RISK_COV_HIS.NMODULEC= SPECIFIC_RISK_COV.NMODULEC
                        AND SPECIFIC_RISK_COV_HIS.NCOVER= SPECIFIC_RISK_COV.NCOVER
                        AND SPECIFIC_RISK_COV_HIS.SCLIENT= SPECIFIC_RISK_COV.SCLIENT
                        AND SPECIFIC_RISK_COV_HIS.NITEMRISK= SPECIFIC_RISK_COV.NITEMRISK
                        AND SPECIFIC_RISK_COV_HIS.DEFFECDATE< INSPOSTCA058.DEFFECDATE);
                    END IF;
                ELSE
                    IF SACTION = 'UPDATE' THEN
                        IF NCUENTA=0 THEN                       
                            
                            INSERT INTO SPECIFIC_RISK_COV_HIS
                            SELECT SPECIFIC_RISK_COV.*,INSPOSTCA058.NUSERCODE,SYSTIMESTAMP,
                            (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_HIS)),0) FROM DUAL) + ROWNUM ,
                            'INSPOSTCA058','UPD'					
                            FROM SPECIFIC_RISK_COV
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE   
                            AND NBRANCH     = INSPOSTCA058.NBRANCH    
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT    
                            AND NPOLICY     = INSPOSTCA058.NPOLICY    
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC   
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT   
                            AND DEFFECDATE <= INSPOSTCA058.DEFFECDATE
                            AND NRISKTYPE   = INSPOSTCA058.NRISKTYPE            
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND (DNULLDATE  > INSPOSTCA058.DEFFECDATE
                            OR  DNULLDATE IS NULL);
                    
                            UPDATE SPECIFIC_RISK_COV
                            SET NCAPITAL     = INSPOSTCA058.NCAPITAL,
                            SDESCRIPTION = INSPOSTCA058.SDESCRIPTION,
                            DCOMPDATE    = SYSDATE,
                            NUSERCODE    = INSPOSTCA058.NUSERCODE
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE   
                            AND NBRANCH     = INSPOSTCA058.NBRANCH    
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT    
                            AND NPOLICY     = INSPOSTCA058.NPOLICY    
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC   
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT   
                            AND DEFFECDATE <= INSPOSTCA058.DEFFECDATE
                            AND NRISKTYPE   = INSPOSTCA058.NRISKTYPE            
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND (DNULLDATE  > INSPOSTCA058.DEFFECDATE
                            OR  DNULLDATE IS NULL);
                        ELSE
                        	-- DDR-05/01/2024-Proceso para endosos retroactivos
                            
                            INSERT INTO SPECIFIC_RISK_COV_DET_HIS
                            SELECT SPECIFIC_RISK_COV_DET.*,INSPOSTCA058.NUSERCODE,SYSTIMESTAMP,
                            (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_DET_HIS)),0) FROM DUAL) + ROWNUM ,
                            'INSPOSTCA058','DEL'
                            FROM SPECIFIC_RISK_COV_DET                            
                            WHERE SCERTYPE  = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND DEFFECDATE >= INSPOSTCA058.DEFFECDATE;
            
                            DELETE SPECIFIC_RISK_COV_DET
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND DEFFECDATE > INSPOSTCA058.DEFFECDATE;
                            
                            INSERT INTO SPECIFIC_RISK_COV_HIS
                            SELECT SPECIFIC_RISK_COV.*,INSPOSTCA058.NUSERCODE,SYSTIMESTAMP,
                            (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_HIS)),0) FROM DUAL) + ROWNUM ,
                            'INSPOSTCA058','DEL'
                            FROM SPECIFIC_RISK_COV                             
                            WHERE SCERTYPE  = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND DEFFECDATE >= INSPOSTCA058.DEFFECDATE;

                            DELETE SPECIFIC_RISK_COV 
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND DEFFECDATE > INSPOSTCA058.DEFFECDATE;

                            UPDATE SPECIFIC_RISK_COV 
                            SET DNULLDATE = INSPOSTCA058.DEFFECDATE,
                            DCOMPDATE = SYSDATE,
                            NUSERCODE = INSPOSTCA058.NUSERCODE
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND SCLIENT     = INSPOSTCA058.SCLIENT                           
                            and DEFFECDATE=
                            (SELECT MAX(SPECIFIC_RISK_COV_HIS.DEFFECDATE) 
                            FROM SPECIFIC_RISK_COV SPECIFIC_RISK_COV_HIS
                            WHERE SPECIFIC_RISK_COV_HIS.SCERTYPE= SPECIFIC_RISK_COV.SCERTYPE
                            AND SPECIFIC_RISK_COV_HIS.NBRANCH= SPECIFIC_RISK_COV.NBRANCH
                            AND SPECIFIC_RISK_COV_HIS.NPRODUCT= SPECIFIC_RISK_COV.NPRODUCT
                            AND SPECIFIC_RISK_COV_HIS.NPOLICY= SPECIFIC_RISK_COV.NPOLICY
                            AND SPECIFIC_RISK_COV_HIS.NCERTIF= SPECIFIC_RISK_COV.NCERTIF
                            AND SPECIFIC_RISK_COV_HIS.NMODULEC= SPECIFIC_RISK_COV.NMODULEC
                            AND SPECIFIC_RISK_COV_HIS.NCOVER= SPECIFIC_RISK_COV.NCOVER
                            AND SPECIFIC_RISK_COV_HIS.SCLIENT= SPECIFIC_RISK_COV.SCLIENT
                            AND SPECIFIC_RISK_COV_HIS.NITEMRISK= SPECIFIC_RISK_COV.NITEMRISK
                            AND SPECIFIC_RISK_COV_HIS.DEFFECDATE< INSPOSTCA058.DEFFECDATE);

                            UPDATE SPECIFIC_RISK_COV
                            SET DNULLDATE = NULL,
                            DCOMPDATE = SYSDATE,
                            NUSERCODE = INSPOSTCA058.NUSERCODE,
                            NCAPITAL = INSPOSTCA058.NCAPITAL
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND DEFFECDATE = INSPOSTCA058.DEFFECDATE;
                        
                        END IF;
                    END IF;
                END IF;   
            ELSE
                IF NCUENTA=0 THEN
                    UPDATE SPECIFIC_RISK_COV
                       SET DNULLDATE = INSPOSTCA058.DEFFECDATE,
                           DCOMPDATE = SYSDATE,
                           NUSERCODE = INSPOSTCA058.NUSERCODE
                     WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE   
                       AND NBRANCH     = INSPOSTCA058.NBRANCH    
                       AND NPRODUCT    = INSPOSTCA058.NPRODUCT    
                       AND NPOLICY     = INSPOSTCA058.NPOLICY    
                       AND NCERTIF     = INSPOSTCA058.NCERTIF
                       AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                       AND NMODULEC    = INSPOSTCA058.NMODULEC   
                       AND NCOVER      = INSPOSTCA058.NCOVER
                       AND SCLIENT     = INSPOSTCA058.SCLIENT   
                       AND DEFFECDATE <= INSPOSTCA058.DEFFECDATE
                       AND NRISKTYPE   = INSPOSTCA058.NRISKTYPE            
                       AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                       AND (DNULLDATE  > INSPOSTCA058.DEFFECDATE
                        OR  DNULLDATE IS NULL);
                        
                    UPDATE SPECIFIC_RISK_COV_DET
                       SET DNULLDATE = INSPOSTCA058.DEFFECDATE,
                           DCOMPDATE = SYSDATE,
                           NUSERCODE = INSPOSTCA058.NUSERCODE
                     WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                       AND NBRANCH     = INSPOSTCA058.NBRANCH
                       AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                       AND NPOLICY     = INSPOSTCA058.NPOLICY
                       AND NCERTIF     = INSPOSTCA058.NCERTIF
                       AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                       AND NMODULEC    = INSPOSTCA058.NMODULEC
                       AND NCOVER      = INSPOSTCA058.NCOVER
                       AND SCLIENT     = INSPOSTCA058.SCLIENT
                       AND DEFFECDATE <= INSPOSTCA058.DEFFECDATE
                       AND NRISKTYPE   = INSPOSTCA058.NRISKTYPE
                       AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                       AND (DNULLDATE  > INSPOSTCA058.DEFFECDATE
                        OR  DNULLDATE IS NULL);                    
                ELSE
               
                        -- DDR-05/01/2024-Proceso para endosos retroactivos
                        INSERT INTO SPECIFIC_RISK_COV_DET_HIS
                        SELECT SPECIFIC_RISK_COV_DET.*,INSPOSTCA058.NUSERCODE,SYSTIMESTAMP,
                        (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_DET_HIS)),0) FROM DUAL) + ROWNUM ,
                        'INSPOSTCA058','DEL'
                        FROM SPECIFIC_RISK_COV_DET                            
                        WHERE SCERTYPE  = INSPOSTCA058.SCERTYPE
                        AND NBRANCH     = INSPOSTCA058.NBRANCH
                        AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                        AND NPOLICY     = INSPOSTCA058.NPOLICY
                        AND NCERTIF     = INSPOSTCA058.NCERTIF
                        AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                        AND NMODULEC    = INSPOSTCA058.NMODULEC
                        AND NCOVER      = INSPOSTCA058.NCOVER
                        AND SCLIENT     = INSPOSTCA058.SCLIENT
                        AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                        AND DEFFECDATE >= INSPOSTCA058.DEFFECDATE;
                        
                        IF SACTION<>'DEL' THEN        
                            DELETE SPECIFIC_RISK_COV_DET
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND DEFFECDATE > INSPOSTCA058.DEFFECDATE;
                        ELSE
                            DELETE SPECIFIC_RISK_COV_DET
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND DEFFECDATE >= INSPOSTCA058.DEFFECDATE;                        
                        END IF;

                        INSERT INTO SPECIFIC_RISK_COV_HIS
                        SELECT SPECIFIC_RISK_COV.*,INSPOSTCA058.NUSERCODE,SYSTIMESTAMP,
                        (SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM SPECIFIC_RISK_COV_HIS)),0) FROM DUAL) + ROWNUM ,
                        'INSPOSTCA058','DEL'
                        FROM SPECIFIC_RISK_COV                             
                        WHERE SCERTYPE  = INSPOSTCA058.SCERTYPE
                        AND NBRANCH     = INSPOSTCA058.NBRANCH
                        AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                        AND NPOLICY     = INSPOSTCA058.NPOLICY
                        AND NCERTIF     = INSPOSTCA058.NCERTIF
                        AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                        AND NMODULEC    = INSPOSTCA058.NMODULEC
                        AND NCOVER      = INSPOSTCA058.NCOVER
                        AND SCLIENT     = INSPOSTCA058.SCLIENT
                        AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                        AND DEFFECDATE >= INSPOSTCA058.DEFFECDATE;

                        IF SACTION<>'DEL' THEN                               
                            DELETE SPECIFIC_RISK_COV 
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND DEFFECDATE > INSPOSTCA058.DEFFECDATE;
                        ELSE
                            DELETE SPECIFIC_RISK_COV 
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND DEFFECDATE >= INSPOSTCA058.DEFFECDATE;
                        END IF;                        
						
                        UPDATE SPECIFIC_RISK_COV 
                        SET DNULLDATE = INSPOSTCA058.DEFFECDATE,
                        DCOMPDATE = SYSDATE,
                        NUSERCODE = INSPOSTCA058.NUSERCODE
                        WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                        AND NBRANCH     = INSPOSTCA058.NBRANCH
                        AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                        AND NPOLICY     = INSPOSTCA058.NPOLICY
                        AND NCERTIF     = INSPOSTCA058.NCERTIF
                        AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                        AND NMODULEC    = INSPOSTCA058.NMODULEC
                        AND NCOVER      = INSPOSTCA058.NCOVER
                        AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                        AND SCLIENT     = INSPOSTCA058.SCLIENT                           
                        and DEFFECDATE=
                        (SELECT MAX(SPECIFIC_RISK_COV_HIS.DEFFECDATE) 
                        FROM SPECIFIC_RISK_COV SPECIFIC_RISK_COV_HIS
                        WHERE SPECIFIC_RISK_COV_HIS.SCERTYPE= SPECIFIC_RISK_COV.SCERTYPE
                        AND SPECIFIC_RISK_COV_HIS.NBRANCH= SPECIFIC_RISK_COV.NBRANCH
                        AND SPECIFIC_RISK_COV_HIS.NPRODUCT= SPECIFIC_RISK_COV.NPRODUCT
                        AND SPECIFIC_RISK_COV_HIS.NPOLICY= SPECIFIC_RISK_COV.NPOLICY
                        AND SPECIFIC_RISK_COV_HIS.NCERTIF= SPECIFIC_RISK_COV.NCERTIF
                        AND SPECIFIC_RISK_COV_HIS.NMODULEC= SPECIFIC_RISK_COV.NMODULEC
                        AND SPECIFIC_RISK_COV_HIS.NCOVER= SPECIFIC_RISK_COV.NCOVER
                        AND SPECIFIC_RISK_COV_HIS.SCLIENT= SPECIFIC_RISK_COV.SCLIENT
                        AND SPECIFIC_RISK_COV_HIS.NITEMRISK= SPECIFIC_RISK_COV.NITEMRISK
                        AND SPECIFIC_RISK_COV_HIS.DEFFECDATE< INSPOSTCA058.DEFFECDATE);
 
                        -- DDR-17/04/2024-Proceso para endosos retroactivos
                        IF SACTION='DEL' THEN
                            UPDATE SPECIFIC_RISK_COV_DET 
                            SET DNULLDATE = INSPOSTCA058.DEFFECDATE,
                            DCOMPDATE = SYSDATE,
                            NUSERCODE = INSPOSTCA058.NUSERCODE
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
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
                            AND SPECIFIC_RISK_COV_DET_HIS.DEFFECDATE< INSPOSTCA058.DEFFECDATE);
                        END IF; 
 
                        IF SACTION<>'DEL' THEN
                            UPDATE SPECIFIC_RISK_COV
                            SET DNULLDATE = NULL,
                            DCOMPDATE = SYSDATE,
                            NUSERCODE = INSPOSTCA058.NUSERCODE,
                            NCAPITAL = INSPOSTCA058.NCAPITAL
                            WHERE SCERTYPE    = INSPOSTCA058.SCERTYPE
                            AND NBRANCH     = INSPOSTCA058.NBRANCH
                            AND NPRODUCT    = INSPOSTCA058.NPRODUCT
                            AND NPOLICY     = INSPOSTCA058.NPOLICY
                            AND NCERTIF     = INSPOSTCA058.NCERTIF
                            AND NGROUP_INSU = INSPOSTCA058.NGROUP_INSU
                            AND NMODULEC    = INSPOSTCA058.NMODULEC
                            AND NCOVER      = INSPOSTCA058.NCOVER
                            AND SCLIENT     = INSPOSTCA058.SCLIENT
                            AND NITEMRISK   = INSPOSTCA058.NITEMRISK
                            AND DEFFECDATE = INSPOSTCA058.DEFFECDATE;
                        END IF;
                END IF;                
/*+ A DIFERENTE FECHA, SE ANULA EL REGISTRO.  SI SE ESTÁ ACTUALIZANDO, SE CREA EL REGISTRO A LA NUEVA FECHA */
                IF SACTION = 'UPDATE' THEN
                    SINSERT := '1';
                END IF;
            END IF;
        END IF;
        
    END IF;

/*+ SE AGREGA EL NUEVO REGISTRO A LA TABLA */
    IF SINSERT = '1' THEN

        SELECT COUNT(*) INTO NEXIST
        FROM  SPECIFIC_RISK_COV
        WHERE SCERTYPE=INSPOSTCA058.SCERTYPE       
        AND NBRANCH=INSPOSTCA058.NBRANCH
        AND NPRODUCT=INSPOSTCA058.NPRODUCT
        AND NPOLICY=INSPOSTCA058.NPOLICY
        AND NCERTIF=INSPOSTCA058.NCERTIF
        AND NGROUP_INSU=INSPOSTCA058.NGROUP_INSU
        AND NMODULEC=INSPOSTCA058.NMODULEC
        AND NCOVER=INSPOSTCA058.NCOVER
        AND SCLIENT=INSPOSTCA058.SCLIENT
        AND DEFFECDATE=INSPOSTCA058.DEFFECDATE
        AND NRISKTYPE=INSPOSTCA058.NRISKTYPE
        AND NITEMRISK=INSPOSTCA058.NITEMRISK;
        
        IF NEXIST=0 THEN
            INSERT INTO SPECIFIC_RISK_COV (SCERTYPE,         NBRANCH,           NPRODUCT,
            NPOLICY,          NCERTIF,           NGROUP_INSU,
            NMODULEC,         NCOVER,            SCLIENT, 
            DEFFECDATE,       NRISKTYPE,         NITEMRISK, 
            NCAPITAL,         NCURRENCY,         NRESERVERISK, 
            SINDEXCLUDE_RISK, SINDAFFECTED_RISK, SDESCRIPTION, 
            DNULLDATE,        DCOMPDATE,         NUSERCODE)
            VALUES (INSPOSTCA058.SCERTYPE,         INSPOSTCA058.NBRANCH,           INSPOSTCA058.NPRODUCT,
            INSPOSTCA058.NPOLICY,          INSPOSTCA058.NCERTIF,           INSPOSTCA058.NGROUP_INSU,
            INSPOSTCA058.NMODULEC,         INSPOSTCA058.NCOVER,            INSPOSTCA058.SCLIENT,
            INSPOSTCA058.DEFFECDATE,       INSPOSTCA058.NRISKTYPE,         NINTEMRISK_AUX,
            INSPOSTCA058.NCAPITAL,         INSPOSTCA058.NCURRENCY,         INSPOSTCA058.NRESERVERISK,
            INSPOSTCA058.SINDEXCLUDE_RISK, INSPOSTCA058.SINDAFFECTED_RISK, INSPOSTCA058.SDESCRIPTION,
            NULL,                          SYSDATE,                        INSPOSTCA058.NUSERCODE);
       END IF;                              
    END IF;
END INSPOSTCA058;