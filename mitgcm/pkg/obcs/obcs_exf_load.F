C $Header: /u/gcmpack/MITgcm/pkg/obcs/obcs_exf_load.F,v 1.4 2011/09/02 18:23:57 jmc Exp $
C $Name:  $

# include "OBCS_OPTIONS.h"

C--  File obcs_exf_load.F: Routines to read of OBC fields with EXF
C--   Contents
C--   o OBCS_EXF_LOAD
C--   o OBCS_EXF_READ_XZ
C--   o OBCS_EXF_READ_YZ

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CBOP
C     !ROUTINE: OBCS_EXF_LOAD
C     !INTERFACE:
      SUBROUTINE OBCS_EXF_LOAD (
     I                           myTime, myIter, myThid )

C     !DESCRIPTION:
C     *==================================================================*
C     | SUBROUTINE OBCS_EXF_LOAD
C     *==================================================================*
C     | read open boundary conditions from file
C     | N.B.: * uses exf and cal routines for file/record handling
C     |       * uses ctrl routines for control variable handling
C     *==================================================================*

C     !DESCRIPTION:
C     !USES:
      IMPLICIT NONE
C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "OBCS_PARAMS.h"
c#include "OBCS_GRID.h"
#include "OBCS_FIELDS.h"
#include "OBCS_SEAICE.h"
#ifdef ALLOW_EXF
# include "EXF_PARAM.h"
#endif
#ifdef ALLOW_PTRACERS
# include "PTRACERS_SIZE.h"
# include "OBCS_PTRACERS.h"
#endif /* ALLOW_PTRACERS */

C     !INPUT/OUTPUT PARAMETERS:
      _RL     myTime
      INTEGER myIter
      INTEGER myThid
CEOP

#if (defined (ALLOW_EXF) && defined (ALLOW_OBCS_PRESCRIBE))
C     !LOCAL VARIABLES:

C     == end of interface ==

#  ifdef ALLOW_OBCS_NORTH
      CALL OBCS_EXF_READ_XZ (
     I     obcsNstartdate, obcsNperiod,
     I     useOBCSYearlyFields,
     U     OBNu,   OBNu0,   OBNu1,   OBNufile,
     U     OBNv,   OBNv0,   OBNv1,   OBNvfile,
     U     OBNt,   OBNt0,   OBNt1,   OBNtfile,
     U     OBNs,   OBNs0,   OBNs1,   OBNsfile,
#   ifdef NONLIN_FRSURF
     U     OBNeta, OBNeta0, OBNeta1, OBNetafile,
#   endif
#   ifdef ALLOW_SEAICE
     I     siobNstartdate, siobNperiod,
     U     OBNa,   OBNa0,   OBNa1,   OBNafile,
     U     OBNh,   OBNh0,   OBNh1,   OBNhfile,
     U     OBNsl,  OBNsl0,  OBNsl1,  OBNslfile,
     U     OBNsn,  OBNsn0,  OBNsn1,  OBNsnfile,
     U     OBNuice,OBNuice0,OBNuice1,OBNuicefile,
     U     OBNvice,OBNvice0,OBNvice1,OBNvicefile,
#   endif
#   ifdef ALLOW_PTRACERS
     U     OBNptr ,OBNptr0, OBNptr1, OBNptrFile,
#   endif
     I     myTime, myIter, myThid )
#  endif /* ALLOW_OBCS_NORTH */

#  ifdef ALLOW_OBCS_SOUTH
      CALL OBCS_EXF_READ_XZ (
     I     obcsSstartdate, obcsSperiod,
     I     useOBCSYearlyFields,
     U     OBSu,   OBSu0,   OBSu1,   OBSufile,
     U     OBSv,   OBSv0,   OBSv1,   OBSvfile,
     U     OBSt,   OBSt0,   OBSt1,   OBStfile,
     U     OBSs,   OBSs0,   OBSs1,   OBSsfile,
#   ifdef NONLIN_FRSURF
     U     OBSeta, OBSeta0, OBSeta1, OBSetafile,
#   endif
#   ifdef ALLOW_SEAICE
     I     siobSstartdate, siobSperiod,
     U     OBSa,   OBSa0,   OBSa1,   OBSafile,
     U     OBSh,   OBSh0,   OBSh1,   OBShfile,
     U     OBSsl,  OBSsl0,  OBSsl1,  OBSslfile,
     U     OBSsn,  OBSsn0,  OBSsn1,  OBSsnfile,
     U     OBSuice,OBSuice0,OBSuice1,OBSuicefile,
     U     OBSvice,OBSvice0,OBSvice1,OBSvicefile,
#   endif
#   ifdef ALLOW_PTRACERS
     U     OBSptr ,OBSptr0, OBSptr1, OBSptrFile,
#   endif
     I     myTime, myIter, myThid )
