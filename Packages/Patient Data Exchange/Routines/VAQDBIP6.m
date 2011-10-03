VAQDBIP6 ;ALB/JRP - CONTINUATIONS FOR VAQDBIP4;25-MAR-93
 ;;1.5;PATIENT DATA EXCHANGE;**41**;NOV 17, 1993
ELIG ;EXTRACT ELIGIBILITIES
 ;  DECLARATIONS TAKEN CARE OF IN VAQDBIP4
 S TMP=$T(ELIG+1^VAQDBII1)
 S FLDS=$TR($P(TMP,";",4),",",";")
 ;ENCRYPT PATIENT NAME
 S STRING=$P($$PATINFO^VAQUTL1(DFN),"^",1)
 S ENCSTR=STRING
 I $$NCRPFLD^VAQUTL2(2,.01) X ENCRYPT
 S NAME=ENCSTR
 ;DETERMINE PRIMARY ELIGIBILITY
 S DIC="^DPT("
 S DA=DFN
 S DR=.361
 S DIQ(0)="E"
 K ^UTILITY("DIQ1",$J)
 D EN^DIQ1
 S PRIME=$G(^UTILITY("DIQ1",$J,2,DFN,.361,"E"))
 ;GET OTHER ELIGIBILITIES
 S TMP=0
 F  S TMP=$O(^DPT(DFN,"E",TMP)) Q:('TMP)  D
 .S DIC="^DPT("
 .S DA=DFN
 .S DR=361
 .S DIQ(0)="E"
 .S DA(2.0361)=TMP
 .S DR(2.0361)=FLDS
 .K ^UTILITY("DIQ1",$J)
 .D EN^DIQ1
 .;SCREEN OUT PRIMARY ELIGIBILITY
 .S Y=$G(^UTILITY("DIQ1",$J,2.0361,DA(2.0361),.01,"E"))
 .Q:(Y=PRIME)
 .S SEQ=$$GETSEQ^VAQDBIP(ARRAY,2.0361,.01)
 .;ENCRYPT VALUE
 .S STRING=Y
 .S ENCSTR=STRING
 .I $$NCRPFLD^VAQUTL2(2.0361,.01) X ENCRYPT
 .S @ARRAY@("ID",2.0361,.01,SEQ)=NAME
 .S @ARRAY@("VALUE",2.0361,.01,SEQ)=ENCSTR
 .S Y=ENCSTR
 .;MOVE INFORMATION INTO EXTRACTION ARRAY
 .F X=1:1:$L(FLDS,";") D
 ..S Z=$P(FLDS,";",X)
 ..;STORE ID
 ..S @ARRAY@("ID",2.0361,Z,SEQ)=Y
 ..;ENCRYPT VALUE
 ..S STRING=$G(^UTILITY("DIQ1",$J,2.0361,DA(2.0361),Z,"E"))
 ..S ENCSTR=STRING
 ..I $$NCRPFLD^VAQUTL2(2.0361,Z) X ENCRYPT
 ..S @ARRAY@("VALUE",2.0361,Z,SEQ)=ENCSTR
 .K ^UTILITY("DIQ1",$J)
 Q
 ;
APPOINT ;EXTRACT APPOINTMENTS
 N VAQDT
 ;  DECLARATIONS TAKEN CARE OF IN VAQDBIP4
 S TMP=$T(APPOINT+1^VAQDBII1)
 S FLDS=$TR($P(TMP,";",4),",",";")
 ;ENCRYPT PATIENT NAME
 S STRING=$P($$PATINFO^VAQUTL1(DFN),"^",1)
 S ENCSTR=STRING
 I $$NCRPFLD^VAQUTL2(2,.01) X ENCRYPT
 S NAME=ENCSTR
 D APPGET ; Get last 5 appointments
 S VAQDT="" ; Process in reverse order
 F VAQDT=$O(^UTILITY("DIQ1",$J,2.98,VAQDT),-1) Q:VAQDT=""  D
 .S Y=VAQDT D DD^%DT
 .S SEQ=$$GETSEQ^VAQDBIP(ARRAY,2.98,.001)
 .;ENCRYPT VALUE
 .S STRING=Y
 .S ENCSTR=STRING
 .I $$NCRPFLD^VAQUTL2(2.98,.001) X ENCRYPT
 .S @ARRAY@("ID",2.98,.001,SEQ)=NAME
 .S @ARRAY@("VALUE",2.98,.001,SEQ)=ENCSTR
 .S Y=ENCSTR
 .;MOVE INFORMATION INTO EXTRACTION ARRAY
 .F X=1:1:$L(FLDS,";") D
 ..S Z=$P(FLDS,";",X)
 ..;STORE ID
 ..S @ARRAY@("ID",2.98,Z,SEQ)=Y
 ..;ENCRYPT VALUE
 ..S STRING=$G(^UTILITY("DIQ1",$J,2.98,VAQDT,Z,"E"))
 ..S ENCSTR=STRING
 ..I $$NCRPFLD^VAQUTL2(2.98,Z) X ENCRYPT
 ..S @ARRAY@("VALUE",2.98,Z,SEQ)=ENCSTR
 K ^UTILITY("DIQ1",$J)
 Q
APPGET ; Get last 5 appointments.
 ; Prior to patch *41, we retrieved data directly from the APPOINTMENTS
 ; subfile (#2.98) of the PATIENT file.  Now, we retrieve using the new
 ; Scheduling Replacement API from a central database.
 ; Fields requested:
 ;  Old  Description       New
 ;  ---  ----------------  ---
 ; .001  Appt date/time      1
 ;  .01  Clinic              2
 ;    3  Status              3
 ;    9  Purpose of Visit   18
 ;  9.5  Appt type          10
 N X,VAQSD,VAQDT,VAQREC
 S VAQSD(4)=DFN
 S VAQSD("FLDS")="1;2;3;18;10"
 S VAQSD("SORT")="P" ; Sort by patient only (not clinic)
 S VAQSD("MAX")=-5 ; Return last 5 appts.
 S X=$$SDAPI^SDAMA301(.VAQSD)
 ; For each of the last 5 appts, move to Utility global,
 ; with VAQDT being the date/time of the appt.
 K ^UTILITY("DIQ1",$J)
 S VAQDT=""
 F  S VAQDT=$O(^TMP($J,"SDAMA301",DFN,VAQDT)) Q:VAQDT=""  S VAQREC=^(VAQDT) D
 . S ^UTILITY("DIQ1",$J,2.98,VAQDT,.01,"E")=$P($P(VAQREC,U,2),";",2)
 . S ^UTILITY("DIQ1",$J,2.98,VAQDT,3,"E")=$P($P(VAQREC,U,3),";",2)
 . S ^UTILITY("DIQ1",$J,2.98,VAQDT,9,"E")=$P($P(VAQREC,U,18),";",2)
 . S ^UTILITY("DIQ1",$J,2.98,VAQDT,9.5,"E")=$P($P(VAQREC,U,10),";",2)
 K ^TMP($J,"SDAMA301")
 Q
 ;
DENTAL ;EXTRACT DENTAL APPOINTMENTS
 ;  DECLARATIONS TAKEN CARE OF IN VAQDBIP4
 S TMP=$T(DENTAL+1^VAQDBII1)
 S FLDS=$TR($P(TMP,";",4),",",";")
 ;ENCRYPT PATIENT NAME
 S STRING=$P($$PATINFO^VAQUTL1(DFN),"^",1)
 S ENCSTR=STRING
 I $$NCRPFLD^VAQUTL2(2,.01) X ENCRYPT
 S NAME=ENCSTR
 ;PUT DENTAL APPOINTMENTS IN REVERS ORDER
 S TMP=0
 K ^TMP("VAQ",$J,$J)
 F  S TMP=$O(^DPT(DFN,.37,TMP)) Q:('TMP)  D
 .S X=+$G(^DPT(DFN,.37,TMP,0))
 .Q:('X)
 .S ^TMP("VAQ",$J,$J,(9999999-X))=TMP_"^"_X
 S TMP=""
 ;EXTRACT 5 DENTAL APPOINTMENTS
 F LOOP=1:1:5 S TMP=$O(^TMP("VAQ",$J,$J,TMP)) Q:(TMP="")  D
 .S DIC="^DPT("
 .S DA=DFN
 .S DR=.37
 .S DIQ(0)="E"
 .S DA(2.11)=+^TMP("VAQ",$J,$J,TMP)
 .S DR(2.11)=FLDS
 .K ^UTILITY("DIQ1",$J)
 .D EN^DIQ1
 .;MOVE DATE OF DENTAL APPOINTMENT INTO EXTRACTION ARRAY
 .S Y=+$P(^TMP("VAQ",$J,$J,TMP),"^",2) D DD^%DT
 .S SEQ=$$GETSEQ^VAQDBIP(ARRAY,2.11,.01)
 .;ENCRYPT VALUE
 .S STRING=Y
 .S ENCSTR=STRING
 .I $$NCRPFLD^VAQUTL2(2.11,.01) X ENCRYPT
 .S @ARRAY@("ID",2.11,.01,SEQ)=NAME
 .S @ARRAY@("VALUE",2.11,.01,SEQ)=ENCSTR
 .S Y=STRING
 .;MOVE INFO INTO EXTRACTION ARRAY
 .F X=1:1:$L(FLDS,";") D
 ..S Z=$P(FLDS,";",X)
 ..Q:(Z=.01)
 ..;STORE ID
 ..S @ARRAY@("ID",2.11,Z,SEQ)=Y
 ..;ENCRYPT VALUE
 ..S STRING=$G(^UTILITY("DIQ1",$J,2.11,DA(2.11),Z,"E"))
 ..S ENCSTR=STRING
 ..I $$NCRPFLD^VAQUTL2(2.11,Z) X ENCRYPT
 ..S @ARRAY@("VALUE",2.11,Z,SEQ)=ENCSTR
 .K ^UTILITY("DIQ1",$J)
 K ^TMP("VAQ",$J,$J)
 Q