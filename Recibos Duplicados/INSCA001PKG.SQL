create or replace PACKAGE BODY        INSUDB.INSCA001PKG
AS
   R_PRODUCT      REAPRODUCTGENERALPKG.RT1;
   R_PRODUCT_LI   REAPRODUCT_LIPKG.RT1;
   R_POLICY       REAPOLICY_BRANCHPKG.RT1;
   R_CERTIFICAT   REACERTIFICAT_BRANCHPKG.RT1;
   BPOLICY        BOOLEAN;
   BCERTIFICAT    BOOLEAN;
   BPRODUCT       BOOLEAN;
   SCLIENAME      VARCHAR (100);
   DLASTCHANGEA   CERTIFICAT.DCHANGDAT%TYPE;

   FUNCTION GETPOLTRANSAC /*--------------------------------------------------------------------------------------*/
                         /* NOMBRE    : GETPOLTRANSAC                                                            */
                         /* OBJETIVO  : OBTIENE EL TIPO DE ACCION GENERAL SEGUN LA TRANSACCION A EJECUTAR        */
                         /* PARAMETROS:                                                                          */
                         /*             1 - NTANSACTION: TIPO DE ACCION DE LA SECUENCIA A EFECTUAR               */
                         /*             2 - NVALUE     : VALOR A RETORNAR: AGRUPAMIENTO SEGUN ACCION             */
                         /*                                                                                      */
                         /* SOURCESAFE INFORMATION                                                              */
                         /*     $AUTHOR: NVAPLAT28 $*/
                         /*     $DATE: 10/05/04 16.11 $*/
                         /*     $REVISION: 43 $*/
                         /*-------------------------------------------------------------------------------------*/
   (NTRANSACTION TABLE221.NCODIGINT%TYPE)
      RETURN SMALLINT
   AS
      NVALUE   SMALLINT;
   BEGIN
      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYISSUE,
             INSGENERALPKG.NCERTIFISSUE,
             INSGENERALPKG.NRECUPERATION,
             INSGENERALPKG.NPOLICYREISSUE,
             INSGENERALPKG.NCERTIFREISSUE,
             INSGENERALPKG.NPOLICYQUOTATION,
             INSGENERALPKG.NCERTIFQUOTATION,
             INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NCERTIFPROPOSAL,
             INSGENERALPKG.NDUPLICATEDPOLICY)
      THEN
         NVALUE := INSGENERALPKG.NISSUE;
      ELSIF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYQUERY,
                INSGENERALPKG.NCERTIFQUERY,
                INSGENERALPKG.NQUOTATIONQUERY,
                INSGENERALPKG.NPROPOSALQUERY,
                INSGENERALPKG.NQUOTAMENDENTQUERY,
                INSGENERALPKG.NPROPAMENDENTQUERY,
                INSGENERALPKG.NQUOTRENEWALQUERY,
                INSGENERALPKG.NPROPRENEWALQUERY)
      THEN
         NVALUE := INSGENERALPKG.NQUERY;
      ELSIF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYAMENDMENT,
                INSGENERALPKG.NTEMPPOLICYAMENDMENT,
                INSGENERALPKG.NCERTIFAMENDMENT,
                INSGENERALPKG.NTEMPCERTIFAMENDMENT)
      THEN
         NVALUE := INSGENERALPKG.NAMEND;
      ELSIF NTRANSACTION IN
               (INSGENERALPKG.NQUOTATIONCONVERTION,
                INSGENERALPKG.NPROPOSALCONVERTION,
                INSGENERALPKG.NPROPQUOTCONVERTION,
                INSGENERALPKG.NQUOTAMENDCONVERTION,
                INSGENERALPKG.NPROPAMENDCONVERTION,
                INSGENERALPKG.NQUOTRENEWALCONVERTION,
                INSGENERALPKG.NPROPRENEWALCONVERTION,
                INSGENERALPKG.NQUOTPROPAMENDENTCONVERTION,
                INSGENERALPKG.NQUOTPROPRENEWALCONVERTION)
      THEN
         NVALUE := INSGENERALPKG.NCONVERT;
      ELSIF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYQUOTAMENDENT,
                INSGENERALPKG.NCERTIFQUOTAMENDENT,
                INSGENERALPKG.NPOLICYPROPAMENDENT,
                INSGENERALPKG.NCERTIFPROPAMENDENT,
                INSGENERALPKG.NPOLICYQUOTRENEWAL,
                INSGENERALPKG.NCERTIFQUOTRENEWAL,
                INSGENERALPKG.NPOLICYPROPRENEWAL,
                INSGENERALPKG.NCERTIFPROPRENEWAL)
      THEN
         NVALUE := INSGENERALPKG.NAMENDPROPQUOT;
      ELSE
         NVALUE := NTRANSACTION;
      END IF;

      RETURN NVALUE;
   END GETPOLTRANSAC;

   FUNCTION GETPOLCERTYPE /*--------------------------------------------------------------------------------------*/
                         /* NOMBRE    : GETPOLCERTYPE                                                            */
                         /* OBJETIVO  : OBTIENE EL TIPO DE POLIZA A TRATAR SEGUN LA ACCION                       */
                         /* PARAMETROS:                                                                          */
                         /*             1 - NTANSACTION: TIPO DE ACCION DE LA SECUENCIA A EFECTUAR               */
                         /*             2 - SVALUE     : VALOR A RETORNAR: AGRUPAMIENTO SEGUN ACCION             */
                         /*                                                                                      */
                         /* SOURCESAFE INFORMATION                                                              */
                         /*     $AUTHOR: NVAPLAT28 $*/
                         /*     $DATE: 10/05/04 16.11 $*/
                         /*     $REVISION: 43 $*/
                         /*-------------------------------------------------------------------------------------*/
   (NTRANSACTION TABLE221.NCODIGINT%TYPE)
      RETURN CHAR
   AS
      SVALUE   CHAR;
   BEGIN
      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NCERTIFPROPOSAL,
             INSGENERALPKG.NPROPOSALQUERY,
             INSGENERALPKG.NPROPOSALCONVERTION)
      THEN
         SVALUE := INSGENERALPKG.SPROPOSAL;
      ELSIF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYISSUE,
                INSGENERALPKG.NCERTIFISSUE,
                INSGENERALPKG.NRECUPERATION,
                INSGENERALPKG.NPOLICYQUERY,
                INSGENERALPKG.NCERTIFQUERY,
                INSGENERALPKG.NPOLICYAMENDMENT,
                INSGENERALPKG.NTEMPPOLICYAMENDMENT,
                INSGENERALPKG.NCERTIFAMENDMENT,
                INSGENERALPKG.NTEMPCERTIFAMENDMENT,
                INSGENERALPKG.NPOLICYREISSUE,
                INSGENERALPKG.NCERTIFREISSUE,
                INSGENERALPKG.NREPRINT,
                INSGENERALPKG.NDECLARATIONS,
                INSGENERALPKG.NCOVERNOTE,
                INSGENERALPKG.NCERTIFQUOTAMENDENT,
                INSGENERALPKG.NQUOTAMENDCONVERTION,
                INSGENERALPKG.NQUOTPROPAMENDENTCONVERTION,
                INSGENERALPKG.NQUOTAMENDENTQUERY,
                INSGENERALPKG.NPOLICYQUOTRENEWAL,
                INSGENERALPKG.NCERTIFQUOTRENEWAL,
                INSGENERALPKG.NQUOTRENEWALCONVERTION,
                INSGENERALPKG.NQUOTPROPRENEWALCONVERTION,
                INSGENERALPKG.NQUOTRENEWALQUERY,
                INSGENERALPKG.NPOLICYPROPAMENDENT,
                INSGENERALPKG.NCERTIFPROPAMENDENT,
                INSGENERALPKG.NPROPAMENDCONVERTION,
                INSGENERALPKG.NPROPAMENDENTQUERY,
                INSGENERALPKG.NPOLICYPROPRENEWAL,
                INSGENERALPKG.NCERTIFPROPRENEWAL,
                INSGENERALPKG.NPROPRENEWALCONVERTION,
                INSGENERALPKG.NPROPRENEWALQUERY)
      THEN
         SVALUE := INSGENERALPKG.SPOLICY;
      ELSIF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYQUOTATION,
                INSGENERALPKG.NCERTIFQUOTATION,
                INSGENERALPKG.NQUOTATIONQUERY,
                INSGENERALPKG.NQUOTATIONCONVERTION,
                INSGENERALPKG.NPROPQUOTCONVERTION)
      THEN
         SVALUE := INSGENERALPKG.SQUOTATION;
      ELSE
         SVALUE := INSGENERALPKG.SPOLICY;
      END IF;

      RETURN SVALUE;
   END GETPOLCERTYPE;

   FUNCTION GETPROPQUOTCERTYPE /*--------------------------------------------------------------------------------------*/
                              /* NOMBRE    : GETPROPQUOTCERTYPE                                                       */
                              /* OBJETIVO  : OBTIENE EL VALOR SCERTYPE SEGUN LA TRANSACCION                           */
                              /* PARAMETROS:                                                                          */
                              /*             1 - NTANSACTION: TIPO DE ACCION DE LA SECUENCIA A EFECTUAR               */
                              /*             2 - SVALUE     : VALOR A RETORNAR: AGRUPAMIENTO SEGUN ACCION             */
                              /*                                                                                      */
                              /* SOURCESAFE INFORMATION                                                              */
                              /*     $AUTHOR: NVAPLAT28 $*/
                              /*     $DATE: 10/05/04 16.11 $*/
                              /*     $REVISION: 43 $*/
                              /*-------------------------------------------------------------------------------------*/
   (NTRANSACTION TABLE221.NCODIGINT%TYPE)
      RETURN CHAR
   AS
      SVALUE   CHAR;
   BEGIN
      IF NTRANSACTION IN
            (INSGENERALPKG.NCERTIFQUOTAMENDENT,
             INSGENERALPKG.NQUOTAMENDCONVERTION,
             INSGENERALPKG.NQUOTPROPAMENDENTCONVERTION,
             INSGENERALPKG.NQUOTAMENDENTQUERY)
      THEN
         SVALUE := INSGENERALPKG.SAMENDQUOT;
      ELSIF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYQUOTRENEWAL,
                INSGENERALPKG.NCERTIFQUOTRENEWAL,
                INSGENERALPKG.NQUOTRENEWALCONVERTION,
                INSGENERALPKG.NQUOTPROPRENEWALCONVERTION,
                INSGENERALPKG.NQUOTRENEWALQUERY)
      THEN
         SVALUE := INSGENERALPKG.SRENEWALQUOT;
      ELSIF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYPROPAMENDENT,
                INSGENERALPKG.NCERTIFPROPAMENDENT,
                INSGENERALPKG.NPROPAMENDCONVERTION,
                INSGENERALPKG.NPROPAMENDENTQUERY)
      THEN
         SVALUE := INSGENERALPKG.SAMENDPROPOSAL;
      ELSIF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYPROPRENEWAL,
                INSGENERALPKG.NCERTIFPROPRENEWAL,
                INSGENERALPKG.NPROPRENEWALCONVERTION,
                INSGENERALPKG.NPROPRENEWALQUERY)
      THEN
         SVALUE := INSGENERALPKG.SRENEWALPROPOSAL;
      ELSIF NTRANSACTION IN (INSGENERALPKG.NQUOTATIONCONVERTION)
      THEN
         SVALUE := INSGENERALPKG.SQUOTATION;
      ELSIF NTRANSACTION IN (INSGENERALPKG.NPROPOSALCONVERTION)
      THEN
         SVALUE := INSGENERALPKG.SPROPOSAL;
      ELSE
         SVALUE := INSGENERALPKG.SPOLICY;
      END IF;

      RETURN SVALUE;
   END GETPROPQUOTCERTYPE;

   FUNCTION POLICYISNEED /*--------------------------------------------------------------------------------------*/
                        /* NOMBRE    : POLICYISNEED                                                             */
                        /* OBJETIVO  : INDICA SI EL CAMPO POLIZA ES OBLIGATORIO SEGUN LA TRANSACCION            */
                        /* PARAMETROS:                                                                          */
                        /*             1 - NTANSACTION: TIPO DE ACCION DE LA SECUENCIA A EFECTUAR               */
                        /*             2 - NVALUE     : VALOR A RETORNAR: 1)TRUE 2)FALSE                        */
                        /*                                                                                      */
                        /* SOURCESAFE INFORMATION                                                              */
                        /*     $AUTHOR: NVAPLAT28 $*/
                        /*     $DATE: 10/05/04 16.11 $*/
                        /*     $REVISION: 43 $*/
                        /*-------------------------------------------------------------------------------------*/
   (NTRANSACTION TABLE221.NCODIGINT%TYPE)
      RETURN SMALLINT
   AS
      NVALUE   SMALLINT;
   BEGIN
      IF NTRANSACTION IN
            (INSGENERALPKG.NCERTIFISSUE,
             INSGENERALPKG.NRECUPERATION,
             INSGENERALPKG.NPOLICYREISSUE,
             INSGENERALPKG.NCERTIFREISSUE,
             INSGENERALPKG.NCERTIFQUOTATION,
             INSGENERALPKG.NCERTIFPROPOSAL,
             INSGENERALPKG.NPOLICYQUERY,
             INSGENERALPKG.NCERTIFQUERY,
             INSGENERALPKG.NQUOTATIONQUERY,
             INSGENERALPKG.NPROPOSALQUERY,
             INSGENERALPKG.NQUOTAMENDENTQUERY,
             INSGENERALPKG.NPROPAMENDENTQUERY,
             INSGENERALPKG.NQUOTRENEWALQUERY,
             INSGENERALPKG.NPROPRENEWALQUERY,
             INSGENERALPKG.NPOLICYAMENDMENT,
             INSGENERALPKG.NTEMPPOLICYAMENDMENT,
             INSGENERALPKG.NCERTIFAMENDMENT,
             INSGENERALPKG.NTEMPCERTIFAMENDMENT,
             INSGENERALPKG.NQUOTATIONCONVERTION,
             INSGENERALPKG.NPROPOSALCONVERTION,
             INSGENERALPKG.NPROPQUOTCONVERTION,
             INSGENERALPKG.NQUOTAMENDCONVERTION,
             INSGENERALPKG.NPROPAMENDCONVERTION,
             INSGENERALPKG.NQUOTRENEWALCONVERTION,
             INSGENERALPKG.NPROPRENEWALCONVERTION,
             INSGENERALPKG.NQUOTPROPAMENDENTCONVERTION,
             INSGENERALPKG.NQUOTPROPRENEWALCONVERTION,
             INSGENERALPKG.NPOLICYQUOTAMENDENT,
             INSGENERALPKG.NCERTIFQUOTAMENDENT,
             INSGENERALPKG.NPOLICYPROPAMENDENT,
             INSGENERALPKG.NCERTIFPROPAMENDENT,
             INSGENERALPKG.NPOLICYQUOTRENEWAL,
             INSGENERALPKG.NCERTIFQUOTRENEWAL,
             INSGENERALPKG.NPOLICYPROPRENEWAL,
             INSGENERALPKG.NCERTIFPROPRENEWAL,
             INSGENERALPKG.NPROPREHABILITATE,
             INSGENERALPKG.NMODPROPREHABQUERY)
      THEN
         NVALUE := 1;
      ELSE
         NVALUE := 2;
      END IF;

      RETURN NVALUE;
   END POLICYISNEED;

   FUNCTION CERTIFISNEED /*--------------------------------------------------------------------------------------*/
                        /* NOMBRE    : CERTIFISNEED                                                             */
                        /* OBJETIVO  : INDICA SI EL CAMPO POLIZA ES OBLIGATORIO SEGUN LA TRANSACCION            */
                        /* PARAMETROS:                                                                          */
                        /*             1 - NTANSACTION: TIPO DE ACCION DE LA SECUENCIA A EFECTUAR               */
                        /*             2 - NVALUE     : VALOR A RETORNAR: 1)TRUE 2)FALSE                        */
                        /*                                                                                      */
                        /* SOURCESAFE INFORMATION                                                              */
                        /*     $AUTHOR: NVAPLAT28 $*/
                        /*     $DATE: 10/05/04 16.11 $*/
                        /*     $REVISION: 43 $*/
                        /*-------------------------------------------------------------------------------------*/
   (NTRANSACTION TABLE221.NCODIGINT%TYPE)
      RETURN SMALLINT
   AS
      NVALUE   SMALLINT;
   BEGIN
      IF NTRANSACTION IN
            (INSGENERALPKG.NCERTIFREISSUE,
             INSGENERALPKG.NCERTIFQUERY,
             INSGENERALPKG.NCERTIFAMENDMENT,
             INSGENERALPKG.NTEMPCERTIFAMENDMENT,
             INSGENERALPKG.NCERTIFQUOTAMENDENT,
             INSGENERALPKG.NCERTIFPROPAMENDENT,
             INSGENERALPKG.NCERTIFQUOTRENEWAL,
             INSGENERALPKG.NCERTIFPROPRENEWAL,
             INSGENERALPKG.NTRANSHOLDER)
      THEN
         NVALUE := 1;
      ELSE
         NVALUE := 2;
      END IF;

      RETURN NVALUE;
   END CERTIFISNEED;

   FUNCTION PROPQUOTISNEED /*--------------------------------------------------------------------------------------*/
                          /* NOMBRE    : PROPQUOTISNEED                                                             */
                          /* OBJETIVO  : INDICA SI EL CAMPO POLIZA ES OBLIGATORIO SEGUN LA TRANSACCION            */
                          /* PARAMETROS:                                                                          */
                          /*             1 - NTANSACTION: TIPO DE ACCION DE LA SECUENCIA A EFECTUAR               */
                          /*             2 - NVALUE     : VALOR A RETORNAR: 1)TRUE 2)FALSE                        */
                          /*                                                                                      */
                          /* SOURCESAFE INFORMATION                                                               */
                          /*     $AUTHOR: NVAPLAT19 $*/
                          /*     $DATE: 27/06/03 9:07A $*/
                          /*     $REVISION: 1 $*/
                          /*-------------------------------------------------------------------------------------*/
   (NTRANSACTION TABLE221.NCODIGINT%TYPE)
      RETURN SMALLINT
   AS
      NVALUE   SMALLINT;
   BEGIN
      IF NTRANSACTION IN
            (INSGENERALPKG.NQUOTAMENDCONVERTION,
             INSGENERALPKG.NQUOTPROPAMENDENTCONVERTION,
             INSGENERALPKG.NQUOTAMENDENTQUERY,
             INSGENERALPKG.NQUOTRENEWALCONVERTION,
             INSGENERALPKG.NQUOTPROPRENEWALCONVERTION,
             INSGENERALPKG.NQUOTRENEWALQUERY,
             INSGENERALPKG.NPROPAMENDCONVERTION,
             INSGENERALPKG.NPROPAMENDENTQUERY,
             INSGENERALPKG.NPROPRENEWALCONVERTION,
             INSGENERALPKG.NPROPRENEWALQUERY,
             INSGENERALPKG.NMODPROPREHABQUERY)
      THEN
         NVALUE := 1;
      ELSE
         NVALUE := 2;
      END IF;

      RETURN NVALUE;
   END PROPQUOTISNEED;

   FUNCTION INSVALSTATUSPOL /*--------------------------------------------------------------------------------------*/
                           /* NOMBRE    : INSVALSTATUSPOL                                                          */
                           /* OBJETIVO  : VALIDA EL ESTADO ACTUAL DE LA POLIZA                                     */
                           /* PARAMETROS:                                                                          */
                           /*             1 - NTANSACTION: TIPO DE ACCION DE LA SECUENCIA A EFECTUAR               */
                           /*             2 - NVALUE     : VALOR A RETORNAR: 1)TRUE 2)FALSE                        */
                           /*                                                                                      */
                           /* SOURCESAFE INFORMATION                                                              */
                           /*     $AUTHOR: NVAPLAT28 $*/
                           /*     $DATE: 10/05/04 16.11 $*/
                           /*     $REVISION: 43 $*/
                           /*-------------------------------------------------------------------------------------*/
   (SCERTYPE        CERTIFICAT.SCERTYPE%TYPE,
    NBRANCH         CERTIFICAT.NBRANCH%TYPE,
    NPRODUCT        CERTIFICAT.NPRODUCT%TYPE,
    NPOLICY         CERTIFICAT.NPOLICY%TYPE,
    NCERTIF         CERTIFICAT.NCERTIF%TYPE,
    NTRANSACTION    TABLE221.NCODIGINT%TYPE,
    NGENTRANSAC     SMALLINT,
    SSTATUSVA       CERTIFICAT.SSTATUSVA%TYPE)
      RETURN NUMBER
   AS
      NVALUE    NUMBER;
      NEXISTS   SMALLINT;
   BEGIN
      /*+ SI LA POLIZA ESTA SALDADA O PRORROGADA ENTONCES SOLAMENTE PUEDE SER CONSULTADA */
      IF SSTATUSVA = '7'
         AND NGENTRANSAC NOT IN
                (INSGENERALPKG.NQUERY,
                 INSGENERALPKG.NPROPREHABILITATE,
                 INSGENERALPKG.NMODPROPREHABQUERY)
      THEN
         NVALUE := 3971;
      /*+ SI LA TRANSACCION ES RECUPERACION SE VALIDA QUE LA POLIZA/CERTIFICADO ESTE INCOMPLETA */
      ELSIF NTRANSACTION = INSGENERALPKG.NRECUPERATION
      THEN
         IF SSTATUSVA <> '3'
         THEN
            IF NCERTIF = 0
            THEN
               NVALUE := 3004;
            ELSE
               NVALUE := 3007;
            END IF;
         END IF;

         IF SSTATUSVA <> '6' AND SSTATUSVA <> '7' AND SSTATUSVA <> '8'
         THEN
            REAPOLICY_HIS_AVMOV (SCERTYPE   => SCERTYPE,
                                 NBRANCH    => NBRANCH,
                                 NPRODUCT   => NPRODUCT,
                                 NPOLICY    => NPOLICY,
                                 NCERTIF    => NCERTIF,
                                 NEXIST     => NEXISTS);
         /*+ SI EXISTE INFORMACION */
         --             IF NEXISTS != 0 THEN
         --                 IF NCERTIF = 0 THEN
         --                     NVALUE := 3267;
         --                 ELSE
         --                     NVALUE := 3266;
         --                 END IF;
         --             END IF;
         END IF;
      /*+ SI LA TRANSACCION ES MODIFICACION O RE-EMISION SE VALIDA QUE LA POLIZA/CERTIFICADO ESTE VALIDA */
      ELSIF NGENTRANSAC IN
               (INSGENERALPKG.NAMEND, INSGENERALPKG.NAMENDPROPQUOT)
            OR NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYREISSUE,
                   INSGENERALPKG.NCERTIFREISSUE,
                   INSGENERALPKG.NPOLICYQUERY,
                   INSGENERALPKG.NCERTIFQUERY)
      THEN
         IF SSTATUSVA <> '1' AND SSTATUSVA <> '4' AND SSTATUSVA <> '5'
         THEN
            /*+ SE VALIDA SI LA POLIZA/CERTIFICADO ESTA ANULADO */
            IF SSTATUSVA = '6'
            THEN
               IF NCERTIF = 0
               THEN
                  NVALUE := 3098;
               ELSE
                  NVALUE := 3099;
               END IF;
            ELSE
               IF NCERTIF = 0
               THEN
                  NVALUE := 3720;
               ELSE
                  NVALUE := 3723;
               END IF;
            END IF;
         ELSE
            /*+ SI LA TRANSACCION ES RE-EMISION SE VALIDA QUE LA POLIZA NO TENGA MOVIMIENTOS POSTERIORES A LA EMISION */
            IF NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYREISSUE, INSGENERALPKG.NCERTIFREISSUE)
            THEN
               REAPOLICY_HIS_AV (SCERTYPE   => SCERTYPE,
                                 NBRANCH    => NBRANCH,
                                 NPRODUCT   => NPRODUCT,
                                 NPOLICY    => NPOLICY,
                                 NCERTIF    => NCERTIF,
                                 NEXIST     => NEXISTS);

               /*+ SI EXISTE INFORMACION */
               IF NEXISTS != 0
               THEN
                  IF NCERTIF = 0
                  THEN
                     NVALUE := 3267;
                  --                     ELSE
                  --                         NVALUE := 3266;
                  END IF;
               END IF;
            END IF;
         END IF;
      /*+ SI ES REIMPRESION SE VALIDA QUE LA POLIZA ESTE IMPRESA */
      ELSIF NTRANSACTION = INSGENERALPKG.NREPRINT
      THEN
         IF SSTATUSVA <> '1' AND SSTATUSVA <> '5'
         THEN
            NVALUE := 3988;
         END IF;
      END IF;

      RETURN NVALUE;
   END INSVALSTATUSPOL;

