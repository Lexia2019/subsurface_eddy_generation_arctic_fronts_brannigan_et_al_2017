C $Header: /u/gcmpack/MITgcm/pkg/autodiff/dummy_in_stepping.F,v 1.3 2007/10/08 23:50:53 jmc Exp $
C $Name:  $

#include "AUTODIFF_OPTIONS.h"

      subroutine dummy_in_stepping( mytime, myiter, myThid )
      IMPLICIT NONE
C     /==========================================================\
C     | SUBROUTINE dummy_in_stepping                             |
C     |==========================================================|
C     == Global variables ===

#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"

C     == Routine arguments ==
C     myThid - Thread number for this instance of the routine.
      integer myThid
      integer myiter
      _RL     mytime

      call TIMER_START('I/O (WRITE)        [ADJOINT LOOP]', myThid )

      call TIMER_STOP( 'I/O (WRITE)        [ADJOINT LOOP]', myThid )

      end









