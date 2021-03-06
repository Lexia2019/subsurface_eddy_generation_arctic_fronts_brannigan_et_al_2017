C $Header: /u/gcmpack/MITgcm/eesupp/src/exch_uv_agrid_3d_rx.template,v 1.5 2010/05/19 01:53:46 jmc Exp $
C $Name:  $

#include "PACKAGES_CONFIG.h"
#include "CPP_EEOPTIONS.h"

CBOP
C     !ROUTINE: EXCH_UV_AGRID_3D_RS

C     !INTERFACE:
      SUBROUTINE EXCH_UV_AGRID_3D_RS(
     U                                Uphi, Vphi,
     I                                withSigns, myNz, myThid )

C     !DESCRIPTION:
C*=====================================================================*
C  Purpose: SUBROUTINE EXCH_UV_AGRID_3D_RS
C      handle exchanges for a 3D vector field on an A-grid.
C
C  Input:
C    Uphi(lon,lat,levs,bi,bj) :: first component of vector
C    Vphi(lon,lat,levs,bi,bj) :: second component of vector
C    withSigns (logical)      :: true to use signs of components
C    myNz                     :: 3rd dimension of input arrays Uphi,Vphi
C    myThid                   :: my Thread Id number
C
C  Output: Uphi and Vphi are updated (halo regions filled)
C
C  Calls: exch (either exch_rx_cube or exch_rx) - twice, once
C         for the first-component, once for second.
C
C  NOTES: 1) If using CubedSphereExchange, only works on ONE PROCESSOR!
C*=====================================================================*

C     !USES:
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Argument list variables ==
      INTEGER myNz
      _RS Uphi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,myNz,nSx,nSy)
      _RS Vphi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,myNz,nSx,nSy)
      LOGICAL withSigns
      INTEGER myThid

C     !LOCAL VARIABLES:
#ifndef ALLOW_EXCH2
C     == Local variables ==
C     i,j,k,bi,bj   :: are DO indices.
C     OL[wens]      ::  Overlap extents in west, east, north, south.
C     exchWidth[XY] :: Extent of regions that will be exchanged.
C     dummy[12]     :: copies of the vector components with haloes filled.

      INTEGER i,j,k,bi,bj
      INTEGER OLw, OLe, OLn, OLs, exchWidthX, exchWidthY
      _RS dummy1(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RS dummy2(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RS negOne
#endif
CEOP

#ifdef ALLOW_EXCH2
      CALL EXCH2_UV_AGRID_3D_RS(
     U                           Uphi, Vphi,
     I                           withSigns, myNz, myThid )
      RETURN
#else /* ALLOW_EXCH2 */

      OLw        = OLx
      OLe        = OLx
      OLn        = OLy
      OLs        = OLy
      exchWidthX = OLx
      exchWidthY = OLy
      negOne = 1.
      IF (withSigns) negOne = -1.


      IF (useCubedSphereExchange) THEN
C---  using CubedSphereExchange:

C First call the exchanges for the two components

       CALL EXCH1_RS_CUBE( Uphi, .FALSE.,
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            EXCH_UPDATE_CORNERS, myThid )
       CALL EXCH1_RS_CUBE( Vphi, .FALSE.,
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            EXCH_UPDATE_CORNERS, myThid )

C Then if we are on the sphere we may need to switch u and v components
C and/or the signs depending on which cube face we are located.

C--    Loops on tile and level indices:
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         DO k = 1,myNz

C First we need to copy the component info into dummy arrays
          DO j = 1-OLy,sNy+OLy
           DO i = 1-OLx,sNx+OLx
             dummy1(i,j) = Uphi(i,j,k,bi,bj)
             dummy2(i,j) = Vphi(i,j,k,bi,bj)
           ENDDO
          ENDDO

C Now choose what to do at each edge of the halo based on which face
C    (we assume that bj is always=1)

C odd faces share disposition of all sections of the halo
          IF ( MOD(bi,2).EQ.1 ) THEN
           DO j = 1,sNy
            DO i = 1,exchWidthX
C east (nothing to change)
c            Uphi(sNx+i,j,k,bi,bj) = dummy1(sNx+i,j)
c            Vphi(sNx+i,j,k,bi,bj) = dummy2(sNx+i,j)
C west
             Uphi(1-i,j,k,bi,bj) = dummy2(1-i,j)
             Vphi(1-i,j,k,bi,bj) = dummy1(1-i,j)*negOne
            ENDDO
           ENDDO
           DO j = 1,exchWidthY
            DO i = 1,sNx
C north
             Uphi(i,sNy+j,k,bi,bj) = dummy2(i,sNy+j)*negOne
             Vphi(i,sNy+j,k,bi,bj) = dummy1(i,sNy+j)
C south (nothing to change)
c            Uphi(i,1-j,k,bi,bj) = dummy1(i,1-j)
c            Vphi(i,1-j,k,bi,bj) = dummy2(i,1-j)
            ENDDO
           ENDDO

          ELSE
C now the even faces (share disposition of all sections of the halo)

           DO j = 1,sNy
            DO i = 1,exchWidthX
C east
             Uphi(sNx+i,j,k,bi,bj) = dummy2(sNx+i,j)
             Vphi(sNx+i,j,k,bi,bj) = dummy1(sNx+i,j)*negOne
C west (nothing to change)
c            Uphi(1-i,j,k,bi,bj) = dummy1(1-i,j)
c            Vphi(1-i,j,k,bi,bj) = dummy2(1-i,j)
            ENDDO
           ENDDO
           DO j = 1,exchWidthY
            DO i = 1,sNx
C north (nothing to change)
c            Uphi(i,sNy+j,k,bi,bj) = dummy1(i,sNy+j)
c            Vphi(i,sNy+j,k,bi,bj) = dummy2(i,sNy+j)
C south
             Uphi(i,1-j,k,bi,bj) = dummy2(i,1-j)*negOne
             Vphi(i,1-j,k,bi,bj) = dummy1(i,1-j)

            ENDDO
           ENDDO

C end odd / even faces
          ENDIF

C--    end of Loops on tile and level indices (k,bi,bj).
         ENDDO
        ENDDO
       ENDDO

      ELSE
C---  not using CubedSphereExchange:

       CALL EXCH1_RS( Uphi,
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            EXCH_UPDATE_CORNERS, myThid )
       CALL EXCH1_RS( Vphi,
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            EXCH_UPDATE_CORNERS, myThid )

C---  using or not using CubedSphereExchange: end
      ENDIF

      RETURN
#endif /* ALLOW_EXCH2 */
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
