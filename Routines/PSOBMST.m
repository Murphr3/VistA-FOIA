PSOBMST ;BIR/LAW-black line resolver ;03/6/98
 ;;7.0;OUTPATIENT PHARMACY;**2,71,193**;DEC 1997
 ;master program launched by psob
 S PSOBMST="",PSOBP1=+PSOBR1,PSOBR1=+$P(PSOBR1,"^",2),PSOBP2=+PSOBR2,PSOBR2=+$P(PSOBR2,"^",2),(NEW1,NEW11)="",PSOBRX=PSOBR1
 F ZI=PSOBP1-1:0 S ZI=$O(^PS(52.9,PSOBIO,1,ZI)) Q:('ZI)!(PSOBP2<ZI)  S (PSOBX,PSOBX1)="",P=$S($P(^(ZI,0),"^",2)="P":U,1:",") D J D PRF:(P=U)&(ZI'=PSOBP1),LBL:(P'=U)&(PSOBX'="") S PSOBRX=0
 D ^%ZISC K CC,EXDT,I,II,IOP,J,JJ,K,L,LBL,NEW1,NEW11,P,PI,POP,PPL,PSCAP,PSOSITE,PSOBIO,PSOBMST,PSOBP1,PSOBP2,PSOBR1,PSOBR2,PSOBRX,PSOBX,PSOBLALL,PSOBX1,REF,RX,WARN,X,Y,ZI,ZY,%ZIS,PSODIV,PDUZ,PSOBXPRT,BBB,BBBB,PBXRF S:$D(ZTQUEUED) ZTREQ="@" Q
J Q:'$D(^PS(52.9,PSOBIO,1,ZI,2))  F J=PSOBRX:0 S J=$O(^PS(52.9,PSOBIO,1,ZI,2,J)) Q:('J)!((ZI=PSOBP2)&(J=PSOBR2))  D SET
 Q
SET I ($L(PSOBX)+$L(^PS(52.9,PSOBIO,1,ZI,2,J,0))+1)<245 S PSOBX=PSOBX_+^(0)_P S:$P(^(0),"^",2) PSOBXPRT($P(^(0),"^"))=$P(^(0),"^",2) S:$P(^(0),"^",3)'="" PBXRF($P(^(0),"^"))=$P(^(0),"^",3)
 E  S PSOBX1=PSOBX1_+^PS(52.9,PSOBIO,1,ZI,2,J,0)_P S:$P(^(0),"^",2) PSOBXPRT($P(^(0),"^"))=$P(^(0),"^",2) S:$P(^(0),"^",3)'="" PBXRF($P(^(0),"^"))=$P(^(0),"^",3)
 Q
PRF Q:(ZI=PSOBP2)&((PSOBR2=0)!($D(^PS(52.9,PSOBIO,1,ZI,2,PSOBR2,0))))  S:PSOBX'="" NEW1="^"_PSOBX S:PSOBX1'="" NEW11="^"_PSOBX1
 S DFN=$P(^PS(52.9,PSOBIO,1,ZI,0),"^"),PSODTCUT=$P(^(0),"^",4),PSOPRPAS=$P(^(0),"^",6),PFIO=IO,%ZIS="",IOP=PFIO D ^%ZIS D START^PSOPRF S (NEW1,NEW11)="" K DFN,PSODTCUT,PSOPRPAS,IOP Q
LBL S PPL=PSOBX,PSOSITE=$P(^PS(52.9,PSOBIO,1,ZI,0),"^",7),REPRINT=1 S:$P(^(0),"^",5)'="" COPIES=$P(^(0),"^",5) S:$P(^(0),"^",6)'="" SIDE=$P(^(0),"^",6) I $D(^(1)),^(1)'="" S RXY=^(1)
 S IOP=IO,%ZIS="" D ^%ZIS K IOP D EN01
 F L=1:1 S LBL=$P(PPL,",",L) Q:(LBL="")&(L'<$L(PPL,","))  D UPDT
 I $G(PSOBX1)'="" S PSOBX=PSOBX1 S PSOBX1="" G LBL
 K PPL,PSOSITE,REPRINT,RXP,RXY,COPIES,SIDE Q
UPDT ;
 S BBB=0 F BBBB=0:0 S BBBB=$O(^PSRX(LBL,1,BBBB)) Q:'BBBB  S BBB=BBBB S:BBBB>5 BBB=BBBB+1
 S K=1,II=0 F JJ=0:0 S JJ=$O(^PSRX(LBL,"A",JJ)) Q:'JJ  S II=JJ,K=K+1
 S II=II+1 S:'($D(^PSRX(LBL,"A",0))#2) ^(0)="^52.3DA^^^" S ^(0)=$P(^(0),"^",1,2)_"^"_II_"^"_K,^PSRX(LBL,"A",II,0)=DT_"^W^"_PDUZ_"^"_$S($G(PSOBXPRT(LBL)):6,$D(PBXRF(LBL)):PBXRF(LBL),1:BBB)_"^"_"GROUP REPRINT" D  Q
 .I $G(PBXRF(LBL))>5,'$G(PSOBXPRT(LBL)) S $P(^PSRX(LBL,"A",II,0),"^",4)=($G(PBXRF(LBL))+1)
EN01 I $D(PSOIOS),PSOIOS]"" D DEVBAR
 I $G(PSOBAR0)]"",$G(PSOBAR1)]"",$D(^PS(59,PSOSITE,1)) S PSOBARS=1
 K PSOCPN,PSOLBLCP
 I $G(PSODISP) D ^PSOLBL4
 G:'$D(PPL)!($P(PSOPAR,"^",30)=2) OUT
 F PI=1:1 Q:$P(PPL,",",PI)=""  S RX=$P(PPL,",",PI) D
 .S PSOBLALL=1,RXRP(RX)=1_"^"_$G(COPIES)_"^"_$S($G(SIDE):1,1:0)
 .S:$G(PSOBXPRT(RX)) RXPR(RX)=PSOBXPRT(RX)
 .S:$D(PBXRF(RX)) RXFL(RX)=PBXRF(RX) D C^PSOLBL
 .K RXRP(+$G(PSOBLRX)),RXPR(+$G(PSOBLRX)),RXFL(+$G(PSOBLRX))
 .K PSOBLRX,RXP
OUT K PSOCPN,PSOLBLCP,RXRP,RXPR,RXFL,PSOBLRX,RXP,RX
 Q
DEVBAR ;get the barcode parameters
 N DA,DR,DPTR,DPTRS,DPTRS1,DIQ,DIC
 S DIC="^%ZIS(1,",DA=PSOIOS,DR="3",DIQ="DPTR",DIQ(0)="I" D EN^DIQ1
 S DPTRS=$G(DPTR(3.5,DA,3,DIQ(0)))
 S DIC="^%ZIS(2,",DA=DPTRS,DR="61;60",DIQ="DPTRS1",DIQ(0)="I" D EN^DIQ1
 S PSOBAR0="" I $G(DPTRS1(3.2,DA,61,DIQ(0)))'="" S PSOBAR0=$G(DPTRS1(3.2,DA,61,DIQ(0)))
 S PSOBAR1="" I $G(DPTRS1(3.2,DA,60,DIQ(0)))'="" S PSOBAR1=$G(DPTRS1(3.2,DA,60,DIQ(0)))
 Q