PROCEDURE INSVALCA001   
/*--------------------------------------------------------------------------------------*/
/* NOMBRE    : INSVALCA001                                                              */
/* OBJETIVO  : EJECUTA LAS VALIDACIONES DE LA CA001                                     */
/* PARAMETROS:                                                                          */
/*             1 - NTRANSACTION: TRANSACCION A EFECTUAR EN LA EMISION                   */
/*             2 - DEFFECDATE : FECHA DE EFECTO DEL REGISTRO                            */
/*             3 - NOFFICE    : CODIGO DE LA OFICINA                                    */
/*             4 - NBRANCH    : CODIGO DEL RAMO COMERCIAL                               */
/*             5 - NPRODUCT   : CODIGO DEL PRODUCTO                                     */
/*             6 - NPOLICY    : NUMERO IDENTIFICATIVO DE LA POLIZA/COTIZACION/PROPUESTA */
/*             6 - NPOLICYDEST  NUMERO DE POLIZA DESTINO (TRANSAC: TRASPASO DE ASEG)    */
/*             7 - NCERTIF    : NUMERO DEL CERTIFICADO                                  */
/*             8 - SPOLITYPE  : TIPO DE POLIZA  A TRATAR                                */
/*             9 - DLEDGERDATE: FECHA DE CONTABILIZACION                                */
/*            10 - NUSERCODE  : CODIGO DEL USUARIO                                      */
/*            11 - DEXPDATE   : FECHA DE EXPIRACION                                     */
/*            12 - NAGENCY    : CODIGO DE LA AGENCIA                                    */
/*            13 - NOFFICEAGEN: CODIGO DE LA AGENCIA DE LA SUCURSAL                     */
/*            14 - NSELLCHANNEL: CODIGO DEL CANAL DE VENTA                              */
/*            15 - NTYPE_AMEND: CODIGO DEL TIPO DE ENDOSO                               */
/*            16 - NSERV_ORDER: NUMERO DE LA INSPECCION ASOCIADA AL MOVIMIENTO          */
/*            17 - NPROPQUOT  : NUMERO DE POLIZA A LA QUE PERTENECE LA COTIZACION       */
/*            18 - NDIGIT     : DIGITO VERIFICADOR DE POLIZA                            */
/*            19 - NPROP_REG  : NUMERO DE PROPUESTA REGULARIZADA QUE DA ORIGEN PROPUESTA*/
/*            20 - ARRAYERRORS: ERRORES GENERADOS                                       */
/*                                                                                      */
/* SOURCESAFE INFORMATION                                                              */
/*     $AUTHOR: NVAPLAT28 $*/
/*     $DATE: 10/05/04 16.11 $*/
/*     $REVISION: 43 $*/
/*-------------------------------------------------------------------------------------*/
   (NTRANSACTION           TABLE221.NCODIGINT%TYPE,
    DEFFECDATE             POLICY.DCOMPDATE%TYPE,
    NOFFICE                POLICY.NOFFICE%TYPE,
    NBRANCH                POLICY.NBRANCH%TYPE,
    NPRODUCT               POLICY.NPRODUCT%TYPE,
    NPOLICY                POLICY.NPOLICY%TYPE,
    NPOLICYDEST            POLICY.NPOLICY%TYPE,
    NCERTIF                CERTIFICAT.NCERTIF%TYPE,
    SPOLITYPE              POLICY.SPOLITYPE%TYPE,
    DLEDGERDATE            POLICY.DCOMPDATE%TYPE,
    NUSERCODE              POLICY.NUSERCODE%TYPE,
    DEXPDATE               POLICY.DCOMPDATE%TYPE,
    NAGENCY                POLICY.NAGENCY%TYPE,
    NOFFICEAGEN            POLICY.NOFFICEAGEN%TYPE,
    NSELLCHANNEL           CERTIFICAT.NSELLCHANNEL%TYPE,
    NTYPE_AMEND            POLICY_HIS.NTYPE_AMEND%TYPE,
    NSERV_ORDER            POLICY_HIS.NSERV_ORDER%TYPE,
    NPROPQUOT              CERTIFICAT.NPOL_QUOT%TYPE,
    NDIGIT                 CERTIFICAT.NDIGIT%TYPE,
    NPROP_REG              CERTIFICAT.NPROP_REG%TYPE,
    NFOLIO                 CERTIFICAT.NFOLIO%TYPE,
    NCOD_SAAPV_AUX         SAAPV.NCOD_SAAPV%TYPE DEFAULT NULL,
    NINSTITUTION_AUX       SAAPV.NINSTITUTION%TYPE DEFAULT NULL,
    ARRAYERRORS        OUT VARCHAR2,
    NCAUSE_AMEND           POLICY_HIS.NCAUSE_AMEND%TYPE DEFAULT NULL)
   AS
      SERRORS               VARCHAR2 (4000);
      BERRORS               BOOLEAN := FALSE;
      NCOUNT                INTEGER;
      NGENTRANSAC           SMALLINT;
      SSEL                  VARCHAR2 (2000);

      /*- DECLARACION DEL CURSOR */
      C_REATYPE_HIST        REAPOLICY_HIS_1PKG.RCT1;
      R_REATYPE_HIST        C_REATYPE_HIST%ROWTYPE;

      C_PRODUCT_GE          REAPRODUCTGENERALPKG.RCT1;
      R_PRODUCT_GE          C_PRODUCT_GE%ROWTYPE;

      C_POLICY              REAPOLICY_BRANCHPKG.RCT1;
      R_POLICY              C_POLICY%ROWTYPE;
      R_POLICYDEST          C_POLICY%ROWTYPE;

      C_CERTIFICAT          REACERTIFICAT_BRANCHPKG.RCT1;
      C_CERTIFICATQUOT      REACERTIFICAT_BRANCHPKG.RCT1;
      R_CERTIFICAT          C_CERTIFICAT%ROWTYPE;
      R_CERTIFICATQUOT      C_CERTIFICAT%ROWTYPE;

      C_CERQUOT             REACERTIFICAT_BRANCHPKG.RCT1;
      R_CERQUOT             C_CERQUOT%ROWTYPE;

      C_USERS               REAUSERSPKG.RCT1;
      R_USERS               C_USERS%ROWTYPE;

      C_TAB_WAIPO           REATAB_WAITPOPKG.RCT1;
      R_TAB_WAIPO           C_TAB_WAIPO%ROWTYPE;

      C_TYPE_AMEND          REATYPE_AMENDPKG.RCT1;
      R_TYPE_AMEND          C_TYPE_AMEND%ROWTYPE;

      C_PROF_ORD            REAPROF_ORD_OPKG.RCT1;
      R_PROF_ORD            C_PROF_ORD%ROWTYPE;

      C_LEDGER              REALEDGERPKG.RCT1;
      R_LEDGER              C_LEDGER%ROWTYPE;

      C_CTROL_DATE          REACTROL_DATEPKG.RCT1;
      R_CTROL_DATE          C_CTROL_DATE%ROWTYPE;

      C_ACCOUNT_POL         REAACCOUNT_POLPKG.RCT1;
      R_ACCOUNT_POL         C_ACCOUNT_POL%ROWTYPE;

      C_PREMIUM             REAPROPQUOTPREMIUMPKG.RCT1;
      R_PREMIUM             C_PREMIUM%ROWTYPE;

      C_CERTIF_QUOT         REAPOLICY_QUOTPROPPKG.RCT1;
      R_CERTIF_QUOT         C_CERTIF_QUOT%ROWTYPE;

      C_SUSPEND             REASUSPENDPKG.RCT1;
      R_SUSPEND             C_SUSPEND%ROWTYPE;

      C_POLICY_HIS          REAPOLICY_HIS_1PKG.RCT1;
      R_POLICY_HIS          C_POLICY_HIS%ROWTYPE;

      BOK                   BOOLEAN := FALSE;
      BFOUND                BOOLEAN := FALSE;
      BLIFE                 BOOLEAN := FALSE;
      BNEEDPOLICY           BOOLEAN := FALSE;
      BFOUNDPOLICY          BOOLEAN := FALSE;
      BFOUNDPOLDEST         BOOLEAN := FALSE;
      BNEEDCERTIF           BOOLEAN := FALSE;
      BFOUNDCERTIF          BOOLEAN := FALSE;
      BNEEDPROPQUOT         BOOLEAN := FALSE;

      SPROPQUOTCERT         CHAR;
      BFOUNDPROPQUOT        BOOLEAN := FALSE;

      NERRORNUM             NUMBER;

      SIND_ORDER_SERV       CHAR;
      SPOLCERTYPE           CHAR;
      SWITCHE               CHAR;

      NPROPONUM_AUX         CERTIFICAT.NPROPONUM%TYPE;

      NFIRSTPREMIUM         PREMIUM.NPREMIUM%TYPE;
      NPREMPROP             PREMIUM.NPREMIUM%TYPE;
      STYPE                 USERS.STYPE%TYPE;

      SQUOTPROP_AUX         VARCHAR2 (200);

      NEXISTS               SMALLINT;

      NCERTIF_AUX           CERTIFICAT.NCERTIF%TYPE;

      SERRORS_AUX           VARCHAR2 (300);

      TYPE T_PREMIUM_STAT IS REF CURSOR;

      C_PREMIUM_STAT        T_PREMIUM_STAT;
      NPREMIUM_AUX          PREMIUM.NPREMIUM%TYPE;
      NSTATUS_PRE_AUX       PREMIUM.NSTATUS_PRE%TYPE;
      NCONTRAT_AUX          PREMIUM.NCONTRAT%TYPE;
      NPAYPREMIUM           CHAR (1) DEFAULT 1;
      NCOUNT_AUX            NUMBER;
      NPROPQUOT_AUX         CERTIFICAT.NPOL_QUOT%TYPE;
      SSTATUSVA             CERTIFICAT.SSTATUSVA%TYPE;
      NBULLETINS_AUX        BULLETINS.NBULLETINS%TYPE;
      DEFFECDATE_AUX        POLICY_HIS.DEFFECDATE%TYPE;
      COUNT_NORIGIN         NUMBER (10);
      /*- VARIABLE UTILIZADAS EN LAS VALIDACIONES DE PROPUESTAS DE REGULARIZACION */

      NCOUNT_PREG           NUMBER (5);
      NSTATQUOTA_PREG       CERTIFICAT.NSTATQUOTA%TYPE;
      NNO_CONVERS_PREG      CERTIFICAT.NNO_CONVERS%TYPE;
      NPRODCLAS             PRODUCT_LI.NPRODCLAS%TYPE;
      SCLIENT               CLIENT.SCLIENT%TYPE;
      NLOWER_LIM            OPT_PREMIU.NLOWER_LIM%TYPE;
      SQUOTNUMAUTO          OPT_SYSTEM.SQUOTNUMAUTO%TYPE;
      NCOUNT_VAL            NUMBER;

      DNEXTRECEIP_AUX       CERTIFICAT.DNEXTRECEIP%TYPE;
      NINTERMED_AUX         INTERMEDIA.NINTERMED%TYPE;
      NINTERMED_POL         INTERMEDIA.NINTERMED%TYPE;

      NCOUNT_DLEDGER        NUMBER;
      SAPV                  PRODUCT_LI.SAPV%TYPE;
      NCOD_SAAPV            LIFE.NCOD_SAAPV%TYPE;
      NINSTITUTION          LIFE.NINSTITUTION%TYPE;
      DLASTPROC             DATE;

      /*- SE DECLARA LA VARIABLE QUE DETERMINA SI EXISTE EL NUMERADOR PARA POLIZAS POR RAMO.*/
      STOO_SELCNT           INTEGER;

      /*+ SE DECLARA LA VARIABLE QUE DETERMINA SI LA PÓLIZA ES PROVENIENTE DE TRASPASO*/
      NPOLICY_TRANSFER      INTEGER;
      DEFFECDATE_TRANSFER   DATE;
      DNEXTMONTHLY          DATE;

      /*+ SE DECLARA LA VARIABLE QUE DETERMINA ESTADO DEL CERTIFICADO*/
      NCERSTATUS            NUMBER;
   BEGIN
      BEGIN
         SELECT                         /*+ INDEX (PRODUCT_LI XPKPRODUCT_LI)*/
               NPRODCLAS, NVL (SAPV, '2')
           INTO NPRODCLAS, SAPV
           FROM PRODUCT_LI
          WHERE     NBRANCH = INSVALCA001.NBRANCH
                AND NPRODUCT = INSVALCA001.NPRODUCT
                AND DEFFECDATE <= INSVALCA001.DEFFECDATE
                AND (DNULLDATE IS NULL OR DNULLDATE > INSVALCA001.DEFFECDATE);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      NCERTIF_AUX := NCERTIF;

      NGENTRANSAC := GETPOLTRANSAC (NTRANSACTION);

      IF NTRANSACTION IS NULL
      THEN
         SERRORS := SERRORS || INSGENERALPKG.SSEP || '3786';
         BERRORS := TRUE;
      END IF;

      /*+ SE VALIDA QUE SE INDIQUE LA FECHA DE LA TRANSACCION */
      IF DEFFECDATE IS NULL
      THEN
         SERRORS := SERRORS || INSGENERALPKG.SSEP || '4003';
         BERRORS := TRUE;
      ELSE
         BEGIN
            SELECT CERT_STAT.NFACESTATUS
              INTO NCERSTATUS
              FROM CERT_STATUS CERT_STAT
             WHERE     CERT_STAT.NBRANCH = INSVALCA001.NBRANCH
                   AND CERT_STAT.NPRODUCT = INSVALCA001.NPRODUCT
                   AND CERT_STAT.NCERTIF = INSVALCA001.NCERTIF
                   AND CERT_STAT.NPOLICY = INSVALCA001.NPOLICY;
         EXCEPTION
            WHEN OTHERS
            THEN
               NCERSTATUS := 0;
         END;


         /*+ SE VERIFICA QUE EL CERTIFICADO NO SE ENCUENTRE SUSPENDIDO, PARA LOS ENDODOS DE POLIZA O CERTIFICADO Y ENDOSO TEMPORAL DE POLIZA*/

         IF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYAMENDMENT,
                INSGENERALPKG.NTEMPPOLICYAMENDMENT,
                INSGENERALPKG.NCERTIFAMENDMENT)
         THEN
            IF NCERSTATUS IN (2)
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '97002';
               BERRORS := TRUE;
            END IF;
         END IF;


         /*+ SE VERIFICA QUE LA VALIDACION NO AFECTE AL INGRESAR PROPUESTAS. Luis Jiménez: 25/03/2009. Error: 536.*/

         IF NTRANSACTION NOT IN
               (INSGENERALPKG.NPOLICYPROPOSAL,
                INSGENERALPKG.NCERTIFPROPOSAL,
                INSGENERALPKG.NPOLICYQUERY,
                INSGENERALPKG.NCERTIFQUERY,
                INSGENERALPKG.NQUOTATIONQUERY,
                INSGENERALPKG.NPROPOSALQUERY)
         THEN
            /*+ SE VALIDA QUE LA FECHA NO SEA ANTERIOR A LA FECHA DEL ULTIMO CIERRE DE PRODUCCION.*/
            REACTROL_DATE (NTYPE_PROCE => 100,            -- CIERRE PRODUCCIóN
                                              RC1 => C_CTROL_DATE);

            FETCH C_CTROL_DATE INTO R_CTROL_DATE;

            CLOSE C_CTROL_DATE;

            IF R_CTROL_DATE.DEFFECDATE IS NOT NULL
               AND R_CTROL_DATE.DEFFECDATE > DEFFECDATE
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '750164';
               BERRORS := TRUE;
            END IF;
         END IF;
      END IF;

      /*+ SI SE TRATA DE UNA TRANSACION DE CONSULTA SE VALIDA PRIMERO EL NUMERO DE POLIZA */
      IF NPOLICY IS NULL
      THEN
         SPOLCERTYPE := GETPOLCERTYPE (NTRANSACTION);

         IF NGENTRANSAC IN
               (INSGENERALPKG.NQUERY,
                INSGENERALPKG.NCONVERT,
                INSGENERALPKG.NRECUPERATION,
                INSGENERALPKG.NPOLICYREISSUE,
                INSGENERALPKG.NCERTIFREISSUE,
                INSGENERALPKG.NAMENDPROPQUOT,
                INSGENERALPKG.NDUPLICATEDPOLICY)
         THEN
            IF SPOLCERTYPE = INSGENERALPKG.SPOLICY
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '3003';
               BERRORS := TRUE;
            ELSE
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '55652';
               BERRORS := TRUE;
            END IF;
         END IF;
      END IF;

      /*+ SE VALIDA QUE AL EMITIR O RECUPERAR UN CERTIFICADO LA POLIZA MATRIZ TENGA UN ESTADO VALIDO (1,4,5)*/
      IF NTRANSACTION IN
            (INSGENERALPKG.NCERTIFISSUE, INSGENERALPKG.NRECUPERATION)
      THEN
         BEGIN
            SELECT SSTATUSVA
              INTO SSTATUSVA
              FROM CERTIFICAT
             WHERE     SCERTYPE = '2'
                   AND NBRANCH = INSVALCA001.NBRANCH
                   AND NPRODUCT = INSVALCA001.NPRODUCT
                   AND NPOLICY = INSVALCA001.NPOLICY
                   AND NCERTIF = 0;
         EXCEPTION
            WHEN OTHERS
            THEN
               SSTATUSVA := NULL;
         END;

         IF SSTATUSVA NOT IN ('1', '4', '5')
         THEN
            IF NTRANSACTION = INSGENERALPKG.NRECUPERATION
            THEN
               IF NCERTIF_AUX > 0
               THEN
                  SERRORS :=
                        SERRORS
                     || INSGENERALPKG.SSEP
                     || '60591|0|1|'
                     || ' ('
                     || REAGENERALPKG.REACODIGINT ('TABLE181',
                                                   'SSTATUSVA',
                                                   NULL,
                                                   SSTATUSVA)
                     || ')';
                  BERRORS := TRUE;
               END IF;
            ELSE
               SERRORS :=
                     SERRORS
                  || INSGENERALPKG.SSEP
                  || '60591|0|1|'
                  || ' ('
                  || REAGENERALPKG.REACODIGINT ('TABLE181',
                                                'SSTATUSVA',
                                                NULL,
                                                SSTATUSVA)
                  || ')';
               BERRORS := TRUE;
            END IF;
         END IF;
      END IF;

      /*+ CONSULTA DE CERTIFICADO - ADVERTENCIA DE ESTADO DISTINTO A VALIDO */
      IF NTRANSACTION = INSGENERALPKG.NCERTIFQUERY
      THEN
         SSTATUSVA := NULL;

         BEGIN
            SELECT SSTATUSVA
              INTO SSTATUSVA
              FROM CERTIFICAT
             WHERE     SCERTYPE = '2'
                   AND NBRANCH = INSVALCA001.NBRANCH
                   AND NPRODUCT = INSVALCA001.NPRODUCT
                   AND NPOLICY = INSVALCA001.NPOLICY
                   AND NCERTIF = INSVALCA001.NCERTIF;
         EXCEPTION
            WHEN OTHERS
            THEN
               SSTATUSVA := NULL;
         END;

         IF SSTATUSVA NOT IN ('1', '4', '5')
         THEN
            SERRORS :=
                  SERRORS
               || INSGENERALPKG.SSEP
               || '3724|0|1|'
               || ' ('
               || REAGENERALPKG.REACODIGINT ('TABLE181',
                                             'SSTATUSVA',
                                             NULL,
                                             SSTATUSVA)
               || ')';
            BERRORS := TRUE;
         END IF;
      END IF;

      /*+ SE VALIDA QUE SE INDIQUE LA SUCURSAL, AGENCIA, OFICINA Y CANAL DE VENTA */
      IF NGENTRANSAC = INSGENERALPKG.NISSUE
      THEN
         IF NOT BERRORS
         THEN
            IF NOFFICE IS NULL
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '9120';
            ELSE
               VALOFFICE_SCHEMA (NUSERCODE    => NUSERCODE,
                                 NOFFICE      => NOFFICE,
                                 NVALOFFICE   => NEXISTS);

               IF NEXISTS != 1
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '12075';
               END IF;
            END IF;

            IF NOFFICEAGEN IS NULL
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '55519';
            END IF;

            IF NAGENCY IS NULL
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '1080';
            END IF;

            IF NSELLCHANNEL IS NULL
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '55583';
            END IF;
         END IF;
      END IF;

      /*+ SE VALIDA QUE SE INDIQUE EL RAMO */
      IF NBRANCH IS NULL
      THEN
         IF NOT BERRORS
         THEN
            SERRORS := SERRORS || INSGENERALPKG.SSEP || '1022';
            BERRORS := TRUE;
         END IF;
      ELSE
         /*+ SE VALIDA QUE SE INDIQUE EL PRODUCTO */
         IF NPRODUCT IS NULL
         THEN
            IF NOT BERRORS
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '1014';
               BERRORS := TRUE;
            END IF;
         ELSIF NOT BERRORS
         THEN
            REAPRODUCTGENERAL (NBRANCH      => NBRANCH,
                               NPRODUCT     => NPRODUCT,
                               DEFFECDATE   => DEFFECDATE,
                               RC1          => C_PRODUCT_GE);

            FETCH C_PRODUCT_GE INTO R_PRODUCT_GE;

            /*+ SI NO EXISTE INFORMACION */
            IF C_PRODUCT_GE%NOTFOUND
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '1011';
               BERRORS := TRUE;
            ELSE
               BFOUND := TRUE;

               /*+ SI CORRESPONDE A UN PRODUCTO DE VIDA */
               IF R_PRODUCT_GE.SBRANCHT = TO_CHAR (INSGENERALPKG.PMLIFE)
               THEN
                  BLIFE := TRUE;
               END IF;

               /*+ SE VALID QUE EL PRODUCTO SEA REAL */
               IF NGENTRANSAC = INSGENERALPKG.NISSUE
               THEN
                  IF R_PRODUCT_GE.SREALIND <> '1'
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '3750';
                     BERRORS := TRUE;
                  /*+ SE VALIDA QUE LA FECHA DE EFECTO DE LA POLIZA SEA MAYOR A LA FECHA DE EFECTO DEL PRODUCTO */
                  ELSE
                     IF DEFFECDATE < R_PRODUCT_GE.DEFFECDATE
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '3913';
                        BERRORS := TRUE;
                     END IF;
                  END IF;
               END IF;

               /*+ SE VALIDA QUE EL TIPO DE POLIZA ESTE PERMITIDO PARA EL PRODUCTO */
               IF (SPOLITYPE = INSGENERALPKG.SINDIVIDUAL
                   AND R_PRODUCT_GE.SINDIVIND <> '1')
                  OR (SPOLITYPE = INSGENERALPKG.SCOLECTIVE
                      AND R_PRODUCT_GE.SGROUPIND <> '1')
                  OR (SPOLITYPE = INSGENERALPKG.SMULTIIND
                      AND R_PRODUCT_GE.SMULTIIND <> '1')
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '11200';
                  BERRORS := TRUE;
               /*+ SI LA TRANSACCION ES CON CERTIFICADO LA POLIZA NO PUEDE SER INDIVIDUAL */
               ELSIF SPOLITYPE = INSGENERALPKG.SINDIVIDUAL
               THEN
                  IF NTRANSACTION IN
                        (INSGENERALPKG.NCERTIFISSUE,
                         INSGENERALPKG.NCERTIFQUERY,
                         INSGENERALPKG.NCERTIFAMENDMENT,
                         INSGENERALPKG.NCERTIFQUOTATION,
                         INSGENERALPKG.NCERTIFPROPOSAL,
                         INSGENERALPKG.NTEMPCERTIFAMENDMENT,
                         INSGENERALPKG.NCERTIFQUOTAMENDENT,
                         INSGENERALPKG.NCERTIFPROPAMENDENT,
                         INSGENERALPKG.NCERTIFQUOTRENEWAL,
                         INSGENERALPKG.NCERTIFPROPRENEWAL,
                         INSGENERALPKG.NTRANSHOLDER)
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '3109';
                  END IF;
               END IF;

               /*+ SI EL TIPO DE PRODUCTO ES SOAP EL FOLIO ES DE ENTRADA OBLIGATORIA*/
               IF R_PRODUCT_GE.SBRANCHT = TO_CHAR (INSGENERALPKG.PMSOAP)
                  AND                     --IF R_PRODUCT_GE.SBRANCHT = '9' AND
                      (   NTRANSACTION = INSGENERALPKG.NPOLICYISSUE
                       OR NTRANSACTION = INSGENERALPKG.NCERTIFISSUE
                       OR NTRANSACTION = INSGENERALPKG.NPOLICYQUOTATION
                       OR NTRANSACTION = INSGENERALPKG.NCERTIFQUOTATION
                       OR NTRANSACTION = INSGENERALPKG.NPOLICYREISSUE
                       OR NTRANSACTION = INSGENERALPKG.NCERTIFREISSUE
                       OR NTRANSACTION = INSGENERALPKG.NRECUPERATION)
                  AND (   SPOLITYPE = INSGENERALPKG.SINDIVIDUAL
                       OR NTRANSACTION = INSGENERALPKG.NCERTIFISSUE
                       OR NTRANSACTION = INSGENERALPKG.NCERTIFQUOTATION
                       OR NTRANSACTION = INSGENERALPKG.NCERTIFREISSUE)
               THEN
                  IF NVL (NFOLIO, 0) <= 0
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '90000016';
                  END IF;
               END IF;
            END IF;

            CLOSE C_PRODUCT_GE;
         END IF;
      END IF;


      /*+ SE VALIDA QUE SI EL NUMERO DE COTIZACION ES AUTOMATICO NO SE PUEDA INCLUIR UNO QUE YA EXISTE */
      IF NTRANSACTION = INSGENERALPKG.NPOLICYQUOTATION
         AND INSVALCA001.NPOLICY IS NOT NULL
      THEN
         SELECT SQUOTNUMAUTO INTO SQUOTNUMAUTO FROM OPT_SYSTEM;


         IF SQUOTNUMAUTO = '1'
         THEN
            BEGIN
               SELECT COUNT (1)
                 INTO NCOUNT_VAL
                 FROM POLICY
                WHERE     SCERTYPE = '3'
                      AND NBRANCH = INSVALCA001.NBRANCH
                      AND NPRODUCT <> INSVALCA001.NPRODUCT
                      AND NPOLICY = INSVALCA001.NPOLICY;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NCOUNT_VAL := 0;
            END;

            IF NVL (NCOUNT_VAL, 0) > 0
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '767097';
               BERRORS := TRUE;
            END IF;
         END IF;
      /* PARA LAS CONVERSIONES DE  COTIZACION A PROPUESTA, SE DEBE VALIDAR QUE ESTA NO EXISTA*/
      ELSIF NTRANSACTION = INSGENERALPKG.NPROPQUOTCONVERTION
      THEN
         IF INSVALCA001.NPROPQUOT IS NOT NULL
         THEN
            BEGIN
               SELECT COUNT (1)
                 INTO NCOUNT_VAL
                 FROM POLICY
                WHERE SCERTYPE = '1' AND NPOLICY = INSVALCA001.NPROPQUOT;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NCOUNT_VAL := 0;
            END;

            IF NVL (NCOUNT_VAL, 0) > 0
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '80162';
               BERRORS := TRUE;
            END IF;
         ELSE
            SERRORS := SERRORS || INSGENERALPKG.SSEP || '800190';
            BERRORS := TRUE;
         END IF;
      /* SI ES PROPUESTA DE POLIZA DEBE SER UNICO*/
      ELSIF NTRANSACTION = INSGENERALPKG.NPOLICYPROPOSAL
            AND INSVALCA001.NPOLICY IS NOT NULL
      THEN
         BEGIN
            SELECT COUNT (1)
              INTO NCOUNT_VAL
              FROM POLICY
             WHERE     SCERTYPE = '1'
                   AND NBRANCH = INSVALCA001.NBRANCH
                   AND NPRODUCT <> INSVALCA001.NPRODUCT
                   AND NPOLICY = INSVALCA001.NPOLICY;
         EXCEPTION
            WHEN OTHERS
            THEN
               NCOUNT_VAL := 0;
         END;

         IF NVL (NCOUNT_VAL, 0) > 0
         THEN
            SERRORS := SERRORS || INSGENERALPKG.SSEP || '80162';
            BERRORS := TRUE;
         END IF;
      END IF;

      IF NOT BERRORS
      THEN
         IF POLICYISNEED (NTRANSACTION) = 1
         THEN
            BNEEDPOLICY := TRUE;
         END IF;

         SPOLCERTYPE := GETPOLCERTYPE (NTRANSACTION);
         BERRORS := FALSE;

         /*+ SI NO INDICO NUMERO DE POLIZA/PROPUESTA/COTIZACION */
         IF NPOLICY IS NULL
         THEN
            /*+ SI LA POLIZA/PROPUESTA/COTIZACION ES OBLIGATORIA */
            IF BNEEDPOLICY
            THEN
               IF SPOLCERTYPE = INSGENERALPKG.SPOLICY
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '3003';
                  BERRORS := TRUE;
               ELSE
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '55652';
                  BERRORS := TRUE;
               END IF;
            END IF;
         /*+ SI INDICO NUMERO DE POLIZA/PROPUESTA/COTIZACION */
         ELSE
            /*+ SI LA POLIZA/PROPUESTA/COTIZACION ES OBLIGATORIA */
            IF BNEEDPOLICY
            THEN
               BEGIN
                  SELECT 1
                    INTO NCOUNT_VAL
                    FROM POLICY
                   WHERE     SCERTYPE = INSVALCA001.SPOLCERTYPE
                         AND NBRANCH = INSVALCA001.NBRANCH
                         AND NPRODUCT = INSVALCA001.NPRODUCT
                         AND NPOLICY = INSVALCA001.NPOLICY;

                  BFOUNDPOLICY := TRUE;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     BFOUNDPOLICY := FALSE;
               END;

               /*+ SI NO ENCONTRO NUMERO DE POLIZA/PROPUESTA/COTIZACION */
               IF NOT BFOUNDPOLICY
               THEN
                  IF SPOLCERTYPE = INSGENERALPKG.SPOLICY
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '3001';
                     BERRORS := TRUE;
                  ELSIF SPOLCERTYPE = INSGENERALPKG.SPROPOSAL
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '3667';
                     BERRORS := TRUE;
                  ELSIF SPOLCERTYPE = INSGENERALPKG.SQUOTATION
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '3668';
                     BERRORS := TRUE;
                  END IF;
               END IF;
            /*+ SI LA POLIZA/PROPUESTA/COTIZACION NO ES OBLIGATORIA */
            ELSE
               /*+ SI LA TRANSACCION ES EMISION DE POLIZA */
               REAPOLICY_BRANCH (SCERTYPE   => SPOLCERTYPE,
                                 NBRANCH    => NBRANCH,
                                 NPRODUCT   => NPRODUCT,
                                 NPOLICY    => NPOLICY,
                                 RC1        => C_POLICY);

               FETCH C_POLICY INTO R_POLICY;

               /*+ SI EXISTE INFORMACION */
               IF C_POLICY%FOUND
               THEN
                  BFOUNDPOLICY := TRUE;
               END IF;

               CLOSE C_POLICY;

               IF NTRANSACTION = INSGENERALPKG.NPOLICYISSUE
               THEN
                  /*+ SI ENCONTRO NUMERO DE POLIZA/PROPUESTA/COTIZACION */
                  IF BFOUNDPOLICY
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '3005';
                     BERRORS := TRUE;
                  END IF;
               END IF;
            END IF;
         END IF;

         REAPOLICY_BRANCH (SCERTYPE   => SPOLCERTYPE,
                           NBRANCH    => NBRANCH,
                           NPRODUCT   => NPRODUCT,
                           NPOLICY    => NPOLICY,
                           RC1        => C_POLICY);

         FETCH C_POLICY INTO R_POLICY;

         /*+ SI EXISTE INFORMACION */
         IF C_POLICY%FOUND
         THEN
            IF NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYQUOTATION,
                   INSGENERALPKG.NPOLICYQUERY,
                   INSGENERALPKG.NQUOTATIONQUERY,
                   INSGENERALPKG.NPROPOSALQUERY,
                   INSGENERALPKG.NPROPQUOTCONVERTION)
            THEN
               /*+ SE BUSCA EL TIPO DE USUARIO QUE ESTA REALIZANDO LA TRANSACCIÓN. */
               BEGIN
                  SELECT STYPE, NINTERMED
                    INTO INSVALCA001.STYPE, NINTERMED_AUX
                    FROM USERS U, INTERMEDIA I
                   WHERE     U.NUSERCODE = INSVALCA001.NUSERCODE
                         AND U.SCLIENT = I.SCLIENT
                         AND I.NINT_STATUS = 1                       -- ACTIVO
                         AND ROWNUM = 1;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     INSVALCA001.STYPE := NULL;
               END;

               /*+ SE VERIFICA SI EL USUARIO ES UN INTERMEDIARIO. */
               IF INSVALCA001.STYPE = '3'
               THEN
                  INSVALVIEWPOL2 (SCERTYPE        => SPOLCERTYPE,
                                  NBRANCH         => NBRANCH,
                                  NPRODUCT        => NPRODUCT,
                                  NPOLICY         => NPOLICY,
                                  NUSERCODE       => NUSERCODE,
                                  NINTERMED       => NINTERMED_AUX,
                                  NINTERMED_POL   => R_POLICY.NINTERMED,
                                  DSTARTDATE      => R_POLICY.DSTARTDATE,
                                  SWITCHE         => SWITCHE);

                  IF SWITCHE = '2'
                  THEN
                     SERRORS :=
                        SERRORS || INSGENERALPKG.SSEP
                        || '1102|0|1|. Esta cotización,propuesta,poliza pertenece a otro intermediario';
                     BERRORS := TRUE;
                  END IF;
               END IF;
            END IF;
         END IF;

         CLOSE C_POLICY;


         /*+SI EL TIPO DE TRANSACCION CORRESPONDE A TRASPASO DE POLIZA, SE VALIDA QUE LA MISMA EXISTA*/
         IF NTRANSACTION = INSGENERALPKG.NTRANSHOLDER
         THEN
            BFOUNDPOLDEST := FALSE;

            /*+ SI NO ENCONTRO NUMERO DE POLIZA DESTINO*/
            IF NPOLICY = NPOLICYDEST
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '61913';
               BERRORS := TRUE;
            END IF;

            REAPOLICY_BRANCH (SCERTYPE   => SPOLCERTYPE,
                              NBRANCH    => NBRANCH,
                              NPRODUCT   => NPRODUCT,
                              NPOLICY    => NPOLICYDEST,
                              RC1        => C_POLICY);

            FETCH C_POLICY INTO R_POLICYDEST;

            /*+ SI EXISTE INFORMACION */
            IF C_POLICY%FOUND
            THEN
               BFOUNDPOLDEST := TRUE;
            END IF;

            CLOSE C_POLICY;

            /*+ SI NO ENCONTRO NUMERO DE POLIZA DESTINO*/
            IF NOT BFOUNDPOLDEST
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '61910';
               BERRORS := TRUE;
            END IF;
         END IF;

         /*+SI EL TIPO DE TRANSACCION CORRESPONDE A DUPLICAR POLIZA, SE VALIDA QUE LA POLIZA DESTINO NO EXISTA*/
         IF NTRANSACTION = INSGENERALPKG.NDUPLICATEDPOLICY
         THEN
            BFOUNDPOLDEST := FALSE;

            /*+ SI SE ENCONTRO NUMERO DE POLIZA DESTINO*/
            REAPOLICY_BRANCH (SCERTYPE   => SPOLCERTYPE,
                              NBRANCH    => NBRANCH,
                              NPRODUCT   => NPRODUCT,
                              NPOLICY    => NPOLICYDEST,
                              RC1        => C_POLICY);

            FETCH C_POLICY INTO R_POLICYDEST;

            /*+ SI EXISTE INFORMACION */
            IF C_POLICY%FOUND
            THEN
               BFOUNDPOLDEST := TRUE;
            END IF;

            CLOSE C_POLICY;

            /*+ SI SE ENCONTRO NUMERO DE POLIZA DESTINO*/
            IF BFOUNDPOLDEST
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '61914';
               BERRORS := TRUE;
            END IF;
         END IF;

         /*+ SE VERIFICA LA INFORMACION DEL CERTIFICADO */
         IF NOT BERRORS
         THEN
            BERRORS := FALSE;

            /*+ SE EL TIPO DE LA POLIZA NO ES INDIVIDUAL */
            IF SPOLITYPE = INSGENERALPKG.SINDIVIDUAL
            THEN
               NCERTIF_AUX := 0;
            ELSE
               IF CERTIFISNEED (NTRANSACTION) = 1
               THEN
                  BNEEDCERTIF := TRUE;
               END IF;

               IF BNEEDCERTIF
               THEN
                  IF NCERTIF_AUX = 0
                  THEN
                     NCERTIF_AUX := NULL;
                  END IF;
               ELSE
                  IF NCERTIF_AUX IS NULL
                  THEN
                     NCERTIF_AUX := 0;
                  END IF;
               END IF;
            END IF;

            /*+ SE VALIDA SI ES OBLIGATORIO EL NUMERO DEL CERTIFICADO */
            IF NCERTIF_AUX IS NULL
            THEN
               IF BNEEDCERTIF
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '3006';
                  BERRORS := TRUE;
               END IF;
            ELSE
               REACERTIFICAT_BRANCH (SCERTYPE   => SPOLCERTYPE,
                                     NBRANCH    => NBRANCH,
                                     NPRODUCT   => NPRODUCT,
                                     NPOLICY    => NPOLICY,
                                     NCERTIF    => NCERTIF_AUX,
                                     RC1        => C_CERTIFICAT);

               FETCH C_CERTIFICAT INTO R_CERTIFICAT;

               /*+ SI EXISTE INFORMACION */
               IF C_CERTIFICAT%FOUND
               THEN
                  BFOUNDCERTIF := TRUE;
               END IF;

               CLOSE C_CERTIFICAT;

               IF NCERTIF_AUX > 0
               THEN
                  IF BFOUNDCERTIF
                  THEN
                     IF NTRANSACTION = INSGENERALPKG.NCERTIFISSUE
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '3008';
                        BERRORS := TRUE;
                     END IF;
                  ELSE
                     IF    NTRANSACTION = INSGENERALPKG.NRECUPERATION
                        OR NTRANSACTION = INSGENERALPKG.NCERTIFAMENDMENT
                        OR NTRANSACTION = INSGENERALPKG.NTEMPCERTIFAMENDMENT
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '3010';
                        BERRORS := TRUE;
                     END IF;
                  END IF;
               END IF;

               /*+ SE VALIDA QUE LA POLIZA NO ESTE SIENDO MODIFICADA POR OTRO USUARIO */
               IF BFOUNDCERTIF
               THEN
                  IF R_CERTIFICAT.NUSER_AMEND > 0
                     AND R_CERTIFICAT.NUSER_AMEND <> NUSERCODE
                  THEN
                     REAUSERS (USERS   => R_CERTIFICAT.NUSER_AMEND,
                               RC1     => C_USERS);

                     FETCH C_USERS INTO R_USERS;

                     /*+ SI EXISTE INFORMACION */
                     IF C_USERS%FOUND
                     THEN
                        IF NGENTRANSAC <> INSGENERALPKG.NQUERY
                        THEN
                           SERRORS :=
                                 SERRORS
                              || INSGENERALPKG.SSEP
                              || '3340|0|1|'
                              || R_USERS.SCLIENAME;
                           BERRORS := TRUE;
                        END IF;
                     END IF;

                     CLOSE C_USERS;
                  END IF;
               END IF;

               /*+ SI LA POLIZA/CERTIFICADO TIENE COMO ULTIMO MOVIMIENTO UNA               */
               /*+ MODIFICACION (ENDOSO) QUE QUEDO INCOMPLETA Y EL USUARIO INTENTA         */
               /*+ HACER CUALQUIER OPERACION, DIFERENTE A CONSULTA, SE ENVIA MENSAJE DE    */
               /*+ ERROR INDICANDO QUE DEBE RE-INSTALAR LA MODIFICACION                    */
               IF NGENTRANSAC NOT IN
                     (INSGENERALPKG.NQUERY, INSGENERALPKG.NPOLICYQUOTAMENDENT)
               THEN
                  IF R_CERTIFICAT.SSTATUSVA = '3'
                  THEN
                     REAPOLICY_HIS_1 (SCERTYPE   => SPOLCERTYPE,
                                      NBRANCH    => NBRANCH,
                                      NPRODUCT   => NPRODUCT,
                                      NPOLICY    => NPOLICY,
                                      NCERTIF    => NCERTIF_AUX,
                                      RC1        => C_POLICY_HIS);

                     FETCH C_POLICY_HIS INTO R_POLICY_HIS;

                     IF R_POLICY_HIS.NTYPE_HIST IN (11, 12)
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '56103';
                        BERRORS := TRUE;
                     END IF;
                  END IF;


                  /* Validacion para no volver a Re-eMIIR POLIZAS UNA VEZ CREADO UN ENDOSO ya finalizado */
                  /*                            -------                                     */
                  IF NTRANSACTION IN
                        (INSGENERALPKG.NPOLICYREISSUE,
                         INSGENERALPKG.NCERTIFREISSUE)
                     AND R_CERTIFICAT.SSTATUSVA = '4'
                  THEN
                     REAPOLICY_HIS_3 (SCERTYPE   => SPOLCERTYPE,
                                      NBRANCH    => NBRANCH,
                                      NPRODUCT   => NPRODUCT,
                                      NPOLICY    => NPOLICY,
                                      NCERTIF    => NCERTIF_AUX,
                                      RC1        => C_POLICY_HIS);

                     FETCH C_POLICY_HIS INTO R_POLICY_HIS;

                     IF R_POLICY_HIS.NTYPE_HIST IN (11, 12)
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '56215';
                        BERRORS := TRUE;
                     END IF;
                  END IF;
               /*                  Fin Validacion  */
               END IF;
            END IF;
         END IF;

         /*+ SE VALIDA EL CAMPO COTIZACION/PROPUESTA */
         IF NOT BERRORS
         THEN
            IF PROPQUOTISNEED (NTRANSACTION) = 1
            THEN
               BNEEDPROPQUOT := TRUE;
            END IF;

            SPROPQUOTCERT := GETPROPQUOTCERTYPE (NTRANSACTION);

            BERRORS := FALSE;

            NPROPQUOT_AUX := NPROPQUOT;

            /*+ SE ASIGNA EL NUMERO DE POLIZA */
            IF NTRANSACTION IN
                  (INSGENERALPKG.NQUOTATIONCONVERTION,
                   INSGENERALPKG.NPROPOSALCONVERTION)
            THEN
               NPROPQUOT_AUX := NPOLICY;
            END IF;

            /*+ SI NO INDICO NUMERO DE PROPUESTA/COTIZACION */
            IF NPROPQUOT_AUX IS NULL
            THEN
               /*+ SI LA TRANSACCION ES MOD. DE PROP. DE REHABILITACION, SE EXIGE EL N? DE PROPUESTA  */
               IF NTRANSACTION = INSGENERALPKG.NPROPREHABILITATE
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '55652';
                  BERRORS := TRUE;
               END IF;

               /*+ SI LA PROPUESTA/COTIZACION ES OBLIGATORIA */
               IF BNEEDPROPQUOT
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '55652';
                  BERRORS := TRUE;
               END IF;
            /*+ SI INDICO NUMERO DE PROPUESTA/COTIZACION */
            ELSE
               /*+VERIFICA QUE LA PROPUESTA EN TRAMITE SEA DE REHABILITACION  999999 */
               IF NTRANSACTION = INSGENERALPKG.NMODPROPREHABQUERY
                  OR NTRANSACTION = INSGENERALPKG.NPROPREHABILITATE
               THEN
                  /*+ SE VERIFICA QUE LA PROPUESTA PERTENESCA A LA POLIZA               */
                  SELECT COUNT (1)
                    INTO COUNT_NORIGIN
                    FROM CERTIFICAT
                   WHERE     SCERTYPE = '8'
                         AND NBRANCH = INSVALCA001.NBRANCH
                         AND NPRODUCT = INSVALCA001.NPRODUCT
                         AND NPOLICY = INSVALCA001.NPROPQUOT_AUX
                         AND NCERTIF = INSVALCA001.NCERTIF
                         AND NPOL_QUOT = INSVALCA001.NPOLICY;

                  IF COUNT_NORIGIN = 0
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '56181';
                     BERRORS := TRUE;
                  END IF;

                  /*+ SE VERIFICA QUE LA PROPUESTA SEA DE REHABILITACION           */
                  COUNT_NORIGIN := 0;

                  SELECT COUNT (1)
                    INTO COUNT_NORIGIN
                    FROM REQUEST
                   WHERE     SCERTYPE = '8'
                         AND NBRANCH = INSVALCA001.NBRANCH
                         AND NPRODUCT = INSVALCA001.NPRODUCT
                         AND NPOLICY = INSVALCA001.NPROPQUOT_AUX
                         AND NCERTIF = INSVALCA001.NCERTIF
                         AND DEFFECDATE <= INSVALCA001.DEFFECDATE
                         AND (DNULLDATE IS NULL
                              OR DNULLDATE > INSVALCA001.DEFFECDATE)
                         AND NORIGIN = 5;

                  IF COUNT_NORIGIN = 0 AND BERRORS = FALSE
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '56179';
                     BERRORS := TRUE;
                  END IF;

                  /*+ SE VERIFICA SI YA SE MODIFICO LA PROPUESTA DE  REHABILITACION */
                  IF NTRANSACTION = INSGENERALPKG.NMODPROPREHABQUERY
                     AND BERRORS = FALSE
                  THEN
                     REAPOLICY_HIS_TYPE_LAST ('8',
                                              NBRANCH,
                                              NPRODUCT,
                                              NPROPQUOT_AUX,
                                              NCERTIF_AUX,
                                              65,
                                              C_REATYPE_HIST);

                     FETCH C_REATYPE_HIST INTO R_REATYPE_HIST;

                     IF C_REATYPE_HIST%NOTFOUND
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '56182';
                        BERRORS := TRUE;
                     END IF;

                     CLOSE C_REATYPE_HIST;
                  END IF;

                  /*+ SE VERIFICA QUE LA PROPUESTA SE ENCUENTRE EN ESTADO PENDIENTE */
                  IF NTRANSACTION = INSGENERALPKG.NPROPREHABILITATE
                     AND BERRORS = FALSE
                  THEN
                     REACERTIFICAT_BRANCH (SCERTYPE   => '8',
                                           NBRANCH    => NBRANCH,
                                           NPRODUCT   => NPRODUCT,
                                           NPOLICY    => NPROPQUOT_AUX,
                                           NCERTIF    => NCERTIF_AUX,
                                           RC1        => C_CERTIFICATQUOT);

                     FETCH C_CERTIFICATQUOT INTO R_CERTIFICATQUOT;

                     IF R_CERTIFICATQUOT.NSTATQUOTA <> 1
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '56180';
                     END IF;
                  END IF;
               END IF;

               REACERTIFICAT_BRANCH (SCERTYPE   => SPROPQUOTCERT,
                                     NBRANCH    => NBRANCH,
                                     NPRODUCT   => NPRODUCT,
                                     NPOLICY    => NPROPQUOT_AUX,
                                     NCERTIF    => NCERTIF_AUX,
                                     RC1        => C_CERQUOT);

               FETCH C_CERQUOT INTO R_CERQUOT;

               /*+ SI EXISTE INFORMACION */
               IF C_CERQUOT%FOUND
               THEN
                  BFOUNDPROPQUOT := TRUE;
               END IF;

               CLOSE C_CERQUOT;

               /*+ SI LA POLIZA/PROPUESTA/COTIZACION ES OBLIGATORIA */
               IF BNEEDPROPQUOT
               THEN
                  /*+ SI NO ENCONTRO NUMERO DE POLIZA/PROPUESTA/COTIZACION */
                  IF NOT BFOUNDPROPQUOT
                  THEN
                     /*+ ESTA VALIDACION NO APLICA PARA LAS PROPUESTAS DE REHABILITACION */
                     IF NTRANSACTION <> INSGENERALPKG.NMODPROPREHABQUERY
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '55651';
                        BERRORS := TRUE;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;

      IF NOT BERRORS
      THEN
          BERRORS := FALSE;

          IF BFOUNDPOLICY
          THEN
              /*+ SE VALIDA QUE LA FECHA DE EFECTO SEA MAYOR O IGUAL A LA FECHA ORIGINAL DE LA POLIZA/PROPUESTA/COTIZACION */
              IF DEFFECDATE < R_CERTIFICAT.DDATE_ORIGI
              THEN
                    SERRORS := SERRORS || INSGENERALPKG.SSEP || '3091';
                    BERRORS := TRUE;
              ELSE
              /*+ SE VALIDA QUE LA FECHA DE EFECTO SEA MAYOR O IGUAL A LA FECHA DE EFECTO DE LA POLIZA/PROPUESTA/COTIZACION */
                  IF NTRANSACTION IN
                        (INSGENERALPKG.NCERTIFISSUE,
                         INSGENERALPKG.NRECUPERATION,
                         INSGENERALPKG.NCERTIFQUOTATION,
                         INSGENERALPKG.NCERTIFPROPOSAL,
                         INSGENERALPKG.NPOLICYAMENDMENT,
                         INSGENERALPKG.NPOLICYPROPAMENDENT,
                         INSGENERALPKG.NPOLICYQUOTAMENDENT,
                         INSGENERALPKG.NPROPOSALCONVERTION,
                         INSGENERALPKG.NQUOTATIONCONVERTION,
                         INSGENERALPKG.NPROPQUOTCONVERTION,
                         INSGENERALPKG.NPOLICYPROPRENEWAL,
                         INSGENERALPKG.NCERTIFPROPRENEWAL)
                  THEN
                         /* POR EL ERROR 137, SE MODIFICO ESTA CONDICION, PARA QUE VALIDARA SIN IMPORTAR LA TRANSACCION*/
                         IF     DEFFECDATE < R_POLICY.DSTARTDATE
                            AND NTRANSACTION <> INSGENERALPKG.NPROPQUOTCONVERTION
                            AND NTRANSACTION <> INSGENERALPKG.NPROPOSALCONVERTION
                         THEN
                            SERRORS := SERRORS || INSGENERALPKG.SSEP || '3262';
                            BERRORS := TRUE;
                         END IF;
          
          
                         IF NTRANSACTION <> INSGENERALPKG.NPOLICYQUOTAMENDENT
                         THEN
                            /*SI EL TIPO DE FACTURACION  ES POR CERTIFICADO Y TIENE RENOVACION INDEPENDIENTE 
                              SE VALIDA QUE LA FECHA DE EMISION DEL CERTIFICADO ESTE DENTRO DE LA VIGENCIA DE LA PÓLIZA*/
                                 IF NVL(R_POLICY.SCOLINVOT,0) = '2' /*Facturación por certificado*/
                                      AND NVL(R_POLICY.SCOLTIMRE,0) = '2' /*Renovación independiente*/
                                 THEN
                                          /*+ DEBE SER MAYOR A LA FECHA DE EFECTO */
                                        IF R_POLICY.DEXPIRDAT <= DEFFECDATE
                                            THEN
                                               SERRORS := SERRORS || INSGENERALPKG.SSEP || '3059';
                                               BERRORS := TRUE;
                                        END IF;
                                 ELSE
                                         /*+ SE VALIDA QUE LA FECHA DE LA PROXIMA FACTURACION SEA MENOR QUE LA FECHA DE EMISION DEL CERTIFICADO */
                                        /*+ FACTURACION ANTICIPADA.*/
                                        IF DEFFECDATE > R_POLICY.DNEXTRECEIP
                                           AND NTRANSACTION = INSGENERALPKG.NCERTIFISSUE
                                        THEN
                                           SERRORS := SERRORS || INSGENERALPKG.SSEP || '38049';
                                           BERRORS := TRUE;
                                        END IF;
          
                                        IF BLIFE
                                           AND (NTRANSACTION = INSGENERALPKG.NPOLICYPROPRENEWAL
                                                OR NTRANSACTION = INSGENERALPKG.NCERTIFPROPRENEWAL)
                                           AND DEFFECDATE > (R_POLICY.DNEXTRECEIP + 1)
                                        THEN
                                           SERRORS := SERRORS || INSGENERALPKG.SSEP || '38049';
                                           BERRORS := TRUE;
                                        END IF;
                                 END IF;
                             END IF;
                  END IF;
          
          
                  IF NTRANSACTION = INSGENERALPKG.NPOLICYPROPOSAL
                  THEN
                     IF DEFFECDATE < R_CERTIFICAT.DCHANGDAT
                     THEN
                        --                    SERRORS := SERRORS || INSGENERALPKG.SSEP || '3090';
                        SERRORS :=
                              SERRORS
                           || INSGENERALPKG.SSEP
                           || '3090|0|1|'
                           || ' ('
                           || TO_CHAR (R_CERTIFICAT.DCHANGDAT, 'DD/MM/YYYY')
                           || ')';
                     END IF;
                  END IF;
          
                  IF NGENTRANSAC IN
                        (INSGENERALPKG.NAMEND, INSGENERALPKG.NAMENDPROPQUOT)
                     AND NTYPE_AMEND NOT IN (909        /*  CAMBIO DE BENEFICIARIO*/
                                                )
                  THEN
                     BEGIN
                        SELECT COUNT (1)
                          INTO NPOLICY_TRANSFER
                          FROM POLICY_TRANSFER
                         WHERE     NBRANCH_VT7 = NBRANCH
                               AND NPRODUC_VT7 = NPRODUCT
                               AND NPOLICY_VT7 = NPOLICY
                               AND NCERTIF_VT7 = NCERTIF;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           NPOLICY_TRANSFER := 0;
                        WHEN OTHERS
                        THEN
                           NPOLICY_TRANSFER := 0;
                     END;
          
                     IF NVL (NPOLICY_TRANSFER, 0) = 0
                     THEN
                        IF DEFFECDATE = R_CERTIFICAT.DDATE_ORIGI
                        THEN
                           SERRORS := SERRORS || INSGENERALPKG.SSEP || '100164';
                        END IF;
                     ELSE
                        BEGIN
                           SELECT DEFFECDATE
                             INTO DEFFECDATE_TRANSFER
                             FROM POLICY_HIS
                            WHERE     NBRANCH = INSVALCA001.NBRANCH
                                  AND NPRODUCT = INSVALCA001.NPRODUCT
                                  AND NPOLICY = INSVALCA001.NPOLICY
                                  AND NCERTIF = INSVALCA001.NCERTIF
                                  AND NMOVEMENT = 1;
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              DEFFECDATE_TRANSFER := NULL;
                           WHEN OTHERS
                           THEN
                              DEFFECDATE_TRANSFER := NULL;
                        END;
          
                        IF DEFFECDATE = DEFFECDATE_TRANSFER
                        THEN
                           SERRORS := SERRORS || INSGENERALPKG.SSEP || '100164';
                        END IF;
                     END IF;
                  END IF;
          
                  /*+ SI LA ACCION ES CONSULTA */
                  IF NGENTRANSAC = INSGENERALPKG.NQUERY
                  THEN
                     /*+ SE VALIDA QUE LA FECHA DE EFECTO SEA MAYOR O IGUAL A LA FECHA ORIGINAL DE LA POLIZA/PROPUESTA/COTIZACION */
                     IF DEFFECDATE < R_CERTIFICAT.DDATE_ORIGI
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '3091';
                     END IF;
                  /*+ SI LA ACCION ES MODIFICACION */
                  ELSIF NGENTRANSAC IN
                           (INSGENERALPKG.NAMEND, INSGENERALPKG.NAMENDPROPQUOT)
                  THEN
                     DNEXTMONTHLY :=
                        VALIDNEXTRECEIPTDATE (R_CERTIFICAT.DSTARTDATE, DEFFECDATE);
          
                     IF NTYPE_AMEND IN
                           (2,
                            3,
                            6,
                            312,
                            313,
                            321,
                            323,
                            324,
                            325,
                            350,
                            351,
                            352,
                            353,
                            354,
                            355,
                            356,
                            357,
                            372,
                            374,
                            377,
                            902,
                            903,
                            904,
                            905,
                            908)
                     THEN                                   /*+ ENDOSO ECONÓMICO +*/
                        IF DEFFECDATE <> DNEXTMONTHLY
                        THEN
                           SERRORS := SERRORS || INSGENERALPKG.SSEP || '22000';
                        END IF;
                     END IF;
          
                     /*+ SE VALIDA QUE LA FECHA DE EFECTO SEA MAYOR O IGUAL A LA ULTIMA FECHA DE MODIFICACION */
                     IF DEFFECDATE < R_CERTIFICAT.DCHANGDAT
                     THEN
                        --SERRORS := SERRORS || INSGENERALPKG.SSEP || '3090';
                        SERRORS :=
                              SERRORS
                           || INSGENERALPKG.SSEP
                           || '3090|0|1|'
                           || ' ('
                           || TO_CHAR (R_CERTIFICAT.DCHANGDAT, 'DD/MM/YYYY')
                           || ')';
                     /*+ SE VALIDA LA FECHA DE MODIFICACION PARA VERIFICAR SI SE PODRIA REVERSAR */
                     ELSIF DEFFECDATE = R_CERTIFICAT.DCHANGDAT
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '3616';
                     /*+ SE VALIDA QUE LA FECHA DE EFECTO MENOR A LA FECHA DE VENCIMIENTO */
                     ELSIF R_CERTIFICAT.DEXPIRDAT IS NOT NULL
                     THEN
                        IF     DEFFECDATE > R_CERTIFICAT.DEXPIRDAT
                           AND NTRANSACTION <> INSGENERALPKG.NPOLICYPROPRENEWAL
                           AND NTRANSACTION <> INSGENERALPKG.NCERTIFPROPRENEWAL
                        THEN
                           SERRORS := SERRORS || INSGENERALPKG.SSEP || '3263';
                        END IF;
                     END IF;
          
                     /*+ SE VALIDA QUE LA FECHA DE EFECTO SE MAYOR A LA FECHA DE LA PROXIMA FACTURACION */
                     IF NGENTRANSAC = INSGENERALPKG.NAMEND
                        OR NTRANSACTION IN
                              (INSGENERALPKG.NPOLICYPROPAMENDENT,
                               INSGENERALPKG.NCERTIFPROPAMENDENT)
                     THEN
                        IF R_CERTIFICAT.DNEXTRECEIP IS NOT NULL
                        THEN
                           IF DEFFECDATE > R_CERTIFICAT.DNEXTRECEIP
                           THEN
                              SERRORS := SERRORS || INSGENERALPKG.SSEP || '38049';
                              BERRORS := TRUE;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
              END IF;
          END IF;
         /*+ SE VALIDA QUE LA FECHA DE EFECTO SEA POSTERIOR A LA ULTIMA GENERACION DE CARGOS JGT*/
         IF NTRANSACTION IN
               (INSGENERALPKG.NQUOTAMENDCONVERTION,
                INSGENERALPKG.NPROPAMENDCONVERTION)
         THEN
            DEFFECDATE_AUX :=
               REAGENERALPKG.REAPOLICY_HISDATE ('2',
                                                INSVALCA001.NBRANCH,
                                                INSVALCA001.NPRODUCT,
                                                INSVALCA001.NPOLICY,
                                                INSVALCA001.NCERTIF,
                                                57);

            IF (DEFFECDATE_AUX IS NOT NULL) AND (DEFFECDATE < DEFFECDATE_AUX)
            THEN
               SERRORS :=
                     SERRORS
                  || INSGENERALPKG.SSEP
                  || '56185|0|1|'
                  || ' ('
                  || TO_CHAR (DEFFECDATE_AUX, 'DD/MM/YYYY')
                  || ')';
               BERRORS := TRUE;
            END IF;

            DEFFECDATE_AUX := NULL;
            DEFFECDATE_AUX :=
               REAGENERALPKG.REAPOLICY_HISDATE ('2',
                                                INSVALCA001.NBRANCH,
                                                INSVALCA001.NPRODUCT,
                                                INSVALCA001.NPOLICY,
                                                INSVALCA001.NCERTIF,
                                                58);

            IF (DEFFECDATE_AUX IS NOT NULL) AND (DEFFECDATE < DEFFECDATE_AUX)
            THEN
               SERRORS :=
                     SERRORS
                  || INSGENERALPKG.SSEP
                  || '56185|0|1|'
                  || ' ('
                  || TO_CHAR (DEFFECDATE_AUX, 'DD/MM/YYYY')
                  || ')';
               BERRORS := TRUE;
            END IF;
         END IF;


         /*+ SE REALIZAN LAS VALIDACIONES SOBRE EL CAMPO PROPUESTA/POLIZA/CERTIFICADO */
         /*+ SI LA TRANSACCION ES PROPUESTA/COTIZACION DE EMISION/MODIFICACION DE POLIZA/CERTIFICADO O CONVERSION */
         IF NGENTRANSAC IN
               (INSGENERALPKG.NCONVERT, INSGENERALPKG.NAMENDPROPQUOT)
            AND NTRANSACTION NOT IN
                   (INSGENERALPKG.NPOLICYQUOTAMENDENT,
                    INSGENERALPKG.NCERTIFQUOTAMENDENT)
         THEN
            IF BFOUNDPROPQUOT
            THEN
               IF R_CERQUOT.NSTATQUOTA <> 1
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '60562';
               ELSE
                  /*+  SE VALIDA QUE EL ESTADO DE LA PROPUESTA NO SEA PENDIENTE POR UN MOTIVO RESTRICTIVO PARA LA CONVERTIR A POLIZA */
                  IF NGENTRANSAC = INSGENERALPKG.NCONVERT
                  THEN
                     IF R_CERQUOT.NWAIT_CODE > 0
                     THEN
                        REATAB_WAITPO (NWAIT_CODE   => R_CERQUOT.NWAIT_CODE,
                                       NORDER       => NULL,
                                       RC1          => C_TAB_WAIPO);

                        FETCH C_TAB_WAIPO INTO R_TAB_WAIPO;

                        IF C_TAB_WAIPO%FOUND
                        THEN
                           IF NVL (R_TAB_WAIPO.SCONVERT, '2') = '2'
                           THEN
                              SERRORS :=
                                    SERRORS
                                 || INSGENERALPKG.SSEP
                                 || '60540|0|1|'
                                 || R_TAB_WAIPO.SDESCRIPT;
                              BERRORS := TRUE;
                           END IF;
                        END IF;

                        CLOSE C_TAB_WAIPO;
                     END IF;
                  END IF;
               END IF;

               /* PARA CONVERTIR DE PROPUESTA A POLIZA EN APV SE DEBE TENER UNA SAAPV VIGENTE */
               IF SAPV = '1'
               THEN
                  IF R_CERTIFICAT.SCERTYPE = '1'
                  THEN
                     SELECT COUNT (1)
                       INTO NCOUNT_PREG
                       FROM LIFE P, SAAPV S
                      WHERE     P.SCERTYPE = R_CERTIFICAT.SCERTYPE
                            AND P.NBRANCH = R_CERTIFICAT.NBRANCH
                            AND P.NPRODUCT = R_CERTIFICAT.NPRODUCT
                            AND P.NPOLICY = R_CERTIFICAT.NPOLICY
                            AND P.NCERTIF = R_CERTIFICAT.NCERTIF
                            AND P.DEFFECDATE <= INSVALCA001.DEFFECDATE
                            AND (P.DNULLDATE IS NULL
                                 OR P.DNULLDATE > INSVALCA001.DEFFECDATE)
                            AND P.NCOD_SAAPV = S.NCOD_SAAPV
                            AND P.NINSTITUTION = S.NINSTITUTION
                            AND NSTATUS_SAAPV = 5;

                     IF NCOUNT_PREG = 0
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '767142';
                     END IF;
                  END IF;

                  IF R_CERTIFICAT.SCERTYPE = '6'
                  THEN
                     BEGIN
                        SELECT NCOD_SAAPV, NINSTITUTION
                          INTO NCOD_SAAPV, NINSTITUTION
                          FROM LIFE P
                         WHERE     P.SCERTYPE = R_CERTIFICAT.SCERTYPE
                               AND P.NBRANCH = R_CERTIFICAT.NBRANCH
                               AND P.NPRODUCT = R_CERTIFICAT.NPRODUCT
                               AND P.NPOLICY = R_CERTIFICAT.NPOLICY
                               AND P.NCERTIF = R_CERTIFICAT.NCERTIF
                               AND P.DEFFECDATE <= INSVALCA001.DEFFECDATE
                               AND (P.DNULLDATE IS NULL
                                    OR P.DNULLDATE > INSVALCA001.DEFFECDATE);
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           NULL;
                     END;

                     IF NVL (NCOD_SAAPV, 0) <> 0
                     THEN
                        SELECT COUNT (1)
                          INTO NCOUNT_PREG
                          FROM SAAPV S
                         WHERE     S.NCOD_SAAPV = INSVALCA001.NCOD_SAAPV
                               AND S.NINSTITUTION = INSVALCA001.NINSTITUTION
                               AND S.NSTATUS_SAAPV = 5;

                        IF NCOUNT_PREG = 0
                        THEN
                           SERRORS :=
                              SERRORS || INSGENERALPKG.SSEP || '767142';
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;

         IF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYQUOTATION,
                INSGENERALPKG.NCERTIFPROPOSAL,
                INSGENERALPKG.NCERTIFQUOTATION,
                INSGENERALPKG.NPOLICYPROPOSAL,
                INSGENERALPKG.NQUOTATIONCONVERTION,
                INSGENERALPKG.NPROPOSALCONVERTION,
                INSGENERALPKG.NPROPQUOTCONVERTION,
                INSGENERALPKG.NPOLICYQUOTAMENDENT,
                INSGENERALPKG.NCERTIFQUOTAMENDENT)
         THEN
            /* SI SE ESTA REALIZANDO UNA CONVERSION DE COTIZACION A PROPUESTA SE VERIFICA QUE LA COTIZACIÓN ESTE VIGENTE.*/
            IF NTRANSACTION IN (INSGENERALPKG.NPROPQUOTCONVERTION)
            THEN
               REAPOLICY_BRANCH (SCERTYPE   => SPOLCERTYPE,
                                 NBRANCH    => NBRANCH,
                                 NPRODUCT   => NPRODUCT,
                                 NPOLICY    => NPOLICY,
                                 RC1        => C_POLICY);

               FETCH C_POLICY INTO R_POLICY;

               IF DEFFECDATE < R_POLICY.DSTARTDATE
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '80173';
                  BERRORS := TRUE;
               ELSIF DEFFECDATE > R_POLICY.DMAXIMUM_DA
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '80052';
                  BERRORS := TRUE;
               END IF;

               CLOSE C_POLICY;

               /* ESTAS VALIDACIONES SE HACEN DENTRO DE LA RESPECTIVA SECUENCIA EN LA CA004*/

               /*                IF NTRANSACTION = INSGENERALPKG.NPROPQUOTCONVERTION THEN
                                   BEGIN
                                       SELECT NWAY_PAY
                                         INTO R_CERTIFICAT.NWAY_PAY
                                         FROM CERTIFICAT
                                        WHERE SCERTYPE = SPOLCERTYPE
                                          AND NBRANCH  = INSVALCA001.NBRANCH
                                          AND NPRODUCT = INSVALCA001.NPRODUCT
                                          AND NPOLICY  = INSVALCA001.NPOLICY
                                          AND NCERTIF  = INSVALCA001.NCERTIF;
                                   EXCEPTION
                                       WHEN NO_DATA_FOUND THEN
                                           R_CERTIFICAT.NWAY_PAY := NULL;
                                       WHEN OTHERS THEN
                                           RAISE;
                                   END;

                                   IF R_CERTIFICAT.NWAY_PAY = INSGENERALPKG.EWAYPAYBYBRIEF THEN
                                          NCOUNT := 0;

                                       REAROLES_COUNT_BY_ROLE(SCERTYPE   => SPOLCERTYPE,
                                                              NBRANCH    => NBRANCH,
                                                              NPRODUCT   => NPRODUCT,
                                                              NPOLICY    => NPOLICY,
                                                              NCERTIF    => NCERTIF_AUX,
                                                              NROLE      => 25, -- PAGADOR
                                                              DEFFECDATE => DEFFECDATE,
                                                              NCOUNT     => NCOUNT);

                                       IF NVL(NCOUNT, 0) = 0 THEN
                                           SERRORS := SERRORS || INSGENERALPKG.SSEP || '80185';
                                           BERRORS:=TRUE;
                                       ELSE
                                           BEGIN
                                               SELECT COUNT(1)
                                                 INTO NCOUNT
                                                 FROM CLIENT_REQ
                                                WHERE NBRANCH     = INSVALCA001.NBRANCH
                                                  AND NPRODUCT    = INSVALCA001.NPRODUCT
                                                  AND NROLE        = 25
                                                  AND NTRATYPEP   = INSGENERALPKG.NPROPQUOTCONVERTION
                                                  AND NFIELD        = 23
                                                  AND DEFFECDATE <= INSVALCA001.DEFFECDATE
                                                  AND (DNULLDATE IS NULL
                                                   OR DNULLDATE >      INSVALCA001.DEFFECDATE);
                                           EXCEPTION
                                               WHEN NO_DATA_FOUND THEN
                                                   NCOUNT := NULL;
                                               WHEN OTHERS THEN
                                                   RAISE;
                                           END;

                                           IF NVL(R_POLICY.NCOD_AGREE, 0) = 0 THEN
                                               SERRORS := SERRORS || INSGENERALPKG.SSEP || '55004';
                                               BERRORS:=TRUE;
                                           END IF;
                                       END IF;

                                       NCOUNT := 0;

                                   END IF;

                               END IF;*/

               IF NOT BERRORS
               THEN
                  VALREQUIREDFIELDS_MASSIVE (INSVALCA001.SPOLCERTYPE,
                                             INSVALCA001.NBRANCH,
                                             INSVALCA001.NPRODUCT,
                                             INSVALCA001.NPOLICY,
                                             INSVALCA001.NCERTIF,
                                             INSVALCA001.DEFFECDATE,
                                             INSVALCA001.NTRANSACTION,
                                             INSVALCA001.SPOLITYPE,
                                             SERRORS);

                  IF SERRORS > ''
                  THEN
                     BERRORS := TRUE;
                  END IF;
               END IF;
            END IF;

            /* SI SE ESTA CREANDO UNA PROPUESTA. */
            IF NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYPROPOSAL,
                   INSGENERALPKG.NCERTIFPROPOSAL)
               AND NPOLICY IS NULL
            THEN
               SERRORS := SERRORS || INSGENERALPKG.SSEP || '800190';

               REAPRODUCTGENERAL (NBRANCH      => NBRANCH,
                                  NPRODUCT     => NPRODUCT,
                                  DEFFECDATE   => DEFFECDATE,
                                  RC1          => C_PRODUCT_GE);

               FETCH C_PRODUCT_GE INTO R_PRODUCT_GE;

               IF DEFFECDATE < TRUNC (SYSDATE) - R_PRODUCT_GE.NQDAYS_PRO
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '80053';
               END IF;

               CLOSE C_PRODUCT_GE;
            END IF;

            /* SI SE ESTA CONVIRTIENDO DE PROPUESTA A PÓLIZA*/
            IF NTRANSACTION = INSGENERALPKG.NPROPOSALCONVERTION
            THEN
               REAPOLICY_BRANCH (SCERTYPE   => SPOLCERTYPE,
                                 NBRANCH    => NBRANCH,
                                 NPRODUCT   => NPRODUCT,
                                 NPOLICY    => NPOLICY,
                                 RC1        => C_POLICY);

               FETCH C_POLICY INTO R_POLICY;

               IF DEFFECDATE < R_POLICY.DSTARTDATE
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '80174';
                  BERRORS := TRUE;
               ELSIF DEFFECDATE > R_POLICY.DMAXIMUM_DA
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '80054';
                  BERRORS := TRUE;
               END IF;


               IF NOT BERRORS
               THEN
                  VALREQUIREDFIELDS_MASSIVE (INSVALCA001.SPOLCERTYPE,
                                             INSVALCA001.NBRANCH,
                                             INSVALCA001.NPRODUCT,
                                             INSVALCA001.NPOLICY,
                                             INSVALCA001.NCERTIF,
                                             INSVALCA001.DEFFECDATE,
                                             INSVALCA001.NTRANSACTION,
                                             INSVALCA001.SPOLITYPE,
                                             SERRORS);

                  IF SERRORS > ''
                  THEN
                     BERRORS := TRUE;
                  END IF;
               END IF;

               CLOSE C_POLICY;
            END IF;

            /* SI SE ESTA COTIZANDO LA FECHA DE VIGENCIA DEBE SER LA DEL DIA. */
            IF NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYQUOTATION,
                   INSGENERALPKG.NCERTIFQUOTATION,
                   INSGENERALPKG.NPOLICYQUOTAMENDENT,
                   INSGENERALPKG.NCERTIFQUOTAMENDENT)
            THEN
               REAPOLICY_BRANCH (SCERTYPE   => SPOLCERTYPE,
                                 NBRANCH    => NBRANCH,
                                 NPRODUCT   => NPRODUCT,
                                 NPOLICY    => NPOLICY,
                                 RC1        => C_POLICY);

               FETCH C_POLICY INTO R_POLICY;

               CLOSE C_POLICY;

               IF DEFFECDATE <> TRUNC (SYSDATE)
                  AND R_POLICY.DSTARTDATE IS NULL
               THEN
                  BEGIN
                     SELECT    SERRORS
                            || INSGENERALPKG.SSEP
                            || DECODE (U.STYPE, '3', 80160, 80051)
                       INTO SERRORS
                       FROM USERS U
                      WHERE U.NUSERCODE = INSVALCA001.NUSERCODE;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '80051';
                  END;
               END IF;
            END IF;

            /*SI LA COTIZACION ESTA TRANSFERIDA, NO SE PUEDE MODIFICAR*/
            IF NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYQUOTATION,
                   INSGENERALPKG.NCERTIFPROPOSAL,
                   INSGENERALPKG.NCERTIFQUOTATION,
                   INSGENERALPKG.NPOLICYPROPOSAL)
            THEN
               IF R_CERTIFICAT.NSTATQUOTA = 1
                  AND R_CERTIFICAT.NWAIT_CODE = 37
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '55650';
               END IF;
            END IF;

            IF NTRANSACTION IN
                  (INSGENERALPKG.NPROPQUOTCONVERTION,
                   INSGENERALPKG.NQUOTATIONCONVERTION)
            THEN
               IF R_CERTIFICAT.NSTATQUOTA = 1
                  AND R_CERTIFICAT.NWAIT_CODE = 38
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '55871';
               END IF;
            END IF;

            /*+ SE VALIDA QUE LA PROPUESTA/COTIZACION ESTE PENDIENTE NO APLICA PARA RECOTIZACIONES */
            IF NTRANSACTION NOT IN
                  (INSGENERALPKG.NPOLICYQUOTAMENDENT,
                   INSGENERALPKG.NCERTIFQUOTAMENDENT)
            THEN
               IF (BFOUNDPOLICY AND NPROPQUOT IS NULL)
                  OR NTRANSACTION = INSGENERALPKG.NPROPQUOTCONVERTION
               THEN
                  IF R_CERTIFICAT.NSTATQUOTA <> 1
                  THEN
                     IF R_CERTIFICAT.NSTATQUOTA = 2
                     THEN
                        SERRORS :=
                              SERRORS
                           || INSGENERALPKG.SSEP
                           || '60562|0|2|'
                           || '(POLIZA/PROPUESTA: '
                           || R_CERTIFICAT.NPOL_QUOT
                           || ')';
                     ELSE
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '60562';
                     END IF;
                  END IF;
               ELSE
                  IF BFOUNDCERTIF
                  THEN
                     IF BNEEDPROPQUOT AND NPROPQUOT IS NULL
                     THEN
                        IF R_CERTIFICAT.NSTATQUOTA <> 1
                        THEN
                           SERRORS := SERRORS || INSGENERALPKG.SSEP || '60562';
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;

         /*+ SE VALIDA EL ESTADO DE LA POLIZA CERTIFICADO SEGUN LA TRANSACCION REALIZADA */
         IF SPOLCERTYPE = INSGENERALPKG.SPOLICY
         THEN
            IF BFOUNDCERTIF
            THEN
               NERRORNUM :=
                  INSVALSTATUSPOL (SPOLCERTYPE,
                                   NBRANCH,
                                   NPRODUCT,
                                   NPOLICY,
                                   NCERTIF_AUX,
                                   NTRANSACTION,
                                   NGENTRANSAC,
                                   R_CERTIFICAT.SSTATUSVA);

               IF NERRORNUM > 0
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || NERRORNUM;
                  BERRORS := TRUE;
               END IF;
            END IF;
         END IF;

         IF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYQUOTAMENDENT,
                INSGENERALPKG.NCERTIFQUOTAMENDENT)
         THEN
            IF DEFFECDATE <> TRUNC (SYSDATE)
            THEN
               SERRORS :=
                     SERRORS
                  || INSGENERALPKG.SSEP
                  || '8316|0|1|'
                  || '( La fecha de recotización debe ser hoy )';
            END IF;
         END IF;

         IF NOT BERRORS
         THEN
            /*
                        BERRORS := FALSE;
                        IF BFOUNDPOLICY THEN
                            IF NTRANSACTION = INSGENERALPKG.NDECLARATIONS AND
                               NCERTIF_AUX <> 0 AND
                               R_PRODUCT_GE.SBRANCHT = TO_CHAR(INSGENERALPKG.PMTRANSPORTE) THEN

                               REAVERIFYDECLAFREQ (SCERTYPE=>SPOLCERTYPE,
                                                   NBRANCH=>NBRANCH,
                                                   NPRODUCT=>NPRODUCT,
                                                   NPOLICY=>NPOLICY,
                                                   NCERTIF=>NCERTIF_AUX,
                                                   DEFFECDATE=>DEFFECDATE,
                                                   DSTARTDATE=>R_POLICY.DSTARTDATE,
                                                   DEXPIRDAT=>R_POLICY.DEXPIRDAT,
                                                   RC1=>C_GROUPS);
                                FETCH C_GROUPS
                                 INTO R_GROUPS;

                                IF C_GROUPS%FOUND THEN
                                    IF R_GROUPS.NFLAG > 0 THEN
                                        IF R_GROUPS.NFLAG = 1 THEN
                                            SERRORS := SERRORS || INSGENERALPKG.SSEP || '3193';
                                            BERRORS := TRUE;
                                        ELSIF R_GROUPS.NFLAG = 2 THEN
                                            SERRORS := SERRORS || INSGENERALPKG.SSEP || '3388';
                                            BERRORS := TRUE;
                                        END IF;
                                    END IF;
                                END IF;
                                CLOSE C_GROUPS;
                            END IF;
                        END IF;
            */

            /*+ SE VALIDA EL TIPO DE ENDOSO */
            IF NGENTRANSAC = INSGENERALPKG.NAMEND
               OR NTRANSACTION IN
                     (INSGENERALPKG.NPOLICYQUOTAMENDENT,
                      INSGENERALPKG.NCERTIFQUOTAMENDENT,
                      INSGENERALPKG.NPOLICYPROPAMENDENT,
                      INSGENERALPKG.NCERTIFPROPAMENDENT)
            THEN
               /*+SE ADVIERTE QUE LA POLIZA TIENE UN CESIONARIO ASOCIADO*/
               NCOUNT := 0;

               BEGIN
                  SELECT 1
                    INTO NCOUNT
                    FROM ROLES
                   WHERE     SCERTYPE = '2'
                         AND NBRANCH = INSVALCA001.NBRANCH
                         AND NPRODUCT = INSVALCA001.NPRODUCT
                         AND NPOLICY = INSVALCA001.NPOLICY
                         AND NCERTIF = INSVALCA001.NCERTIF
                         AND DEFFECDATE <= INSVALCA001.DEFFECDATE
                         AND (DNULLDATE IS NULL
                              OR DNULLDATE > INSVALCA001.DEFFECDATE)
                         AND NROLE = 33;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     NCOUNT := '0';
               END;

               IF NCOUNT >= 1
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '767053';
               END IF;

               IF NTYPE_AMEND IS NULL
               THEN
                  REAEXIST_TYPE_AMEND (NBRANCH      => NBRANCH,
                                       NPRODUCT     => NPRODUCT,
                                       DEFFECDATE   => DEFFECDATE,
                                       NEXIST       => NEXISTS);

                  IF NEXISTS = 1
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '55504';
                  END IF;
               ELSE
                  REATYPE_AMEND (NBRANCH       => NBRANCH,
                                 NPRODUCT      => NPRODUCT,
                                 DEFFECDATE    => DEFFECDATE,
                                 NTYPE_AMEND   => NTYPE_AMEND,
                                 RC1           => C_TYPE_AMEND);

                  FETCH C_TYPE_AMEND INTO R_TYPE_AMEND;

                  IF C_TYPE_AMEND%FOUND
                  THEN
                     SIND_ORDER_SERV := R_TYPE_AMEND.SIND_ORDER_SERV;
                  END IF;

                  CLOSE C_TYPE_AMEND;


                  IF     NTYPE_AMEND = 50
                     AND SAPV = '1'
                     AND NVL (NCOD_SAAPV_AUX, 0) = 0
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '767158';
                  END IF;
               END IF;

               IF NCAUSE_AMEND IS NULL
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '750007';
               END IF;
            END IF;

            /*+ SE VALIDA EL NUMERO DE INSPECCION */
            IF NSERV_ORDER IS NULL
            THEN
               /*+ SI EL RAMO NO ES VIDA Y A TRANSACCION ES UNA EMISION O CONVERSION A POLIZA */
               IF NOT BLIFE
               THEN
                  IF NTRANSACTION IN
                        (INSGENERALPKG.NPOLICYISSUE,
                         INSGENERALPKG.NCERTIFISSUE,
                         INSGENERALPKG.NRECUPERATION,
                         INSGENERALPKG.NPOLICYREISSUE,
                         INSGENERALPKG.NCERTIFREISSUE,
                         INSGENERALPKG.NPROPOSALCONVERTION,
                         INSGENERALPKG.NQUOTATIONCONVERTION)
                  THEN
                     SIND_ORDER_SERV := '1';
                  END IF;
               END IF;

               IF SIND_ORDER_SERV = '1'
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '55503';
               END IF;
            /*+ SE VALIDA QUE LA ORDEN ESTE REGISTRADA Y ESTE REALIZADA O PAGADA */
            ELSE
               REAPROF_ORD_O (NSERV_ORDER => NSERV_ORDER, RC1 => C_PROF_ORD);

               FETCH C_PROF_ORD INTO R_PROF_ORD;

               IF C_PROF_ORD%NOTFOUND
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '55508';
               ELSE
                  IF R_PROF_ORD.NSTATUS_ORD NOT IN (3, 4)
                  THEN
                     SERRORS_AUX :=
                        REAGENERALPKG.
                         REACODIGINT (STABLE      => 'TABLE215',
                                      SFIELD      => 'NSTATUS_ORD',
                                      NCODIGINT   => R_PROF_ORD.NSTATUS_ORD,
                                      SCODIGINT   => NULL);
                     SERRORS_AUX :=
                           '('
                        || SERRORS_AUX
                        || ') NO PERMITE EJECUTAR ESTA OPERACION';
                     SERRORS :=
                           SERRORS
                        || INSGENERALPKG.SSEP
                        || '55786|0|1|'
                        || SERRORS_AUX;
                  END IF;
               END IF;

               CLOSE C_PROF_ORD;
            END IF;

            /*+ SE VALIDA LA FECHA DE CONTABILIZACIO */
            IF DLEDGERDATE IS NULL
            THEN
               /*+ SI LA TRANSACCION ES EMISION, RECUPEACION O MODIFICACION NORMAL DEBE ESTAR LLENA */
               IF NTRANSACTION IN
                     (INSGENERALPKG.NPOLICYISSUE,
                      INSGENERALPKG.NCERTIFISSUE,
                      INSGENERALPKG.NRECUPERATION,
                      INSGENERALPKG.NPOLICYAMENDMENT,
                      INSGENERALPKG.NCERTIFAMENDMENT)
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '7056';
               END IF;
            ELSE
               IF NTRANSACTION IN
                     (INSGENERALPKG.NPOLICYISSUE,
                      INSGENERALPKG.NCERTIFISSUE,
                      INSGENERALPKG.NRECUPERATION,
                      INSGENERALPKG.NPOLICYAMENDMENT,
                      INSGENERALPKG.NCERTIFAMENDMENT,
                      INSGENERALPKG.NQUOTATIONCONVERTION,
                      INSGENERALPKG.NPROPOSALCONVERTION,
                      INSGENERALPKG.NPOLICYREISSUE,
                      INSGENERALPKG.NCERTIFREISSUE)
               THEN
                  /*+ SE VALIDA QUE LA FECHA  DEBE SER POSTERIOR AL PERIODO CONTABLE EN VIGOR */
                  INSVALDLEDGERDAT (NTYPE_PROCE   => 1,
                                    DEFFECDATE    => DLEDGERDATE,
                                    NCOUNT        => NCOUNT_DLEDGER);

                  IF NCOUNT_DLEDGER = 0
                  THEN
                     SERRORS :=
                           SERRORS
                        || INSGENERALPKG.SSEP
                        || '1006|0|1|(Fecha de contalibización)';
                  END IF;
               /*+  SE VALIDA LA FECHA DE CONTABILIZACION CON RESPECTO A LA DE LOS ASIENTOS */
               --                    REACTROL_DATE (NTYPE_PROCE=>1,
               --                                   RC1=>C_CTROL_DATE);

               --                    FETCH C_CTROL_DATE
               --                     INTO R_CTROL_DATE;

               --                    IF C_CTROL_DATE%FOUND THEN
               --                        IF DLEDGERDATE < R_CTROL_DATE.DEFFECDATE THEN
               --                            SERRORS := SERRORS || INSGENERALPKG.SSEP || '1008';
               --                        END IF;
               --                    END IF;
               END IF;
            END IF;

            /*+ SE VALIDA LA FECHA DE VENCIMIENTO SI LA TRANSACCION ES MODIFICACION TEMPORAL */
            IF NTRANSACTION IN
                  (INSGENERALPKG.NTEMPPOLICYAMENDMENT,
                   INSGENERALPKG.NTEMPCERTIFAMENDMENT)
            THEN
               /*+ DEBE ESTAR LLENA */
               IF DEXPDATE IS NULL
               THEN
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '5050';
                  BERRORS := TRUE;
               ELSE
                  /*+ DEBE SER MAYOR A LA FECHA DE EFECTO */
                  IF DEXPDATE <= DEFFECDATE
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '3059';
                     BERRORS := TRUE;
                  END IF;

                  /*+ DEBE ANTERIOR A LA FECHA DE VENCIMIENTO */
                  IF DEXPDATE > R_CERTIFICAT.DEXPIRDAT
                     AND R_CERTIFICAT.DEXPIRDAT IS NOT NULL
                  THEN
                     IF NCERTIF_AUX = 0
                     THEN
                        SERRORS :=
                              SERRORS
                           || INSGENERALPKG.SSEP
                           || '3263|0|1|'
                           || '('
                           || R_CERTIFICAT.DEXPIRDAT
                           || ')';
                        BERRORS := TRUE;
                     ELSE
                        SERRORS :=
                              SERRORS
                           || INSGENERALPKG.SSEP
                           || '3265|0|1|'
                           || '('
                           || R_CERTIFICAT.DEXPIRDAT
                           || ')';
                        BERRORS := TRUE;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;

         /*+ SE REALIZAN LAS VALIDACIONES GENERALES DE LA POLIZA */
         IF NOT BERRORS
         THEN
            /*+ SE VALIDA QUE LA POLIZA NO TENGA SINIESTRO PENDIENTES */
            IF BLIFE
            THEN
               IF SPOLCERTYPE = INSGENERALPKG.SPOLICY
               THEN
                  IF BFOUNDCERTIF
                  THEN
                     REACOUNTCLAIM (SCERTYPE   => SPOLCERTYPE,
                                    NBRANCH    => NBRANCH,
                                    NPRODUCT   => NPRODUCT,
                                    NPOLICY    => NPOLICY,
                                    NCERTIF    => NCERTIF_AUX,
                                    NCOUNT     => NEXISTS);

                     /*+ SI EXISTEN SINIESTROS ASOCIADOS */
                     IF NEXISTS > 0
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '55778';
                     END IF;
                  END IF;
               END IF;
            END IF;

            /*+ SI ES UNA PROPUESTA/COTIZACION DE MODIFICACION SE VALIDA QUE NO TENGA PROPUESTAS ESPECIALES PENDIENTES */
            IF NGENTRANSAC = INSGENERALPKG.NAMENDPROPQUOT
               AND NTRANSACTION NOT IN
                      (INSGENERALPKG.NPOLICYQUOTAMENDENT,
                       INSGENERALPKG.NCERTIFQUOTAMENDENT)
            THEN
               REASPECIALPROPOSALCOUNT (
                  NBRANCH      => NBRANCH,
                  NPRODUCT     => NPRODUCT,
                  NPOLICY      => NPOLICY,
                  NCERTIF      => NCERTIF_AUX,
                  NSTATQUOTA   => INSGENERALPKG.ESQPENDING,
                  NCOUNT       => NEXISTS,
                  NPROPONUM    => NPROPONUM_AUX);

               IF NEXISTS > 0
               THEN
                  SERRORS :=
                        SERRORS
                     || INSGENERALPKG.SSEP
                     || '55779|0|1|'
                     || '('
                     || NPROPONUM_AUX
                     || ')';
               END IF;
            END IF;

            /*+ SI ES UNA MODIFICACION SE VERIFICA SI LA COBRANZA ESTA GENERADA SI LA TRANSACCION ES RE-EMISION */
            IF NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYREISSUE, INSGENERALPKG.NCERTIFREISSUE)
            THEN
               /*+ SI EL PRODUCTO ES DE VIDA ACTIVA SE VERIFICA SI TIENE VALOR POLIZA GENERADO */
               IF BLIFE
               THEN
                  /*+ SI SE TRATA DE UN PRODUCTO DE VIDA ACTIVA */
                  IF NPRODCLAS = 7
                  THEN
                     REAACCOUNT_POL (SCERTYPE   => SPOLCERTYPE,
                                     NBRANCH    => NBRANCH,
                                     NPRODUCT   => NPRODUCT,
                                     NPOLICY    => NPOLICY,
                                     NCERTIF    => NCERTIF_AUX,
                                     RC1        => C_ACCOUNT_POL);

                     FETCH C_ACCOUNT_POL INTO R_ACCOUNT_POL;

                     IF C_ACCOUNT_POL%FOUND
                     THEN
                        IF R_ACCOUNT_POL.NVALUEPOL > 0
                        THEN
                           SERRORS := SERRORS || INSGENERALPKG.SSEP || '55506';
                        END IF;
                     END IF;

                     CLOSE C_ACCOUNT_POL;
                  END IF;
               END IF;

               /*+ SE VALIDA QUE NO SE PUEDE RE-EMITIR POLIZAS QUE TENGAN RECIBOS O CUOTAS, COBRADAS.  */
               SSEL :=
                     'SELECT /*+ INDEX (PREMIUM XIF1364PREMIUM)*/ '
                  || '       NPREMIUM, NSTATUS_PRE, NCONTRAT      '
                  || '  FROM PREMIUM                              '
                  || ' WHERE SCERTYPE = :SCERTYPE                 '
                  || '   AND NBRANCH  = :NBRANCH                  '
                  || '   AND NPRODUCT = :NPRODUCT                 '
                  || '   AND NPOLICY  = :NPOLICY                  '
                  || '   AND NCERTIF  = :NCERTIF                  ';

               OPEN C_PREMIUM_STAT FOR SSEL
                  USING SPOLCERTYPE,
                        NBRANCH,
                        NPRODUCT,
                        NPOLICY,
                        NCERTIF_AUX;

               LOOP
                  FETCH C_PREMIUM_STAT
                  INTO NPREMIUM_AUX, NSTATUS_PRE_AUX, NCONTRAT_AUX;

                  EXIT WHEN C_PREMIUM_STAT%NOTFOUND OR NPAYPREMIUM = 2;

                  /*+ VERIFICA SI EL RECIVO ES FINANCIADO  */
                  IF NSTATUS_PRE_AUX = 8
                  THEN
                     SELECT COUNT (1)
                       INTO NCOUNT_AUX
                       FROM FINANC_DRA
                      WHERE NCONTRAT = INSVALCA001.NCONTRAT_AUX
                            AND NSTAT_DRAFT = 2;

                     IF NCOUNT_AUX > 0
                     THEN
                        NPAYPREMIUM := 2;
                     END IF;
                  /*+ SI NO ES FINANCIADO SE VERIFICA QUE ESTE PAGADO */
                  ELSIF NSTATUS_PRE_AUX IN (2, 5, 6, 7)
                  THEN
                     NPAYPREMIUM := 2;
                  END IF;
               END LOOP;

               CLOSE C_PREMIUM_STAT;

               IF NPAYPREMIUM = 2
               THEN
                  SERRORS :=
                        SERRORS
                     || INSGENERALPKG.SSEP
                     || '60576 |0|1|'
                     || ' NO PODRA RE-EMITIR ';
               ELSE
                  NBULLETINS_AUX := NULL;

                  BEGIN
                     SELECT                     /*+ INDEX ( P XDELPREMIUM ) */
                           B.NBULLETINS
                       INTO NBULLETINS_AUX
                       FROM PREMIUM P, BULLETINS_DET B
                      WHERE     P.SCERTYPE = INSVALCA001.SPOLCERTYPE
                            AND P.NBRANCH = INSVALCA001.NBRANCH
                            AND P.NPRODUCT = INSVALCA001.NPRODUCT
                            AND P.NPOLICY = INSVALCA001.NPOLICY
                            AND P.NCERTIF = INSVALCA001.NCERTIF_AUX
                            AND P.SCERTYPE = B.SCERTYPE
                            AND P.NRECEIPT = B.NRECEIPT
                            AND P.NBRANCH = B.NBRANCH
                            AND P.NPRODUCT = B.NPRODUCT
                            AND P.NDIGIT = B.NDIGIT
                            AND P.NPAYNUMBE = B.NPAYNUMBE
                            AND ROWNUM = 1;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NBULLETINS_AUX := NULL;
                  END;

                  IF NVL (NBULLETINS_AUX, 0) <> 0
                  THEN
                     SERRORS :=
                           SERRORS
                        || INSGENERALPKG.SSEP
                        || '750095 |0|1|'
                        || ':'
                        || TRIM (TO_CHAR (NBULLETINS_AUX));
                  END IF;
               END IF;
            END IF;

            /*+ SE VALIDA QUE LA POLIZA TENGA INGRESO DE PRIMERA PRIMA */
            IF NTRANSACTION IN
                  (INSGENERALPKG.NPROPOSALCONVERTION,
                   INSGENERALPKG.NQUOTATIONCONVERTION)
            THEN
               IF R_PRODUCT_GE.SFIRST_PAY = '1'
               THEN
                  IF NPOLICY > 0
                  THEN
                     /*+ SE BUSCA EL CONTRATANTE DE LA POLIZA*/
                     BEGIN
                        SELECT                   /*+ INDEX (ROLES XDELROLES)*/
                              SCLIENT
                          INTO SCLIENT
                          FROM ROLES
                         WHERE     SCERTYPE = INSVALCA001.SPOLCERTYPE
                               AND NBRANCH = INSVALCA001.NBRANCH
                               AND NPRODUCT = INSVALCA001.NPRODUCT
                               AND NPOLICY = INSVALCA001.NPOLICY
                               AND NCERTIF = INSVALCA001.NCERTIF
                               AND NROLE = 1
                               AND DEFFECDATE <= INSVALCA001.DEFFECDATE
                               AND (DNULLDATE IS NULL
                                    OR DNULLDATE > INSVALCA001.DEFFECDATE);
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           SCLIENT := NULL;
                     END;

                     REAPROPQUOTPREMIUM (SCERTYPE     => SPOLCERTYPE,
                                         NBRANCH      => NBRANCH,
                                         NPRODUCT     => NPRODUCT,
                                         NPOLICY      => NPOLICY,
                                         NCERTIF      => NCERTIF_AUX,
                                         DEFFECDATE   => DEFFECDATE,
                                         SCLIENT      => SCLIENT,
                                         RC1          => C_PREMIUM);

                     FETCH C_PREMIUM INTO R_PREMIUM;

                     IF C_PREMIUM%FOUND
                     THEN
                        NFIRSTPREMIUM := R_PREMIUM.NFIRSTPREMIUM;
                        NPREMPROP := R_PREMIUM.NPREMPROP;
                     ELSE
                        NFIRSTPREMIUM := 0;
                        NPREMPROP := 0;
                     END IF;

                     CLOSE C_PREMIUM;
                  ELSE
                     NFIRSTPREMIUM := 0;
                  END IF;

                  IF NFIRSTPREMIUM <= 0
                  THEN
                     /*+ SE VERIFICA SI ESTA AUTORIZADA LA PROPUESTA SIN PAGO DE PRIMA INCIAL ANTES DE ENVIAR LA VALIDACION*/
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '55507';
                  ELSE
                     IF NPREMPROP > 0
                     THEN
                        /*+CAMBIA EL MARGEN DE TOLERANCIA DE PESO A UD */
                        --                            BEGIN
                        --                                SELECT REAGENERALPKG.CONVERTEXCHANGE(NULL,NVL(NLOWER_LIM,0),1,4,DEFFECDATE)
                        --                                  INTO NLOWER_LIM
                        --                                  FROM OPT_PREMIU
                        --                                 WHERE ROWNUM = 1;
                        --                            EXCEPTION
                        --                                WHEN OTHERS THEN
                        --                                    NLOWER_LIM := NULL;
                        --                            END;
                        NLOWER_LIM :=
                           GETLOWER_LIMEXC (DEFFECDATE, 4, NPREMPROP);

                        IF NFIRSTPREMIUM + NVL (NLOWER_LIM, 0) < NPREMPROP
                        THEN
                           IF NVL (NPRODCLAS, 1) = 4
                           THEN
                              SERRORS :=
                                 SERRORS || INSGENERALPKG.SSEP || '750131';
                           ELSE
                              SERRORS :=
                                 SERRORS || INSGENERALPKG.SSEP || '60017';
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;

            /*+ SI LA TRANSACCION ES MODIFICACION, O PROPUESTAS DE MODIFICACION */
            IF NGENTRANSAC IN
                  (INSGENERALPKG.NAMEND, INSGENERALPKG.NAMENDPROPQUOT)
               AND NTRANSACTION NOT IN
                      (INSGENERALPKG.NPOLICYQUOTAMENDENT,
                       INSGENERALPKG.NCERTIFQUOTAMENDENT)
            THEN
               /*+ SE VALIDA QUE LA POLIZA NO TENGA OTRAS COTIZACIONES PENDIENTES */
               REAPOLICY_QUOTPROP (SCERTYPE     => SPOLCERTYPE,
                                   NBRANCH      => NBRANCH,
                                   NPRODUCT     => NPRODUCT,
                                   NPOLICY      => NPOLICY,
                                   NCERTIF      => NCERTIF_AUX,
                                   NSTATQUOTA   => INSGENERALPKG.ESQPENDING,
                                   NPROPQUOT    => NPROPQUOT,
                                   RC1          => C_CERTIF_QUOT);

               FETCH C_CERTIF_QUOT INTO R_CERTIF_QUOT;

               IF C_CERTIF_QUOT%FOUND
               THEN
                  BOK := TRUE;
               ELSE
                  BOK := FALSE;
               END IF;

               SQUOTPROP_AUX := NULL;

               WHILE C_CERTIF_QUOT%FOUND
               LOOP
                  IF SQUOTPROP_AUX IS NULL
                  THEN
                     SQUOTPROP_AUX := SQUOTPROP_AUX || R_CERTIF_QUOT.NPOLICY;
                  ELSE
                     SQUOTPROP_AUX :=
                        SQUOTPROP_AUX || ',' || R_CERTIF_QUOT.NPOLICY;
                  END IF;

                  FETCH C_CERTIF_QUOT INTO R_CERTIF_QUOT;
               END LOOP;

               CLOSE C_CERTIF_QUOT;

               IF BOK
               THEN
                  SERRORS :=
                        SERRORS
                     || INSGENERALPKG.SSEP
                     || '55649|0|1|'
                     || '('
                     || SQUOTPROP_AUX
                     || ')';
               END IF;
            END IF;

            /*+ SI LA POLIZA SE ENCUENTRA EN SUSPENSION DE GARANTIA */
            IF NGENTRANSAC = INSGENERALPKG.NAMEND
            THEN
               /*+ SE VALIDA QUE LA FECHA DE MODIFICACION DE LA POLIZA NO SE ENCUENTRE EN EL PERIODO DE SUSPENSION DE GARANTIA */
               REASUSPEND (SCERTYPE     => SPOLCERTYPE,
                           NBRANCH      => NBRANCH,
                           NPRODUCT     => NPRODUCT,
                           NPOLICY      => NPOLICY,
                           NCERTIF      => NCERTIF_AUX,
                           DEFFECDATE   => DEFFECDATE,
                           RC1          => C_SUSPEND);

               FETCH C_SUSPEND INTO R_SUSPEND;

               IF C_SUSPEND%FOUND
               THEN
                  IF DEFFECDATE >= R_SUSPEND.DEFFECDATE
                     AND DEFFECDATE <= R_SUSPEND.DEXPIRDAT
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '3994';
                  END IF;
               END IF;

               CLOSE C_SUSPEND;
            END IF;

            /*+ SI LA POLIZA ES COLECTIVA Y LA TRANSACCION ES CONVERSION SE VALIDA LA CANTIDAD MINIMA DE CERTIFICADOS */
            IF SPOLITYPE = INSGENERALPKG.SCOLECTIVE
            THEN
               IF NTRANSACTION IN
                     (INSGENERALPKG.NQUOTATIONCONVERTION,
                      INSGENERALPKG.NPROPOSALCONVERTION)
               THEN
                  IF R_POLICY.SINSUBANK <> '1'
                  THEN
                     REACERTIFCOUNT (SCERTYPE   => SPOLCERTYPE,
                                     NBRANCH    => NBRANCH,
                                     NPRODUCT   => NPRODUCT,
                                     NPOLICY    => NPOLICY,
                                     NCOUNT     => NCOUNT);

                     IF R_PRODUCT_GE.NQ_CERTIF > NCOUNT
                     THEN
                        SERRORS := SERRORS || INSGENERALPKG.SSEP || '55653';
                     END IF;
                  END IF;
               END IF;
            END IF;

            /*+  SI LA TRANSACION ES EMITIR PROPUESTA POLIZA/CERTIFICADO Y EL NUMERO */
            /*+  DE PROPUESTA REGULARIZADA ES DISTINTO DE VACIO, ESTA PROPUESTA */
            /*+  DEBE EXISTIR EN EL SISTEMA Y NO ESTAR ANULADA O EL MOTIVO DE ANULACION PERMITA REEMISION. */
            IF (NTRANSACTION = INSGENERALPKG.NPOLICYPROPOSAL
                OR NTRANSACTION = INSGENERALPKG.NCERTIFPROPOSAL)
               AND NPROP_REG IS NOT NULL
            THEN
               NCOUNT_PREG := 1;

               BEGIN
                  SELECT NSTATQUOTA, NNO_CONVERS
                    INTO NSTATQUOTA_PREG, NNO_CONVERS_PREG
                    FROM CERTIFICAT
                   WHERE     SCERTYPE = SPOLCERTYPE
                         AND NPOLICY = INSVALCA001.NPROP_REG
                         AND NCERTIF = NCERTIF_AUX
                         AND ROWNUM = 1;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NCOUNT_PREG := 0;
               END;

               /*+ SI EXISTE INFORMACION */
               IF NCOUNT_PREG <> 0
               THEN
                  IF NSTATQUOTA_PREG <> 4 OR NNO_CONVERS_PREG <> 34
                  THEN
                     SERRORS := SERRORS || INSGENERALPKG.SSEP || '60545';
                  END IF;
               ELSE
                  SERRORS := SERRORS || INSGENERALPKG.SSEP || '60544';
               END IF;
            END IF;
         END IF;
      END IF;


      /*+ SE VALIDA QUE EXISTA EL NUMERADOR CORRESPONDIENTE A POLIZAS POR RAMOS.*/
      BEGIN
         SELECT 1
           INTO STOO_SELCNT
           FROM DUAL
          WHERE NOT EXISTS
                       (SELECT ROWID, NLASTNUMB, NEND_NUM
                          FROM NUMERATOR
                         WHERE     NTYPENUM = 2
                               AND NORD_NUM = NBRANCH
                               AND NLASTNUMB < NEND_NUM);
      EXCEPTION
         WHEN OTHERS
         THEN
            STOO_SELCNT := 0;
      END;

      /*+ SI LA LINEA DE ASIENTO NO EXISTE.*/
      IF STOO_SELCNT != 0
      THEN
         IF NOT BERRORS
         THEN
            SERRORS := SERRORS || INSGENERALPKG.SSEP || '10295';
            BERRORS := TRUE;
         END IF;
      END IF;

      ARRAYERRORS := SUBSTR (SERRORS, 3);
   END INSVALCA001;

   PROCEDURE INSPOLICY_CA001 /*---------------------------------------------------------------------------------*/
                            /* NOMBRE    : INSPOLICY_CA001                                                     */
                            /* OBJETIVO  :                                                                     */
                            /*                                                                                 */
                            /* SOURCESAFE INFORMATION                                                              */
                            /*     $AUTHOR: NVAPLAT28 $*/
                            /*     $DATE: 10/05/04 16.11 $*/
                            /*     $REVISION: 43 $*/
                            /*---------------------------------------------------------------------------------*/
   (NTRANSACTION    TABLE221.NCODIGINT%TYPE,
    SCERTYPE        CERTIFICAT.SCERTYPE%TYPE,
    NBRANCH         CERTIFICAT.NBRANCH%TYPE,
    NPRODUCT        CERTIFICAT.NPRODUCT%TYPE,
    NPOLICY         CERTIFICAT.NPOLICY%TYPE,
    NCERTIF         CERTIFICAT.NCERTIF%TYPE,
    NUSERCODE       CERTIFICAT.NUSERCODE%TYPE,
    DEFFECDATE      CERTIFICAT.DSTARTDATE%TYPE,
    NOFFICE         POLICY.NOFFICE%TYPE,
    SBUSSITYP       POLICY.SBUSSITYP%TYPE,
    SPOLITYPE       POLICY.SPOLITYPE%TYPE,
    DNULLDATE       CERTIFICAT.DNULLDATE%TYPE,
    NAGENCY         POLICY.NAGENCY%TYPE,
    NOFFICEAGEN     POLICY.NOFFICEAGEN%TYPE,
    NPOL_QUOT       CERTIFICAT.NPOL_QUOT%TYPE)
   AS
      C_PRODUCT_LI         REAPRODUCT_LIPKG.RCT1;
      SPROVTAX_AUX         POLICY.SPROVTAX%TYPE;
      SHOLDERPROVTAX_AUX   POLICY.SHOLDERPROVTAX%TYPE;
   BEGIN
      SPROVTAX_AUX := NULL;
      SHOLDERPROVTAX_AUX := NULL;

      R_POLICY.SCERTYPE := SCERTYPE;
      R_POLICY.NBRANCH := NBRANCH;
      R_POLICY.NPRODUCT := NPRODUCT;
      R_POLICY.NPOLICY := NPOLICY;
      R_POLICY.NUSERCODE := NUSERCODE;

      /*+SI SE TRATA DE LA EMISION DE UNA COTIZACION O SOLICITUD SE GUARDA EL NUMERO*/
      /*+EN OTRO CAMPO*/
      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYQUOTATION,
             INSGENERALPKG.NCERTIFQUOTATION,
             INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NCERTIFPROPOSAL,
             INSGENERALPKG.NPOLICYAMENDMENT,
             INSGENERALPKG.NTEMPPOLICYAMENDMENT)
      THEN
         R_POLICY.SSTATUS_POL := '3';
         R_POLICY.SPROPO_CERT := SCERTYPE;
         R_POLICY.STYPE_PROP := '1';
      ELSIF NTRANSACTION IN
               (INSGENERALPKG.NQUOTATIONCONVERTION,
                INSGENERALPKG.NPROPOSALCONVERTION)
      THEN
         R_POLICY.NPROPONUM := NPOLICY;
      END IF;

      /*+SE ASIGNA EL VALOR DEL USUARIO DE LA MODIFICACION*/
      R_POLICY.NUSER_AMEND := NULL;

      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYAMENDMENT,
             INSGENERALPKG.NCERTIFAMENDMENT,
             INSGENERALPKG.NTEMPPOLICYAMENDMENT,
             INSGENERALPKG.NTEMPCERTIFAMENDMENT,
             INSGENERALPKG.NRECUPERATION,
             INSGENERALPKG.NPOLICYISSUE,
             INSGENERALPKG.NCERTIFISSUE,
             INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NCERTIFPROPOSAL)
      THEN
         IF NCERTIF = 0
         THEN
            R_POLICY.NUSER_AMEND := NUSERCODE;
         END IF;
      END IF;

      /*+ASIGNACION DEL PARAMETRO ESTADO DE LA POLIZA COMO EN CAPTURA IMCOMPLETA SOLO SI SE ESTA EMITIENDO*/
      IF NTRANSACTION = INSGENERALPKG.NPOLICYISSUE
      THEN
         R_POLICY.SSTATUS_POL := '3';
      END IF;

      /*+ SE ASIGNA LA FECHA DE EFECTO SOLO CUANDO CORRESPONDA A UNA EMISION*/
      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYISSUE,
             INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NPOLICYQUOTATION,
             INSGENERALPKG.NPOLICYQUOTAMENDENT,
             INSGENERALPKG.NCERTIFQUOTAMENDENT,
             INSGENERALPKG.NPOLICYQUOTRENEWAL,
             INSGENERALPKG.NCERTIFQUOTRENEWAL,
             INSGENERALPKG.NPOLICYPROPAMENDENT,
             INSGENERALPKG.NCERTIFPROPAMENDENT,
             INSGENERALPKG.NPOLICYPROPRENEWAL,
             INSGENERALPKG.NCERTIFPROPRENEWAL)
      THEN
         R_POLICY.DDATE_ORIGI := DEFFECDATE;
         R_POLICY.SDIRDEBIT := NULL;
         R_POLICY.DSTARTDATE := DEFFECDATE;
         R_POLICY.SIND_COMM := '1';
         R_POLICY.SCONCOLL := '2';
         /*+INDICA LA EXISTENCIA DE COASEGURO CEDIDO*/
         R_POLICY.SCOINSURI := '2';
      END IF;

      /*+ SI LA TRANSACION ES EMISION, COTIZACION O PROPUESTA DE POLIZA O CERTIFICADO*/
      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYISSUE,
             INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NPOLICYQUOTATION)
      THEN
         IF BPRODUCT
         THEN
            IF NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYPROPOSAL,
                   INSGENERALPKG.NPOLICYQUOTATION)
            THEN
               IF NOT BPOLICY
               THEN
                  R_POLICY.SINDEXTYP := R_PRODUCT.SREVALTYP;
                  R_POLICY.SRENEWAL := R_PRODUCT.SRENEWAL;
                  R_POLICY.SREVALAPL := R_PRODUCT.SREVALAPL;
                  R_POLICY.STYP_CLAUSE := R_PRODUCT.STYP_CLAUSE;
                  R_POLICY.STYP_DISCXP := R_PRODUCT.STYP_DISCXP;
                  R_POLICY.STYP_MODULE := R_PRODUCT.STYP_MODULE;
                  R_POLICY.NINDEXFAC := R_PRODUCT.NREVALRAT;
                  R_POLICY.NPAYFREQ := R_PRODUCT.NPAYFREQ;
                  R_POLICY.NCOPIES := R_PRODUCT.NCOPIES;
                  R_POLICY.NNOTICE := R_PRODUCT.NCANCNOTI;
               END IF;
            ELSE
               R_POLICY.SINDEXTYP := R_PRODUCT.SREVALTYP;
               R_POLICY.SRENEWAL := R_PRODUCT.SRENEWAL;
               R_POLICY.SREVALAPL := R_PRODUCT.SREVALAPL;
               R_POLICY.STYP_CLAUSE := R_PRODUCT.STYP_CLAUSE;
               R_POLICY.STYP_DISCXP := R_PRODUCT.STYP_DISCXP;
               R_POLICY.STYP_MODULE := R_PRODUCT.STYP_MODULE;
               R_POLICY.NINDEXFAC := R_PRODUCT.NREVALRAT;
               R_POLICY.NPAYFREQ := R_PRODUCT.NPAYFREQ;
               R_POLICY.NCOPIES := R_PRODUCT.NCOPIES;
               R_POLICY.NNOTICE := R_PRODUCT.NCANCNOTI;
            END IF;
         END IF;
      END IF;

      /*+ASIGNACION DEL PARAMETRO SUCURSAL*/
      R_POLICY.NOFFICE := NOFFICE;

      /*+ASIGNACION DEL PARAMETRO PROPIETARIA*/
      R_POLICY.NOFFICE_OWN := NOFFICE;

      /*+ASIGNACION DEL PARAMETRO TIPO DE POLIZA*/
      R_POLICY.SBUSSITYP := SBUSSITYP;

      /*+ASIGNACION DEL PARAMETRO TIPO DE POLIZA*/
      R_POLICY.SPOLITYPE := SPOLITYPE;

      /*+ASIGNACION DEL PARAMETRO DE NUMERO DE LA AGENCIA*/
      R_POLICY.NAGENCY := NAGENCY;

      /*+ASIGNACION DEL PARAMETRO DE NUMERO DE LA OFICINA*/
      R_POLICY.NOFFICEAGEN := NOFFICEAGEN;

      /*+INDICA SI LA POLIZA TIENE ASOCIADA UNA CUENTA CORRIENTE*/
      R_POLICY.SACCOUNTI := '2';

      /*+INDICA LA EXISTENCIA DE COASEGURO CEDIDO*/
      --    R_POLICY.SCOINSURI := '2';

      /*+SE INICIALIZA EL CODIGO DE ANULACION CON CEROS*/
      R_POLICY.NNULLCODE := NULL;

      /*+INDICA SI LA POLIZA SUSTITUYE A OTRA*/
      R_POLICY.SSUBSTITI := 2;

      /*+SE INICIALIZA EL TIPO DE RECIBO*/
      IF R_POLICY.SPOLITYPE = '1'
      THEN
         R_POLICY.SCOLINVOT := '2';
      END IF;

      R_POLICY.NLAST_CERTI := NCERTIF;

      /*+ SI SE TRATA DE UNA RE-EMISION O DE RE-IMPRESION SE CAMBIA EL ESTADO DE LA POLIZA*/

      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYREISSUE, INSGENERALPKG.NCERTIFREISSUE)
      THEN
         IF NTRANSACTION = INSGENERALPKG.NPOLICYREISSUE
         THEN
            R_POLICY.SSTATUS_POL := '3';
         END IF;

         R_POLICY.DDATE_ORIGI := DEFFECDATE;
         R_POLICY.DSTARTDATE := DEFFECDATE;
         R_POLICY.DISSUEDAT := TRUNC (SYSDATE);
      ELSE
         IF NTRANSACTION = INSGENERALPKG.NREPRINT
         THEN
            R_POLICY.SSTATUS_POL := '4';
         END IF;
      END IF;

      IF R_PRODUCT.SBRANCHT = '1'
      THEN
         REAPRODUCT_LI (NBRANCH      => NBRANCH,
                        NPRODUCT     => NPRODUCT,
                        DEFFECDATE   => DEFFECDATE,
                        RC1          => C_PRODUCT_LI);

         FETCH C_PRODUCT_LI INTO R_PRODUCT_LI;

         BPRODUCT := C_PRODUCT_LI%FOUND;

         CLOSE C_PRODUCT_LI;

         IF BPRODUCT
         THEN
            IF R_PRODUCT_LI.NPRODCLAS <> 4
            THEN
               R_POLICY.SCURRACC := '1';
            ELSE
               R_POLICY.SCURRACC := '4';
            END IF;
         END IF;
      END IF;


      /*+ SE RECUPERAN LOS VALORES DE LOS CAMPOS (SPROVTAX,SHOLDERPROVTAX) DE LA PÓLIZA            */
      BEGIN
         SELECT P.SPROVTAX, P.SHOLDERPROVTAX
           INTO INSPOLICY_CA001.SPROVTAX_AUX,
                INSPOLICY_CA001.SHOLDERPROVTAX_AUX
           FROM POLICY P
          WHERE     P.NPOLICY = R_POLICY.NPOLICY
                AND P.NPRODUCT = R_POLICY.NPRODUCT
                AND P.NBRANCH = R_POLICY.NBRANCH
                AND P.SCERTYPE = R_POLICY.SCERTYPE;
      EXCEPTION
         WHEN OTHERS
         THEN
            INSPOLICY_CA001.SPROVTAX_AUX := NULL;
            INSPOLICY_CA001.SHOLDERPROVTAX_AUX := NULL;
      END;

      INSPOLICY (SCERTYPE         => R_POLICY.SCERTYPE,
                 NBRANCH          => R_POLICY.NBRANCH,
                 NPRODUCT         => R_POLICY.NPRODUCT,
                 NPOLICY          => R_POLICY.NPOLICY,
                 SCLIENT          => R_POLICY.SCLIENT,
                 SACCOUNTI        => R_POLICY.SACCOUNTI,
                 NAMOUCOMM        => R_POLICY.NAMOUCOMM,
                 SBUSSITYP        => R_POLICY.SBUSSITYP,
                 NCAPITAL         => R_POLICY.NCAPITAL,
                 DCHANGDAT        => R_POLICY.DCHANGDAT,
                 SCOINSURI        => R_POLICY.SCOINSURI,
                 NCOLCLADI        => R_POLICY.NCOLCLADI,
                 SCOLINVOT        => R_POLICY.SCOLINVOT,
                 SCOLREINT        => R_POLICY.SCOLREINT,
                 SCOLTIMRE        => R_POLICY.SCOLTIMRE,
                 NCOMMISSI        => R_POLICY.NCOMMISSI,
                 SCOMMITYP        => R_POLICY.SCOMMITYP,
                 NCOPIES          => R_POLICY.NCOPIES,
                 DDAT_NO_CON      => R_POLICY.DDAT_NO_CON,
                 DDATE_ORIGI      => R_POLICY.DDATE_ORIGI,
                 SDECLARI         => R_POLICY.SDECLARI,
                 SDIRDEBIT        => R_POLICY.SDIRDEBIT,
                 DSTARTDATE       => R_POLICY.DSTARTDATE,
                 DEXPIRDAT        => R_POLICY.DEXPIRDAT,
                 NINDEXFAC        => R_POLICY.NINDEXFAC,
                 SINDEXTYP        => R_POLICY.SINDEXTYP,
                 NINTERMED        => R_POLICY.NINTERMED,
                 DISSUEDAT        => R_POLICY.DISSUEDAT,
                 NLAST_CERTI      => R_POLICY.NLAST_CERTI,
                 NLEADCOMI        => R_POLICY.NLEADCOMI,
                 NLEADCOMP        => R_POLICY.NLEADCOMP,
                 NLEADEXPE        => R_POLICY.NLEADEXPE,
                 SLEADINVO        => R_POLICY.SLEADINVO,
                 SLEADNOTI        => R_POLICY.SLEADNOTI,
                 SLEADPOLI        => R_POLICY.SLEADPOLI,
                 NLEADSHARE       => R_POLICY.NLEADSHARE,
                 DMAXIMUM_DA      => R_POLICY.DMAXIMUM_DA,
                 NNO_CONVERS      => R_POLICY.NNO_CONVERS,
                 NNOTE_ADEND      => R_POLICY.NNOTE_ADEND,
                 NNOTE_BENEF      => R_POLICY.NNOTE_BENEF,
                 NNOTE_COMME      => R_POLICY.NNOTE_COMME,
                 NNOTE_CONDI      => R_POLICY.NNOTE_CONDI,
                 NNOTE_COVER      => R_POLICY.NNOTE_COVER,
                 NNOTICE          => R_POLICY.NNOTICE,
                 NNULLCODE        => R_POLICY.NNULLCODE,
                 NOFFICE          => R_POLICY.NOFFICE,
                 NOFFICE_OWN      => R_POLICY.NOFFICE_OWN,
                 NPARTICIP        => R_POLICY.NPARTICIP,
                 NPAYFREQ         => R_POLICY.NPAYFREQ,
                 SPOLITYPE        => R_POLICY.SPOLITYPE,
                 NPREMIUM         => R_POLICY.NPREMIUM,
                 SPROPO_CERT      => R_POLICY.SPROPO_CERT,
                 NPROPONUM        => R_POLICY.NPROPONUM,
                 DPROPODAT        => R_POLICY.DPROPODAT,
                 NQ_CERTIF        => R_POLICY.NQ_CERTIF,
                 SRENEWAL         => R_POLICY.SRENEWAL,
                 SREVALAPL        => R_POLICY.SREVALAPL,
                 NSHARE           => R_POLICY.NSHARE,
                 SPRORSHORT       => R_POLICY.SPRORSHORT,
                 NMOV_HISTOR      => R_POLICY.NMOV_HISTOR,
                 SSTATUS_POL      => R_POLICY.SSTATUS_POL,
                 SSUBSTITI        => R_POLICY.SSUBSTITI,
                 NTARIFF          => R_POLICY.NTARIFF,
                 NTRANSACTIO      => R_POLICY.NTRANSACTIO,
                 STYP_CLAUSE      => R_POLICY.STYP_CLAUSE,
                 STYP_DISCXP      => R_POLICY.STYP_DISCXP,
                 STYP_MODULE      => R_POLICY.STYP_MODULE,
                 NUSER_AMEND      => R_POLICY.NUSER_AMEND,
                 NUSERCODE        => R_POLICY.NUSERCODE,
                 DNEXTRECEIP      => R_POLICY.DNEXTRECEIP,
                 NQUOTA           => R_POLICY.NQUOTA,
                 SNONULL          => R_POLICY.SNONULL,
                 SCONCOLL         => R_POLICY.SCONCOLL,
                 STYPE_PROP       => R_POLICY.STYPE_PROP,
                 NOFICIAL_P       => R_POLICY.NOFICIAL_P,
                 SNUMFORM         => R_POLICY.SNUMFORM,
                 NDAYSFQ          => R_POLICY.NDAYSFQ,
                 NDAYSSQ          => R_POLICY.NDAYSSQ,
                 NCOMPANY         => R_POLICY.NCOMPANY,
                 SORIGINAL        => R_POLICY.SORIGINAL,
                 NOFFICEINS       => R_POLICY.NOFFICEINS,
                 NCOD_AGREE       => R_POLICY.NCOD_AGREE,
                 SINSUBANK        => R_POLICY.SINSUBANK,
                 SLEG             => R_POLICY.SLEG,
                 NAGENCY          => R_POLICY.NAGENCY,
                 NOFFICEAGEN      => R_POLICY.NOFFICEAGEN,
                 STYPENOM         => R_POLICY.STYPENOM,
                 SNOPAYROLL       => R_POLICY.SNOPAYROLL,
                 SCOLTPRES        => R_POLICY.SCOLTPRES,
                 SIND_COMM        => R_POLICY.SIND_COMM,
                 SCURRACC         => R_POLICY.SCURRACC,
                 NREPINSURED      => R_POLICY.NREPINSURED,
                 NCLAIM_NOTICE    => R_POLICY.NCLAIM_NOTICE,
                 SMASSIVE         => R_POLICY.SMASSIVE,
                 SREPPRINTCOV     => R_POLICY.SREPPRINTCOV,
                 SRECEIPT_IND     => R_POLICY.SRECEIPT_IND,
                 SDOCUTYP         => R_POLICY.SDOCUTYP,
                 NTERM_GRACE      => R_POLICY.NTERM_GRACE,
                 SPROVTAX         => INSPOLICY_CA001.SPROVTAX_AUX,
                 SHOLDERPROVTAX   => INSPOLICY_CA001.SHOLDERPROVTAX_AUX,
                 SREMOVEINDEX     => R_POLICY.SREMOVEINDEX,
                 NADJAPPTYPE      => R_POLICY.NADJAPPTYPE,
                 NCOMMIT          => 2);

      COMMIT;
   END INSPOLICY_CA001;


   PROCEDURE INSCERTIFICAT_CA001 /*---------------------------------------------------------------------------------*/
                                /* NOMBRE    : INSCERTIFICAT_CA001                                                 */
                                /* OBJETIVO  :                                                                     */
                                /*                                                                                 */
                                /* SOURCESAFE INFORMATION                                                              */
                                /*     $AUTHOR: NVAPLAT28 $*/
                                /*     $DATE: 10/05/04 16.11 $*/
                                /*     $REVISION: 43 $*/
                                /*---------------------------------------------------------------------------------*/
   (NTRANSACTION    TABLE221.NCODIGINT%TYPE,
    SCERTYPE        CERTIFICAT.SCERTYPE%TYPE,
    NBRANCH         CERTIFICAT.NBRANCH%TYPE,
    NPRODUCT        CERTIFICAT.NPRODUCT%TYPE,
    NPOLICY         CERTIFICAT.NPOLICY%TYPE,
    NCERTIF         CERTIFICAT.NCERTIF%TYPE,
    NUSERCODE       CERTIFICAT.NUSERCODE%TYPE,
    DEFFECDATE      CERTIFICAT.DSTARTDATE%TYPE,
    NSELLCHANNEL    CERTIFICAT.NSELLCHANNEL%TYPE,
    DFER            CERTIFICAT.DFER%TYPE,
    NPOL_QUOT       CERTIFICAT.NPOL_QUOT%TYPE,
    NDIGIT          CERTIFICAT.NDIGIT%TYPE,
    NPROP_REG       CERTIFICAT.NPROP_REG%TYPE,
    NRENEWALNUM     CERTIFICAT.NRENEWALNUM%TYPE,
    NFOLIO          CERTIFICAT.NFOLIO%TYPE DEFAULT NULL)
   AS
      STYPE       USERS.STYPE%TYPE;
      NCOUNT      NUMBER;
      SCLIENT     USERS.SCLIENT%TYPE;
      NINTERMED   INTERMEDIA.NINTERMED%TYPE;
      NINTERTYP   INTERMEDIA.NINTERTYP%TYPE;
   /*- OBJETOS PARA OBTENER LOS DATOS DEL CERTIFICADO*/
   BEGIN
      R_CERTIFICAT.SCERTYPE := SCERTYPE;
      R_CERTIFICAT.NBRANCH := NBRANCH;
      R_CERTIFICAT.NPRODUCT := NPRODUCT;
      R_CERTIFICAT.NPOLICY := NPOLICY;
      R_CERTIFICAT.NCERTIF := NCERTIF;
      R_CERTIFICAT.NUSERCODE := NUSERCODE;
      R_CERTIFICAT.NDIGIT := NDIGIT;
      R_CERTIFICAT.NPROP_REG := NPROP_REG;
      R_CERTIFICAT.NRENEWALNUM := NRENEWALNUM;

      /*+ SI SE TRATA DE LA EMISION DE UNA COTIZACION O SOLICITUD SE GUARDA EL NUMERO*/
      /*+ EN OTRO CAMPO*/
      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYQUOTATION,
             INSGENERALPKG.NCERTIFQUOTATION,
             INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NCERTIFPROPOSAL)
      THEN
         IF NTRANSACTION IN
               (INSGENERALPKG.NQUOTATIONCONVERTION,
                INSGENERALPKG.NPROPOSALCONVERTION)
         THEN
            R_CERTIFICAT.NPROPONUM := NPOLICY;
         END IF;

         R_CERTIFICAT.NSTATQUOTA := 1;
      END IF;

      /*+ASIGNACION DEL PARAMETRO FECHA DE EFECTO*/
      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYAMENDMENT,
             INSGENERALPKG.NCERTIFAMENDMENT,
             INSGENERALPKG.NTEMPPOLICYAMENDMENT,
             INSGENERALPKG.NTEMPCERTIFAMENDMENT)
      THEN
         R_CERTIFICAT.DCHANGDAT := DEFFECDATE;
      END IF;

      /*+SE ASIGNA EL VALOR DEL USUARIO DE LA MODIFICACION*/
      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYAMENDMENT,
             INSGENERALPKG.NCERTIFAMENDMENT,
             INSGENERALPKG.NTEMPPOLICYAMENDMENT,
             INSGENERALPKG.NTEMPCERTIFAMENDMENT,
             INSGENERALPKG.NRECUPERATION,
             INSGENERALPKG.NPOLICYISSUE,
             INSGENERALPKG.NCERTIFISSUE,
             INSGENERALPKG.NCERTIFPROPOSAL,
             INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NPOLICYQUOTATION,
             INSGENERALPKG.NCERTIFQUOTATION)
      THEN
         R_CERTIFICAT.NUSER_AMEND := NUSERCODE;
      ELSE
         R_CERTIFICAT.NUSER_AMEND := NULL;
      END IF;

      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYISSUE,
             INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NPOLICYQUOTATION,
             INSGENERALPKG.NCERTIFISSUE,
             INSGENERALPKG.NCERTIFPROPOSAL,
             INSGENERALPKG.NCERTIFQUOTATION)
      THEN
         /*+ASIGNACION DEL PARAMETRO FECHA DE EFECTO DE LA POLIZA*/
         /*+SE ASIGNA LA FECHA DE EFECTO SOLO CUANDO CORRESPONDA A UNA EMISION*/
         R_CERTIFICAT.DSTARTDATE := DEFFECDATE;
         R_CERTIFICAT.DCHANGDAT := DEFFECDATE;
         R_CERTIFICAT.DDATE_ORIGI := DEFFECDATE;

         /*+ASIGNACION DEL PARAMETRO INDICADOR DE REASEGURO*/
         R_CERTIFICAT.SREINSURA := '2';
         R_CERTIFICAT.DISSUEDAT := TRUNC (SYSDATE);
         R_CERTIFICAT.DDATE_ACCEPT := TRUNC (SYSDATE);
      END IF;

      /*+ SI CORRESPONDE A UN RE-EMISION*/
      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYREISSUE, INSGENERALPKG.NCERTIFREISSUE)
      THEN
         R_CERTIFICAT.DDATE_ORIGI := DEFFECDATE;
         R_CERTIFICAT.DCHANGDAT := DEFFECDATE;
         R_CERTIFICAT.DISSUEDAT := TRUNC (SYSDATE);
         R_CERTIFICAT.DSTARTDATE := DEFFECDATE;
      END IF;

      /*+ SI CORRESPONDE A EMISION DE CERTIFICADOS Y ES DE VIDA NDURATION = NULL*/
      IF NTRANSACTION IN
            (INSGENERALPKG.NCERTIFISSUE,
             INSGENERALPKG.NCERTIFQUOTATION,
             INSGENERALPKG.NCERTIFPROPOSAL)
         AND R_PRODUCT.SBRANCHT = '1'
      THEN
         R_CERTIFICAT.NDURATION := NULL;
      END IF;

      /*+ASIGNACION DEL PARAMETRO ESTADO DEL CERTIFICADO*/
      R_CERTIFICAT.SSTATUSVA := '3';

      /*+SE INICIALIZA EL CODIGO DE ANULACION CON CEROS*/
      R_CERTIFICAT.NNULLCODE := NULL;

      /*+SE INICIALIZA EL CODIGO DEL CANAL DE VENTA*/
      R_CERTIFICAT.NSELLCHANNEL := NSELLCHANNEL;

      /*+SE INICIALIZA EL CODIGO DEL CANAL DE VENTA*/
      R_CERTIFICAT.DFER := DFER;
      /*+ SE ASIGNA EL VALOR A LA POLIZA ASOCIADA A LA COTIZACION EN TRATAMIENTO*/
      R_CERTIFICAT.NPOL_QUOT := NPOL_QUOT;

      /*+ SE ASIGNA LA FECHA DE TARIFA*/
      R_CERTIFICAT.DTARIFFDATE := DEFFECDATE;

      /*+ SI SE TRATA DE UNA COTIZACION/PROPUESTA DE POLIZA/CERTIFICADO*/
      /*+ PROPUESTA DE MODIFICACION/RENOVACION DE POLIZA/CERTIFICADO,*/
      /*+ COTIZACION DE MODIFICACION/RENOCACION DE POLIZA CERTIFICADO*/
      /*+ LA CAUSA DE ESTADO PENDIENTE "NWAIT_CODE" DEBE SER 1*/
      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYQUOTATION,
             INSGENERALPKG.NCERTIFQUOTATION,
             INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NCERTIFPROPOSAL,
             INSGENERALPKG.NPOLICYQUOTAMENDENT,
             INSGENERALPKG.NCERTIFQUOTAMENDENT,
             INSGENERALPKG.NPOLICYPROPAMENDENT,
             INSGENERALPKG.NCERTIFPROPAMENDENT,
             INSGENERALPKG.NPOLICYQUOTRENEWAL,
             INSGENERALPKG.NCERTIFQUOTRENEWAL,
             INSGENERALPKG.NPOLICYPROPRENEWAL,
             INSGENERALPKG.NCERTIFPROPRENEWAL)
         AND NTRANSACTION NOT IN
                (INSGENERALPKG.NPROPREHABILITATE,
                 INSGENERALPKG.NMODPROPREHABQUERY)
      THEN
         R_CERTIFICAT.NWAIT_CODE := 1;
      END IF;

      INSCERTIFICAT (SCERTYPE         => R_CERTIFICAT.SCERTYPE,
                     NBRANCH          => R_CERTIFICAT.NBRANCH,
                     NPRODUCT         => R_CERTIFICAT.NPRODUCT,
                     NPOLICY          => R_CERTIFICAT.NPOLICY,
                     NCERTIF          => R_CERTIFICAT.NCERTIF,
                     SCLIENT          => R_CERTIFICAT.SCLIENT,
                     NCAPITAL         => R_CERTIFICAT.NCAPITAL,
                     SCUMUL_CODE      => R_CERTIFICAT.SCUMUL_CODE,
                     DDAT_NO_CON      => R_CERTIFICAT.DDAT_NO_CON,
                     DDATE_ORIGI      => R_CERTIFICAT.DDATE_ORIGI,
                     DCHANGDAT        => R_CERTIFICAT.DCHANGDAT,
                     DEXPIRDAT        => R_CERTIFICAT.DEXPIRDAT,
                     NGROUP           => R_CERTIFICAT.NGROUP,
                     DISSUEDAT        => R_CERTIFICAT.DISSUEDAT,
                     DMAXIMUM_DA      => R_CERTIFICAT.DMAXIMUM_DA,
                     NNO_CONVERS      => R_CERTIFICAT.NNO_CONVERS,
                     NNOTE_BENEF      => R_CERTIFICAT.NNOTE_BENEF,
                     NNOTE_DRISK      => R_CERTIFICAT.NNOTE_DRISK,
                     NNULLCODE        => R_CERTIFICAT.NNULLCODE,
                     NPAYFREQ         => R_CERTIFICAT.NPAYFREQ,
                     NPREMIUM         => R_CERTIFICAT.NPREMIUM,
                     DPROPODAT        => R_CERTIFICAT.DPROPODAT,
                     SRENEWAL         => R_CERTIFICAT.SRENEWAL,
                     SPRORSHORT       => R_CERTIFICAT.SPRORSHORT,
                     NSITUATION       => R_CERTIFICAT.NSITUATION,
                     DSTARTDATE       => R_CERTIFICAT.DSTARTDATE,
                     SSTATUSVA        => R_CERTIFICAT.SSTATUSVA,
                     NUSER_AMEND      => R_CERTIFICAT.NUSER_AMEND,
                     NUSERCODE        => R_CERTIFICAT.NUSERCODE,
                     NSUS_BRANCH      => R_CERTIFICAT.NSUS_BRANCH,
                     NWAIT_CODE       => R_CERTIFICAT.NWAIT_CODE,
                     NSUS_POLICY      => R_CERTIFICAT.NSUS_POLICY,
                     NSUS_CERTIF      => R_CERTIFICAT.NSUS_CERTIF,
                     DNEXTRECEIP      => R_CERTIFICAT.DNEXTRECEIP,
                     NPROPONUM        => R_CERTIFICAT.NPROPONUM,
                     NQUOTA           => R_CERTIFICAT.NQUOTA,
                     NDAYSFQ          => R_CERTIFICAT.NDAYSFQ,
                     NDAYSSQ          => R_CERTIFICAT.NDAYSSQ,
                     SNUMFORM         => R_CERTIFICAT.SNUMFORM,
                     SREINSURA        => R_CERTIFICAT.SREINSURA,
                     SEXEMPTION       => R_CERTIFICAT.SEXEMPTION,
                     SDIRIND          => R_CERTIFICAT.SDIRIND,
                     NWAY_PAY         => R_CERTIFICAT.NWAY_PAY,
                     NBILL_DAY        => R_CERTIFICAT.NBILL_DAY,
                     NSENDADDR        => R_CERTIFICAT.NSENDADDR,
                     SAUT_GUARVAL     => R_CERTIFICAT.SAUT_GUARVAL,
                     NSELLCHANNEL     => R_CERTIFICAT.NSELLCHANNEL,
                     DFER             => R_CERTIFICAT.DFER,
                     NDAYS_QUOT       => R_CERTIFICAT.NDAYS_QUOT,
                     NSTATQUOTA       => R_CERTIFICAT.NSTATQUOTA,
                     NPOL_QUOT        => R_CERTIFICAT.NPOL_QUOT,
                     SBILL_IND        => R_CERTIFICAT.SBILL_IND,
                     NIMAGENUM        => R_CERTIFICAT.NIMAGENUM,
                     NRENEWALNUM      => R_CERTIFICAT.NRENEWALNUM,
                     NDIGIT           => R_CERTIFICAT.NDIGIT,
                     NPROP_REG        => R_CERTIFICAT.NPROP_REG,
                     NDAY_PAY         => R_CERTIFICAT.NDAY_PAY,
                     NDURATION        => R_CERTIFICAT.NDURATION,
                     NORIGIN          => R_CERTIFICAT.NORIGIN,
                     NAFP_COMMISS     => R_CERTIFICAT.NAFP_COMMISS,
                     NAFP_COMM_CURR   => R_CERTIFICAT.NAFP_COMM_CURR,
                     NCOLLECTOR       => NULL,
                     SFRACRECEIP      => R_CERTIFICAT.SFRACRECEIP,
                     NGROUP_AGREE     => R_CERTIFICAT.NGROUP_AGREE,
                     NCOMMIT          => 2,
                     DTARIFFDATE      => R_CERTIFICAT.DTARIFFDATE,
                     NFOLIO           => NFOLIO,
                     NREVALTYPE       => R_CERTIFICAT.NREVALTYPE,
                     NREVALFREQ       => R_CERTIFICAT.NREVALFREQ,
                     DNEXTREVAL       => R_CERTIFICAT.DNEXTREVAL,
                     NEXPIRRULE       => R_CERTIFICAT.NEXPIRRULE);

      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYQUOTATION, INSGENERALPKG.NCERTIFQUOTATION)
      THEN
         /*+ VERIFICO SI PARA EL PRODUCTO ESTA PERMITIDA LA FIGURA INTERMEDIARIO */
         SELECT COUNT (1)
           INTO NCOUNT
           FROM CLIALLOPRO
          WHERE     NBRANCH = R_CERTIFICAT.NBRANCH
                AND NPRODUCT = R_CERTIFICAT.NPRODUCT
                AND NROLE = 13;

         IF NCOUNT > 0
         THEN
            /*+ VERIFICO SI PARA LA COTIZACION ESTA CARGADO EL INTERMEDIARIO */

            SELECT COUNT (1)
              INTO NCOUNT
              FROM COMMISSION
             WHERE     SCERTYPE = R_CERTIFICAT.SCERTYPE
                   AND NBRANCH = R_CERTIFICAT.NBRANCH
                   AND NPRODUCT = R_CERTIFICAT.NPRODUCT
                   AND NPOLICY = R_CERTIFICAT.NPOLICY
                   AND NCERTIF = R_CERTIFICAT.NCERTIF
                   AND DEFFECDATE <= R_CERTIFICAT.DSTARTDATE
                   AND (DNULLDATE IS NULL
                        OR DNULLDATE > R_CERTIFICAT.DSTARTDATE);

            /*+ SI NO ESTA CARGADO EL INTERMEDIARIO */
            IF NCOUNT = 0
            THEN
               /*+ SE BUSCA EL TIPO DE USUARIO QUE ESTA REALIZANDO LA TRANSACCIÓN. */
               BEGIN
                  SELECT U.STYPE,
                         U.SCLIENT,
                         NINTERMED,
                         NINTERTYP
                    INTO INSCERTIFICAT_CA001.STYPE,
                         INSCERTIFICAT_CA001.SCLIENT,
                         NINTERMED,
                         NINTERTYP
                    FROM USERS U, INTERMEDIA I
                   WHERE     U.NUSERCODE = INSCERTIFICAT_CA001.NUSERCODE
                         AND U.SCLIENT = I.SCLIENT
                         AND I.NINT_STATUS = 1                       -- ACTIVO
                         AND ROWNUM = 1;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     INSCERTIFICAT_CA001.STYPE := NULL;
               END;

               /*+ SE VERIFICA SI EL USUARIO ES UN INTERMEDIARIO. */
               IF INSCERTIFICAT_CA001.STYPE = '3'
               THEN
                  BEGIN
                     INSERT INTO ROLES (SCERTYPE,
                                        NBRANCH,
                                        NPRODUCT,
                                        NPOLICY,
                                        NCERTIF,
                                        NROLE,
                                        SCLIENT,
                                        DEFFECDATE,
                                        DCOMPDATE,
                                        NSTATUSROL,
                                        NUSERCODE,
                                        NINTERMED)
                          VALUES (R_CERTIFICAT.SCERTYPE,
                                  R_CERTIFICAT.NBRANCH,
                                  R_CERTIFICAT.NPRODUCT,
                                  R_CERTIFICAT.NPOLICY,
                                  R_CERTIFICAT.NCERTIF,
                                  13,
                                  INSCERTIFICAT_CA001.SCLIENT,
                                  R_CERTIFICAT.DSTARTDATE,
                                  SYSDATE,
                                  1,
                                  INSCERTIFICAT_CA001.NUSERCODE,
                                  INSCERTIFICAT_CA001.NINTERMED);

                     INSERT INTO COMMISSION (SCERTYPE,
                                             NBRANCH,
                                             NPRODUCT,
                                             NPOLICY,
                                             NCERTIF,
                                             DEFFECDATE,
                                             NINTERMED,
                                             NINTERTYP,
                                             NUSERCODE,
                                             SCOMMITYP,
                                             DCOMPDATE,
                                             NSHARE)
                          VALUES (R_CERTIFICAT.SCERTYPE,
                                  R_CERTIFICAT.NBRANCH,
                                  R_CERTIFICAT.NPRODUCT,
                                  R_CERTIFICAT.NPOLICY,
                                  R_CERTIFICAT.NCERTIF,
                                  R_CERTIFICAT.DSTARTDATE,
                                  NINTERMED,
                                  NINTERTYP,
                                  INSCERTIFICAT_CA001.NUSERCODE,
                                  '1',
                                  SYSDATE,
                                  100);

                     UPDATE POLICY
                        SET NINTERMED = INSCERTIFICAT_CA001.NINTERMED
                      WHERE     SCERTYPE = R_CERTIFICAT.SCERTYPE
                            AND NBRANCH = R_CERTIFICAT.NBRANCH
                            AND NPRODUCT = R_CERTIFICAT.NPRODUCT
                            AND NPOLICY = R_CERTIFICAT.NPOLICY;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;
               END IF;
            END IF;
         END IF;
      END IF;
   END INSCERTIFICAT_CA001;

   PROCEDURE INSPARTICULARDATA_CA001 /*---------------------------------------------------------------------------------*/
                                    /* NOMBRE    : INSPARTICULARDATA                                                   */
                                    /* OBJETIVO  :                                                                     */
                                    /*                                                                                 */
                                    /* SOURCESAFE INFORMATION                                                              */
                                    /*     $AUTHOR: NVAPLAT28 $*/
                                    /*     $DATE: 10/05/04 16.11 $*/
                                    /*     $REVISION: 43 $*/
                                    /*---------------------------------------------------------------------------------*/
   (SCERTYPE        CERTIFICAT.SCERTYPE%TYPE,
    NBRANCH         CERTIFICAT.NBRANCH%TYPE,
    NPRODUCT        CERTIFICAT.NPRODUCT%TYPE,
    NPOLICY         CERTIFICAT.NPOLICY%TYPE,
    NCERTIF         CERTIFICAT.NCERTIF%TYPE,
    DEFFECDATE      CERTIFICAT.DSTARTDATE%TYPE,
    NUSERCODE       CERTIFICAT.NUSERCODE%TYPE,
    NTRANSACTION    TABLE221.NCODIGINT%TYPE,
    DLASTCHANGEA    CERTIFICAT.DCHANGDAT%TYPE,
    DNULLDATE       CERTIFICAT.DNULLDATE%TYPE)
   AS
      BEXIST         BOOLEAN;
      STABNAME       TAB_NAME_B.STABNAME%TYPE;
      R_DNULLDATE    LIFE.DNULLDATE%TYPE;
      R_DEFFECDATE   LIFE.DEFFECDATE%TYPE;
      C_CERTIFICAT   REFCURSORPKG.RCT1;
      NPROCTYPE      INTEGER;
      INSTRCUENTA       VARCHAR2(2000);
      NCUENTA NUMBER;
    TYPE RCURSOR IS REF CURSOR;
    C_SSELSQL      RCURSOR;

   BEGIN
   
      SELECT STABNAME
        INTO STABNAME
        FROM TAB_NAME_B
       WHERE NBRANCH = INSPARTICULARDATA_CA001.NBRANCH;

      REAPARTICULARDATA (SCERTYPE     => SCERTYPE,
                         NBRANCH      => NBRANCH,
                         NPRODUCT     => NPRODUCT,
                         NPOLICY      => NPOLICY,
                         NCERTIF      => NCERTIF,
                         DEFFECDATE   => DEFFECDATE,
                         STABNAME     => STABNAME,
                         RC1          => C_CERTIFICAT);

      FETCH C_CERTIFICAT
      INTO STABNAME, R_DNULLDATE, R_DEFFECDATE;

      BEXIST := C_CERTIFICAT%FOUND;

      CLOSE C_CERTIFICAT;

      IF NOT BEXIST
      THEN
         CREPARTICULARDATA (SCERTYPE     => SCERTYPE,
                            NBRANCH      => NBRANCH,
                            NPRODUCT     => NPRODUCT,
                            NPOLICY      => NPOLICY,
                            NCERTIF      => NCERTIF,
                            DEFFECDATE   => DEFFECDATE,
                            NUSERCODE    => NUSERCODE,
                            STABNAME     => STABNAME,
                            NCOMMIT      => 2);
      ELSE
         BEXIST := FALSE;

         IF NTRANSACTION IN
               (INSGENERALPKG.NCERTIFREISSUE, INSGENERALPKG.NPOLICYREISSUE)
         THEN
            BEXIST := TRUE;
            NPROCTYPE := 18;
            R_DEFFECDATE := DEFFECDATE;
            R_DNULLDATE := NULL;
         ELSIF DTCHAR (DLASTCHANGEA) < DTCHAR (DEFFECDATE)
         THEN
            IF NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYAMENDMENT,
                   INSGENERALPKG.NCERTIFAMENDMENT)
            THEN
               BEXIST := TRUE;
               NPROCTYPE := 12;
               R_DNULLDATE := DEFFECDATE;
            ELSIF NTRANSACTION IN
                     (INSGENERALPKG.NTEMPPOLICYAMENDMENT,
                      INSGENERALPKG.NTEMPCERTIFAMENDMENT)
            THEN
               BEXIST := TRUE;
               NPROCTYPE := 13;
               R_DNULLDATE := DEFFECDATE;
            END IF;
         END IF;
