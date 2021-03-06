C $Header: /u/gcmpack/MITgcm/pkg/exf/exf_getclim.F,v 1.18 2010/04/28 04:54:54 heimbach Exp $
C $Name:  $

#include "EXF_OPTIONS.h"


      subroutine exf_getclim(
     I                        mytime,
     I                        myiter,
     I                        mythid
     &                      )

c     ==================================================================
c     SUBROUTINE exf_getclim
c     ==================================================================
c
c     o Get the climatogy fields for the current time step. The switches
c       for the inclusion of the individual forcing components have to
c       be set in EXF_OPTIONS.h .
c
c       A note on surface fluxes:
c
c       The MITgcm-UV vertical coordinate z is positive upward.
c       This implies that a positive flux is out of the ocean
c       model. However, the wind stress forcing is not treated
c       this way. A positive zonal wind stress accelerates the
c       model ocean towards the east.
c
c     started: Ralf.Giering@FastOpt.de 25-Mai-2000
c
c     ==================================================================
c     SUBROUTINE exf_getclim
c     ==================================================================

      implicit none

c     == global variables ==
#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"
#ifdef ALLOW_BULK_OFFLINE
# include "PARAMS.h"
# include "DYNVARS.h"
#endif
#include "EXF_PARAM.h"
#include "EXF_CONSTANTS.h"
#include "EXF_FIELDS.h"
#ifdef ALLOW_AUTODIFF
# include "ctrl.h"
# include "ctrl_dummy.h"
#endif

c     == routine arguments ==

c     mythid - thread number for this instance of the routine.

      integer mythid
      integer myiter
      _RL     mytime

c     == local variables ==

      integer interp_method
      integer bi, bj, i, j

c     == end of interface ==

      interp_method=2

#ifdef ALLOW_CLIMSST_RELAXATION
c     Get values of climatological sst fields.
      call exf_set_gen  (
     &     climsstfile, climsststartdate, climsstperiod, 
     &     exf_inscal_climsst,
     &     climsst_exfremo_intercept, climsst_exfremo_slope,
     &     climsst, climsst0, climsst1, climsstmask, 
#ifdef USE_EXF_INTERPOLATION
     &     climsst_lon0, climsst_lon_inc, climsst_lat0, climsst_lat_inc,
     &     climsst_nlon, climsst_nlat, xC, yC, interp_method,
#endif
     &     mytime, myiter, mythid )
c
      do bj = mybylo(mythid),mybyhi(mythid)
       do bi = mybxlo(mythid),mybxhi(mythid)
        do j = 1,sny
         do i = 1,snx
            if (climsst(i,j,bi,bj) .lt. climtempfreeze) then
               climsst(i,j,bi,bj) = climtempfreeze
            endif
         enddo
        enddo
       enddo
      enddo
c
c--   Update the tile edges.
      _EXCH_XY_RL(climsst, mythid)
#endif

#ifdef ALLOW_CLIMSSS_RELAXATION
c     Get values of climatological sss fields.
      call exf_set_gen  (
     &     climsssfile, climsssstartdate, climsssperiod, 
     &     exf_inscal_climsss,
     &     climsss_exfremo_intercept, climsss_exfremo_slope,
     &     climsss, climsss0, climsss1, climsssmask, 
#ifdef USE_EXF_INTERPOLATION
     &     climsss_lon0, climsss_lon_inc, climsss_lat0, climsss_lat_inc,
     &     climsss_nlon, climsss_nlat, xC, yC, interp_method,
#endif
     &     mytime, myiter, mythid )
c
c--   Update the tile edges.
      _EXCH_XY_RL(climsss, mythid)
#endif

#ifdef ALLOW_SST_CONTROL
      call ctrl_get_gen (
     &     xx_sst_file, xx_sststartdate, xx_sstperiod,
     &     maskc, climsst, xx_sst0, xx_sst1, xx_sst_dummy,
     &     mytime, myiter, mythid )
#endif

#ifdef ALLOW_CLIMSTRESS_RELAXATION
c     Get values of climatological ustr fields.
      call exf_set_uv (
     &     climustrfile, climustrstartdate, climustrperiod,
     &     exf_inscal_climustr, climustr, climustr0, climustr1, 
     &     climustrmask,
     &     climustr_lon0, climustr_lon_inc, 
     &     climustr_lat0, climustr_lat_inc,
     &     climustr_nlon, climustr_nlat,
     &     climustr_exfremo_intercept, climustr_exfremo_slope,
     &     climvstrfile, climvstrstartdate, climvstrperiod,
     &     exf_inscal_climvstr, climvstr, climvstr0, climvstr1, 
     &     climvstrmask,
     &     climvstr_lon0, climvstr_lon_inc, 
     &     climvstr_lat0, climvstr_lat_inc,
     &     climvstr_nlon, climvstr_nlat,
     &     climvstr_exfremo_intercept, climvstr_exfremo_slope,
     &     mytime, myiter, mythid )
c
      CALL EXCH_UV_XY_RL( climustr, climvstr, .TRUE., myThid )
c
#endif /* CLIMSTRESS_RELAXATION */

#ifdef ALLOW_BULK_OFFLINE
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
         DO j=1-oLy,sNy+oLy
          DO i=1-oLx,sNx+oLx
# ifdef ALLOW_CLIMSST_RELAXATION
           if ( climsstfile .NE. ' ' .AND. 
     &          climsstperiod .NE. 0. )
     &          theta(i,j,1,bi,bj) = climsst(i,j,bi,bj)
# endif
# ifdef ALLOW_CLIMSSS_RELAXATION
           if ( climsssfile .NE. ' ' .AND. 
     &          climsssperiod .NE. 0. )
     &          salt(i,j,1,bi,bj) = climsss(i,j,bi,bj)
# endif
# ifdef ALLOW_CLIMSTRESS_RELAXATION
           if ( climustrfile .NE. ' ' .AND. 
     &          climustrperiod .NE. 0. )
     &          uvel(i,j,1,bi,bj) = climustr(i,j,bi,bj)
           if ( climvstrfile .NE. ' ' .AND. 
     &          climvstrperiod .NE. 0. )
     &          vvel(i,j,1,bi,bj) = climvstr(i,j,bi,bj)
# endif
           if ( myiter .EQ. niter0 ) then
              if ( maskC(i,j,1,bi,bj) .NE. 0. .AND.
     &             theta(i,j,1,bi,bj) .EQ. 0. ) then
                print *, 'ph-warn-exf-clim ', i, j, theta(i,j,1,bi,bj)
cph                STOP 'in exf_getclim'
              endif
           endif
          ENDDO
         ENDDO
       ENDDO
      ENDDO
#endif /* ALLOW_BULK_OFFLINE */

      end
