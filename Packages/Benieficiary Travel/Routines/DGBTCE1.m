DGBTCE1 ;ALB/LM - BENEFICIARY TRAVEL CLAIM RE-ENTER/EDIT CONT.; 9/13/89@8:00 ;4/23/91  09:42
 ;;1.0;Beneficiary Travel;**17**;September 25, 2001;Build 6
 Q
CONT ; ENTRY POINTS FROM DGBTEE,DGBTCE
 I DGBTDE<0 S DGBTDE=0
 S DGBTFLX=" DEDUCTIBLE AMOUNT HAS BEEN CHANGED " I DGBTACCT=4 S DGBTPA=$S(DGBTTC-DGBTDE>0:DGBTTC-DGBTDE,DGBTTC-DGBTDE<0:DGBTTC,1:0)
DIE5 S DGBTINFL=$S(DGBTDE=DGBTDCV:$P(DGBTVAR("R"),DGBTFLX)_$P(DGBTVAR("R"),DGBTFLX,2)_" ",DGBTDE'=DGBTDCV&(DGBTVAR("R")'[DGBTFLX):$E(DGBTVAR("R")_DGBTINFL_DGBTFLX,1,79),1:DGBTVAR("R"))
 S DIE="^DGBT(392,",DA=DGBTDT
 S DR="9///"_DGBTDE_";10///"_DGBTPA_$S(DGBTINFL=" ":"",1:";51///^S X=DGBTINFL") S DGBTINFL=""
 D ^DIE K DIE,DQ,DR I $D(DTOUT)!($D(Y)) S DGBTTOUT=-1 Q
 ;    stuff amount payable
 I DGBTFLAG=2 W !!,"DEDUCTIBLE AMOUNT CAN NOT EXCEED THE TOTAL COSTS FOR THIS CLAIM",! K X S DGBTFLAG=0 G DED1^DGBTCE
 I DGBTFLAG=1 W !!,"DEDUCTIBLE FOR THIS CLAIM CAN NOT EXCEED THE AMOUNT REMAINING FOR THIS MONTH",! K X S DGBTFLAG=0 G DED1^DGBTCE
 ;
 S DIE="^DGBT(392,",DA=DGBTDT,DIE("NO^")="BACK",DR="51"
DIE6 D ^DIE K DIE,DQ,DR I $D(DTOUT)!($D(Y)) S DGBTTOUT=-1 Q
 D QUIT
 D SCREEN^DGBTCD
 Q
QUIT ;KILL VARIABLES
 K DGBTCITY,DGBTSTAT,DGBTWAY,DGBTMILE,DIE,DR,DGBTOWRT,DGBTML,DGBTMLFB,DGBTACCT,DGBTAP,DGBTMAL,DGBTFAB,DGBTME,DGBTMAF,DGBTTC,DGBTDCM,DGBTDPV,DGBTDPM,DGBTDRM,DGBTDCV,DGBTDE,DGBTPA,I,DGBTELIG,DGBTFLAG,DGBTMETC,DGBTMLT,DGBTCP,DGBTMR1
 K DGBTFR1,DGBTFR2,DGBTFR3,DGBTFR4,DGBTTO1,DGBTTO2,DGBTTO3,DGBTTO4,DGBTMR,DGBTRATE,DGBTSCP,DGBTFLX Q