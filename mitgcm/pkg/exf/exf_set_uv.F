C $Header: /u/gcmpack/MITgcm/pkg/exf/exf_set_uv.F,v 1.21 2009/09/02 19:18:39 jmc Exp $
C $Name:  $

#include "EXF_OPTIONS.h"

      subroutine exf_set_uv(
     &     uvecfile, uvecstartdate, uvecperiod,
     &     exf_inscal_uvec, uvec, uvec0, uvec1, uvecmask,
     &     uvec_lon0, uvec_lon_inc, uvec_lat0, uvec_lat_inc,
     &     uvec_nlon, uvec_nlat,
     &     uvec_remove_intercept, uvec_remove_slope,
     &     vvecfile, vvecstartdate, vvecperiod,
     &     exf_inscal_vvec, vvec, vvec0, vvec1, vvecmask,
     &     vvec_lon0, vvec_lon_inc, vvec_lat0, vvec_lat_inc,
     &     vvec_nlon, vvec_nlat,
     &     vvec_remove_intercept, vvec_remove_slope,
     &     mycurrenttime, mycurrentiter, mythid )

c     ==================================================================
c     SUBROUTINE exf_set_uv
c     ==================================================================
c
c     o Read-in, interpolate, and rotate wind or wind stress vectors
c       from a spherical-polar input grid to an arbitrary output grid.
c
c       menemenlis@jpl.nasa.gov, 8-Dec-2003
c
c     ==================================================================
c     SUBROUTINE exf_set_uv
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"

#include "EXF_PARAM.h"
#include "EXF_FIELDS.h"
#include "EXF_CONSTANTS.h"

#ifdef ALLOW_AUTODIFF
# include "ctrl.h"
# include "ctrl_dummy.h"
#endif

c     == routine arguments ==

