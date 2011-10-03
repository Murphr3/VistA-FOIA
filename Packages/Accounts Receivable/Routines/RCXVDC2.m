RCXVDC2 ;DAOU/ALA-AR Data Extraction Data Creation ;02-JUL-03
 ;;4.5;Accounts Receivable;**201,227,228**;Mar 20, 1995
 ;
 ; PATIENT FILE (# 2)
 Q
D2 ; 
 NEW RCXVDT,RCXVD,RCXVD1,RCXVD2,RCXVD3,RCXVPF,RCXVDA,RCXVENR,RCXVPE
 N RCXVPE1,RCXVCT,RCMTYP,RCMTDA,RCMTDT,PC1,PC2,PC3
 NEW RCXVCTY,RCXVICN,RCXVELG,VADM
 S RCXVD=$G(^DPT(DFN,0))
 S RCXVDT=$P(RCXVD,U,3)
 S RCXVDA=$E($$HLDATE^HLFNC(RCXVDT),1,8) ; DT of Birth
 S RCXVDA=RCXVDA_RCXVU_$P(RCXVD,U,9) ; SSN
 S RCXVICN=$P($G(^DPT(DFN,"MPI")),U,1)
 S RCXVDA=RCXVDA_RCXVU_RCXVICN ; ICN
 S RCXVDA=RCXVDA_RCXVU_$P($$SITE^VASITE(),U,3)_"v"_DFN ; IEN
 S RCXVDA=RCXVDA_RCXVU_$P(RCXVD,U,2) ; SEX
 S RCXVD1=$G(^DPT(DFN,.11))
 S RCXVD2=$G(^DPT(DFN,.35))
 S RCXVD3="^^^^^^^^^^^"
 S RCXVDA=RCXVDA_RCXVU_$P(RCXVD1,U,6) ; ZIPCODE
 ;
 NEW VAPA,VAERR
 D ADD^VADPT
 S RCXVCTY=$P($G(VAPA(7)),U,2)
 S RCXVDA=RCXVDA_RCXVU_RCXVCTY ; COUNTY
 ;
 S RCXVPE="",RCXVPE1=""
 S RCXVENR=$P($G(^DPT(DFN,"ENR")),U,1)
 I RCXVENR'="" D
 . S RCXVPE=$P($G(^DGEN(27.11,RCXVENR,0)),U,7) ; Enrollment priority
 . S RCXVPE1=$$GET1^DIQ(27.11,RCXVENR_",",.12,"E") ; Enrollment subgroup
 ;
 ;Primary Eligibility Code
 S RCXVELG=$P($G(^DPT(DFN,.36)),U,1)
 I RCXVELG'="" S RCXVELG=$P($G(^DIC(8,RCXVELG,0)),U,1)
 S RCXVDA=RCXVDA_RCXVU_RCXVPE_RCXVU_RCXVPE1_RCXVU_RCXVELG
 S RCXVDT=$P(RCXVD2,U)
 D DEM^VADPT S RCXVDT=$P(VADM(6),U)
 S RCXVDA=RCXVDA_RCXVU_$E($$HLDATE^HLFNC(RCXVDT),1,8) ;Date of Death
 S RCXVDA=RCXVDA_RCXVU_$P(VADM(10),U,2) ;Marital Status
 ;means test data
 F RCMTYP=1,2,3,4 D:$D(^DGMT(408.31,"AID",RCMTYP,DFN))
 . S PC3=RCMTYP*3,PC2=PC3-1,PC1=PC3-2
 . S RCMTDT=$O(^DGMT(408.31,"AID",RCMTYP,DFN,-9999999))
 . S RCMTDA=$O(^DGMT(408.31,"AID",RCMTYP,DFN,RCMTDT,0)) Q:'RCMTDA
 . S RCXVDT=-RCMTDT
 . S $P(RCXVD3,U,PC1)=$E($$HLDATE^HLFNC(RCXVDT),1,8) ;Test Date
 . S $P(RCXVD3,U,PC2)=$$GET1^DIQ(408.31,RCMTDA_",",.03,"E") ;Test Status
 . S $P(RCXVD3,U,PC3)=$P($G(^DGMT(408.31,RCMTDA,0)),U,4) ;Income
 . Q
 S ^TMP($J,RCXVBLN,"2-2A")=RCXVDA
 S ^TMP($J,RCXVBLN,"2-2B")=RCXVD3
 Q
 ;