DECLARE NCUENTA NUMBER;
BEGIN

SELECT COUNT(0) INTO  NCUENTA FROM USER_TABLES WHERE TABLE_NAME='COVER_HIS';

IF NCUENTA<>0 THEN
     EXECUTE IMMEDIATE 'DROP TABLE COVER_HIS';
END IF;
SELECT COUNT(0) INTO  NCUENTA FROM USER_TABLES WHERE TABLE_NAME='THEFT_HIS';

IF NCUENTA<>0 THEN
     EXECUTE IMMEDIATE 'DROP TABLE THEFT_HIS';
END IF;   
SELECT COUNT(0) INTO  NCUENTA FROM USER_TABLES WHERE TABLE_NAME='LIFE_HIS';

IF NCUENTA<>0 THEN
     EXECUTE IMMEDIATE 'DROP TABLE LIFE_HIS';
END IF;   

SELECT COUNT(0) INTO  NCUENTA FROM USER_TABLES WHERE TABLE_NAME='MULTI_RISK_HIS';

IF NCUENTA<>0 THEN
     EXECUTE IMMEDIATE 'DROP TABLE MULTI_RISK_HIS';
END IF;   

SELECT COUNT(0) INTO  NCUENTA FROM USER_TABLES WHERE TABLE_NAME='HOMEOWNER_HIS';

IF NCUENTA<>0 THEN
     EXECUTE IMMEDIATE 'DROP TABLE HOMEOWNER_HIS';
END IF;   

SELECT COUNT(0) INTO  NCUENTA FROM USER_TABLES WHERE TABLE_NAME='EQUIPMENT_HIS';

IF NCUENTA<>0 THEN
     EXECUTE IMMEDIATE 'DROP TABLE EQUIPMENT_HIS';
END IF;   



