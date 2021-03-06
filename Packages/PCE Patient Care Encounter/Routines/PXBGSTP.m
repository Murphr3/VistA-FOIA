PXBGSTP ;ISL/JVS - GATHER STOP CODES FROM SECONDARY VISITS ;7/24/96  08:15
 ;;1.0;PCE PATIENT CARE ENCOUNTER;;Aug 12, 1996
 ;
 ;
 ;
STP(PXBVST) ;--Gather the stop codes from the secondary visits
 ;
 ;
 ;PXBVST=PRIMARY VISIT
 ;--Validate A primary visit is sent in
 I $P($G(^AUPNVSIT(PXBVST,150)),"^",3)'="P" S PXBCNT=0 Q
 ;
 ;--NEW variables
 N IEN,STP,STOPCODE,AMISCODE,INDATEI,INDATEE,PXBC
 N D0,D1,DA,DDH,DIG,DIH,DIQ,DR
 ;--KILL variables
 K ^TMP("PXBU",$J),VAUGHN,PXBKY,PXBSAM,PXBSKY,GROUP
 ;--CREATE tmp global
 I $D(^AUPNVSIT("AD",PXBVST)) D
 .S IEN=0 F  S IEN=$O(^AUPNVSIT("AD",PXBVST,IEN)) Q:IEN'>0  D
 ..I '$P(^AUPNVSIT(IEN,0),"^",8) Q
 ..I $P(^AUPNVSIT(IEN,150),"^",3)="C" Q
 ..S ^TMP("PXBU",$J,"STP",IEN)=""
 ;
 ;
A ;--Set array with the STOP CODES from the visits
 I $D(^TMP("PXBU",$J,"STP")) D
 .S IEN=0 F  S IEN=$O(^TMP("PXBU",$J,"STP",IEN)) Q:IEN'>0  D
 ..S DIC=9000010,DR=.08,DA=IEN,DIQ="VAUGHN(",DIQ(0)="EI" D EN^DIQ1
 ..S STOPCODE=$G(VAUGHN(9000010,DA,.08,"E"))
 ..S STOPIEN=$G(VAUGHN(9000010,DA,.08,"I"))
 ..S DIC=40.7,DR="1;2",DA=STOPIEN,DIQ="VAUGHN(",DIQ(0)="EI" D EN^DIQ1
 ..S AMISCODE=$G(VAUGHN(40.7,DA,1,"E"))
 ..I $G(AMISCODE)']"" Q
 ..S INDATEI=$G(VAUGHN(40.7,DA,2,"I"))
 ..S INDATEE=$G(VAUGHN(40.7,DA,2,"E"))
 ..S GROUP=AMISCODE_"^"_STOPCODE_"^"_INDATEI_"^"_INDATEE
 ..S STP(AMISCODE,IEN)=GROUP
 ;
 ;
B ;--ADD Line Numbers
 I $D(STP) D
 .S PXBC=0,STP="" F  S STP=$O(STP(STP)) Q:STP=""  D
 ..S IEN=0 F  S IEN=$O(STP(STP,IEN)) Q:IEN=""  S PXBC=PXBC+1 D
 ...S PXBKY(STP,PXBC)=$G(STP(STP,IEN)),PXBSAM(PXBC)=$G(STP(STP,IEN))
 ...S PXBSKY(PXBC,IEN)=""
F ;--FINISH UP THE VARIABLES
 K ^TMP("PXBU",$J),VAUGHN
 S PXBCNT=+$G(PXBC)
CREDIT ;--FIND THE MAIN CREDIT STOP FROM MAIN VISIT
 N CLIPTR,TANA,CRESTP
 S CLIPTR=$P($G(^AUPNVSIT(PXBVST,0)),"^",22) Q:CLIPTR']""
 S CRESTP=$P($G(^SC(CLIPTR,0)),"^",7) Q:CRESTP']""
 ;
 ;
 S DIC=40.7,DR=".01;1",DA=CRESTP,DIQ="TANA(",DIQ(0)="EI" D EN^DIQ1
 S CREDIT=TANA(40.7,CRESTP,1,"E")_"--"_TANA(40.7,CRESTP,.01,"E")
 Q
 ;
