create or replace PROCEDURE INSUDB.INSPARTICULARDATA
/*---------------------------------------------------------------------------------------------*/
/* NOMBRE:   INSPARTICULARDATA                                                                 */
/* OBJETIVO: ESTE PROCEDIMIENTO ES EL ENCARGADO DE DUPLICAR LA INFORMACIoN                     */
/*           EXISTENTE EN LA TABLA DE DATOS PARTICULARES DEL RAMO.                             */
/*           MIENTO QUE CREA EL RECIBO.                                                        */
/* PARaMETROS: 1 - SCERTYPE      :CoDIGO DEL RAMO A RENOVAR                                    */
/*             2 - NBRANCH       :CoDIGO DEL RAMO A RENOVAR                                    */
/*             3 - NPRODUCT      :CoDIGO DEL PRODUCTO A RENOVAR                                */
/*             4 - NPOLICY       :NUMERO DE PoLIZA                                             */
/*             5 - NCERTIF       :NuMERO DEL CERTIFICADO A RENOVAR                             */
/*             6 - DSTARTDATE    :FECHA DE EFECTO DEL NUEVO REGISTRO                           */
/*             7 - DNULLDATE     :FECHA DE ANULACIoN DEL REGISTRO                              */
/*             8 - NUSERCODE     :NuMERO DEL USUARIO                                           */
/*             9 - STABNAME           :NOMBRE DE LA TABLA DE DATOS PARTICULARES             */
/*            10 - NPROCTYPE            :NuMERO DE LA TRANSACCIoN                             */
/* SOURCESAFE INFORMATION:                                                                     */
/*     $Author: Nvaplat41 $                                                                    */
/*     $Date: 1/10/03 13.55 $                                                                */
/*     $Revision: 14 $                                                                          */
/*---------------------------------------------------------------------------------------------*/
    (SCERTYPE    POLICY.SCERTYPE%TYPE,
     NBRANCH     POLICY.NBRANCH%TYPE,
     NPRODUCT    POLICY.NPRODUCT%TYPE,
     NPOLICY     POLICY.NPOLICY%TYPE,
     NCERTIF     CERTIFICAT.NCERTIF%TYPE,
     DSTARTDATE  POLICY.DSTARTDATE%TYPE,
     DNULLDATE   POLICY.DNULLDATE%TYPE,
     DTEMPUPDATE POLICY.DSTARTDATE%TYPE DEFAULT NULL,
     NUSERCODE   POLICY.NUSERCODE%TYPE,
     STABNAME    TAB_NAME_B.STABNAME%TYPE,
     NPROCTYPE   INTEGER,
     NCOMMIT     SMALLINT DEFAULT 1) AUTHID CURRENT_USER AS

     SOWNER_BASE TABLE5638.SOWNER_BASE%TYPE;

     CURSOR C_REASYSCOLUMNS IS
         SELECT COLUMN_NAME
           FROM ALL_TAB_COLUMNS
          WHERE OWNER = RTRIM(INSPARTICULARDATA.SOWNER_BASE)
            AND TABLE_NAME = RTRIM(INSPARTICULARDATA.STABNAME);

    COLUMN_NAME ALL_TAB_COLUMNS.COLUMN_NAME%TYPE;
    SSEP        VARCHAR2(1);
/*- SE DECLARA LA VARIABLE  DPEFFEDATE PARA CONTENER EL VALOR DE LA FECHA DE EFECTO CON LA CUAL */
/*- SE REALIZARAN LAS LECTURAS A LOS ARCHIVOS CON HISTORIA */
    NTRANSACTIO     INTEGER;
    DDATE_RESULT    DATE;
    L_DEFFECDATE    POLICY.DSTARTDATE%TYPE;
