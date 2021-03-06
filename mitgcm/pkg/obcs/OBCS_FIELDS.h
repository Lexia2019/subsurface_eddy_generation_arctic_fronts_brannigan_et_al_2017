C $Header: /u/gcmpack/MITgcm/pkg/obcs/OBCS_FIELDS.h,v 1.1 2011/05/24 14:22:40 jmc Exp $
C $Name:  $

#ifdef ALLOW_OBCS

CBOP
C     !ROUTINE: OBCS_FIELDS.h
C     !INTERFACE:
C     #include "OBCS_FIELDS.h"

C     !DESCRIPTION:
C     *==========================================================*
C     | OBCS_FIELDS.h
C     | o Header file containing OB values of model fields
C     *==========================================================*
CEOP

#ifdef ALLOW_OBCS_PRESCRIBE
C     OBCS_ldRec     :: time-record currently loaded (in temp arrays *[1])
      COMMON /OBCS_LOAD_I/ OBCS_ldRec
      INTEGER OBCS_ldRec(nSx,nSy)
#endif /* ALLOW_OBCS_PRESCRIBE */

C OB[N,S,E,W][u,v,t,s,a,h,sn,sl,uice,vice]File :: Files with boundary conditions,
C                                                 the letter combinations mean:
C                     N/S/E/W   :: northern/southern/eastern/western boundary
C                     u/v/t/s   :: ocean u/v velocities, temperature/salinity
C                     a/h       :: sea ice concentration/effective thickness
C                     sn/sl     :: effective snow thickness/sea ice salinity
C                     uice/vice :: sea ice u/v drift velocities

C--   COMMON /OBCS_FIELDS/ Open boundary related stuff
C     OBNu is the U value imposed at the Northern OB
C     OBNv is the V value imposed at the Northern OB
C     OBNt is the T value imposed at the Northern OB
C     OBNs is the S value imposed at the Northern OB
C     OBNa is the ice AREA value imposed at the Northern OB
C     OBNh is the ice HEFF value imposed at the Northern OB
C     OBNsl is the ice HSALT value imposed at the Northern OB
C     OBNsn is the ice HSNOW value imposed at the Northern OB
C     OBNuice is the uice value imposed at the Northern OB
C     OBNvice is the vice value imposed at the Northern OB
C     etc

