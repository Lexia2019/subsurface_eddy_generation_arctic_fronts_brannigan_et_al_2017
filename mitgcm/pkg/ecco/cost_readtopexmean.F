C $Header: /u/gcmpack/MITgcm/pkg/ecco/cost_readtopexmean.F,v 1.5 2010/03/24 01:34:38 jmc Exp $
C $Name:  $

#include "COST_CPPOPTIONS.h"


      subroutine cost_ReadTopexMean(
     I                               mythid
     &                             )

c     ==================================================================
c     SUBROUTINE cost_ReadTopexMean
c     ==================================================================
c
c     o Read the time mean TOPEX SSH field.
c
c     started: Christian Eckert eckert@mit.edu 25-May-1999
c
c     changed: Christian Eckert eckert@mit.edu 25-Feb-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c     ==================================================================
c     SUBROUTINE cost_ReadTopexMean
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "GRID.h"

#include "ecco_cost.h"

c     == routine arguments ==

      integer mythid

#ifdef ALLOW_SSH_MEAN_COST_CONTRIBUTION
c     == local variables ==

      integer i,j,k
      integer bi,bj
      integer itlo,ithi
      integer jtlo,jthi
      integer jmin,jmax
      integer imin,imax
      _RL spval
      _RL factor

c     == end of interface ==

      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)
      jmin = 1
      jmax = sny
      imin = 1
      imax = snx

c--   Convert mean ssh from cm to m
      factor =  0.01 _d 0
      spval  = -9990. _d 0

      call mdsreadfield( topexmeanfile, cost_iprec, cost_yftype, 1,
     &                   tpmean, 1, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          k = 1
          do j = jmin,jmax
            do i = imin,imax
              if (_hFacC(i,j,k,bi,bj) .eq. 0.) then
                tpmeanmask(i,j,bi,bj) = 0. _d 0
              else
                tpmeanmask(i,j,bi,bj) = 1. _d 0
              endif
              if (tpmean(i,j,bi,bj) .lt. spval) then
                tpmeanmask(i,j,bi,bj) = 0. _d 0
              endif
              if (tpmean(i,j,bi,bj) .eq. 0. _d 0 ) then
                 tpmeanmask(i,j,bi,bj) = 0. _d 0
              endif

              if ( R_low(i,j,bi,bj) .GT. -200. ) then
                tpmeanmask(i,j,bi,bj) = 0. _d 0
              endif

              tpmeanmask(i,j,bi,bj) = tpmeanmask(i,j,bi,bj)*frame(i,j)
              tpmean(i,j,bi,bj) = tpmean(i,j,bi,bj)*
     &                            tpmeanmask(i,j,bi,bj)*
     &                             factor
            enddo
          enddo
        enddo
      enddo

#endif /* ALLOW_SSH_MEAN_COST_CONTRIBUTION */

      return
      end
