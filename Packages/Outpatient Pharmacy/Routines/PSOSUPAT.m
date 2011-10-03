PSOSUPAT ;BIR/RTR-Pull all Rx's from suspense for a patient ;03/01/96
 ;;7.0;OUTPATIENT PHARMACY;**8,130,185**;DEC 1997
 ;External reference to ^PS(55 supported by DBIA 2228
 ;External reference to ^PSSLOCK supported by DBIA 2789
PAT N PSOALRX,PSOALRXS S POP=0 K RXP,RXRR,RXFL,RXRP,RXPR,ASKED,BC,DELCNT,WARN,PSOAL,PSOPROFL,PSOQFLAG,PSOPULL,PSOWIN,PSOWINEN,PPLHOLD,PPLHOLDX W ! S DIR("A")="Are you entering the patient name or barcode",DIR(0)="SBO^P:Patient Name;B:Barcode"
 S DIR("?")="Enter P if you are going to enter the patient name. Enter B if you are going to enter or wand the barcode."
 D ^DIR K DIR G:$D(DIRUT) ^PSOSUPRX S BC=Y D NOW^%DTC S TM=$E(%,1,12),TM1=$P(TM,".",2)
BC S (OUT,POP)=0 I BC="B" W ! S DIR("A")="Enter/wand barcode",DIR(0)="FO^5:20",DIR("?")="Enter or wand a prescription barcode for the patient you wish to pull all Rx's for" D ^DIR K DIR G:$G(DIRUT) PAT S BCNUM=Y D
 .D PSOINST Q:OUT  S RX=$P(BCNUM,"-",2) K RTE S MW="" D:$D(^PSRX(RX,0))
 ..S (DFN,PSODFN)=$P(^PSRX(RX,0),"^",2) W " ",$P($G(^DPT(DFN,0)),"^")
 ..D ICN^PSODPT(DFN)
 .I '$D(^PSRX(RX,0)) W !,$C(7),"NO PRESCRIPTION RECORD FOR THIS BARCODE." S OUT=1
 G:OUT BC
NAM I BC="P" W ! S DIC(0)="AEMZQ",DIC="^DPT(",DIC("S")="I $D(^PS(52.5,""AC"",+Y))!($D(^PS(52.5,""AG"",+Y)))" D ^DIC K DIC G:$D(DTOUT)!($D(DUOUT))!(Y<0) PAT S (DFN,PSODFN)=+Y K RTE S MW=""
 S PSOLOUD=1 D:$P($G(^PS(55,PSODFN,0)),"^",6)'=2 EN^PSOHLUP(PSODFN) K PSOLOUD
 S (ASKED,DELCNT,WARN)=0 F CBD=0:0 S CBD=$O(^PS(55,DFN,"P",CBD)) Q:CBD'>0  D TEST
 I $G(PSOQFLAG) D RESET G EXIT
 ;S HOLDPROF=$G(PSOPROFL) K PSOPROFL
 ;I $D(PSOPART) S (PSOPULL,PSODBQ)=1 F RR=0:0 S RR=$O(PSOPART(RR)) Q:'RR  S PDUZ=DUZ,PPL=RR,RXP=PSOPART(RR) D Q^PSORXL
 ;S PSOPROFL=HOLDPROF I $D(ZTSK),'$G(PPLHOLD) W !!,"LABEL(S) ARE QUEUED TO PRINT",!
 F GGGG=0:0 S GGGG=$O(RXPR(GGGG)) Q:'GGGG  K:'$G(RXPR(GGGG)) RXPR(GGGG)
 K RXP,PPL S PDUZ=DUZ,PSONOPRT=1
 I $G(PPLHOLD)'="" S PPL=PPLHOLD S:$G(SUSROUTE) BBRX(1)=PPL S HOLDPPL=PPL,PSOPULL=1,PSODBQ=1,RXLTOP=1 D WIND^PSOSUPRX D Q^PSORXL I '$G(PSOQFLAG) W !!,"LABEL(S) ARE QUEUED TO PRINT",! S PPL=$P(HOLDPPL,",") D PRF D:'$G(PSOQFLAG)  S PSOQFLAG=0
 .I $P(PSOPAR,"^",8),$G(PSOPROFL) W !!,"PROFILE(S) ARE QUEUED TO PRINT"
 ;call to bingo board
 I $G(PPLHOLDX),'$G(PSOQGLAG),$G(SUSROUTE) S BBRX(2)=PPLHOLDX
 D:$G(BINGRTE)&($D(DISGROUP))&('$G(PSOQFLAG)) ^PSOBING1 K BINGRTE,BBRX
 I $G(PPLHOLDX),'$G(PSOQFLAG) D  S PDUZ=DUZ,PPL=PPLHOLDX,PSNP=0,(PSODBQ,PSOPULL)=1 D Q^PSORXL
 .F XXX=0:0 S XXX=$O(RXPR1(XXX)) Q:'XXX  S RXPR(XXX)=$P(RXPR1(XXX),"^",2)
 .F WWWW=0:0 S WWWW=$O(RXRP1(WWWW)) Q:'WWWW  S:$D(RXRP1(WWWW)) RXRP(WWWW)=1
 I $G(PSOQFLAG) D RESET
EXIT K ACT,BCNUM,CBD,CNT,COM,DA,DEAD,DEL,DELCNT,DFN,DIRUT,DR,DTOUT,DUOUT,DTTM,GG,HOLD,HOLDPPL,HDSFN,OUT,PSOPULL,PSOWIN,PSOWINEN,PSODBQ,PPLHOLD,PPLHOLDX,HOLDPROF,RR,ZZZZ,PSDNAME,PSDDDATE,ZTSK,WWWW,RXRP,RXRP1,PSONOPRT,RXFL,RXRR
 S PSOALRX="" F  S PSOALRX=$O(PSOALRXS(PSOALRX)) Q:PSOALRX=""  D PSOUL^PSSLOCK(PSOALRX)
 K MW,PDUZ,PPL,PRF,PSPOP,PSOPROFL,RF,RFCNT,RX,RXPR,RXPR1,RXREC,SFN,GGGG,STOP,SUB,VADM,WARN,X,Y,Y(0),%,%W,%Y,%Y1,RXLTOP,PSOGET,PSOGETF,PSOGETFN Q
TEST I $D(^PS(55,DFN,"P",CBD,0)) S RXREC=+^(0) I +$P($G(^PSRX(RXREC,"STA")),"^")=5,$D(^PS(52.5,"B",RXREC)) S SFN=+$O(^(RXREC,0)) Q:SFN'>0!($G(PSOQFLAG))!('$D(^PS(52.5,SFN,0)))  S PSPOP=0 D:$G(PSODIV) DIV I 'PSPOP D CHKDEAD Q:DEAD  D BEG
 Q
CHKDEAD D DEM^VADPT S PSDNAME=$G(VADM(1)) I VADM(1)="" W !?10,"PATIENT NAME UNKNOWN" S DEAD=0 Q
 I VADM(6)="" S DEAD=0 Q
 S PSDDDATE=$P(VADM(6),"^",2) F ZZZZ=0:0 S ZZZZ=$O(^PS(55,DFN,"P",ZZZZ)) Q:'ZZZZ  I $D(^PS(55,DFN,"P",ZZZZ,0)),$P($G(^(0)),"^") S (DA,RXREC)=$P(^(0),"^") I $O(^PS(52.5,"B",DA,0)) D DEAD
 Q
DEAD S HOLD=DA,REA="C",COM="Died ("_$G(PSDDDATE)_")",DA=RXREC,DEAD=1 D CAN^PSOCAN W:'$G(WARN) !!,?10,$G(PSDNAME)," DIED ",$G(PSDDDATE) S WARN=1,DA=HOLD K HOLD,REA Q
DIV I $D(^PS(52.5,SFN,0)),$D(^PSRX(+$P(^PS(52.5,SFN,0),"^"),2)),$P(^PS(52.5,SFN,0),"^",6)'=$G(PSOSITE) S RXREC=+$P(^PS(52.5,SFN,0),"^") D CKDIV
 Q
CKDIV I '$P($G(PSOSYS),"^",2) W !!?10,$C(7),"Rx # ",$P(^PSRX(RXREC,0),"^")," is not a valid choice. (Different Division)" S PSPOP=1 Q
 I $P($G(PSOSYS),"^",3) W !!?10,$C(7) S DIR("A")="Rx # "_$P(^PSRX(RXREC,0),"^")_" is from another division.  Continue",DIR(0)="Y",DIR("B")="Y" D ^DIR K DIR I $G(DIRUT)!('Y) S PSPOP=1
 Q
BEG I $P($G(^PSRX(RXREC,2)),"^",6)<DT,$P($G(^("STA")),"^")<11 D  S DIE=52,DA=RXREC,DR="100///"_11 D ^DIE S DA=SFN,DIK="^PS(52.5," D ^DIK K DIE,DA,DIK W !!,"Rx #"_$P(^PSRX(RXREC,0),"^")_" has expired!" D PAUSE Q
 .D EX^PSOSUTL
 I '$D(^PS(52.5,SFN,0)) K PSOAL Q
 I +$G(^PS(52.5,SFN,"P")) W !!,$C(7),">>> Rx #",$P(^PSRX(+$P(^(0),"^"),0),"^")_" has already been printed from suspense.",!,?5,"Use the reprint routine under the rx option to produce a label." D PAUSE Q
 S PSOALRX=$P($G(^PS(52.5,SFN,0)),"^") I PSOALRX D PSOL^PSSLOCK(PSOALRX) I '$G(PSOMSG) D  D PAUSE K PSOMSG,PSOALRX Q
 .I $P($G(PSOMSG),"^",2)'="" W !!,"Rx: "_$P($G(^PSRX(PSOALRX,0)),"^")_" cannot be pulled from suspense.",!,$P($G(PSOMSG),"^",2),! Q
 .W !!,"Another person is editing Rx "_$P($G(^PSRX(PSOALRX,0)),"^"),!,"It cannot be pulled from suspense.",!
 S PSOALRXS(+$G(PSOALRX))=""
 K PSOMSG,PSOALRX
 S DA=$P(^PS(52.5,SFN,0),"^"),RXPR(DA)=+$P(^(0),"^",5),RXFL(DA)=$P($G(^(0)),"^",13)
 I $L($G(PPLHOLD))<240 S PPLHOLD=$S($G(PPLHOLD)="":$P(^PS(52.5,SFN,0),"^"),1:$G(PPLHOLD)_","_+^PS(52.5,SFN,0)) S:$P(^PS(52.5,SFN,0),"^",12) RXRP(DA)=1 G STR
 S PPLHOLDX=$S($G(PPLHOLDX)="":$P(^PS(52.5,SFN,0),"^"),1:$G(PPLHOLDX)_","_+^PS(52.5,SFN,0)) S:$G(RXPR(DA)) RXPR1(DA)=DA_"^"_RXPR(DA) S:$P(^PS(52.5,SFN,0),"^",12) RXRP1(DA)=1 K RXPR(DA)
STR I '$D(^PSRX(RXREC,1)),'$G(RXPR(RXREC)),'$G(RXPR1(RXREC)) S PSOPROFL=1
QUES S HDSFN=SFN D QUES^PSOSUPRX Q
PRF I $P(PSOPAR,"^",8),'$D(PRF(DFN)),$G(PSOPROFL) S HOLD=DFN D ^PSOPRF S DFN=HOLD,PRF(DFN)=""
 Q
PSOINST I '$D(^PSRX(+$P(Y,"-",2),0)) W !!,$C(7),"Non-existent prescription" S OUT=1 Q
 I $P(Y,"-")'=PSOINST W !!,$C(7),"The prescription is not from this institution." S OUT=1 Q
 Q
MAIL I $D(PSOWINEN),$G(PSOWIN) S ^PSRX(RXREC,"MP")=$S(PSOWINEN'="":PSOWINEN,1:"")
MAILS I $G(RXPR(RXREC)) S DA(1)=RXREC,DA=RXPR(RXREC),DIE="^PSRX("_DA(1)_",""P"",",DR=".02///"_MW D ^DIE K DIE Q
 S RFCNT=0 F RR=0:0 S RR=$O(^PSRX(RXREC,1,RR)) Q:'RR  S RFCNT=RR
 I 'RFCNT,'$G(RXPR(RXREC)) S DA=RXREC,DIE=52,DR="11///"_MW D ^DIE
 I RFCNT,'$G(RXPR(RXREC)) S DA(1)=RXREC,DA=RFCNT,DIE="^PSRX("_DA(1)_",1,",DR="2///"_MW D ^DIE
 K DIE,RFCNT,RR Q
RESET ;
 N PRSDA,PRSP,PRMW,PRMP,PRFILL,PRFILLN,PRPSRX,DA
 F PRSDA=0:0 S PRSDA=$O(RXRR(PRSDA)) Q:'PRSDA  D
 .S PRSP=$O(^PS(52.5,"B",PRSDA,0)) Q:'PRSP
 .Q:'$D(^PS(52.5,PRSP,0))
 .S PRMW=$S($P($G(RXRR(PRSDA)),"^")="":"M",1:$P($G(RXRR(PRSDA)),"^")),PRMP=$P($G(RXRR(PRSDA)),"^",2),PRFILL=$P($G(RXRR(PRSDA)),"^",3),PRFILLN=$P($G(RXRR(PRSDA)),"^",4),PRPSRX=$S($P($G(RXRR(PRSDA)),"^",5)="":"M",1:$P($G(RXRR(PRSDA)),"^",5))
 .I PRMW'="" S $P(^PS(52.5,PRSP,0),"^",4)=PRMW D
 ..I PRFILL="P" D  Q
 ...I $D(^PSRX(PRSDA,"P",+$G(PRFILLN),0)) S $P(^PSRX(PRSDA,"P",+$G(PRFILLN),0),"^",2)=$G(PRPSRX),$P(^PSRX(PRSDA,"MP"),"^")=PRMP
 ..I PRFILL="R",$G(PRFILLN) S DA(1)=PRSDA,DA=PRFILLN,DIE="^PSRX("_DA(1)_",1,",DR="2////"_PRPSRX D ^DIE K DIE
 ..I PRFILL="O" S DA=PRSDA,DIE="^PSRX(",DR="11////"_PRPSRX D ^DIE K DIE
 ..S $P(^PSRX(PRSDA,"MP"),"^")=PRMP
 Q
PAUSE ;
 W ! K DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR
 Q