#  endif /* ALLOW_OBCS_SOUTH */

#  ifdef ALLOW_OBCS_EAST
      CALL OBCS_EXF_READ_YZ (
     I     obcsEstartdate, obcsEperiod,
     I     useOBCSYearlyFields,
     U     OBEu,   OBEu0,   OBEu1,   OBEufile,
     U     OBEv,   OBEv0,   OBEv1,   OBEvfile,
     U     OBEt,   OBEt0,   OBEt1,   OBEtfile,
     U     OBEs,   OBEs0,   OBEs1,   OBEsfile,
#   ifdef NONLIN_FRSURF
     U     OBEeta, OBEeta0, OBEeta1, OBEetafile,
#   endif
#   ifdef ALLOW_SEAICE
     I     siobEstartdate, siobEperiod,
     U     OBEa,   OBEa0,   OBEa1,   OBEafile,
     U     OBEh,   OBEh0,   OBEh1,   OBEhfile,
     U     OBEsl,  OBEsl0,  OBEsl1,  OBEslfile,
     U     OBEsn,  OBEsn0,  OBEsn1,  OBEsnfile,
     U     OBEuice,OBEuice0,OBEuice1,OBEuicefile,
     U     OBEvice,OBEvice0,OBEvice1,OBEvicefile,
#   endif
#   ifdef ALLOW_PTRACERS
     U     OBEptr ,OBEptr0, OBEptr1, OBEptrFile,
#   endif
     I     myTime, myIter, myThid )
#  endif /* ALLOW_OBCS_EAST */

#  ifdef ALLOW_OBCS_WEST
      CALL OBCS_EXF_READ_YZ (
     I     obcsWstartdate, obcsWperiod,
     I     useOBCSYearlyFields,
     U     OBWu,   OBWu0,   OBWu1,   OBWufile,
     U     OBWv,   OBWv0,   OBWv1,   OBWvfile,
     U     OBWt,   OBWt0,   OBWt1,   OBWtfile,
     U     OBWs,   OBWs0,   OBWs1,   OBWsfile,
#   ifdef NONLIN_FRSURF
     U     OBWeta, OBWeta0, OBWeta1, OBWetafile,
#   endif
#   ifdef ALLOW_SEAICE
     I     siobWstartdate, siobWperiod,
     U     OBWa,   OBWa0,   OBWa1,   OBWafile,
     U     OBWh,   OBWh0,   OBWh1,   OBWhfile,
     U     OBWsl,  OBWsl0,  OBWsl1,  OBWslfile,
     U     OBWsn,  OBWsn0,  OBWsn1,  OBWsnfile,
     U     OBWuice,OBWuice0,OBWuice1,OBWuicefile,
     U     OBWvice,OBWvice0,OBWvice1,OBWvicefile,
#   endif
#   ifdef ALLOW_PTRACERS
     U     OBWptr ,OBWptr0, OBWptr1, OBWptrFile,
#   endif
     I     myTime, myIter, myThid )
#  endif /* ALLOW_OBCS_WEST */

#endif /* ALLOW_EXF and ALLOW_OBCS_PRESCRIBE */

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CBOP
C     !ROUTINE: OBCS_EXF_LOAD
C     !INTERFACE:
      SUBROUTINE OBCS_EXF_READ_XZ (
     I     obcsstartdate, obcsperiod,
     I     useYearlyFields,
     U     OBu,   OBu0,   OBu1,   OBufile,
     U     OBv,   OBv0,   OBv1,   OBvfile,
     U     OBt,   OBt0,   OBt1,   OBtfile,
     U     OBs,   OBs0,   OBs1,   OBsfile,
#ifdef NONLIN_FRSURF
     U     OBeta, OBeta0, OBeta1, OBetafile,
#endif
#ifdef ALLOW_SEAICE
     I     siobstartdate, siobperiod,
     U     OBa,   OBa0,   OBa1,   OBafile,
     U     OBh,   OBh0,   OBh1,   OBhfile,
     U     OBsl,  OBsl0,  OBsl1,  OBslfile,
     U     OBsn,  OBsn0,  OBsn1,  OBsnfile,
     U     OBuice,OBuice0,OBuice1,OBuicefile,
     U     OBvice,OBvice0,OBvice1,OBvicefile,
#endif
#ifdef ALLOW_PTRACERS
     U     OBptr ,OBptr0, OBptr1, OBptrFile,
#endif
     I     myTime, myIter, myThid )

