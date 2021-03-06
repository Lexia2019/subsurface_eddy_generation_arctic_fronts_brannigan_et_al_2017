C $Header: /u/gcmpack/MITgcm/pkg/exf/exf_init_fixed.F,v 1.17 2011/05/25 00:48:57 jmc Exp $
C $Name:  $

#include "EXF_OPTIONS.h"

CBOP
C     !ROUTINE: EXF_INIT_FIXED
C     !INTERFACE:
      SUBROUTINE EXF_INIT_FIXED( myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE EXF_INIT_FIXED
C     | o Routine to initialize EXF variables
C     |   that are kept fixed during the run.
C     *==========================================================*
C     \ev
C     !USES:
      IMPLICIT NONE

C     === Global variables ===
#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "cal.h"
#include "EXF_PARAM.h"
#include "EXF_CONSTANTS.h"
#ifdef ALLOW_ICEFRONT
# include "ICEFRONT_OPTIONS.h"
# include "ICEFRONT.h"
#endif

C     !INPUT/OUTPUT PARAMETERS:
C     === Routine arguments ===
C     myThid ::  my Thread Id number
      INTEGER myThid
CEOP

C     !LOCAL VARIABLES:
C     === Local variables ===
      INTEGER date_array(4), difftime(4), yearStartDate(4)

c     Complete the start date specifications for the forcing
c     fields to get a complete calendar date array.
c     FLDstartdate, for FLD = { uwind, vwind, wspeed, etc. },
c     returns time in seconds of first FLD record from the
c     beginning of the model integration or, if useYearlyFields,
c     from the beginning of the year.

      _BEGIN_MASTER( myThid )

#ifdef ALLOW_ATM_WIND
      IF ( uwindfile .NE. ' ' .AND. uwindperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( uwindstartdate1, uwindstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   uwindstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   uwindstartdate       ,myThid)
        uwindstartdate   =  modelstart + uwindstartdate
       ENDIF
      ENDIF
      IF ( vwindfile .NE. ' ' .AND. vwindperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( vwindstartdate1, vwindstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   vwindstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   vwindstartdate       ,myThid)
        vwindstartdate   =  modelstart + vwindstartdate
       ENDIF
      ENDIF
#endif /* ALLOW_ATM_WIND */
      IF ( wspeedfile .NE. ' ' .AND. wspeedperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( wspeedstartdate1, wspeedstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   wspeedstartdate      ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   wspeedstartdate      ,myThid)
        wspeedstartdate  =  modelstart + wspeedstartdate
       ENDIF
      ENDIF
      IF ( ustressfile .NE. ' ' .AND. ustressperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( ustressstartdate1, ustressstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   ustressstartdate     ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   ustressstartdate     ,myThid)
        ustressstartdate =  modelstart + ustressstartdate
       ENDIF
      ENDIF
      IF ( vstressfile .NE. ' ' .AND. vstressperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( vstressstartdate1, vstressstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   vstressstartdate     ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   vstressstartdate     ,myThid)
        vstressstartdate =  modelstart + vstressstartdate
       ENDIF
      ENDIF

#ifdef ALLOW_ATM_TEMP
      IF ( atempfile .NE. ' ' .AND. atempperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( atempstartdate1, atempstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   atempstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   atempstartdate       ,myThid)
        atempstartdate   =  modelstart + atempstartdate
       ENDIF
      ENDIF
      IF ( aqhfile .NE. ' ' .AND. aqhperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( aqhstartdate1, aqhstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   aqhstartdate         ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   aqhstartdate         ,myThid)
        aqhstartdate     =  modelstart + aqhstartdate
       ENDIF
      ENDIF
      IF ( lwfluxfile .NE. ' ' .AND. lwfluxperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( lwfluxstartdate1, lwfluxstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   lwfluxstartdate      ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   lwfluxstartdate      ,myThid)
        lwfluxstartdate  =  modelstart + lwfluxstartdate
       ENDIF
      ENDIF
      IF ( precipfile .NE. ' ' .AND. precipperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( precipstartdate1, precipstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   precipstartdate      ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   precipstartdate      ,myThid)
        precipstartdate  =  modelstart + precipstartdate
       ENDIF
      ENDIF
      IF ( snowprecipfile .NE. ' ' .AND. snowprecipperiod .GT. 0. ) THEN
       CALL cal_FullDate( snowprecipstartdate1, snowprecipstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   snowprecipstartdate  ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   snowprecipstartdate  ,myThid)
        snowprecipstartdate=modelstart + snowprecipstartdate
       ENDIF
      ENDIF
#else /* ifndef ALLOW_ATM_TEMP */
      IF ( hfluxfile .NE. ' ' .AND. hfluxperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( hfluxstartdate1, hfluxstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   hfluxstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   hfluxstartdate       ,myThid)
        hfluxstartdate   =  modelstart + hfluxstartdate
       ENDIF
      ENDIF
      IF ( sfluxfile .NE. ' ' .AND. sfluxperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( sfluxstartdate1, sfluxstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   sfluxstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   sfluxstartdate       ,myThid)
        sfluxstartdate   =  modelstart + sfluxstartdate
       ENDIF
      ENDIF
#endif /* ALLOW_ATM_TEMP */

#if defined(ALLOW_ATM_TEMP) || defined(SHORTWAVE_HEATING)
      IF ( swfluxfile .NE. ' ' .AND. swfluxperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( swfluxstartdate1, swfluxstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   swfluxstartdate      ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   swfluxstartdate      ,myThid)
        swfluxstartdate  =  modelstart + swfluxstartdate
       ENDIF
      ENDIF
#endif /* defined(ALLOW_ATM_TEMP) || defined(SHORTWAVE_HEATING) */

#ifdef EXF_READ_EVAP
      IF ( evapfile .NE. ' ' .AND. evapperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( evapstartdate1, evapstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   evapstartdate        ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   evapstartdate        ,myThid)
        evapstartdate    =  modelstart + evapstartdate
       ENDIF
      ENDIF
#endif /* EXF_READ_EVAP */

#ifdef ALLOW_RUNOFF
      IF ( runofffile .NE. ' ' .AND. runoffperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( runoffstartdate1, runoffstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   runoffstartdate      ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   runoffstartdate      ,myThid)
        runoffstartdate  =  modelstart + runoffstartdate
       ENDIF
      ENDIF
#endif /* ALLOW_RUNOFF */

#ifdef ALLOW_ICEFRONT
      IF ( sgrunofffile .NE. ' ' .AND. sgrunoffperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( sgrunoffstartdate1, sgrunoffstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime, sgrunoffstartdate      ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime, sgrunoffstartdate      ,myThid)
        sgrunoffstartdate  =  modelstart + sgrunoffstartdate
       ENDIF
      ENDIF
#endif /* ALLOW_ICEFRONT */

#ifdef ALLOW_DOWNWARD_RADIATION
      IF ( swdownfile .NE. ' ' .AND. swdownperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( swdownstartdate1, swdownstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   swdownstartdate      ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   swdownstartdate      ,myThid)
        swdownstartdate  =  modelstart + swdownstartdate
       ENDIF
      ENDIF
      IF ( lwdownfile .NE. ' ' .AND. lwdownperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( lwdownstartdate1, lwdownstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   lwdownstartdate      ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   lwdownstartdate      ,myThid)
        lwdownstartdate  =  modelstart + lwdownstartdate
       ENDIF
      ENDIF
#endif /* ALLOW_DOWNWARD_RADIATION */

#ifdef ATMOSPHERIC_LOADING
      IF ( apressurefile .NE. ' ' .AND. apressureperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( apressurestartdate1,  apressurestartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   apressurestartdate   ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   apressurestartdate   ,myThid)
        apressurestartdate= modelstart + apressurestartdate
       ENDIF
      ENDIF
#endif /* ATMOSPHERIC_LOADING */

#ifdef ALLOW_ICE_AREAMASK
      IF ( areamaskfile .NE. ' ' .AND. areamaskperiod .GT. 0. ) THEN
       CALL cal_FullDate  ( areamaskstartdate1,  areamaskstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   areamaskstartdate   ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   areamaskstartdate   ,myThid)
        areamaskstartdate= modelstart + areamaskstartdate
       ENDIF
      ENDIF
#endif /* ALLOW_ICE_AREAMASK */

#ifdef ALLOW_OBCS
      IF ( obcsNperiod .GT. 0 ) THEN
       CALL cal_FullDate  ( obcsNstartdate1, obcsNstartdate2,
     &      date_array, myThid )
       IF ( useOBCSYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   obcsNstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   obcsNstartdate       ,myThid)
        obcsNstartdate   =  modelstart + obcsNstartdate
       ENDIF
      ENDIF
      IF ( obcsSperiod .GT. 0 ) THEN
       CALL cal_FullDate  ( obcsSstartdate1, obcsSstartdate2,
     &      date_array, myThid )
       IF ( useOBCSYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   obcsSstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   obcsSstartdate       ,myThid)
        obcsSstartdate   =  modelstart + obcsSstartdate
       ENDIF
      ENDIF
      IF ( obcsEperiod .GT. 0 ) THEN
       CALL cal_FullDate  ( obcsEstartdate1, obcsEstartdate2,
     &      date_array, myThid )
       IF ( useOBCSYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   obcsEstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   obcsEstartdate       ,myThid)
        obcsEstartdate   =  modelstart + obcsEstartdate
       ENDIF
      ENDIF
      IF ( obcsWperiod .GT. 0 ) THEN
       CALL cal_FullDate  ( obcsWstartdate1, obcsWstartdate2,
     &      date_array, myThid )
       IF ( useOBCSYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   obcsWstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   obcsWstartdate       ,myThid)
        obcsWstartdate   =  modelstart + obcsWstartdate
       ENDIF
      ENDIF
# ifdef ALLOW_SEAICE
      IF ( siobNperiod .GT. 0 ) THEN
       CALL cal_FullDate  ( siobNstartdate1, siobNstartdate2,
     &      date_array, myThid )
       IF ( useOBCSYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   siobNstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   siobNstartdate       ,myThid)
        siobNstartdate   =  modelstart + siobNstartdate
       ENDIF
      ENDIF
      IF ( siobSperiod .GT. 0 ) THEN
       CALL cal_FullDate  ( siobSstartdate1, siobSstartdate2,
     &      date_array, myThid )
       IF ( useOBCSYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   siobSstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   siobSstartdate       ,myThid)
        siobSstartdate   =  modelstart + siobSstartdate
       ENDIF
      ENDIF
      IF ( siobEperiod .GT. 0 ) THEN
       CALL cal_FullDate  ( siobEstartdate1, siobEstartdate2,
     &      date_array, myThid )
       IF ( useOBCSYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   siobEstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   siobEstartdate       ,myThid)
        siobEstartdate   =  modelstart + siobEstartdate
       ENDIF
      ENDIF
      IF ( siobWperiod .GT. 0 ) THEN
       CALL cal_FullDate  ( siobWstartdate1, siobWstartdate2,
     &      date_array, myThid )
       IF ( useOBCSYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   siobWstartdate       ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds ( difftime,   siobWstartdate       ,myThid)
        siobWstartdate   =  modelstart + siobWstartdate
       ENDIF
      ENDIF
# endif /* ALLOW_SEAICE */
#endif /* ALLOW_OBCS */

#ifdef ALLOW_CLIMSST_RELAXATION
      IF ( climsstfile .NE. ' ' .AND. climsstperiod .GT. 0. ) THEN
       CALL cal_FullDate( climsststartdate1, climsststartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds (difftime,    climsststartdate     ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds (difftime,    climsststartdate     ,myThid)
        climsststartdate =  modelstart + climsststartdate
       ENDIF
      ENDIF
#endif /* ALLOW_CLIMSST_RELAXATION */

#ifdef ALLOW_CLIMSSS_RELAXATION
      IF ( climsssfile .NE. ' ' .AND. climsssperiod .GT. 0. ) THEN
       CALL cal_FullDate( climsssstartdate1, climsssstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds (difftime,    climsssstartdate     ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds (difftime,    climsssstartdate     ,myThid)
        climsssstartdate =  modelstart + climsssstartdate
       ENDIF
      ENDIF
#endif /* ALLOW_CLIMSSS_RELAXATION */

#ifdef ALLOW_CLIMSTRESS_RELAXATION
      IF ( climustrfile .NE. ' ' .AND. climustrperiod .GT. 0. ) THEN
       CALL cal_FullDate( climustrstartdate1, climustrstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds (difftime,    climustrstartdate     ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds (difftime,    climustrstartdate     ,myThid)
        climustrstartdate =  modelstart + climustrstartdate
       ENDIF
      ENDIF
c
      IF ( climvstrfile .NE. ' ' .AND. climvstrperiod .GT. 0. ) THEN
       CALL cal_FullDate( climvstrstartdate1, climvstrstartdate2,
     &      date_array, myThid )
       IF ( useExfYearlyFields ) THEN
        yearStartDate(1) = int(date_array(1)/10000.) * 10000 + 101
        yearStartDate(2) = 0
        yearStartDate(3) = date_array(3)
        yearStartDate(4) = date_array(4)
        CALL cal_TimePassed( yearStartDate,date_array,difftime,myThid)
        CALL cal_ToSeconds (difftime,    climvstrstartdate     ,myThid)
       ELSE
        CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
        CALL cal_ToSeconds (difftime,    climvstrstartdate     ,myThid)
        climvstrstartdate =  modelstart + climvstrstartdate
       ENDIF
      ENDIF
#endif /* ALLOW_CLIMSTRESS_RELAXATION */

      _END_MASTER( myThid )
      _BARRIER

#if defined(ALLOW_ZENITHANGLE) && defined(SHORTWAVE_HEATING)
      IF ( useExfZenAlbedo .OR. useExfZenIncoming ) THEN
       CALL EXF_ZENITHANGLE_TABLE(myThid)
      ENDIF
#endif

C--   Summarize the External forcing setup.
      CALL EXF_SUMMARY( myThid )

#ifdef ALLOW_DIAGNOSTICS
      IF ( useDiagnostics ) THEN
        CALL EXF_DIAGNOSTICS_INIT( myThid )
      ENDIF
#endif

      RETURN
      END