/*- SE DECLARA LA VARIABLE  INSTR PARA PREPARA LAS INSTRUCCIONES */
    INSTR           VARCHAR2(2000);
    INSTR1           VARCHAR2(2000);
    INSTR2          VARCHAR2(2000);
    INSTR3          VARCHAR2(2000);
    INSTR4          VARCHAR2(2000);
    INSTRUPD      VARCHAR2(2000);
    INSTRUPDNULO      VARCHAR2(2000);    
    INSTRDEL       VARCHAR2(2000);
    INSTRINHIS VARCHAR2(2000);
    NCUENTA NUMBER;
    DSTARTDATE_AUX  POLICY.DSTARTDATE%TYPE;
    SORIGEN           VARCHAR2(2000);
    SACTION           VARCHAR2(3);

     TYPE RCURSOR IS REF CURSOR;
     C_SSELSQL      RCURSOR;
BEGIN
    SORIGEN:='INSPARTICULARDATA';
    SACTION:='DEL';
    DSTARTDATE_AUX:= DSTARTDATE;

-- DDR-26/12/2023-Verifico si es un endoso reatroactivo
   INSTR4 := ' SELECT count(0)'
           || ' FROM ' || INSPARTICULARDATA.STABNAME
           || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
           || ' AND NBRANCH = ' || TO_CHAR(INSPARTICULARDATA.NBRANCH)
           || ' AND NPRODUCT = '|| TO_CHAR(INSPARTICULARDATA.NPRODUCT)
           || ' AND NPOLICY = ' || TO_CHAR(INSPARTICULARDATA.NPOLICY)
           || ' AND NCERTIF = ' || TO_CHAR(INSPARTICULARDATA.NCERTIF)
           || ' AND DTCHAR(DEFFECDATE) > '''
           || DTCHAR(INSPARTICULARDATA.DSTARTDATE)  || ''''
           || ' AND DNULLDATE   IS NULL';

    OPEN C_SSELSQL FOR INSTR4;
    FETCH C_SSELSQL
     INTO NCUENTA;
    CLOSE C_SSELSQL;

    IF NCUENTA=0 THEN   
        INSTR3 := ' SELECT DEFFECDATE'
               || ' FROM ' || INSPARTICULARDATA.STABNAME
               || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
               || ' AND NBRANCH = ' || TO_CHAR(INSPARTICULARDATA.NBRANCH)
               || ' AND NPRODUCT = '|| TO_CHAR(INSPARTICULARDATA.NPRODUCT)
               || ' AND NPOLICY = ' || TO_CHAR(INSPARTICULARDATA.NPOLICY)
               || ' AND NCERTIF = ' || TO_CHAR(INSPARTICULARDATA.NCERTIF)
               || ' AND DTCHAR(DEFFECDATE) <= '''
               || DTCHAR(INSPARTICULARDATA.DSTARTDATE)  || ''''
               || ' AND (DNULLDATE   IS NULL  OR DTCHAR(DNULLDATE) > '''
               || DTCHAR(INSPARTICULARDATA.DSTARTDATE) || ''')';
    ELSE
	-- DDR-26/12/2023-Fecha de efectividad del endoso retroactivo
           INSTR3 := ' SELECT DEFFECDATE'
           || ' FROM ' || INSPARTICULARDATA.STABNAME
           || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
           || ' AND NBRANCH = ' || TO_CHAR(INSPARTICULARDATA.NBRANCH)
           || ' AND NPRODUCT = '|| TO_CHAR(INSPARTICULARDATA.NPRODUCT)
           || ' AND NPOLICY = ' || TO_CHAR(INSPARTICULARDATA.NPOLICY)
           || ' AND NCERTIF = ' || TO_CHAR(INSPARTICULARDATA.NCERTIF)
           || ' AND DTCHAR(DEFFECDATE) > '''
           || DTCHAR(INSPARTICULARDATA.DSTARTDATE)  || ''''
           || ' AND DNULLDATE   IS NULL';
    END IF;
    OPEN C_SSELSQL FOR INSTR3;
    FETCH C_SSELSQL
     INTO L_DEFFECDATE;
    CLOSE C_SSELSQL;

    IF TRUNC(L_DEFFECDATE) <> TRUNC(DSTARTDATE) THEN
/*+ SE BUSCA EL ULTIMO NUMERO DE TRANSACCION ASIGNADA EN EL ARCHIVO DE POLIZA "POLICY" */
        BEGIN
            SELECT NTRANSACTIO + 1
              INTO NTRANSACTIO
              FROM POLICY
             WHERE SCERTYPE = INSPARTICULARDATA.SCERTYPE
               AND NBRANCH  = INSPARTICULARDATA.NBRANCH
               AND NPRODUCT = INSPARTICULARDATA.NPRODUCT
               AND NPOLICY  = INSPARTICULARDATA.NPOLICY;
        END;

        IF NPROCTYPE = 12 OR
           NPROCTYPE = 13 THEN

/*+ SE OBTIENE EL OWNER DE LOS OBJETOS*/
            SELECT UPPER(SOWNER_BASE)
              INTO INSPARTICULARDATA.SOWNER_BASE
              FROM TABLE5638
             WHERE NCOMPANY = REAGENERALPKG.REAOPT_SYSTEM_COMPANY;

            SSEP := ' ';

            OPEN C_REASYSCOLUMNS;
            FETCH C_REASYSCOLUMNS INTO COLUMN_NAME;
            WHILE (C_REASYSCOLUMNS%FOUND)  LOOP
                INSTR  := INSTR  ||SSEP||COLUMN_NAME;
                IF COLUMN_NAME = 'DEFFECDATE' AND
                   NPROCTYPE <> 13 THEN
                    INSTR2 := INSTR2 ||SSEP|| 'STDATE(''' || DTCHAR(INSPARTICULARDATA.DSTARTDATE) || ''')';
                ELSIF COLUMN_NAME = 'DEFFECDATE' AND
                      NPROCTYPE = 13 THEN
                    INSTR2 := INSTR2 ||SSEP|| 'STDATE(''' || DTCHAR(INSPARTICULARDATA.DSTARTDATE)|| ''')';
                ELSIF COLUMN_NAME = 'DCOMPDATE' THEN
                    INSTR2 := INSTR2 ||SSEP|| 'STDATE('''  || DTCHAR(SYSDATE) || ''')';
                ELSIF COLUMN_NAME = 'NTRANSACTIO' THEN
                    INSTR2 := INSTR2 ||SSEP|| TO_CHAR(NTRANSACTIO);
                ELSIF COLUMN_NAME = 'NUSERCODE' THEN
                    INSTR2 := INSTR2 ||SSEP|| TO_CHAR(NUSERCODE);
                ELSIF COLUMN_NAME = 'DNULLDATE' AND
                       NPROCTYPE = 13 THEN
                    INSTR2 := INSTR2 ||SSEP||  'STDATE('''  || DTCHAR(INSPARTICULARDATA.DTEMPUPDATE) || ''')';
                ELSIF COLUMN_NAME = 'DNULLDATE' AND
                      NPROCTYPE <> 13 THEN
                    INSTR2 := INSTR2 ||SSEP|| 'NULL';
                ELSIF COLUMN_NAME = 'NNULLCODE' AND
                      NPROCTYPE <> 13  THEN
                    INSTR2 := INSTR2 ||SSEP|| 'NULL';
                ELSIF COLUMN_NAME = 'NNULLCODE' AND
                      NPROCTYPE = 13 THEN
                    INSTR2 := INSTR2 ||SSEP|| '3';
                ELSE
                    INSTR2 := INSTR2 ||SSEP|| COLUMN_NAME;
                END IF;
                    SSEP := ',';
                FETCH C_REASYSCOLUMNS INTO COLUMN_NAME;
            END LOOP;

            CLOSE C_REASYSCOLUMNS;
               INSTR  := 'INSERT INTO '||INSPARTICULARDATA.STABNAME||'('||INSTR||') ';
               IF NCUENTA=0 THEN             
               INSTR2 := ' SELECT '|| INSTR2 || ' FROM ' || INSPARTICULARDATA.STABNAME
                      || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
                      || ' AND NBRANCH = ' || TO_CHAR(INSPARTICULARDATA.NBRANCH)
                      || ' AND NPRODUCT = '|| TO_CHAR(INSPARTICULARDATA.NPRODUCT)
                      || ' AND NPOLICY = ' || TO_CHAR(INSPARTICULARDATA.NPOLICY)
                      || ' AND NCERTIF = ' || TO_CHAR(INSPARTICULARDATA.NCERTIF)
                      || ' AND DTCHAR(DEFFECDATE) <= '''
                      || DTCHAR(INSPARTICULARDATA.DSTARTDATE)  || ''''
                      || ' AND (DNULLDATE   IS NULL  OR DTCHAR(DNULLDATE) > '''
                      || DTCHAR(INSPARTICULARDATA.DSTARTDATE) || ''')';
                ELSE
				-- DDR-26/12/2023-Insercion de registro en la tabla particular cuando no existe para la misma fecha
                INSTR2 := ' SELECT '|| INSTR2 || ' FROM ' || INSPARTICULARDATA.STABNAME
                      || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
                      || ' AND NBRANCH = ' || TO_CHAR(INSPARTICULARDATA.NBRANCH)
                      || ' AND NPRODUCT = '|| TO_CHAR(INSPARTICULARDATA.NPRODUCT)
                      || ' AND NPOLICY = ' || TO_CHAR(INSPARTICULARDATA.NPOLICY)
                      || ' AND NCERTIF = ' || TO_CHAR(INSPARTICULARDATA.NCERTIF)
                      || ' AND DTCHAR(DEFFECDATE) > '''
                      || DTCHAR(INSPARTICULARDATA.DSTARTDATE)  || ''''
                      || ' AND DNULLDATE   IS NULL'
                      || ' AND NOT EXISTS ('
                      || ' SELECT 1  FROM ' || INSPARTICULARDATA.STABNAME
                      || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
                      || ' AND NBRANCH = ' || TO_CHAR(INSPARTICULARDATA.NBRANCH)
                      || ' AND NPRODUCT = '|| TO_CHAR(INSPARTICULARDATA.NPRODUCT)
                      || ' AND NPOLICY = ' || TO_CHAR(INSPARTICULARDATA.NPOLICY)
                      || ' AND NCERTIF = ' || TO_CHAR(INSPARTICULARDATA.NCERTIF)
                      || ' AND DTCHAR(DEFFECDATE) = '''
                      || DTCHAR(INSPARTICULARDATA.DSTARTDATE)  || ''')';
                END IF;

            EXECUTE IMMEDIATE  (INSTR||INSTR2) ;
            DSTARTDATE_AUX := DSTARTDATE - 1;
        END IF;

        IF NCUENTA=0 THEN             
         -- DDR-12/04/2024-Edicion           
         
		 INSTRINHIS :=  'INSERT INTO ' || TRIM(INSPARTICULARDATA.STABNAME) ||'_HIS '
			   || 'SELECT ' || TRIM(INSPARTICULARDATA.STABNAME) ||'.*,' || NUSERCODE ||',SYSTIMESTAMP,'
               || '(SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM '|| TRIM(INSPARTICULARDATA.STABNAME) ||'_HIS)),0) FROM DUAL) + ROWNUM ,'
               || ''''||SORIGEN||''','''||SACTION||''' FROM ' || TRIM(INSPARTICULARDATA.STABNAME)     
               || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
               || ' AND NBRANCH = '  || TO_CHAR(INSPARTICULARDATA.NBRANCH)
               || ' AND NPRODUCT = ' || TO_CHAR(INSPARTICULARDATA.NPRODUCT)
               || ' AND NPOLICY = '  || TO_CHAR(INSPARTICULARDATA.NPOLICY)
               || ' AND NCERTIF = '  || TO_CHAR(INSPARTICULARDATA.NCERTIF)
               || ' AND DTCHAR(DEFFECDATE) <= '''|| DTCHAR(INSPARTICULARDATA.DSTARTDATE_AUX) || ''''
               || ' AND (DNULLDATE   IS NULL'
               || ' OR DTCHAR(DNULLDATE) > '''  || DTCHAR(INSPARTICULARDATA.DSTARTDATE_AUX) || ''')';
        

/*+ SE ACTUALIZA EL REGISTRO DE DATOS PARTICULARES PARA COLOCAR EL VALOR EN EL CAMPO NULLDATE */
        INSTR :=  'UPDATE ' || INSPARTICULARDATA.STABNAME
               || ' SET DCOMPDATE = SYSDATE '
               || ', NNULLCODE = 3, DNULLDATE = STDATE(''' || DTCHAR(INSPARTICULARDATA.DSTARTDATE)  || ''')'
               || ', NUSERCODE= ' || TO_CHAR(INSPARTICULARDATA.NUSERCODE)
               || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
               || ' AND NBRANCH = '  || TO_CHAR(INSPARTICULARDATA.NBRANCH) 
               || ' AND NPRODUCT = ' || TO_CHAR(INSPARTICULARDATA.NPRODUCT)
               || ' AND NPOLICY = '  || TO_CHAR(INSPARTICULARDATA.NPOLICY)
               || ' AND NCERTIF = '  || TO_CHAR(INSPARTICULARDATA.NCERTIF)
               || ' AND DTCHAR(DEFFECDATE) <= '''|| DTCHAR(INSPARTICULARDATA.DSTARTDATE_AUX) || ''''
               || ' AND (DNULLDATE   IS NULL'
               || ' OR DTCHAR(DNULLDATE) > '''  || DTCHAR(INSPARTICULARDATA.DSTARTDATE_AUX) || ''')';
        ELSE
		-- DDR-26/12/2023-Tratamiento de tablas particulares para endosos retroactivos
		 INSTRINHIS :=  'INSERT INTO ' || TRIM(INSPARTICULARDATA.STABNAME) ||'_HIS '
			   || 'SELECT ' || TRIM(INSPARTICULARDATA.STABNAME) ||'.*,' || NUSERCODE ||',SYSTIMESTAMP,'
               || '(SELECT NVL(((SELECT MAX(NTRANSACTIO_HIS) FROM '|| TRIM(INSPARTICULARDATA.STABNAME) ||'_HIS)),0) FROM DUAL) + ROWNUM ,'
               || ''''||SORIGEN||''','''||SACTION||''' FROM ' || TRIM(INSPARTICULARDATA.STABNAME)     
               || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
               || ' AND NBRANCH = '  || TO_CHAR(INSPARTICULARDATA.NBRANCH)
               || ' AND NPRODUCT = ' || TO_CHAR(INSPARTICULARDATA.NPRODUCT)
               || ' AND NPOLICY = '  || TO_CHAR(INSPARTICULARDATA.NPOLICY)
               || ' AND NCERTIF = '  || TO_CHAR(INSPARTICULARDATA.NCERTIF)
               || ' AND DTCHAR(DEFFECDATE) >= DTCHAR(''' || INSPARTICULARDATA.DSTARTDATE || ''')'
               || ' ORDER BY  DTCHAR(DEFFECDATE)';

         INSTRDEL :=  'DELETE ' || INSPARTICULARDATA.STABNAME
               || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
               || ' AND NBRANCH = '  || TO_CHAR(INSPARTICULARDATA.NBRANCH)
               || ' AND NPRODUCT = ' || TO_CHAR(INSPARTICULARDATA.NPRODUCT)
               || ' AND NPOLICY = '  || TO_CHAR(INSPARTICULARDATA.NPOLICY)
               || ' AND NCERTIF = '  || TO_CHAR(INSPARTICULARDATA.NCERTIF)
               || ' AND DTCHAR(DEFFECDATE) > DTCHAR(''' || INSPARTICULARDATA.DSTARTDATE || ''')';


        INSTRUPD :=  'UPDATE ' || INSPARTICULARDATA.STABNAME
               || ' SET DCOMPDATE = SYSDATE '
               || ', NNULLCODE = 3, DNULLDATE = STDATE(''' || DTCHAR(INSPARTICULARDATA.DSTARTDATE)  || ''')'
               || ', NUSERCODE= ' || TO_CHAR(INSPARTICULARDATA.NUSERCODE)
               || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
               || ' AND NBRANCH = '  || TO_CHAR(INSPARTICULARDATA.NBRANCH)
               || ' AND NPRODUCT = ' || TO_CHAR(INSPARTICULARDATA.NPRODUCT)
               || ' AND NPOLICY = '  || TO_CHAR(INSPARTICULARDATA.NPOLICY)
               || ' AND NCERTIF = '  || TO_CHAR(INSPARTICULARDATA.NCERTIF)
               || ' AND DTCHAR(DEFFECDATE)='
               || '(SELECT DTCHAR(MAX(PART_HIS.DEFFECDATE))'
               || ' FROM ' || INSPARTICULARDATA.STABNAME || 'PART_HIS'
               || ' WHERE PART_HIS.SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
               || ' AND NBRANCH = '  || TO_CHAR(INSPARTICULARDATA.NBRANCH)
               || ' AND NPRODUCT = ' || TO_CHAR(INSPARTICULARDATA.NPRODUCT)
               || ' AND NPOLICY = '  || TO_CHAR(INSPARTICULARDATA.NPOLICY)
               || ' AND NCERTIF = '  || TO_CHAR(INSPARTICULARDATA.NCERTIF)
               || ' AND DTCHAR(PART_HIS.DEFFECDATE) < DTCHAR(''' || INSPARTICULARDATA.DSTARTDATE || '''))';

            INSTRUPDNULO :=  'UPDATE ' || INSPARTICULARDATA.STABNAME
               || ' SET DCOMPDATE = SYSDATE '
               || ', NNULLCODE = NULL, DNULLDATE = NULL'
               || ', NUSERCODE= ' || TO_CHAR(INSPARTICULARDATA.NUSERCODE)
               || ' WHERE SCERTYPE = ''' || INSPARTICULARDATA.SCERTYPE || ''''
               || ' AND NBRANCH = '  || TO_CHAR(INSPARTICULARDATA.NBRANCH)
               || ' AND NPRODUCT = ' || TO_CHAR(INSPARTICULARDATA.NPRODUCT)
               || ' AND NPOLICY = '  || TO_CHAR(INSPARTICULARDATA.NPOLICY)
               || ' AND NCERTIF = '  || TO_CHAR(INSPARTICULARDATA.NCERTIF)
               || ' AND DTCHAR(DEFFECDATE) = DTCHAR(''' || INSPARTICULARDATA.DSTARTDATE || ''')';               
        END IF;            


        IF NCUENTA=0 THEN
               -- DDR-13/04/2024-Edicion
               EXECUTE IMMEDIATE(INSTRINHIS);
               EXECUTE IMMEDIATE(INSTR);
         ELSE
			-- DDR-26/12/2023-Tratamiento de tablas particulares para endosos retroactivos
               EXECUTE IMMEDIATE(INSTRINHIS);        
               EXECUTE IMMEDIATE(INSTRDEL);
               EXECUTE IMMEDIATE(INSTRUPD); 
               EXECUTE IMMEDIATE(INSTRUPDNULO);  
        END IF;


    END IF;
    IF NCOMMIT = 1 THEN
        COMMIT;
    END IF;
END INSPARTICULARDATA;