#ifdef ALLOW_OBCS_NORTH
      COMMON /OBCS_FIELDS_N/
     &      OBNu,OBNv,OBNt,OBNs
      _RL OBNu (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBNv (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBNt (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBNs (1-Olx:sNx+Olx,Nr,nSx,nSy)
#ifdef ALLOW_OBCS_PRESCRIBE
      COMMON /OBCS_FIELDS_AUX_N/
     &      OBNu0,OBNv0,OBNt0,OBNs0,
     &      OBNu1,OBNv1,OBNt1,OBNs1
      _RL OBNu0 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBNv0 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBNt0 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBNs0 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBNu1 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBNv1 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBNt1 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBNs1 (1-Olx:sNx+Olx,Nr,nSx,nSy)
#endif /* ALLOW_OBCS_PRESCRIBE */
#endif /* ALLOW_OBCS_NORTH */

#ifdef ALLOW_OBCS_SOUTH
      COMMON /OBCS_FIELDS_S/
     &      OBSu,OBSv,OBSt,OBSs
      _RL OBSu (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSv (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSt (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSs (1-Olx:sNx+Olx,Nr,nSx,nSy)
#ifdef ALLOW_OBCS_PRESCRIBE
      COMMON /OBCS_FIELDS_AUX_S/
     &      OBSu0,OBSv0,OBSt0,OBSs0,
     &      OBSu1,OBSv1,OBSt1,OBSs1
      _RL OBSu0 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSv0 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSt0 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSs0 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSu1 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSv1 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSt1 (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSs1 (1-Olx:sNx+Olx,Nr,nSx,nSy)
#endif /* ALLOW_OBCS_PRESCRIBE */
#endif /* ALLOW_OBCS_SOUTH */

#ifdef ALLOW_OBCS_EAST
      COMMON /OBCS_FIELDS_E/
     &      OBEu,OBEv,OBEt,OBEs
      _RL OBEu (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBEv (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBEt (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBEs (1-Oly:sNy+Oly,Nr,nSx,nSy)
#ifdef ALLOW_OBCS_PRESCRIBE
      COMMON /OBCS_FIELDS_AUX_E/
     &      OBEu0,OBEv0,OBEt0,OBEs0,
     &      OBEu1,OBEv1,OBEt1,OBEs1
      _RL OBEu0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBEv0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBEt0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBEs0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBEu1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBEv1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBEt1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBEs1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
#endif /* ALLOW_OBCS_PRESCRIBE */
#endif /* ALLOW_OBCS_EAST */

#ifdef ALLOW_OBCS_WEST
      COMMON /OBCS_FIELDS_W/
     &      OBWu,OBWv,OBWt,OBWs
      _RL OBWu (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWv (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWt (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWs (1-Oly:sNy+Oly,Nr,nSx,nSy)
#ifdef ALLOW_OBCS_PRESCRIBE
      COMMON /OBCS_FIELDS_AUX_W/
     &      OBWu0,OBWv0,OBWt0,OBWs0,
     &      OBWu1,OBWv1,OBWt1,OBWs1
      _RL OBWu0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWv0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWt0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWs0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWu1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWv1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWt1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWs1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
#endif /* ALLOW_OBCS_PRESCRIBE */
#endif /* ALLOW_OBCS_WEST */

#ifdef ALLOW_NONHYDROSTATIC
      COMMON /OBCS_NH_FIELDS/
     &      OBNw, OBSw, OBEw, OBWw
      _RL OBNw (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSw (1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBEw (1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWw (1-Oly:sNy+Oly,Nr,nSx,nSy)
#ifdef ALLOW_OBCS_PRESCRIBE
      COMMON /OBCS_NH_FIELDS_AUX/
     &      OBNw0, OBSw0, OBEw0, OBWw0,
     &      OBNw1, OBSw1, OBEw1, OBWw1
      _RL OBNw0(1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSw0(1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBEw0(1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWw0(1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBNw1(1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBSw1(1-Olx:sNx+Olx,Nr,nSx,nSy)
      _RL OBEw1(1-Oly:sNy+Oly,Nr,nSx,nSy)
      _RL OBWw1(1-Oly:sNy+Oly,Nr,nSx,nSy)
#endif /* ALLOW_OBCS_PRESCRIBE */
#endif /* ALLOW_NONHYDROSTATIC */

#ifdef NONLIN_FRSURF
      COMMON /OBCS_NLFS_FIELDS/
     &  OBNeta,  OBSeta,  OBEeta,  OBWeta
      _RL OBNeta (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBSeta (1-Olx:sNx+Olx,nSx,nSy)
      _RL OBEeta (1-Oly:sNy+Oly,nSx,nSy)
      _RL OBWeta (1-Oly:sNy+Oly,nSx,nSy)
#ifdef ALLOW_OBCS_PRESCRIBE
      COMMON /OBCS_NLFS_FIELDS_AUX/
     &      OBNeta0,OBSeta0,OBEeta0,OBWeta0,
     &      OBNeta1,OBSeta1,OBEeta1,OBWeta1
      _RL OBNeta0(1-Olx:sNx+Olx,nSx,nSy)
      _RL OBSeta0(1-Olx:sNx+Olx,nSx,nSy)
      _RL OBEeta0(1-Oly:sNy+Oly,nSx,nSy)
      _RL OBWeta0(1-Oly:sNy+Oly,nSx,nSy)
      _RL OBNeta1(1-Olx:sNx+Olx,nSx,nSy)
      _RL OBSeta1(1-Olx:sNx+Olx,nSx,nSy)
      _RL OBEeta1(1-Oly:sNy+Oly,nSx,nSy)
      _RL OBWeta1(1-Oly:sNy+Oly,nSx,nSy)
#endif /* ALLOW_OBCS_PRESCRIBE */
#endif /* NONLIN_FRSURF */

#endif /* ALLOW_OBCS */