-- BDT 20240102 Me fijo si es un endoso retroactivo (para eso uso la variable NCUENTA)          
        NCUENTA :=0;
        IF NOT BEXIST AND (NTRANSACTION =INSGENERALPKG.NPOLICYAMENDMENT OR NTRANSACTION=INSGENERALPKG.NCERTIFAMENDMENT) THEN    
            INSTRCUENTA := ' SELECT count(0)'
               || ' FROM ' || STABNAME
               || ' WHERE SCERTYPE = ''' || SCERTYPE || ''''
               || ' AND NBRANCH = ' || TO_CHAR(NBRANCH)
               || ' AND NPRODUCT = '|| TO_CHAR(NPRODUCT)
               || ' AND NPOLICY = ' || TO_CHAR(NPOLICY)
               || ' AND NCERTIF = ' || TO_CHAR(NCERTIF)
               || ' AND DTCHAR(DEFFECDATE) > '''
               || DTCHAR(DEFFECDATE)  || ''''
               || ' AND DNULLDATE   IS NULL';
            
            OPEN C_SSELSQL FOR INSTRCUENTA;
            FETCH C_SSELSQL
            INTO NCUENTA;
            CLOSE C_SSELSQL;
        END IF;
-- BDT 20240102 Me fijo si es un endoso retroactivo (para eso uso la variable NCUENTA)                  
         IF (BEXIST OR NCUENTA<>0) THEN
            INSPARTICULARDATA (SCERTYPE      => SCERTYPE,
                               NBRANCH       => NBRANCH,
                               NPRODUCT      => NPRODUCT,
                               NPOLICY       => NPOLICY,
                               NCERTIF       => NCERTIF,
                               DSTARTDATE    => DEFFECDATE,
                               DNULLDATE     => NULL,
                               DTEMPUPDATE   => NULL,
                               NUSERCODE     => NUSERCODE,
                               STABNAME      => STABNAME,
                               NPROCTYPE     => NPROCTYPE,
                               NCOMMIT       => 2);
         END IF;
      END IF;
   END INSPARTICULARDATA_CA001;

   PROCEDURE UPDATE_POLICYHIS /*---------------------------------------------------------------------------------*/
                             /* NOMBRE    : UPDATE_POLICYHIS                                                    */
                             /* OBJETIVO  :                                                                     */
                             /*                                                                                 */
                             /* SOURCESAFE INFORMATION                                                              */
                             /*     $AUTHOR: NVAPLAT28 $*/
                             /*     $DATE: 10/05/04 16.11 $*/
                             /*     $REVISION: 43 $*/
                             /*---------------------------------------------------------------------------------*/
   (SCERTYPE              POLICY_HIS.SCERTYPE%TYPE,
    NBRANCH               POLICY_HIS.NBRANCH%TYPE,
    NPRODUCT              POLICY_HIS.NPRODUCT%TYPE,
    NPOLICY               POLICY_HIS.NPOLICY%TYPE,
    NCERTIF               POLICY_HIS.NCERTIF%TYPE,
    DEFFECDATE            POLICY_HIS.DEFFECDATE%TYPE,
    NTYPE_HIST            POLICY_HIS.NTYPE_HIST%TYPE,
    DEXPIRDAT             POLICY_HIS.DNULLDATE%TYPE,
    NUSERCODE             POLICY_HIS.NUSERCODE%TYPE,
    DLEDGERDAT            POLICY_HIS.DLEDGERDAT%TYPE,
    NTYPE_AMEND           POLICY_HIS.NTYPE_AMEND%TYPE,
    NSERV_ORDER           POLICY_HIS.NSERV_ORDER%TYPE,
    DFER                  POLICY_HIS.DFER%TYPE,
    NTRANSACTIO    IN OUT POLICY.NTRANSACTIO%TYPE,
    NMOV_HISTOR    IN OUT POLICY.NMOV_HISTOR%TYPE,
    NCAUSE_AMEND          POLICY_HIS.NCAUSE_AMEND%TYPE DEFAULT NULL)
   AS
      CURSOR C_CURREN_POL
      IS
         SELECT NCURRENCY
           FROM CURREN_POL
          WHERE     SCERTYPE = UPDATE_POLICYHIS.SCERTYPE
                AND NBRANCH = UPDATE_POLICYHIS.NBRANCH
                AND NPRODUCT = UPDATE_POLICYHIS.NPRODUCT
                AND NPOLICY = UPDATE_POLICYHIS.NPOLICY
                AND NCERTIF = UPDATE_POLICYHIS.NCERTIF
                AND DEFFECDATE <= UPDATE_POLICYHIS.DEFFECDATE
                AND (DNULLDATE IS NULL
                     OR DNULLDATE > UPDATE_POLICYHIS.DEFFECDATE);

      R_POLICY_HIS   POLICY_HIS%ROWTYPE;
   BEGIN
      OPEN C_CURREN_POL;

      FETCH C_CURREN_POL INTO R_POLICY_HIS.NCURRENCY;

      IF C_CURREN_POL%NOTFOUND
      THEN
         --R_POLICY_HIS.NCURRENCY := 1;
         BEGIN
            SELECT NCURRENCY
              INTO R_POLICY_HIS.NCURRENCY
              FROM CUR_ALLOW
             WHERE     NBRANCH = UPDATE_POLICYHIS.NBRANCH
                   AND NPRODUCT = UPDATE_POLICYHIS.NPRODUCT
                   AND SDEFAULTI = '1'
                   AND DEFFECDATE <= UPDATE_POLICYHIS.DEFFECDATE
                   AND (DNULLDATE IS NULL
                        OR DNULLDATE > UPDATE_POLICYHIS.DEFFECDATE);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               R_POLICY_HIS.NCURRENCY := 1;
            WHEN TOO_MANY_ROWS
            THEN
               R_POLICY_HIS.NCURRENCY := 1;
            WHEN OTHERS
            THEN
               R_POLICY_HIS.NCURRENCY := 1;
         END;
      END IF;

      CLOSE C_CURREN_POL;

      IF NTYPE_HIST <> 54 AND NTYPE_HIST <> 55
      THEN
         IF NTYPE_HIST = 11
         THEN
            R_POLICY_HIS.DNULLDATE := DEXPIRDAT;
         ELSE
            R_POLICY_HIS.DNULLDATE := NULL;
         END IF;
      END IF;

      R_POLICY_HIS.NTRANSACTIO := NVL (NTRANSACTIO, 0);
      R_POLICY_HIS.NTYPE_HIST := NTYPE_HIST;
      R_POLICY_HIS.NMOVEMENT := NVL (NMOV_HISTOR, 0);
      R_POLICY_HIS.SCERTYPE := SCERTYPE;
      R_POLICY_HIS.NBRANCH := NBRANCH;
      R_POLICY_HIS.NPRODUCT := NPRODUCT;
      R_POLICY_HIS.NPOLICY := NPOLICY;
      R_POLICY_HIS.NCERTIF := NCERTIF;
      R_POLICY_HIS.DEFFECDATE := DEFFECDATE;
      R_POLICY_HIS.NUSERCODE := NUSERCODE;
      R_POLICY_HIS.DLEDGERDAT := DLEDGERDAT;
      R_POLICY_HIS.NTYPE_AMEND := NTYPE_AMEND;
      R_POLICY_HIS.NSERV_ORDER := NSERV_ORDER;
      R_POLICY_HIS.DFER := DFER;
      R_POLICY_HIS.NCAUSE_AMEND := NCAUSE_AMEND;

      INSPOLICY_HIS (SCERTYPE          => R_POLICY_HIS.SCERTYPE,
                     NBRANCH           => R_POLICY_HIS.NBRANCH,
                     NPRODUCT          => R_POLICY_HIS.NPRODUCT,
                     NPOLICY           => R_POLICY_HIS.NPOLICY,
                     NCERTIF           => R_POLICY_HIS.NCERTIF,
                     NCURRENCY         => R_POLICY_HIS.NCURRENCY,
                     DEFFECDATE        => R_POLICY_HIS.DEFFECDATE,
                     DNULLDATE         => R_POLICY_HIS.DNULLDATE,
                     SNULL_MOVE        => R_POLICY_HIS.SNULL_MOVE,
                     NRECEIPT          => R_POLICY_HIS.NRECEIPT,
                     NTRANSACTIO       => R_POLICY_HIS.NTRANSACTIO,
                     NTYPE             => R_POLICY_HIS.NTYPE_HIST,
                     NUSERCODE         => R_POLICY_HIS.NUSERCODE,
                     NCLAIM            => R_POLICY_HIS.NCLAIM,
                     NMOVEMENT         => R_POLICY_HIS.NMOVEMENT,
                     DLEDGERDAT        => R_POLICY_HIS.DLEDGERDAT,
                     NTYPE_AMEND       => R_POLICY_HIS.NTYPE_AMEND,
                     NSERV_ORDER       => R_POLICY_HIS.NSERV_ORDER,
                     DFER              => R_POLICY_HIS.DFER,
                     NPROPONUM         => R_POLICY_HIS.NPROPONUM,
                     NCOMMIT           => 2,
                     NNOTENUM          => NULL,
                     NNULLCODE         => NULL,
                     NREASON_CANCELL   => NULL,
                     NCAUSE_AMEND      => R_POLICY_HIS.NCAUSE_AMEND);

      NMOV_HISTOR := R_POLICY_HIS.NMOVEMENT;
      NTRANSACTIO := R_POLICY_HIS.NTRANSACTIO;
   END UPDATE_POLICYHIS;

PROCEDURE INSTRANSACTION 
/*---------------------------------------------------------------------------------*/
/* NOMBRE    : INSTRANSACTION                                                      */
/* OBJETIVO  :                                                                     */
/*                                                                                 */
/* SOURCESAFE INFORMATION                                                          */
/*     $AUTHOR: NVAPLAT28 $*/
/*     $DATE: 10/05/04 16.11 $*/
/*     $REVISION: 43 $*/
/*---------------------------------------------------------------------------------*/
   (NTRANSACTION       TABLE221.NCODIGINT%TYPE,
    SCERTYPE           CERTIFICAT.SCERTYPE%TYPE,
    NBRANCH            CERTIFICAT.NBRANCH%TYPE,
    NPRODUCT           CERTIFICAT.NPRODUCT%TYPE,
    NPOLICY            CERTIFICAT.NPOLICY%TYPE,
    NPOLICYDEST        CERTIFICAT.NPOLICY%TYPE,
    NCERTIF            CERTIFICAT.NCERTIF%TYPE,
    DEFFECDATE         CERTIFICAT.DSTARTDATE%TYPE,
    NOFFICE            POLICY.NOFFICE%TYPE,
    SBUSSITYP          POLICY.SBUSSITYP%TYPE,
    SPOLITYPE          POLICY.SPOLITYPE%TYPE,
    DLEDGERDAT         POLICY_HIS.DLEDGERDAT%TYPE,
    DNULLDATE          CERTIFICAT.DNULLDATE%TYPE,
    DLASTCHANGE        CERTIFICAT.DCHANGDAT%TYPE,
    NAGENCY            POLICY.NAGENCY%TYPE,
    NOFFICEAGEN        POLICY.NOFFICEAGEN%TYPE,
    NSELLCHANNEL       CERTIFICAT.NSELLCHANNEL%TYPE,
    NTYPE_AMEND        POLICY_HIS.NTYPE_AMEND%TYPE,
    NSERV_ORDER        POLICY_HIS.NSERV_ORDER%TYPE,
    DFER               CERTIFICAT.DFER%TYPE,
    NPOL_QUOT          CERTIFICAT.NPOL_QUOT%TYPE,
    NUSERCODE          CERTIFICAT.NUSERCODE%TYPE,
    NDIGIT             CERTIFICAT.NDIGIT%TYPE,
    NPROP_REG          CERTIFICAT.NPROP_REG%TYPE,
    NRENEWALNUM        CERTIFICAT.NRENEWALNUM%TYPE,
    SCODISPL           WINDOWS.SCODISPL%TYPE,
    NFOLIO             CERTIFICAT.NFOLIO%TYPE,
    NCOD_SAAPV         LIFE.NCOD_SAAPV%TYPE DEFAULT NULL,
    NINSTITUTION       LIFE.NINSTITUTION%TYPE DEFAULT NULL,
    NCAUSE_AMEND       POLICY_HIS.NCAUSE_AMEND%TYPE DEFAULT NULL,
    RC1            OUT REFCURSORPKG.RCT1)
   AS
      NTYPE_HIST      POLICY_HIS.NTYPE_HIST%TYPE;
      NTRANSACTIO     POLICY.NTRANSACTIO%TYPE;
      NMOV_HISTOR     POLICY.NMOV_HISTOR%TYPE;
      NPOLICY_AUX     POLICY.NPOLICY%TYPE := NVL (NPOLICY, 0);
      NCERTIF_AUX     POLICY.NPOLICY%TYPE := NVL (NCERTIF, 0);
      NPOL_QUOT_AUX   CERTIFICAT.NPOL_QUOT%TYPE := NVL (NPOL_QUOT, 0);
      NPOLICY_OUT     CERTIFICAT.NPOLICY%TYPE;
      NCERTIF_OUT     CERTIFICAT.NCERTIF%TYPE;
      C_POLICY        REAPOLICY_BRANCHPKG.RCT1;
      C_CERTIFICAT    REACERTIFICAT_BRANCHPKG.RCT1;
      C_PRODUCT       REAPRODUCTGENERALPKG.RCT1;
      C_PRODUCT_LI    REAPRODUCT_LIPKG.RCT1;
      SINVALID        VARCHAR2 (2000);
      NPRODCLAS       PRODUCT_LI.NPRODCLAS%TYPE;
      SOWNER_BASE     TABLE5638.SOWNER_BASE%TYPE;
      BNEWPOLICY      BOOLEAN;

      SCOMPON         SEQUEN_POL.SCOMPON%TYPE;
   BEGIN
      R_CERTIFICAT := NULL;

      REAPRODUCTGENERAL (NBRANCH      => NBRANCH,
                         NPRODUCT     => NPRODUCT,
                         DEFFECDATE   => DEFFECDATE,
                         RC1          => C_PRODUCT);

      FETCH C_PRODUCT INTO R_PRODUCT;

      BPRODUCT := C_PRODUCT%FOUND;

      CLOSE C_PRODUCT;

      BPOLICY := FALSE;

      /*+ NTRANSACTION:= 45 - SI EL TIPO DE TRANSACCION ES TRASPASO DE ASEGURADO, LA POLIZA DESTINO SE LE ASIGNA A LA AUXILIAR*/
      IF NTRANSACTION = INSGENERALPKG.NTRANSHOLDER
      THEN
         NPOLICY_AUX := NPOLICYDEST;
      END IF;


      IF NPOLICY_AUX > 0
      THEN
         REAPOLICY_BRANCH (SCERTYPE   => SCERTYPE,
                           NBRANCH    => NBRANCH,
                           NPRODUCT   => NPRODUCT,
                           NPOLICY    => NPOLICY_AUX,
                           RC1        => C_POLICY);

         FETCH C_POLICY INTO R_POLICY;

         BPOLICY := C_POLICY%FOUND;

         CLOSE C_POLICY;
      END IF;

      BCERTIFICAT := FALSE;

      IF NPOLICY_AUX > 0
      THEN
         REACERTIFICAT_BRANCH (SCERTYPE   => SCERTYPE,
                               NBRANCH    => NBRANCH,
                               NPRODUCT   => NPRODUCT,
                               NPOLICY    => NPOLICY_AUX,
                               NCERTIF    => NCERTIF_AUX,
                               RC1        => C_CERTIFICAT);

         FETCH C_CERTIFICAT INTO R_CERTIFICAT;

         BCERTIFICAT := C_CERTIFICAT%FOUND;

         CLOSE C_CERTIFICAT;
      END IF;

      IF BCERTIFICAT
      THEN
         DLASTCHANGEA := R_CERTIFICAT.DCHANGDAT;
      ELSE
         DLASTCHANGEA := DLASTCHANGE;
      END IF;

      /*+ SE GENERA NUEVO NUMERO DE POLIZA SEGUN TR4ANSACCION EN FORMA AUTOMATICA            */
      /*+ SI ES CONVERCION DE PROPUESTA A POLIZA Y EL INDICADOR SNUMPROP DE PRODUCT ES IGUAL */
      /*+ A '1' EL NUMERO DE LA POLIZA SERA IGUAL AL NUMERO DE LA PROPUESTA                  */
      IF NTRANSACTION = INSGENERALPKG.NPROPOSALCONVERTION
         AND R_PRODUCT.SNUMPROP = '1'
      THEN
         NPOL_QUOT_AUX := NPOLICY_AUX;
      ELSE
         IF NTRANSACTION = INSGENERALPKG.NQUOTPROPAMENDENTCONVERTION
         THEN
            NPOL_QUOT_AUX := NULL;
         /*+ NTRANSACTION:= 45 - SI EL TIPO DE TRANSACCION ES TRASPASO DE ASEGURADO, SE GENERA EL NUEVO CERTIFICADO*/
         ELSIF NTRANSACTION = INSGENERALPKG.NTRANSHOLDER
         THEN
            NPOL_QUOT_AUX := NPOLICY_AUX;
         ELSIF NTRANSACTION = INSGENERALPKG.NDUPLICATEDPOLICY
         THEN
            IF NVL (NPOLICYDEST, 0) <> 0
            THEN
               NPOL_QUOT_AUX := NPOLICY_AUX;
               NPOLICY_AUX := NPOLICYDEST;
            END IF;
         END IF;

         IF NTRANSACTION <> INSGENERALPKG.NTRANSHOLDER
         THEN
            BNEWPOLICY := TRUE;

            IF NTRANSACTION = INSGENERALPKG.NDUPLICATEDPOLICY
            THEN
               IF NVL (NPOLICYDEST, 0) <> 0
               THEN
                  BNEWPOLICY := FALSE;
               END IF;
            ELSIF NTRANSACTION = INSGENERALPKG.NPROPQUOTCONVERTION
            THEN
               IF NVL (NPOL_QUOT, 0) <> 0
               THEN
                  BNEWPOLICY := FALSE;

                  NPOL_QUOT_AUX := NPOLICY_AUX;
                  NPOLICY_AUX := NPOL_QUOT;
               END IF;
            END IF;

            IF BNEWPOLICY
            THEN
               GETNEWPOLICY_CERTIF (NTRANSACTION   => NTRANSACTION,
                                    SCERTYPE       => SCERTYPE,
                                    NBRANCH        => NBRANCH,
                                    NPRODUCT       => NPRODUCT,
                                    NUSERCODE      => NUSERCODE,
                                    NPOLICY        => NPOLICY_AUX,
                                    NCERTIF        => NCERTIF_AUX,
                                    NPOL_QUOT      => NPOL_QUOT_AUX);
            END IF;
         END IF;
      END IF;

      NPOLICY_OUT := NPOLICY_AUX;
      NCERTIF_OUT := NCERTIF_AUX;


      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYISSUE,
             INSGENERALPKG.NCERTIFISSUE,
             INSGENERALPKG.NPOLICYQUOTATION,
             INSGENERALPKG.NCERTIFQUOTATION,
             INSGENERALPKG.NPOLICYPROPOSAL,
             INSGENERALPKG.NCERTIFPROPOSAL,
             INSGENERALPKG.NPOLICYAMENDMENT,
             INSGENERALPKG.NTEMPPOLICYAMENDMENT,
             INSGENERALPKG.NCERTIFAMENDMENT,
             INSGENERALPKG.NTEMPCERTIFAMENDMENT,
             INSGENERALPKG.NPOLICYQUOTAMENDENT,
             INSGENERALPKG.NCERTIFQUOTAMENDENT,
             INSGENERALPKG.NPOLICYPROPAMENDENT,
             INSGENERALPKG.NCERTIFPROPAMENDENT,
             INSGENERALPKG.NPOLICYPROPRENEWAL,
             INSGENERALPKG.NCERTIFPROPRENEWAL,
             INSGENERALPKG.NPOLICYQUOTRENEWAL,
             INSGENERALPKG.NCERTIFQUOTRENEWAL,
             INSGENERALPKG.NPROPREHABILITATE,
             INSGENERALPKG.NMODPROPREHABQUERY,
             INSGENERALPKG.NQUOTPROPAMENDENTCONVERTION,
             INSGENERALPKG.NRECUPERATION)
      THEN
         IF NTRANSACTION IN
               (INSGENERALPKG.NPOLICYQUOTAMENDENT,
                INSGENERALPKG.NCERTIFQUOTAMENDENT,
                INSGENERALPKG.NPOLICYPROPAMENDENT,
                INSGENERALPKG.NCERTIFPROPAMENDENT,
                INSGENERALPKG.NPOLICYPROPRENEWAL,
                INSGENERALPKG.NCERTIFPROPRENEWAL,
                INSGENERALPKG.NPOLICYQUOTRENEWAL,
                INSGENERALPKG.NCERTIFQUOTRENEWAL,
                INSGENERALPKG.NPROPREHABILITATE,
                INSGENERALPKG.NMODPROPREHABQUERY,
                INSGENERALPKG.NQUOTPROPAMENDENTCONVERTION)
         THEN
            NPOLICY_OUT := NPOL_QUOT_AUX;

            /*+ SE OBTIENE EL OWNER DE LOS OBJETOS*/
            SELECT UPPER (SOWNER_BASE)
              INTO INSTRANSACTION.SOWNER_BASE
              FROM TABLE5638
             WHERE NCOMPANY = REAGENERALPKG.REAOPT_SYSTEM_COMPANY;


            /*+SI LA TRANSACCION CORRESPONDE A CONVERSION DE COTIZACION/PROPUESTA DE MODIFICACION*/
            IF NTRANSACTION = INSGENERALPKG.NQUOTPROPAMENDENTCONVERTION
            THEN
               CREQUOTPROPPOLICY (SCERTYPE       => '6',
                                  NBRANCH        => NBRANCH,
                                  NPRODUCT       => NPRODUCT,
                                  NPOLICY        => NPOL_QUOT,
                                  NCERTIF        => NCERTIF_AUX,
                                  NPROPONUM      => NPOL_QUOT_AUX,
                                  DEFFECDATE     => DEFFECDATE,
                                  NUSERCODE      => NUSERCODE,
                                  DLEDGERDAT     => DLEDGERDAT,
                                  NTYPE_AMEND    => NTYPE_AMEND,
                                  NSERV_ORDER    => NSERV_ORDER,
                                  DFER           => DFER,
                                  NOFFICE        => NOFFICE,
                                  NOFFICEAGEN    => NOFFICEAGEN,
                                  NAGENCY        => NAGENCY,
                                  NSELLCHANNEL   => NSELLCHANNEL,
                                  NTRANSACTION   => NTRANSACTION,
                                  SOWNER_BASE    => SOWNER_BASE);

               /* SE ACTUALIZA LA SAAP PARA LOS ENDOSOS */
               IF NVL (NCOD_SAAPV, 0) > 0
               THEN
                  UPDATE LIFE
                     SET NCOD_SAAPV = INSTRANSACTION.NCOD_SAAPV,
                         NINSTITUTION = INSTRANSACTION.NINSTITUTION
                   WHERE     SCERTYPE = '6'
                         AND NBRANCH = INSTRANSACTION.NBRANCH
                         AND NPRODUCT = INSTRANSACTION.NPRODUCT
                         AND NPOLICY = INSTRANSACTION.NPOL_QUOT_AUX
                         AND NCERTIF = NCERTIF_AUX
                         AND DEFFECDATE <= INSTRANSACTION.DEFFECDATE
                         AND (DNULLDATE IS NULL
                              OR DNULLDATE > INSTRANSACTION.DEFFECDATE);

                  COMMIT;

                  FOR I
                     IN (SELECT NCOD_SAAPV
                           FROM SAAPV S
                          WHERE S.NCOD_SAAPV = INSTRANSACTION.NCOD_SAAPV
                                AND S.NINSTITUTION =
                                       INSTRANSACTION.NINSTITUTION
                                AND S.NSTATUS_SAAPV = 5             -- VIGENTE
                                AND S.NTYPE_SAAPV = 2 -- MODIFICACIÓN DE PÓLIZA
                                                     )
                  LOOP
                     INSVI7501PKG.
                      UPD_POLICY (
                        SCERTYPE       => '6',
                        NBRANCH        => INSTRANSACTION.NBRANCH,
                        NPRODUCT       => INSTRANSACTION.NPRODUCT,
                        NPOLICY        => INSTRANSACTION.NPOL_QUOT_AUX,
                        NCERTIF        => NCERTIF_AUX,
                        NCOD_SAAPV     => INSTRANSACTION.NCOD_SAAPV,
                        DEFFECDATE     => INSTRANSACTION.DEFFECDATE,
                        NINSTITUTION   => INSTRANSACTION.NINSTITUTION);
                  END LOOP;
               END IF;
            /*          SE INVOCA ESTE PROCESO CUANDO SE CREA LA SOLICITUD DE ENDOSO "SCERTYPE = '6'"
                        NTRANSACTION = 26 */
            ELSE
               CREQUOTPROPPOLICY (SCERTYPE       => SCERTYPE,
                                  NBRANCH        => NBRANCH,
                                  NPRODUCT       => NPRODUCT,
                                  NPOLICY        => NPOLICY_AUX,
                                  NCERTIF        => NCERTIF_AUX,
                                  NPROPONUM      => NPOL_QUOT_AUX,
                                  DEFFECDATE     => DEFFECDATE,
                                  NUSERCODE      => NUSERCODE,
                                  DLEDGERDAT     => DLEDGERDAT,
                                  NTYPE_AMEND    => NTYPE_AMEND,
                                  NSERV_ORDER    => NSERV_ORDER,
                                  DFER           => DFER,
                                  NOFFICE        => NOFFICE,
                                  NOFFICEAGEN    => NOFFICEAGEN,
                                  NAGENCY        => NAGENCY,
                                  NSELLCHANNEL   => NSELLCHANNEL,
                                  NTRANSACTION   => NTRANSACTION,
                                  SOWNER_BASE    => SOWNER_BASE);

               INSPARTICULARDATA_CA001 (SCERTYPE       => SCERTYPE,
                                        NBRANCH        => NBRANCH,
                                        NPRODUCT       => NPRODUCT,
                                        NPOLICY        => NPOL_QUOT_AUX,
                                        NCERTIF        => NCERTIF_AUX,
                                        DEFFECDATE     => DEFFECDATE,
                                        NUSERCODE      => NUSERCODE,
                                        NTRANSACTION   => NTRANSACTION,
                                        DLASTCHANGEA   => DLASTCHANGE,
                                        DNULLDATE      => DNULLDATE);

               /* SE ACTUALIZA LA SAAP PARA LOS ENDOSOS */
               IF NVL (NCOD_SAAPV, 0) > 0
               THEN
                  FOR I
                     IN (SELECT NCOD_SAAPV, NINSTITUTION
                           FROM SAAPV S
                          WHERE S.NCOD_SAAPV = INSTRANSACTION.NCOD_SAAPV
                                AND S.NINSTITUTION =
                                       INSTRANSACTION.NINSTITUTION
                                AND S.NSTATUS_SAAPV = 5            /*VIGENTE*/
                                AND S.NTYPE_SAAPV = 2 /*MODIFICACIÓN DE PÓLIZA*/
                                                     )
                  LOOP
                     INSVI7502PKG.
                      UPDATE_SAAPV_POL (
                        SCERTYPE       => '6',
                        NBRANCH        => INSTRANSACTION.NBRANCH,
                        NPRODUCT       => INSTRANSACTION.NPRODUCT,
                        NPOLICY        => INSTRANSACTION.NPOL_QUOT_AUX,
                        NCERTIF        => NCERTIF_AUX,
                        NCOD_SAAPV     => INSTRANSACTION.NCOD_SAAPV,
                        NUSERCODE      => NUSERCODE,
                        DEFFECDATE     => INSTRANSACTION.DEFFECDATE,
                        NINSTITUTION   => INSTRANSACTION.NINSTITUTION);
                  END LOOP;
               END IF;
            END IF;
         ELSE
            INSPOLICY_CA001 (NTRANSACTION   => NTRANSACTION,
                             SCERTYPE       => SCERTYPE,
                             NBRANCH        => NBRANCH,
                             NPRODUCT       => NPRODUCT,
                             NPOLICY        => NPOLICY_AUX,
                             NCERTIF        => NCERTIF_AUX,
                             NUSERCODE      => NUSERCODE,
                             DEFFECDATE     => DEFFECDATE,
                             NOFFICE        => NOFFICE,
                             SBUSSITYP      => SBUSSITYP,
                             SPOLITYPE      => SPOLITYPE,
                             DNULLDATE      => DNULLDATE,
                             NAGENCY        => NAGENCY,
                             NOFFICEAGEN    => NOFFICEAGEN,
                             NPOL_QUOT      => NPOL_QUOT_AUX);

            INSCERTIFICAT_CA001 (NTRANSACTION   => NTRANSACTION,
                                 SCERTYPE       => SCERTYPE,
                                 NBRANCH        => NBRANCH,
                                 NPRODUCT       => NPRODUCT,
                                 NPOLICY        => NPOLICY_AUX,
                                 NCERTIF        => NCERTIF_AUX,
                                 NUSERCODE      => NUSERCODE,
                                 DEFFECDATE     => DEFFECDATE,
                                 NSELLCHANNEL   => NSELLCHANNEL,
                                 DFER           => DFER,
                                 NPOL_QUOT      => NPOL_QUOT_AUX,
                                 NDIGIT         => NDIGIT,
                                 NPROP_REG      => NPROP_REG,
                                 NRENEWALNUM    => NRENEWALNUM,
                                 NFOLIO         => NFOLIO);

            INSPARTICULARDATA_CA001 (SCERTYPE       => SCERTYPE,
                                     NBRANCH        => NBRANCH,
                                     NPRODUCT       => NPRODUCT,
                                     NPOLICY        => NPOLICY_AUX,
                                     NCERTIF        => NCERTIF_AUX,
                                     DEFFECDATE     => DEFFECDATE,
                                     NUSERCODE      => NUSERCODE,
                                     NTRANSACTION   => NTRANSACTION,
                                     DLASTCHANGEA   => DLASTCHANGEA,
                                     DNULLDATE      => DNULLDATE);

            IF NVL (NCOD_SAAPV, 0) > 0
            THEN
               UPDATE LIFE
                  SET NCOD_SAAPV = INSTRANSACTION.NCOD_SAAPV,
                      NINSTITUTION = INSTRANSACTION.NINSTITUTION
                WHERE     SCERTYPE = INSTRANSACTION.SCERTYPE
                      AND NBRANCH = INSTRANSACTION.NBRANCH
                      AND NPRODUCT = INSTRANSACTION.NPRODUCT
                      AND NPOLICY = INSTRANSACTION.NPOLICY_AUX
                      AND NCERTIF = NCERTIF_AUX
                      AND DEFFECDATE <= INSTRANSACTION.DEFFECDATE
                      AND (DNULLDATE IS NULL
                           OR DNULLDATE > INSTRANSACTION.DEFFECDATE);
            END IF;
         END IF;
      END IF;

      IF NTRANSACTION IN
            (INSGENERALPKG.NQUOTATIONCONVERTION,
             INSGENERALPKG.NPROPOSALCONVERTION,
             INSGENERALPKG.NQUOTAMENDCONVERTION,
             INSGENERALPKG.NPROPAMENDCONVERTION,
             INSGENERALPKG.NQUOTRENEWALCONVERTION,
             INSGENERALPKG.NPROPRENEWALCONVERTION,
             INSGENERALPKG.NQUOTPROPRENEWALCONVERTION,
             INSGENERALPKG.NPROPQUOTCONVERTION)
      THEN
         IF NTRANSACTION = INSGENERALPKG.NPROPQUOTCONVERTION
         THEN
            INSQUOTPROPCONVERTIONPKG.
             INSQUOTPROPCONVERTION (SCERTYPE       => '3',
                                    NBRANCH        => NBRANCH,
                                    NPRODUCT       => NPRODUCT,
                                    NPOLICY        => NPOLICY_AUX,
                                    NCERTIF        => NCERTIF_AUX,
                                    NPROPONUM      => NPOL_QUOT_AUX,
                                    DEFFECDATE     => DEFFECDATE,
                                    NUSERCODE      => NUSERCODE,
                                    SPOLITYPE      => SPOLITYPE,
                                    SORIGINAL      => NULL,
                                    SINVALID       => SINVALID,
                                    SCERTYPE_DES   => '1',
                                    SCOMMIT        => '1',
                                    SCOLTIMRE      => NULL,
                                    SCODISPL       => SCODISPL,
                                    NTRANSACTION   => NTRANSACTION);

            UPDATE CERTIFICAT
               SET NWAIT_CODE = 1
             WHERE     SCERTYPE = '1'
                   AND NBRANCH = INSTRANSACTION.NBRANCH
                   AND NPRODUCT = INSTRANSACTION.NPRODUCT
                   AND NPOLICY = NPOLICY_AUX
                   AND NCERTIF = INSTRANSACTION.NCERTIF_AUX;

            UPDATE INSURED_EXPDIS P
               SET DDATE_FR = DEFFECDATE,
                   DDATE_TO = DEFFECDATE + (DDATE_TO - DDATE_FR)
             WHERE     SCERTYPE = '1'
                   AND NBRANCH = INSTRANSACTION.NBRANCH
                   AND NPRODUCT = INSTRANSACTION.NPRODUCT
                   AND NPOLICY = NPOLICY_AUX
                   AND NCERTIF = INSTRANSACTION.NCERTIF_AUX
                   AND DDATE_FR IS NOT NULL;


            INSUPDPOLICY_WIN_ARR (SCERTYPE     => '1',
                                  NBRANCH      => INSTRANSACTION.NBRANCH,
                                  NPRODUCT     => INSTRANSACTION.NPRODUCT,
                                  NPOLICY      => NPOLICY_AUX,
                                  NCERTIF      => NCERTIF_AUX,
                                  DEFFECDATE   => INSTRANSACTION.DEFFECDATE,
                                  SWINDOW      => 'CA004|3',
                                  NUSERCODE    => INSTRANSACTION.NUSERCODE);

            /* SE AÑADEN LAS VENTANAS REQUERIDAS PARA LA PROPUESTA YA QUE EN LA COTIZACION NO EXISTEN */

            IF NVL (NCERTIF_AUX, 0) = 0
            THEN
               SCOMPON := 1;
            ELSE
               SCOMPON := 2;
            END IF;

            FOR R_REG
               IN (SELECT SCODISPL, DECODE (SREQUIRE, '1', '3', '1') SCONTENT
                     FROM SEQUEN_POL
                    WHERE     NBRANCH = INSTRANSACTION.NBRANCH
                          AND NPRODUCT = INSTRANSACTION.NPRODUCT
                          AND SBUSSITYP = '1'
                          AND SPOLITYPE = INSTRANSACTION.SPOLITYPE
                          AND NTRATYPEP = 7                       -- PROPUESTA
                          AND SCOMPON = INSTRANSACTION.SCOMPON
                          AND 0 =
                                 (SELECT INSTR (SV_WINPOLIC, SCODISPL)
                                    FROM POLICY_WIN
                                   WHERE SCERTYPE = '1'
                                         AND NBRANCH = INSTRANSACTION.NBRANCH
                                         AND NPRODUCT =
                                                INSTRANSACTION.NPRODUCT
                                         AND NPOLICY = NPOLICY_AUX
                                         AND NCERTIF =
                                                INSTRANSACTION.NCERTIF_AUX
                                         AND DEFFECDATE =
                                                INSTRANSACTION.DEFFECDATE))
            LOOP
               INSADDPOLICY_WIN (SCERTYPE     => '1',
                                 NBRANCH      => NBRANCH,
                                 NPRODUCT     => NPRODUCT,
                                 NPOLICY      => NPOLICY_AUX,
                                 NCERTIF      => NCERTIF_AUX,
                                 DEFFECDATE   => DEFFECDATE,
                                 SCODISPL     => R_REG.SCODISPL,
                                 NUSERCODE    => NUSERCODE,
                                 SCONTENT     => R_REG.SCONTENT);
            END LOOP;
         --        ELSIF NTRANSACTION = INSGENERALPKG.NQUOTPROPAMENDENTCONVERTION THEN
         --            NULL;
         --             SELECT UPPER(SOWNER_BASE)
         --               INTO INSTRANSACTION.SOWNER_BASE
         --               FROM TABLE5638
         --              WHERE NCOMPANY = REAGENERALPKG.REAOPT_SYSTEM_COMPANY;
         --
         --                                       CREQUOTPROPPOLICY(SCERTYPE     => '6',
         --                                                         NBRANCH      => NBRANCH,
         --                                                         NPRODUCT     => NPRODUCT,
         --                                                         NPOLICY      => NPOLICY_AUX,
         --                                                         NCERTIF      => NCERTIF_AUX,
         --                                                         NPROPONUM    => NPOL_QUOT_AUX,
         --                                                         DEFFECDATE   => DEFFECDATE,
         --                                                         NUSERCODE    => NUSERCODE,
         --                                                         DLEDGERDAT   => DLEDGERDAT,
         --                                                         NTYPE_AMEND  => NTYPE_AMEND,
         --                                                         NSERV_ORDER  => NSERV_ORDER,
         --                                                         DFER         => DFER,
         --                                                         NOFFICE      => NOFFICE,
         --                                                         NOFFICEAGEN  => NOFFICEAGEN,
         --                                                         NAGENCY      => NAGENCY,
         --                                                         NSELLCHANNEL => NSELLCHANNEL,
         --                                                         NTRANSACTION => NTRANSACTION,
         --                                                         SOWNER_BASE  => SOWNER_BASE);
         ELSE
            INSQUOTPROPCONVERTIONPKG.
             INSQUOTPROPCONVERTION (SCERTYPE       => SCERTYPE,
                                    NBRANCH        => NBRANCH,
                                    NPRODUCT       => NPRODUCT,
                                    NPOLICY        => NPOLICY_AUX,
                                    NCERTIF        => NCERTIF_AUX,
                                    NPROPONUM      => NPOL_QUOT_AUX,
                                    DEFFECDATE     => DEFFECDATE,
                                    NUSERCODE      => NUSERCODE,
                                    SPOLITYPE      => SPOLITYPE,
                                    SORIGINAL      => NULL,
                                    SINVALID       => SINVALID,
                                    SCERTYPE_DES   => '2',
                                    SCOMMIT        => '1',
                                    SCOLTIMRE      => NULL,
                                    SCODISPL       => SCODISPL);
         END IF;
      ELSE
         NTYPE_HIST := 0;

         IF NTRANSACTION = INSGENERALPKG.NPOLICYISSUE
         THEN
            NTYPE_HIST := 1;
         ELSIF NTRANSACTION = INSGENERALPKG.NCERTIFISSUE
         THEN
            NTYPE_HIST := 2;
         ELSIF NTRANSACTION = INSGENERALPKG.NRECUPERATION
         THEN
            INSPOLICY_CA001 (NTRANSACTION   => NTRANSACTION,
                             SCERTYPE       => SCERTYPE,
                             NBRANCH        => NBRANCH,
                             NPRODUCT       => NPRODUCT,
                             NPOLICY        => NPOLICY_AUX,
                             NCERTIF        => NCERTIF_AUX,
                             NUSERCODE      => NUSERCODE,
                             DEFFECDATE     => DEFFECDATE,
                             NOFFICE        => NOFFICE,
                             SBUSSITYP      => SBUSSITYP,
                             SPOLITYPE      => SPOLITYPE,
                             DNULLDATE      => DNULLDATE,
                             NAGENCY        => NAGENCY,
                             NOFFICEAGEN    => NOFFICEAGEN,
                             NPOL_QUOT      => NPOL_QUOT_AUX);

            INSCERTIFICAT_CA001 (NTRANSACTION   => NTRANSACTION,
                                 SCERTYPE       => SCERTYPE,
                                 NBRANCH        => NBRANCH,
                                 NPRODUCT       => NPRODUCT,
                                 NPOLICY        => NPOLICY_AUX,
                                 NCERTIF        => NCERTIF_AUX,
                                 NUSERCODE      => NUSERCODE,
                                 DEFFECDATE     => DEFFECDATE,
                                 NSELLCHANNEL   => NSELLCHANNEL,
                                 DFER           => DFER,
                                 NPOL_QUOT      => NPOL_QUOT_AUX,
                                 NDIGIT         => NDIGIT,
                                 NPROP_REG      => NPROP_REG,
                                 NRENEWALNUM    => NRENEWALNUM);

            IF NCERTIF_AUX = 0
            THEN
               NTYPE_HIST := 3;
            ELSE
               NTYPE_HIST := 4;
            END IF;
         ELSIF NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYQUOTATION,
                   INSGENERALPKG.NCERTIFQUOTATION)
         THEN
            NTYPE_HIST := 7;
         /* SI ES PROPUESTA DE POLIZA*/
         ELSIF NTRANSACTION = INSGENERALPKG.NPOLICYPROPOSAL
         THEN
            NTYPE_HIST := 9;

            /* SI EL NUMERO DE PROPUESTA REGULARIZADA NO ESTA VACIO*/
            /* SE INVOCA AL PROCEDIMIENTO QUE REGULARIZA EL PAGO DE PRIMERA PRIMA*/
            IF NVL (NPROP_REG, 0) <> 0
            THEN
               INSREGMOVE_ACC (NPROPONUM   => NPOLICY_AUX,
                               NBRANCH     => NBRANCH,
                               NPRODUCT    => NPRODUCT,
                               NPROP_REG   => NPROP_REG);
            END IF;
         ELSIF NTRANSACTION = INSGENERALPKG.NCERTIFPROPOSAL
         THEN
            NTYPE_HIST := 10;
         ELSIF NTRANSACTION = INSGENERALPKG.NPOLICYAMENDMENT
         THEN
            NTYPE_HIST := 11;
         ELSIF NTRANSACTION = INSGENERALPKG.NTEMPPOLICYAMENDMENT
         THEN
            NTYPE_HIST := 54;
         ELSIF NTRANSACTION = INSGENERALPKG.NCERTIFAMENDMENT
         THEN
            NTYPE_HIST := 12;
         ELSIF NTRANSACTION = INSGENERALPKG.NTEMPCERTIFAMENDMENT
         THEN
            NTYPE_HIST := 55;
         ELSIF NTRANSACTION IN
                  (INSGENERALPKG.NPOLICYREISSUE, INSGENERALPKG.NCERTIFREISSUE)
         THEN
            IF NTRANSACTION = INSGENERALPKG.NPOLICYREISSUE
            THEN
               INSPOLICY_CA001 (NTRANSACTION   => NTRANSACTION,
                                SCERTYPE       => SCERTYPE,
                                NBRANCH        => NBRANCH,
                                NPRODUCT       => NPRODUCT,
                                NPOLICY        => NPOLICY_AUX,
                                NCERTIF        => NCERTIF_AUX,
                                NUSERCODE      => NUSERCODE,
                                DEFFECDATE     => DEFFECDATE,
                                NOFFICE        => NOFFICE,
                                SBUSSITYP      => SBUSSITYP,
                                SPOLITYPE      => SPOLITYPE,
                                DNULLDATE      => DNULLDATE,
                                NAGENCY        => NAGENCY,
                                NOFFICEAGEN    => NOFFICEAGEN,
                                NPOL_QUOT      => NPOL_QUOT_AUX);
            /* SI ES RE-EMISION DEL CERTIFICADO*/
            ELSE
               /* SI SE ESTA RE-EMITIENDO UN CERTIFICADO SE DEBE PONER OBLIGATORIAS LAS TRANSACCIONES CA014 y CA016 */
               /* ESTAS NO SE PUEDEN PONER DESDE EL DISEÑADOR DE PRODUCTOS YA QUE EL MISMO NOS SEPARA LA PARAMETRIZACION DE */
               /* EMISION DE LA DE RE-EMISION */
               INSUPDPOLICY_WIN (SCERTYPE     => SCERTYPE,
                                 NBRANCH      => NBRANCH,
                                 NPRODUCT     => NPRODUCT,
                                 NPOLICY      => NPOLICY,
                                 NCERTIF      => NCERTIF,
                                 DEFFECDATE   => DEFFECDATE,
                                 SCODISPL     => 'CA014',
                                 NUSERCODE    => NUSERCODE,
                                 SCONTEN      => '1',
                                 NCOMMIT      => '1');
            END IF;

            INSCERTIFICAT_CA001 (NTRANSACTION   => NTRANSACTION,
                                 SCERTYPE       => SCERTYPE,
                                 NBRANCH        => NBRANCH,
                                 NPRODUCT       => NPRODUCT,
                                 NPOLICY        => NPOLICY_AUX,
                                 NCERTIF        => NCERTIF_AUX,
                                 NUSERCODE      => NUSERCODE,
                                 DEFFECDATE     => DEFFECDATE,
                                 NSELLCHANNEL   => NSELLCHANNEL,
                                 DFER           => DFER,
                                 NPOL_QUOT      => NPOL_QUOT_AUX,
                                 NDIGIT         => NDIGIT,
                                 NPROP_REG      => NPROP_REG,
                                 NRENEWALNUM    => NRENEWALNUM);

            INSPARTICULARDATA_CA001 (SCERTYPE       => SCERTYPE,
                                     NBRANCH        => NBRANCH,
                                     NPRODUCT       => NPRODUCT,
                                     NPOLICY        => NPOLICY_AUX,
                                     NCERTIF        => NCERTIF_AUX,
                                     DEFFECDATE     => DEFFECDATE,
                                     NUSERCODE      => NUSERCODE,
                                     NTRANSACTION   => NTRANSACTION,
                                     DLASTCHANGEA   => DLASTCHANGEA,
                                     DNULLDATE      => DNULLDATE);

            IF NTRANSACTION = INSGENERALPKG.NPOLICYREISSUE
            THEN
               NTYPE_HIST := 5;
            ELSE
               NTYPE_HIST := 6;
            END IF;
         /* RE_IMPRESION*/
         ELSIF NTRANSACTION = INSGENERALPKG.NREPRINT
         THEN
            INSPOLICY_CA001 (NTRANSACTION   => NTRANSACTION,
                             SCERTYPE       => SCERTYPE,
                             NBRANCH        => NBRANCH,
                             NPRODUCT       => NPRODUCT,
                             NPOLICY        => NPOLICY_AUX,
                             NCERTIF        => NCERTIF_AUX,
                             NUSERCODE      => NUSERCODE,
                             DEFFECDATE     => DEFFECDATE,
                             NOFFICE        => NOFFICE,
                             SBUSSITYP      => SBUSSITYP,
                             SPOLITYPE      => SPOLITYPE,
                             DNULLDATE      => DNULLDATE,
                             NAGENCY        => NAGENCY,
                             NOFFICEAGEN    => NOFFICEAGEN,
                             NPOL_QUOT      => NPOL_QUOT_AUX);

            NTYPE_HIST := 19;
         /* DUPLICAR POLIZA*/
         ELSIF NTRANSACTION = INSGENERALPKG.NDUPLICATEDPOLICY
         THEN
            INSQUOTPROPCONVERTIONPKG.
             INSQUOTPROPCONVERTION (SCERTYPE       => '2',
                                    NBRANCH        => NBRANCH,
                                    NPRODUCT       => NPRODUCT,
                                    NPOLICY        => NPOLICY_AUX,
                                    NCERTIF        => NCERTIF_AUX,
                                    NPROPONUM      => NPOL_QUOT_AUX,
                                    DEFFECDATE     => DEFFECDATE,
                                    NUSERCODE      => NUSERCODE,
                                    SPOLITYPE      => SPOLITYPE,
                                    SORIGINAL      => NULL,
                                    SINVALID       => SINVALID,
                                    SCERTYPE_DES   => '2',
                                    SCOMMIT        => '1',
                                    SCOLTIMRE      => NULL,
                                    SCODISPL       => SCODISPL,
                                    NTRANSACTION   => NTRANSACTION);
         /* TRASPASO DE ASEGURADO*/
         ELSIF NTRANSACTION = INSGENERALPKG.NTRANSHOLDER
         THEN
            INSQUOTPROPCONVERTIONPKG.
             INSQUOTPROPCONVERTION (SCERTYPE       => '2',
                                    NBRANCH        => NBRANCH,
                                    NPRODUCT       => NPRODUCT,
                                    NPOLICY        => NPOLICY,
                                    NCERTIF        => NCERTIF_AUX,
                                    NPROPONUM      => NPOLICY_AUX,
                                    DEFFECDATE     => DEFFECDATE,
                                    NUSERCODE      => NUSERCODE,
                                    SPOLITYPE      => SPOLITYPE,
                                    SORIGINAL      => NULL,
                                    SINVALID       => SINVALID,
                                    SCERTYPE_DES   => '2',
                                    SCOMMIT        => '1',
                                    SCOLTIMRE      => NULL,
                                    SCODISPL       => SCODISPL,
                                    NTRANSACTION   => NTRANSACTION);
            NCERTIF_OUT := NCERTIF_AUX;
         END IF;

         IF NTYPE_HIST > 0
         THEN
            UPDATE_POLICYHIS (SCERTYPE       => SCERTYPE,
                              NBRANCH        => NBRANCH,
                              NPRODUCT       => NPRODUCT,
                              NPOLICY        => NPOLICY_AUX,
                              NCERTIF        => NCERTIF_AUX,
                              DEFFECDATE     => DEFFECDATE,
                              NTYPE_HIST     => NTYPE_HIST,
                              DEXPIRDAT      => DNULLDATE,
                              NUSERCODE      => NUSERCODE,
                              DLEDGERDAT     => DLEDGERDAT,
                              NTYPE_AMEND    => NTYPE_AMEND,
                              NSERV_ORDER    => NSERV_ORDER,
                              DFER           => DFER,
                              NTRANSACTIO    => NTRANSACTIO,
                              NMOV_HISTOR    => NMOV_HISTOR,
                              NCAUSE_AMEND   => NCAUSE_AMEND);
         END IF;
      END IF;

      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYAMENDMENT, INSGENERALPKG.NCERTIFAMENDMENT)
         AND 1 = 2
      THEN
         UPDATE PREMIUM
            SET SSTATUSVA = '2'
          WHERE     SCERTYPE = INSTRANSACTION.SCERTYPE
                AND NBRANCH = INSTRANSACTION.NBRANCH
                AND NPRODUCT = INSTRANSACTION.NPRODUCT
                AND NPOLICY = INSTRANSACTION.NPOLICY_AUX
                AND NCERTIF = INSTRANSACTION.NCERTIF_AUX
                AND NSTATUS_PRE IN (1, 4, 8);
      END IF;

      IF NTRANSACTION IN
            (INSGENERALPKG.NPOLICYREISSUE, INSGENERALPKG.NCERTIFREISSUE)
      THEN
         UPDATE PREMIUM
            SET SSTATUSVA = '3'
          WHERE     SCERTYPE = INSTRANSACTION.SCERTYPE
                AND NBRANCH = INSTRANSACTION.NBRANCH
                AND NPRODUCT = INSTRANSACTION.NPRODUCT
                AND NPOLICY = INSTRANSACTION.NPOLICY_AUX
                AND NCERTIF = INSTRANSACTION.NCERTIF_AUX
                AND NSTATUS_PRE IN (1, 4, 8);
      END IF;

      IF R_PRODUCT.SBRANCHT = '1'
      THEN
         REAPRODUCT_LI (NBRANCH      => NBRANCH,
                        NPRODUCT     => NPRODUCT,
                        DEFFECDATE   => DEFFECDATE,
                        RC1          => C_PRODUCT_LI);

         FETCH C_PRODUCT_LI INTO R_PRODUCT_LI;

         BPRODUCT := C_PRODUCT_LI%FOUND;

         CLOSE C_PRODUCT_LI;

         IF BPRODUCT
         THEN
            NPRODCLAS := R_PRODUCT_LI.NPRODCLAS;
         END IF;
      END IF;

      COMMIT;

      OPEN RC1 FOR
         SELECT R_PRODUCT.SBRANCHT SBRANCHT,
                NPOLICY_OUT NPOLICY,
                NCERTIF_OUT NCERTIF,
                R_CERTIFICAT.DSTARTDATE DSTARTDATE,
                R_CERTIFICAT.DEXPIRDAT DEXPIRDAT,
                SINVALID SINVALID,
                NPRODCLAS NPRODCLAS,
                NTRANSACTIO NTRANSACTIO
           FROM DUAL;
   END INSTRANSACTION;
END INSCA001PKG;