C $Header: /u/gcmpack/MITgcm/pkg/ptracers/ptracers_zonal_filt_apply.F,v 1.1 2009/10/14 19:53:38 jmc Exp $
C $Name:  $

#include "PTRACERS_OPTIONS.h"
#ifdef ALLOW_ZONAL_FILT
#include "ZONAL_FILT_OPTIONS.h"
#endif

CBOP 0
C     !ROUTINE: PTRACERS_ZONAL_FILT_APPLY

C     !INTERFACE:
      SUBROUTINE PTRACERS_ZONAL_FILT_APPLY(
     I                                      myThid )

C     !DESCRIPTION:
C     *==========================================================*
C     | S/R PTRACERS_ZONAL_FILT_APPLY
C     | o Apply FFT filter to all passive tracers
C     *==========================================================*

C     !USES:
      IMPLICIT NONE
C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS_PARAMS.h"
#include "PTRACERS_FIELDS.h"


C     !INPUT/OUTPUT PARAMETERS:
C     myThid  :: my Thread Id number
      INTEGER myThid
CEOP

#ifdef ALLOW_ZONAL_FILT

C     !LOCAL VARIABLES:
      INTEGER iTr
      INTEGER bi,bj

      DO iTr = 1,PTRACERS_numInUse
       DO bj=myByLo(myThid),myByHi(myThid)
        DO bi=myBxLo(myThid),myBxHi(myThid)

          CALL ZONAL_FILTER(
     U                       pTracer(1-Olx,1-Oly,1,bi,bj,iTr),
     I                       hFacC(1-OLx,1-OLy,1,bi,bj),
     I                       1, sNy, Nr, bi, bj, 1, myThid )

        ENDDO
       ENDDO
      ENDDO

#endif /* ALLOW_ZONAL_FILT */

      RETURN
      END