c     *vec_lon_0,          :: longitude and latitude of SouthWest
c         *vec_lat_0          corner of global input grid for *vec
c     *vec_nlon, *vec_nlat :: input x-grid and y-grid size for *vec
c     *vec_lon_inc         :: scalar x-grid increment for *vec
c     *vec_lat_inc         :: vector y-grid increments for *vec

      character*(128) uvecfile, uvecfile0, uvecfile1
      _RL     uvecstartdate, uvecperiod
      _RL     exf_inscal_uvec
      _RL     uvec_remove_intercept, uvec_remove_slope
      _RL     uvec  (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL     uvec0 (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL     uvec1 (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      character*1 uvecmask
      _RL uvec_lon0, uvec_lon_inc
      _RL uvec_lat0, uvec_lat_inc(MAX_LAT_INC)
      INTEGER uvec_nlon, uvec_nlat
      character*(128) vvecfile, vvecfile0, vvecfile1
      _RL     vvecstartdate, vvecperiod
      _RL     exf_inscal_vvec
      _RL     vvec_remove_intercept, vvec_remove_slope
      _RL     vvec  (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL     vvec0 (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL     vvec1 (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      character*1 vvecmask
      _RL vvec_lon0, vvec_lon_inc
      _RL vvec_lat0, vvec_lat_inc(MAX_LAT_INC)
      INTEGER vvec_nlon, vvec_nlat
      _RL     mycurrenttime
      integer mycurrentiter
      integer mythid

#ifdef USE_EXF_INTERPOLATION
c     == local variables ==

      logical first, changed
      _RL     fac, x1, x2, x3, x4, y1, y2, y3, y4, dx, dy
      _RL     tmp_u (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL     tmp_v (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      integer count0, count1
      integer i, j, bi, bj
      integer   il, interp_method
      integer year0, year1

c     == external ==

      integer  ilnblnk
      external ilnblnk

c     == end of interface ==

      IF ( usingCurvilinearGrid .OR. rotateGrid ) THEN

        if ( uvecfile .NE. ' ' .and. vvecfile .NE. ' ' ) then

c     get record numbers and interpolation factor
          call exf_GetFFieldRec(
     I        uvecstartdate, uvecperiod
     I        , useExfYearlyFields
     O        , fac, first, changed
     O        , count0, count1, year0, year1
     I        , mycurrenttime, mycurrentiter, mythid
     &        )

          if ( first ) then

            call exf_GetYearlyFieldName(
     I         useExfYearlyFields, twoDigitYear, uvecperiod, year0,
     I         uvecfile,
     O         uvecfile0,
     I         mycurrenttime, mycurrentiter, mythid )
            call exf_GetYearlyFieldName(
     I         useExfYearlyFields, twoDigitYear, vvecperiod, year0,
     I         vvecfile,
     O         vvecfile0,
     I         mycurrenttime, mycurrentiter, mythid )

c     scalar interpolation to (xC,yC) locations
            interp_method=12
            call exf_interp( uvecfile0, exf_iprec
     &          , tmp_u, count0, xC, yC
     &          , uvec_lon0,uvec_lon_inc
     &          , uvec_lat0,uvec_lat_inc
     &          , uvec_nlon,uvec_nlat,interp_method,mythid
     &          )
            interp_method=22
            call exf_interp( vvecfile0, exf_iprec
     &          , tmp_v, count0, xC, yC
     &          , vvec_lon0,vvec_lon_inc
     &          , vvec_lat0,vvec_lat_inc
     &          , vvec_nlon,vvec_nlat,interp_method,mythid
     &          )
c     vector rotation
            do bj = mybylo(mythid),mybyhi(mythid)
              do bi = mybxlo(mythid),mybxhi(mythid)
                do j = 1,sny
                  do i = 1,snx
                    x1=xG(i,j,bi,bj)
                    x2=xG(i+1,j,bi,bj)
                    x3=xG(i,j+1,bi,bj)
                    x4=xG(i+1,j+1,bi,bj)
                    if ((x2-x1).gt.180) x2=x2-360
                    if ((x1-x2).gt.180) x2=x2+360
                    if ((x3-x1).gt.180) x3=x3-360
                    if ((x1-x3).gt.180) x3=x3+360
                    if ((x4-x1).gt.180) x4=x4-360
                    if ((x1-x4).gt.180) x4=x4+360
                    y1=yG(i,j,bi,bj)
                    y2=yG(i+1,j,bi,bj)
                    y3=yG(i,j+1,bi,bj)
                    y4=yG(i+1,j+1,bi,bj)
                    dx=0.5*(x3+x4-x1-x2)
                    dx=dx*
     &                  cos(deg2rad*yC(i,j,bi,bj))
                    dy=0.5*(y3+y4-y1-y2)
                    vvec1(i,j,bi,bj)=
     &                  (tmp_u(i,j,bi,bj)*dx+
     &                  tmp_v(i,j,bi,bj)*dy)/
     &                  sqrt(dx*dx+dy*dy)
                    dx=0.5*(x2+x4-x1-x3)
                    dx=dx*
     &                  cos(deg2rad*yC(i,j,bi,bj))
                    dy=0.5*(y2+y4-y1-y3)
                    uvec1(i,j,bi,bj)=
     &                  (tmp_u(i,j,bi,bj)*dx+
     &                  tmp_v(i,j,bi,bj)*dy)/
     &                  sqrt(dx*dx+dy*dy)
                  enddo
                enddo
              enddo
            enddo
c     apply mask
            if (exf_yftype .eq. 'RL') then
              call exf_filter_rl( uvec1, uvecmask, mythid )
              call exf_filter_rl( vvec1, vvecmask, mythid )
            else
c             call exf_filter_rs( uvec1, uvecmask, mythid )
c             call exf_filter_rs( vvec1, vvecmask, mythid )
              STOP 'S/R EXF_SET_UV: invalid exf_yftype'
            end if
          endif

          if (( first ) .or. ( changed )) then
            call exf_SwapFFields( uvec0, uvec1, mythid )
            call exf_SwapFFields( vvec0, vvec1, mythid )

            call exf_GetYearlyFieldName(
     I         useExfYearlyFields, twoDigitYear, uvecperiod, year1,
     I         uvecfile,
     O         uvecfile1,
     I         mycurrenttime, mycurrentiter, mythid )
            call exf_GetYearlyFieldName(
     I         useExfYearlyFields, twoDigitYear, vvecperiod, year1,
     I         vvecfile,
     O         vvecfile1,
     I         mycurrenttime, mycurrentiter, mythid )

c     scalar interpolation to (xC,yC) locations
            interp_method=12
            call exf_interp( uvecfile1, exf_iprec
     &          , tmp_u, count1, xC, yC
     &          , uvec_lon0,uvec_lon_inc
     &          , uvec_lat0,uvec_lat_inc
     &          , uvec_nlon,uvec_nlat,interp_method,mythid
     &          )
            interp_method=22
            call exf_interp( vvecfile1, exf_iprec
     &          , tmp_v, count1, xC, yC
     &          , vvec_lon0,vvec_lon_inc
     &          , vvec_lat0,vvec_lat_inc
     &          , vvec_nlon,vvec_nlat,interp_method,mythid
     &          )
c     vector rotation
            do bj = mybylo(mythid),mybyhi(mythid)
              do bi = mybxlo(mythid),mybxhi(mythid)
                do j = 1,sny
                  do i = 1,snx
                    x1=xG(i,j,bi,bj)
                    x2=xG(i+1,j,bi,bj)
                    x3=xG(i,j+1,bi,bj)
                    x4=xG(i+1,j+1,bi,bj)
                    if ((x2-x1).gt.180) x2=x2-360
                    if ((x1-x2).gt.180) x2=x2+360
                    if ((x3-x1).gt.180) x3=x3-360
                    if ((x1-x3).gt.180) x3=x3+360
                    if ((x4-x1).gt.180) x4=x4-360
                    if ((x1-x4).gt.180) x4=x4+360
                    y1=yG(i,j,bi,bj)
                    y2=yG(i+1,j,bi,bj)
                    y3=yG(i,j+1,bi,bj)
                    y4=yG(i+1,j+1,bi,bj)
                    dx=0.5*(x3+x4-x1-x2)
                    dx=dx*
     &                  cos(deg2rad*yC(i,j,bi,bj))
                    dy=0.5*(y3+y4-y1-y2)
                    vvec1(i,j,bi,bj)=
     &                  (tmp_u(i,j,bi,bj)*dx+
     &                  tmp_v(i,j,bi,bj)*dy)/
     &                  sqrt(dx*dx+dy*dy)
                    dx=0.5*(x2+x4-x1-x3)
                    dx=dx*
     &                  cos(deg2rad*yC(i,j,bi,bj))
                    dy=0.5*(y2+y4-y1-y3)
                    uvec1(i,j,bi,bj)=
     &                  (tmp_u(i,j,bi,bj)*dx+
     &                  tmp_v(i,j,bi,bj)*dy)/
     &                  sqrt(dx*dx+dy*dy)
                  enddo
                enddo
              enddo
            enddo
c     apply mask
            if (exf_yftype .eq. 'RL') then
              call exf_filter_rl( uvec1, uvecmask, mythid )
              call exf_filter_rl( vvec1, vvecmask, mythid )
            else
c             call exf_filter_rs( uvec1, uvecmask, mythid )
c             call exf_filter_rs( vvec1, vvecmask, mythid )
              STOP 'S/R EXF_SET_UV: invalid exf_yftype'
            end if
          endif

c     Interpolate linearly onto the current time.
          do bj = mybylo(mythid),mybyhi(mythid)
            do bi = mybxlo(mythid),mybxhi(mythid)
              do j = 1,sny
                do i = 1,snx
                  uvec(i,j,bi,bj) = exf_inscal_uvec * (
     &                fac * uvec0(i,j,bi,bj) +
     &                (exf_one - fac) * uvec1(i,j,bi,bj) )
                  vvec(i,j,bi,bj) = exf_inscal_vvec * (
     &                fac * vvec0(i,j,bi,bj) +
     &                (exf_one - fac) * vvec1(i,j,bi,bj) )
                enddo
              enddo
            enddo
          enddo

        endif

      ELSE
c     IF ( .NOT. ( usingCurvilinearGrid .OR rotateGrid ) )

       interp_method=12
        call exf_set_gen(
     &      uvecfile, uvecstartdate, uvecperiod,
     &      exf_inscal_uvec,
     &      uvec_remove_intercept, uvec_remove_slope,
     &      uvec, uvec0, uvec1, uvecmask,
     &      uvec_lon0, uvec_lon_inc, uvec_lat0, uvec_lat_inc,
     &      uvec_nlon, uvec_nlat, xC, yC, interp_method,
     &      mycurrenttime, mycurrentiter, mythid )
        interp_method=22
        call exf_set_gen(
     &      vvecfile, vvecstartdate, vvecperiod,
     &      exf_inscal_vvec,
     &      vvec_remove_intercept, vvec_remove_slope,
     &      vvec, vvec0, vvec1, vvecmask,
     &      vvec_lon0, vvec_lon_inc, vvec_lat0, vvec_lat_inc,
     &      vvec_nlon, vvec_nlat, xC, yC, interp_method,
     &      mycurrenttime, mycurrentiter, mythid )

      ENDIF

#endif /* USE_EXF_INTERPOLATION */

      return
      end
