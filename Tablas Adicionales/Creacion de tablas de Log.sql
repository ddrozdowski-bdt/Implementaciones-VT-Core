DECLARE NCUENTA NUMBER;
BEGIN

SELECT COUNT(0) INTO  NCUENTA FROM USER_TABLES WHERE TABLE_NAME='MODULES_HIS';

IF NCUENTA<>0 THEN
     EXECUTE IMMEDIATE 'DROP TABLE MODULES_HIS';
END IF;

SELECT COUNT(0) INTO  NCUENTA FROM USER_TABLES WHERE TABLE_NAME='SPECIFIC_RISK_COV_HIS';

IF NCUENTA<>0 THEN
     EXECUTE IMMEDIATE 'DROP TABLE SPECIFIC_RISK_COV_HIS';
END IF;   

SELECT COUNT(0) INTO  NCUENTA FROM USER_TABLES WHERE TABLE_NAME='SPECIFIC_RISK_COV_DET_HIS';

IF NCUENTA<>0 THEN
     EXECUTE IMMEDIATE 'DROP TABLE SPECIFIC_RISK_COV_DET_HIS';
END IF;   

SELECT COUNT(0) INTO  NCUENTA FROM USER_TABLES WHERE TABLE_NAME='CLAUSE_HIS';
IF NCUENTA<>0 THEN
     EXECUTE IMMEDIATE 'DROP TABLE CLAUSE_HIS';
END IF;   

END;
/  
CREATE TABLE "INSUDB"."MODULES_HIS" 
(	"SCERTYPE" CHAR(1 BYTE), 
"NBRANCH" NUMBER(5,0), 
"NPRODUCT" NUMBER(5,0), 
"NPOLICY" NUMBER(10,0), 
"NCERTIF" NUMBER(10,0), 
"NGROUP_INSU" NUMBER(5,0), 
"NMODULEC" NUMBER(5,0), 
"DEFFECDATE" DATE, 
"DCOMPDATE_HIS" DATE, 
"DNULLDATE" DATE, 
"NUSERCODE_HIS" NUMBER(5,0), 
"SCHANGEI" CHAR(1 BYTE), 
"NCURRENCY" NUMBER(5,0), 
"NPREMIRAT" NUMBER(9,6), 
"STYP_RAT" CHAR(1 BYTE), 
"SINHERIT" CHAR(1 BYTE),
"NUSERCODE" NUMBER(5,0),
"DCOMPDATE" TIMESTAMP, 
"NTRANSACTIO_HIS" NUMBER(10,0), 
"SORIGEN_HIS" VARCHAR2(100),
"SACTION_HIS" VARCHAR2(10)
) SEGMENT CREATION IMMEDIATE 
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
STORAGE(INITIAL 3145728 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "DATA0" ;
/
CREATE TABLE "INSUDB"."SPECIFIC_RISK_COV_HIS" 
(	"SCERTYPE" CHAR(1 BYTE), 
"NBRANCH" NUMBER(5,0), 
"NPRODUCT" NUMBER(5,0), 
"NPOLICY" NUMBER(10,0), 
"NCERTIF" NUMBER(10,0), 
"NGROUP_INSU" NUMBER(5,0), 
"NMODULEC" NUMBER(5,0), 
"NCOVER" NUMBER(5,0), 
"SCLIENT" CHAR(14 BYTE), 
"DEFFECDATE" DATE, 
"NRISKTYPE" NUMBER(5,0), 
"NITEMRISK" NUMBER(5,0), 
"NCAPITAL" NUMBER(18,6), 
"NCURRENCY" NUMBER(5,0), 
"NRESERVERISK" NUMBER(18,6), 
"SINDEXCLUDE_RISK" CHAR(1 BYTE), 
"SINDAFFECTED_RISK" CHAR(1 BYTE), 
"SDESCRIPTION" CHAR(50 BYTE), 
"DNULLDATE" DATE, 
"DCOMPDATE_HIS" DATE, 
"NUSERCODE_HIS" NUMBER(5,0),
"NUSERCODE" NUMBER(5,0),
"DCOMPDATE" TIMESTAMP, 
"NTRANSACTIO_HIS" NUMBER(10,0), 
"SORIGEN_HIS" VARCHAR2(100),
"SACTION_HIS" VARCHAR2(10)    
) SEGMENT CREATION IMMEDIATE 
PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "DATA0" ;
/
CREATE TABLE "INSUDB"."SPECIFIC_RISK_COV_DET_HIS" 
(	"SCERTYPE" CHAR(1 BYTE), 
"NBRANCH" NUMBER(5,0), 
"NPRODUCT" NUMBER(5,0), 
"NPOLICY" NUMBER(10,0), 
"NCERTIF" NUMBER(10,0), 
"NGROUP_INSU" NUMBER(5,0), 
"NMODULEC" NUMBER(5,0), 
"NCOVER" NUMBER(5,0), 
"SCLIENT" CHAR(14 BYTE), 
"DEFFECDATE" DATE, 
"NRISKTYPE" NUMBER(5,0), 
"NITEMRISK" NUMBER(5,0), 
"NDEFTYPE" NUMBER(5,0), 
"NVALUELIST" NUMBER(5,0), 
"SVALUETEXT" VARCHAR2(200 BYTE), 
"NVALUENUM" NUMBER(18,6), 
"DVALUEDATE" DATE, 
"DNULLDATE" DATE, 
"DCOMPDATE_HIS" DATE, 
"NUSERCODE_HIS" NUMBER(5,0),
"NUSERCODE" NUMBER(5,0),
"DCOMPDATE" TIMESTAMP, 
"NTRANSACTIO_HIS" NUMBER(10,0), 
"SORIGEN_HIS" VARCHAR2(100),
"SACTION_HIS" VARCHAR2(10)    
) SEGMENT CREATION IMMEDIATE 
PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "DATA0" ;
/
CREATE TABLE "INSUDB"."CLAUSE_HIS" 
(	"SCERTYPE" CHAR(1 BYTE), 
"NBRANCH" NUMBER(5,0), 
"NPRODUCT" NUMBER(5,0), 
"NPOLICY" NUMBER(10,0), 
"NCERTIF" NUMBER(10,0), 
"NCLAUSE" NUMBER(5,0), 
"DEFFECDATE" DATE, 
"DCOMPDATE_HIS" DATE, 
"NID" NUMBER(5,0), 
"NNOTENUM" NUMBER(10,0), 
"DNULLDATE" DATE, 
"NUSERCODE_HIS" NUMBER(5,0), 
"SCLIENT" CHAR(14 BYTE), 
"NGROUP_INSU" NUMBER(5,0), 
"NMODULEC" NUMBER(5,0), 
"NCOVER" NUMBER(5,0), 
"NCAUSE" NUMBER(5,0), 
"SAGREE" CHAR(1 BYTE), 
"STYPE_CLAUSE" CHAR(1 BYTE), 
"SDOC_ATTACH" VARCHAR2(45 BYTE), 
"NDISC_CODE" NUMBER(5,0), 
"NCOMMER_ACTIVITY" NUMBER(10,0) DEFAULT 0,
"NUSERCODE" NUMBER(5,0),
"DCOMPDATE" TIMESTAMP, 
"NTRANSACTIO_HIS" NUMBER(10,0), 
"SORIGEN_HIS" VARCHAR2(100),
"SACTION_HIS" VARCHAR2(10)
) SEGMENT CREATION IMMEDIATE 
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "DATA0" ;