END;
/  
CREATE TABLE "INSUDB"."COVER_HIS" 
(	"SCERTYPE" CHAR(1 BYTE), 
"NBRANCH" NUMBER(5,0), 
"NPRODUCT" NUMBER(5,0), 
"NPOLICY" NUMBER(10,0), 
"NCERTIF" NUMBER(10,0), 
"NGROUP_INSU" NUMBER(5,0), 
"NMODULEC" NUMBER(5,0), 
"NCOVER" NUMBER(5,0), 
"DEFFECDATE" DATE, 
"SCLIENT" CHAR(14 BYTE), 
"NROLE" NUMBER(5,0), 
"NCAPITAL" NUMBER(18,6), 
"NCAPITALI" NUMBER(18,6), 
"SCHANGE" CHAR(1 BYTE), 
"DCOMPDATE_OLD" DATE, 
"SFRANDEDI" CHAR(1 BYTE), 
"NCURRENCY" NUMBER(5,0), 
"NDISCOUNT" NUMBER(4,2), 
"NFIXAMOUNT" NUMBER(10,0), 
"NMAXAMOUNT" NUMBER(10,0), 
"SFREE_PREMI" CHAR(1 BYTE), 
"NMINAMOUNT" NUMBER(10,0), 
"DNULLDATE" DATE, 
"NPREMIUM" NUMBER(18,6), 
"NRATE" NUMBER(4,2), 
"NWAIT_QUAN" NUMBER(5,0), 
"NRATECOVE" NUMBER(9,6), 
"NUSERCODE_OLD" NUMBER(5,0), 
"SWAIT_TYPE" CHAR(1 BYTE), 
"SFRANCAPL" CHAR(1 BYTE), 
"NDISC_AMOUN" NUMBER(18,6), 
"NTYPDURINS" NUMBER(5,0), 
"NDURINSUR" NUMBER(5,0), 
"NAGEMININS" NUMBER(5,0), 
"NAGEMAXINS" NUMBER(5,0), 
"NAGEMAXPER" NUMBER(5,0), 
"NTYPDURPAY" NUMBER(5,0), 
"NDURPAY" NUMBER(5,0), 
"NCAUSEUPD" NUMBER(5,0), 
"NCAPITAL_WAIT" NUMBER(18,6), 
"NAGELIMIT" NUMBER(5,0), 
"NAGE_PER" NUMBER(5,0), 
"DANIVERSARY" DATE, 
"DSEEKTAR" DATE, 
"DFER" DATE, 
"NBRANCH_REI" NUMBER(5,0), 
"NRETARIF" NUMBER(5,0), 
"NCAPITAL_O" NUMBER(18,6), 
"NPREMIUM_O" NUMBER(18,6), 
"NRATECOVE_O" NUMBER(9,6), 
"NTAXAMOUNT" NUMBER(18,6), 
"NRECAMOUNT" NUMBER(18,6), 
"NDESCAMOUNT" NUMBER(18,6), 
"NCOMMI_AN" NUMBER(18,6), 
"NRATECOVE_B" NUMBER(18,6), 
"NCAPITAL_REQ" NUMBER(18,6), 
"NRATECLA" NUMBER(4,2), 
"NFIXAMOCLA" NUMBER(10,0), 
"NMINAMOCLA" NUMBER(10,0), 
"NMAXAMOCLA" NUMBER(10,0), 
"NDISCCLA" NUMBER(4,2), 
"NDISC_AMOCLA" NUMBER(18,6), 
"NFRANCDAYS" NUMBER(3,0), 
"NREVALTYPE" NUMBER(5,0),
"NUSERCODE" NUMBER(5,0),
"DCOMPDATE" TIMESTAMP, 
"NTRANSACTIO_HIS" NUMBER(10,0), 
"SORIGEN_HIS" VARCHAR2(100),
"SACTION_HIS" VARCHAR2(10)
) SEGMENT CREATION IMMEDIATE 
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
STORAGE(INITIAL 19922944 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "DATA0" ;
/
CREATE TABLE "INSUDB"."THEFT_HIS" 
(	"SCERTYPE" CHAR(1 BYTE), 
"NBRANCH" NUMBER(5,0), 
"NPRODUCT" NUMBER(5,0), 
"NPOLICY" NUMBER(10,0), 
"NCERTIF" NUMBER(10,0), 
"DEFFECDATE" DATE, 
"NCAPITAL" NUMBER(12,0), 
"NAREA" NUMBER(5,0), 
"NBUSSTREND" NUMBER(5,0), 
"NCATEGORY" NUMBER(5,0), 
"DCOMPDATE_OLD" DATE, 
"DEXPIRDAT" DATE, 
"NRISKCLASS" NUMBER(5,0), 
"DISSUEDAT" DATE, 
"NNULLCODE" NUMBER(5,0), 
"DNULLDATE" DATE, 
"NINSURED" NUMBER(5,2), 
"NPREMIUM" NUMBER(18,6), 
"NGROUP" NUMBER(5,0), 
"DSTARTDATE" DATE, 
"SCLIENT" CHAR(14 BYTE), 
"NTRANSACTIO" NUMBER(10,0), 
"NUSERCODE_OLD" NUMBER(5,0), 
"NEMPLOYEES" NUMBER(5,0), 
"NUBICATION" NUMBER(5,0), 
"NVIGILANCE" NUMBER(5,0), 
"NSITUATION" NUMBER(5,0), 
"SCOMPLCOD" CHAR(6 BYTE), 
"SDESCBUSSI" CHAR(30 BYTE), 
"NCONSTCAT" NUMBER(5,0), 
"NCODKIND" NUMBER(2,0), 
"NBUSINESSTY" NUMBER(1,0), 
"NCOMMERGRP" NUMBER(3,0), 
"NPAYFREQ" NUMBER(5,0), 
"SPREBILLING" CHAR(1 BYTE),
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
CREATE TABLE "INSUDB"."LIFE_HIS" 
(	"SCERTYPE" CHAR(1 BYTE), 
"NPRODUCT" NUMBER(5,0), 
"NBRANCH" NUMBER(5,0), 
"NPOLICY" NUMBER(10,0), 
"NCERTIF" NUMBER(10,0), 
"DEFFECDATE" DATE, 
"NAGE" NUMBER(5,0), 
"SCLIENT" CHAR(14 BYTE), 
"NAGE_LIMIT" NUMBER(5,0), 
"NAGE_REINSU" NUMBER(5,0), 
"SAMORTI_WAY" CHAR(1 BYTE), 
"NCAPITAL" NUMBER(18,6), 
"NCAPITAL_CA" NUMBER(18,6), 
"DCOMPDATE_OLD" DATE, 
"NEND_NUM" NUMBER(5,0), 
"NENT_RIGHT" NUMBER(5,0), 
"NEXA_AMOUNT" NUMBER(10,0), 
"NEXAM_TYPE" NUMBER(5,0), 
"DEXPIRDAT" DATE, 
"NTYPDURINS" NUMBER(5,0), 
"NINIT_NUM" NUMBER(5,0), 
"NINSUR_TIME" NUMBER(5,0), 
"DISSUEDAT" DATE, 
"SLOAN_NUMBE" CHAR(10 BYTE), 
"NNULLCODE" NUMBER(5,0), 
"DNULLDATE" DATE, 
"NPAY_TIME" NUMBER(5,0), 
"SPDURAIND" CHAR(1 BYTE), 
"NPERMULTI" NUMBER(18,6), 
"NPERNUMAI" NUMBER(18,6), 
"NPERNUNMI" NUMBER(18,6), 
"NPREMIUM" NUMBER(18,6), 
"NPREMIUM_CA" NUMBER(18,6), 
"NRECEIPT" NUMBER(10,0), 
"NSALD_AMOUN" NUMBER(18,6), 
"SSALD_PROG" CHAR(1 BYTE), 
"DSTARTDATE" DATE, 
"NTITLES_SUB" NUMBER(5,0), 
"NUSERCODE_OLD" NUMBER(5,0), 
"NWAR_INT_EX" NUMBER(4,2), 
"NWAR_INTERE" NUMBER(4,2), 
"NXPREM_TIME" NUMBER(5,0), 
"NYEARS_OLD" NUMBER(5,0), 
"NTRANSACTIO" NUMBER(10,0), 
"DPROG_DATE" DATE, 
"NRENTAMOUNT" NUMBER(18,6), 
"NCURRRENT" NUMBER(10,0), 
"SCREDITNUM" CHAR(20 BYTE), 
"NCRED_PRO" NUMBER(5,0), 
"DINIT_CRE" DATE, 
"DEND_CRE" DATE, 
"NCURREN_CRE" NUMBER(5,0), 
"NAMOUNT_CRE" NUMBER(18,6), 
"NAMOUNT_ACT" NUMBER(18,6), 
"NCALCAPITAL" NUMBER(1,0), 
"NTYPPREMIUM" NUMBER(1,0), 
"NCOUNT_INSU" NUMBER(5,0), 
"NGROUP_COMP" NUMBER(5,0), 
"NTARIFF" NUMBER(5,0), 
"NGROUP" NUMBER(5,0), 
"NSITUATION" NUMBER(5,0), 
"SACCNUM" VARCHAR2(20 BYTE), 
"NCAPITALMAX" NUMBER(18,6), 
"NPERC_CAP" NUMBER(9,6), 
"NLEGAMOUNT" NUMBER(18,6), 
"NTYPDURPAY" NUMBER(5,0), 
"DDATE_PAY" DATE, 
"NRATEDESG" NUMBER(9,6), 
"SIDURAIND" CHAR(1 BYTE), 
"NQ_QUOT" NUMBER(3,0), 
"NSAVING_PCT" NUMBER(5,0), 
"NDISC_SAVE_PCT" NUMBER(5,0), 
"NDISC_UNIT_PCT" NUMBER(5,0), 
"NINDEX_TABLE" NUMBER(5,0), 
"NWARRN_TABLE" NUMBER(5,0), 
"NOPTION" NUMBER(5,0), 
"NPREMIUMBAS" NUMBER(18,6), 
"NMODULEC" NUMBER(5,0), 
"NPREMDEAL" NUMBER(18,6), 
"NPREMDEAL_ANU" NUMBER(18,6), 
"NPREMMIN" NUMBER(18,6), 
"NINTWARR" NUMBER(8,6), 
"SPRINTCOV" CHAR(1 BYTE), 
"SFOLIONUMBER" CHAR(10 BYTE), 
"NYEARMONTH_FPAY" NUMBER(6,0), 
"NTAXREGIME" NUMBER(6,0), 
"NCOD_SAAPV" NUMBER(10,0), 
"NINSTITUTION" NUMBER(5,0), 
"NTYPEEXC" NUMBER(5,0), 
"SPREBILLING" CHAR(1 BYTE), 
"SNOANSW" CHAR(1 BYTE), 
"SPREVACC" CHAR(1 BYTE), 
"SYMEDIC" CHAR(1 BYTE), 
"SNEXTHOSP" CHAR(1 BYTE), 
"SRISKACT" CHAR(1 BYTE), 
"SIMC" CHAR(1 BYTE),
"NUSERCODE" NUMBER(5,0),
"DCOMPDATE" TIMESTAMP, 
"NTRANSACTIO_HIS" NUMBER(10,0), 
"SORIGEN_HIS" VARCHAR2(100),
"SACTION_HIS" VARCHAR2(10)
) SEGMENT CREATION IMMEDIATE 
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
STORAGE(INITIAL 11534336 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "DATA0" ;
/
CREATE TABLE "INSUDB"."MULTI_RISK_HIS" 
(	"SCERTYPE" CHAR(1 BYTE), 
"NBRANCH" NUMBER(5,0), 
"NPRODUCT" NUMBER(5,0), 
"NPOLICY" NUMBER(10,0), 
"NCERTIF" NUMBER(10,0), 
"DEFFECDATE" DATE, 
"NCRICODE" NUMBER(5,0), 
"NCOMMER_ACTIVITY" NUMBER(10,0), 
"NARTICLE" NUMBER(5,0), 
"NCAPITAL" NUMBER(18,6), 
"SCATEGORY" CHAR(1 BYTE), 
"NCL_RISK" NUMBER(5,0), 
"DCOMPDATE_OLD" DATE, 
"NDET_RISK" NUMBER(5,0), 
"DEXPIRDAT" DATE, 
"DISSUEDAT" DATE, 
"NNULLCODE" NUMBER(5,0), 
"DNULLDATE" DATE, 
"NPREMIUM" NUMBER(18,6), 
"DSTARTDATE" DATE, 
"NUSERCODE_OLD" NUMBER(5,0), 
"NTRANSACTIO" NUMBER(10,0), 
"NSITUATION" NUMBER(5,0), 
"NGROUP" NUMBER(5,0), 
"SCLIENT" CHAR(14 BYTE), 
"SCOMPLCOD" CHAR(6 BYTE), 
"NCONSTCAT" NUMBER(5,0), 
"NCODKIND" NUMBER(2,0), 
"NPAYFREQ" NUMBER(5,0), 
"NCIIU" NUMBER(10,0), 
"NMETERS" NUMBER(18,6), 
"SPREBILLING" CHAR(1 BYTE), 
"NGRAIN" NUMBER(10,0), 
"NPROTECTION" NUMBER(5,0), 
"SSILOIDENTIFIER" VARCHAR2(30 BYTE), 
"NSEGMENT" NUMBER(5,0), 
"SFIELDNAME" VARCHAR2(30 BYTE), 
"DSTORAGE" DATE, 
"SBENEFITMEASURE" VARCHAR2(30 BYTE), 
"NSTORAGETONS" NUMBER(5,2), 
"NVALUEBYTON" NUMBER(18,6), 
"NFENCE" NUMBER(10,0), 
"NREFVALUE" NUMBER(18,6), 
"SDESCBUSSI" CLOB,
"NUSERCODE" NUMBER(5,0),
"DCOMPDATE" TIMESTAMP, 
"NTRANSACTIO_HIS" NUMBER(10,0), 
"SORIGEN_HIS" VARCHAR2(100),
"SACTION_HIS" VARCHAR2(10)
) SEGMENT CREATION IMMEDIATE 
PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "DATA0" 
LOB ("SDESCBUSSI") STORE AS BASICFILE (
TABLESPACE "DATA0" ENABLE STORAGE IN ROW CHUNK 8192 RETENTION 
NOCACHE LOGGING 
STORAGE(INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
/
CREATE TABLE "INSUDB"."HOMEOWNER_HIS"
 (	"SCERTYPE" CHAR(1 BYTE) NOT NULL ENABLE, 
"NBRANCH" NUMBER(5,0) NOT NULL ENABLE, 
"NPRODUCT" NUMBER(5,0) NOT NULL ENABLE, 
"NPOLICY" NUMBER(10,0) NOT NULL ENABLE, 
"NCERTIF" NUMBER(10,0) NOT NULL ENABLE, 
"DEFFECDATE" DATE NOT NULL ENABLE, 
"DNULLDATE" DATE, 
"NNULLCODE" NUMBER(5,0), 
"SCLIENT" CHAR(14 BYTE), 
"DSTARTDATE" DATE, 
"DEXPIRDAT" DATE, 
"DISSUEDAT" DATE, 
"NPREMIUM" NUMBER(18,6), 
"NTRANSACTIO" NUMBER(10,0), 
"NGROUP" NUMBER(5,0), 
"NSITUATION" NUMBER(5,0), 
"NDWELLINGTYPE" NUMBER(5,0), 
"NOWNERSHIP" NUMBER(5,0), 
"NYEAR_BUILT" NUMBER(4,0), 
"SCOV_PURC" CHAR(1 BYTE), 
"NPRICE_PURCH" NUMBER(18,6), 
"NCURRENCY_PURCH" NUMBER(5,0), 
"DDATE_PURCH" DATE, 
"SPOLICY_OTHER" CHAR(1 BYTE), 
"NCAP_OTHER" NUMBER(12,0), 
"NCURRENCY_OTHER" NUMBER(5,0), 
"DEXPIR_OTHER" DATE, 
"NSWIMPOOL" NUMBER(5,0), 
"SFENCEPOOL" CHAR(1 BYTE), 
"NFENCEHEIGHT" NUMBER(5,0), 
"STRAMPOLINE" CHAR(1 BYTE), 
"SANIMALSIND" CHAR(1 BYTE), 
"SANIMALSDES" VARCHAR2(200 BYTE), 
"SATTACKEDIND" CHAR(1 BYTE), 
"NEXTERCONSTR" NUMBER(5,0), 
"SOTHER_CONSTR" VARCHAR2(60 BYTE), 
"NSTORIES" NUMBER(5,0), 
"NFOUNDTYPE" NUMBER(5,0), 
"NROOFTYPE" NUMBER(5,0), 
"NROOFYEAR" NUMBER(4,0), 
"NHOMESUPER" NUMBER(8,2), 
"NLANDSUPER" NUMBER(8,2), 
"NGARAGE" NUMBER(5,0), 
"NFIREPLACE" NUMBER(5,0), 
"NBEDROOMS" NUMBER(5,0), 
"NFULLBATH" NUMBER(5,0), 
"NHALFBATH" NUMBER(5,0), 
"NALT_HEATING" NUMBER(5,0), 
"NAIRTYPE" NUMBER(5,0), 
"SGAS" CHAR(1 BYTE), 
"SSPRINKSYS" CHAR(1 BYTE), 
"SALARM_COMP" VARCHAR2(60 BYTE), 
"SNON_SMOK" CHAR(1 BYTE), 
"NDIST_FIRE" NUMBER(6,2), 
"SFIREDEPART" VARCHAR2(60 BYTE), 
"NDIST_HYDR" NUMBER(6,2), 
"NFLOODZONE" NUMBER(2,0), 
"SFLOODIND" CHAR(1 BYTE), 
"DCOMPDATE_OLD" DATE, 
"NUSERCODE_OLD" NUMBER(5,0), 
"NCAPITAL" NUMBER(24,6), 
"NPAYFREQ" NUMBER(5,0), 
"NSEISMICZONE" NUMBER(5,0), 
"NCRICODE" NUMBER(5,0), 
"NSQUAREVALUE" NUMBER(18,6), 
"SPREBILLING" CHAR(1 BYTE), 
"SGATEDCOMMUNITY" CHAR(1 BYTE), 
"NPOLHOLDERTYPE" NUMBER(5,0), 
"SSURVEILLANCE" CHAR(1 BYTE), 
"SALARM" CHAR(1 BYTE), 
"SARMOREDDOOR" CHAR(1 BYTE), 
"NPROPOSAL" NUMBER(5,0), 
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
CREATE TABLE "INSUDB"."EQUIPMENT_HIS" 
(	"SCERTYPE" CHAR(1 BYTE), 
"NPRODUCT" NUMBER(5,0), 
"NBRANCH" NUMBER(5,0), 
"NPOLICY" NUMBER(10,0), 
"NCERTIF" NUMBER(10,0), 
"DEFFECDATE" DATE, 
"NCAPITAL" NUMBER(18,6), 
"NPREMIUM" NUMBER(18,6), 
"DCOMPDATE_OLD" DATE, 
"DEXPIRDAT" DATE, 
"DISSUEDAT" DATE, 
"NNULLCODE" NUMBER(5,0), 
"DNULLDATE" DATE, 
"DSTARTDATE" DATE, 
"NUSERCODE_OLD" NUMBER(5,0), 
"NTRANSACTIO" NUMBER(10,0), 
"NSITUATION" NUMBER(5,0), 
"NGROUP" NUMBER(5,0), 
"SCLIENT" CHAR(14 BYTE), 
"NPAYFREQ" NUMBER(5,0), 
"SPREBILLING" CHAR(1 BYTE), 
"NEQUIPMENT" NUMBER(5,0), 
"NBRAND" NUMBER(10,0), 
"SMODEL" CHAR(200 BYTE), 
"NBULITYEAR" NUMBER(4,0), 
"NCURRENCY" NUMBER(10,0), 
"NREFVALUE" NUMBER(18,6), 
"SPATENT" CHAR(40 BYTE), 
"SMOTOR" CHAR(40 BYTE), 
"SCHASSIS" CHAR(40 BYTE), 
"SOBSST" CLOB, 
"NZONE" NUMBER(5,0), 
"SLONA" CHAR(30 BYTE), 
"DEXPIRLEASING" DATE, 
"NCIIU" NUMBER(10,0), 
"NCOMMER_ACTIVITY" NUMBER(10,0), 
"SSUBSCRIBER" CHAR(50 BYTE), 
"NSEGMENT" NUMBER(5,0), 
"NPOLASSOC" NUMBER(30,0), 
"NCOMPANYASSOC" NUMBER(5,0), 
"SLIQTYPE" CHAR(60 BYTE),
"NUSERCODE" NUMBER(5,0),
"DCOMPDATE" TIMESTAMP, 
"NTRANSACTIO_HIS" NUMBER(10,0), 
"SORIGEN_HIS" VARCHAR2(100),
"SACTION_HIS" VARCHAR2(10)
) SEGMENT CREATION IMMEDIATE 
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "DATA0" 
LOB ("SOBSST") STORE AS BASICFILE (
TABLESPACE "DATA0" ENABLE STORAGE IN ROW CHUNK 8192 RETENTION 
NOCACHE LOGGING 
STORAGE(INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
/