C     !DESCRIPTION:
C     *==================================================================*
C     | SUBROUTINE OBCS_EXF_READ_XZ
C     *==================================================================*
C     | read open boundary conditions from file
C     | N.B.: * uses exf and cal routines for file/record handling
C     |       * uses ctrl routines for control variable handling
C     *==================================================================*

C     !USES:
      IMPLICIT NONE
C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#ifdef ALLOW_EXF
# include "EXF_PARAM.h"
#endif
#ifdef ALLOW_PTRACERS
# include "PTRACERS_SIZE.h"
# include "PTRACERS_PARAMS.h"
#endif /* ALLOW_PTRACERS */

C     !INPUT/OUTPUT PARAMETERS:
      _RL     obcsstartdate
      _RL     obcsperiod
      LOGICAL useYearlyFields
      _RL OBu     (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBv     (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBt     (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBs     (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBu0    (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBv0    (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBt0    (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBs0    (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBu1    (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBv1    (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBt1    (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBs1    (1-Olx:sNx+Olx,Nr,nSx,nSy)
      CHARACTER*(MAX_LEN_FNAM) OBuFile,OBvFile,OBtFile,OBsFile
#ifdef NONLIN_FRSURF
      _RL OBeta   (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBeta0  (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBeta1  (1-Olx:sNx+Olx,nSx,nSy)
      CHARACTER*(MAX_LEN_FNAM) OBetaFile
#endif
#ifdef ALLOW_SEAICE
      _RL     siobstartdate
      _RL     siobperiod
      _RL OBa     (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBh     (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBa0    (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBh0    (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBa1    (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBh1    (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBsl    (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBsn    (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBsl0   (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBsn0   (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBsl1   (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBsn1   (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBuice  (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBvice  (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBuice0 (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBvice0 (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBuice1 (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBvice1 (1-Olx:sNx+Olx,nSx,nSy)
      CHARACTER*(MAX_LEN_FNAM)
     &     OBaFile,OBhFile,OBslFile,OBsnFile,OBuiceFile,OBviceFile
#endif /* ALLOW_SEAICE */
#ifdef ALLOW_PTRACERS
      _RL OBptr (1-Olx:sNx+Olx,Nr,nSx,nSy,PTRACERS_num)
      _RL OBptr0(1-Olx:sNx+Olx,Nr,nSx,nSy,PTRACERS_num)
      _RL OBptr1(1-Olx:sNx+Olx,Nr,nSx,nSy,PTRACERS_num)
      CHARACTER*(MAX_LEN_FNAM) OBptrFile(PTRACERS_num)
#endif /* ALLOW_PTRACERS */
      _RL     myTime
      INTEGER myIter
      INTEGER myThid
CEOP

#if defined ALLOW_OBCS && defined ALLOW_OBCS_PRESCRIBE \
    && defined ALLOW_EXF

C     !LOCAL VARIABLES:
      logical first, changed
      integer count0, count1
      integer year0, year1
      _RL     fac
# ifdef ALLOW_PTRACERS
      integer iTracer
# endif /* ALLOW_PTRACERS */
C     == end of interface ==

      if ( obcsperiod .eq. -12. _d 0 ) then
c     obcsperiod=-12 means input file contains 12 monthly means
c     record numbers are assumed 1 to 12 corresponding to
c     Jan. through Dec.
       call cal_GetMonthsRec(
     O                        fac, first, changed,
     O                        count0, count1,
     I                        myTime, myIter, myThid )

      elseif ( obcsperiod .lt. 0. _d 0 ) then
       print *, 'obcsperiod is out of range'
       STOP 'ABNORMAL END: S/R OBCS_PRESCIBE_EXF_XZ'
      else
c     get record numbers and interpolation factor
       call exf_GetFFieldRec(
     I                       obcsstartdate, obcsperiod,
     I                       useYearlyFields,
     O                       fac, first, changed,
     O                       count0, count1, year0, year1,
     I                       myTime, myIter, myThid )
      endif
      CALL EXF_SET_OBCS_XZ(  OBu, OBu0, OBu1, OBufile, 'u', Nr
     I                     , fac, first, changed, useYearlyFields
     I                     , obcsperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
      CALL EXF_SET_OBCS_XZ(  OBv, OBv0, OBv1, OBvfile, 'v', Nr
     I                     , fac, first, changed, useYearlyFields
     I                     , obcsperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
      CALL EXF_SET_OBCS_XZ(  OBt, OBt0, OBt1, OBtfile, 's', Nr
     I                     , fac, first, changed, useYearlyFields
     I                     , obcsperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
      CALL EXF_SET_OBCS_XZ(  OBs, OBs0, OBs1, OBsfile, 's', Nr
     I                     , fac, first, changed, useYearlyFields
     I                     , obcsperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
# ifdef NONLIN_FRSURF
       CALL EXF_SET_OBCS_XZ( OBeta, OBeta0, OBeta1, OBetaFile, 's', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , obcsperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
# endif /* NONLIN_FRSURF */
# ifdef ALLOW_PTRACERS
      if ( usePTRACERS ) then
       do iTracer = 1, PTRACERS_numInUse
        CALL EXF_SET_OBCS_XZ(  OBptr (1-Olx,1,1,1,iTracer)
     I                       , OBptr0(1-Olx,1,1,1,iTracer)
     I                       , OBptr1(1-Olx,1,1,1,iTracer)
     I                       , OBptrFile(iTracer), 's', Nr
     I                       , fac, first, changed, useYearlyFields
     I                       , obcsperiod, count0, count1, year0, year1
     I                       , myTime, myIter, myThid )
       enddo
      endif
# endif /* ALLOW_PTRACERS */
# ifdef ALLOW_SEAICE
      IF (useSEAICE) THEN
       if ( siobperiod .eq. -12. _d 0 ) then
c     siobperiod=-12 means input file contains 12 monthly means
c     record numbers are assumed 1 to 12 corresponding to
c     Jan. through Dec.
        call cal_GetMonthsRec(
     O                        fac, first, changed,
     O                        count0, count1,
     I                        myTime, myIter, myThid )

       elseif ( siobperiod .lt. 0. _d 0 ) then
        print *, 'siobperiod is out of range'
        STOP 'ABNORMAL END: S/R OBCS_PRESCIBE_EXF_XZ'
       else
c     get record numbers and interpolation factor
        call exf_GetFFieldRec(
     I                       siobstartdate, siobperiod,
     I                       useYearlyFields,
     O                       fac, first, changed,
     O                       count0, count1, year0, year1,
     I                       myTime, myIter, myThid )
       endif
       CALL EXF_SET_OBCS_XZ(  OBa, OBa0, OBa1, OBafile, 's', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
       CALL EXF_SET_OBCS_XZ(  OBh, OBh0, OBh1, OBhfile, 's', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
       CALL EXF_SET_OBCS_XZ(  OBsl, OBsl0, OBsl1, OBslfile, 's', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
       CALL EXF_SET_OBCS_XZ(  OBsn, OBsn0, OBsn1, OBsnfile, 's', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
       CALL EXF_SET_OBCS_XZ( OBuice,OBuice0,OBuice1,OBuicefile,'u', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
       CALL EXF_SET_OBCS_XZ( OBvice,OBvice0,OBvice1,OBvicefile,'v', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
      ENDIF
# endif /* ALLOW_SEAICE */

#endif /* ALLOW_OBCS and ALLOW_OBCS_PRESCRIBE and ALLOW_EXF */
      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CBOP
C     !ROUTINE: OBCS_EXF_LOAD
C     !INTERFACE:
      SUBROUTINE OBCS_EXF_READ_YZ (
     I     obcsstartdate, obcsperiod,
     I     useYearlyFields,
     U     OBu,   OBu0,   OBu1,   OBufile,
     U     OBv,   OBv0,   OBv1,   OBvfile,
     U     OBt,   OBt0,   OBt1,   OBtfile,
     U     OBs,   OBs0,   OBs1,   OBsfile,
#ifdef NONLIN_FRSURF
     U     OBeta, OBeta0, OBeta1, OBetafile,
#endif
#ifdef ALLOW_SEAICE
     I     siobstartdate, siobperiod,
     U     OBa,   OBa0,   OBa1,   OBafile,
     U     OBh,   OBh0,   OBh1,   OBhfile,
     U     OBsl,  OBsl0,  OBsl1,  OBslfile,
     U     OBsn,  OBsn0,  OBsn1,  OBsnfile,
     U     OBuice,OBuice0,OBuice1,OBuicefile,
     U     OBvice,OBvice0,OBvice1,OBvicefile,
#endif
#ifdef ALLOW_PTRACERS
     U     OBptr ,OBptr0, OBptr1, OBptrFile,
#endif
     I     myTime, myIter, myThid )

C     !DESCRIPTION:
C     *==================================================================*
C     | SUBROUTINE OBCS_EXF_READ_YZ
C     *==================================================================*
C     | read open boundary conditions from file
C     | N.B.: * uses exf and cal routines for file/record handling
C     |       * uses ctrl routines for control variable handling
C     *==================================================================*

C     !USES:
      IMPLICIT NONE
C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#ifdef ALLOW_EXF
# include "EXF_PARAM.h"
#endif
#ifdef ALLOW_PTRACERS
# include "PTRACERS_SIZE.h"
# include "PTRACERS_PARAMS.h"
#endif /* ALLOW_PTRACERS */

C     !INPUT/OUTPUT PARAMETERS:
      _RL     obcsstartdate
      _RL     obcsperiod
      LOGICAL useYearlyFields
      _RL OBu     (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBv     (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBt     (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBs     (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBu0    (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBv0    (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBt0    (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBs0    (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBu1    (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBv1    (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBt1    (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBs1    (1-Oly:sNy+Oly,Nr,nSx,nSy)
      CHARACTER*(MAX_LEN_FNAM) OBuFile,OBvFile,OBtFile,OBsFile
#ifdef NONLIN_FRSURF
      _RL OBeta   (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBeta0  (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBeta1  (1-Oly:sNy+Oly,nSx,nSy)
      CHARACTER*(MAX_LEN_FNAM) OBetaFile
#endif
#ifdef ALLOW_SEAICE
      _RL     siobstartdate
      _RL     siobperiod
      _RL OBa     (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBh     (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBa0    (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBh0    (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBa1    (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBh1    (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBsl    (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBsn    (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBsl0   (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBsn0   (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBsl1   (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBsn1   (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBuice  (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBvice  (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBuice0 (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBvice0 (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBuice1 (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBvice1 (1-Oly:sNy+Oly,nSx,nSy)
      CHARACTER*(MAX_LEN_FNAM)
     &     OBaFile,OBhFile,OBslFile,OBsnFile,OBuiceFile,OBviceFile
#endif /* ALLOW_SEAICE */
#ifdef ALLOW_PTRACERS
      _RL OBptr (1-Oly:sNy+Oly,Nr,nSx,nSy,PTRACERS_num)
      _RL OBptr0(1-Oly:sNy+Oly,Nr,nSx,nSy,PTRACERS_num)
      _RL OBptr1(1-Oly:sNy+Oly,Nr,nSx,nSy,PTRACERS_num)
      CHARACTER*(MAX_LEN_FNAM) OBptrFile(PTRACERS_num)
#endif /* ALLOW_PTRACERS */
      _RL     myTime
      INTEGER myIter
      INTEGER myThid
CEOP

#if defined ALLOW_OBCS && defined ALLOW_OBCS_PRESCRIBE \
    && defined ALLOW_EXF

C     !LOCAL VARIABLES:
      logical first, changed
      integer count0, count1
      integer year0, year1
      _RL     fac
# ifdef ALLOW_PTRACERS
      integer iTracer
# endif /* ALLOW_PTRACERS */

c     == end of interface ==

      if ( obcsperiod .eq. -12. _d 0 ) then
c     obcsperiod=-12 means input file contains 12 monthly means
c     record numbers are assumed 1 to 12 corresponding to
c     Jan. through Dec.
       call cal_GetMonthsRec(
     O                        fac, first, changed,
     O                        count0, count1,
     I                        myTime, myIter, myThid )

      elseif ( obcsperiod .lt. 0. _d 0 ) then
       print *, 'obcsperiod is out of range'
       STOP 'ABNORMAL END: S/R OBCS_PRESCIBE_EXF_YZ'
      else
c     get record numbers and interpolation factor
       call exf_GetFFieldRec(
     I                       obcsstartdate, obcsperiod,
     I                       useYearlyFields,
     O                       fac, first, changed,
     O                       count0, count1, year0, year1,
     I                       myTime, myIter, myThid )
      endif
      CALL EXF_SET_OBCS_YZ(  OBu, OBu0, OBu1, OBufile, 'u', Nr
     I                     , fac, first, changed, useYearlyFields
     I                     , obcsperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
      CALL EXF_SET_OBCS_YZ(  OBv, OBv0, OBv1, OBvfile, 'v', Nr
     I                     , fac, first, changed, useYearlyFields
     I                     , obcsperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
      CALL EXF_SET_OBCS_YZ(  OBt, OBt0, OBt1, OBtfile, 's', Nr
     I                     , fac, first, changed, useYearlyFields
     I                     , obcsperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
      CALL EXF_SET_OBCS_YZ(  OBs, OBs0, OBs1, OBsfile, 's', Nr
     I                     , fac, first, changed, useYearlyFields
     I                     , obcsperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
# ifdef NONLIN_FRSURF
       CALL EXF_SET_OBCS_YZ( OBeta, OBeta0, OBeta1, OBetaFile, 's', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , obcsperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
# endif /* NONLIN_FRSURF */
# ifdef ALLOW_PTRACERS
      if ( usePTRACERS ) then
       do iTracer = 1, PTRACERS_numInUse
        CALL EXF_SET_OBCS_YZ(  OBptr (1-Olx,1,1,1,iTracer)
     I                       , OBptr0(1-Olx,1,1,1,iTracer)
     I                       , OBptr1(1-Olx,1,1,1,iTracer)
     I                       , OBptrFile(iTracer), 's', Nr
     I                       , fac, first, changed, useYearlyFields
     I                       , obcsperiod, count0, count1, year0, year1
     I                       , myTime, myIter, myThid )
       enddo
      endif
# endif /* ALLOW_PTRACERS */
# ifdef ALLOW_SEAICE
      IF (useSEAICE) THEN
       if ( siobperiod .eq. -12. _d 0 ) then
c     siobperiod=-12 means input file contains 12 monthly means
c     record numbers are assumed 1 to 12 corresponding to
c     Jan. through Dec.
        call cal_GetMonthsRec(
     O                        fac, first, changed,
     O                        count0, count1,
     I                        myTime, myIter, myThid
     &           )

       elseif ( siobperiod .lt. 0. _d 0 ) then
        print *, 'siobperiod is out of range'
        STOP 'ABNORMAL END: S/R OBCS_PRESCIBE_EXF_XZ'
       else
c     get record numbers and interpolation factor
        call exf_GetFFieldRec(
     I                       siobstartdate, siobperiod,
     I                       useYearlyFields,
     O                       fac, first, changed,
     O                       count0, count1, year0, year1,
     I                       myTime, myIter, myThid )
       endif
       CALL EXF_SET_OBCS_YZ(  OBa, OBa0, OBa1, OBafile, 's', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
       CALL EXF_SET_OBCS_YZ(  OBh, OBh0, OBh1, OBhfile, 's', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
       CALL EXF_SET_OBCS_YZ(  OBsl, OBsl0, OBsl1, OBslfile, 's', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
       CALL EXF_SET_OBCS_YZ(  OBsn, OBsn0, OBsn1, OBsnfile, 's', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
       CALL EXF_SET_OBCS_YZ( OBuice,OBuice0,OBuice1,OBuicefile,'u', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
       CALL EXF_SET_OBCS_YZ( OBvice,OBvice0,OBvice1,OBvicefile,'v', 1
     I                     , fac, first, changed, useYearlyFields
     I                     , siobperiod, count0, count1, year0, year1
     I                     , myTime, myIter, myThid )
      ENDIF
# endif /* ALLOW_SEAICE */

#endif /* ALLOW_OBCS and ALLOW_OBCS_PRESCRIBE and ALLOW_EXF */
      RETURN
      END
