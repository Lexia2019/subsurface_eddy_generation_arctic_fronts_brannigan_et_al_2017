C $Header: /u/gcmpack/MITgcm/pkg/autodiff/active_file_loc_control.F,v 1.8 2010/03/22 02:15:02 jmc Exp $
C $Name:  $

#include "AUTODIFF_OPTIONS.h"

c     ==================================================================
c
c     active_file_control_loc.F: Routines to handle the i/o of active vari-
c                            ables for the adjoint calculations. All
c                            files are direct access files.
c
c     Routines:
c
c     o  active_read_rl_loc         - Basic routine to handle active read
c                                 operations.
c     o  active_write_rl_loc        - Basic routine to handle active write
c                                 operations.
c
c
c     ==================================================================

CBOP
C     !ROUTINE: active_read_rl_loc
C     !INTERFACE:
      subroutine active_read_rl_loc(
     I                           active_var_file,
     O                           active_var,
     I                           globalfile,
     I                           lAdInit,
     I                           irec,
     I                           mynr,
     I                           theSimulationMode,
     I                           myOptimIter,
     I                           mythid
     &                         )

C     !DESCRIPTION: \bv
c     ==================================================================
c     o Read an active _RL variable from file.
c     The variable *globalfile* can be used as a switch, which allows
c     to read from a global file. The adjoint files are, however, always
c     treated as tiled files.
c     started: Christian Eckert eckert@mit.edu    Jan-1999
c     ==================================================================
C     \ev

C     !USES:
      implicit none

c     == global variables ==
#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "ctrl.h"

C     !INPUT/OUTPUT PARAMETERS:
c     == routine arguments ==
c     active_var_file: filename
c     active_var:      array
c     irec:            record number
c     myOptimIter:     number of optimization iteration (default: 0)
c     mythid:          thread number for this instance
c     doglobalread:    flag for global or local read/write
c                      (default: .false.)
c     lAdInit:         initialisation of corresponding adjoint
c                      variable and write to active file
c     mynr:            vertical array dimension
c     theSimulationMode: forward mode or reverse mode simulation
      character*(*) active_var_file
      logical  globalfile
      logical  lAdInit
      integer  irec
      integer  mynr
      integer  theSimulationMode
      integer  myOptimIter
      integer  mythid
      _RL     active_var(1-olx:snx+olx,1-oly:sny+oly,mynr,nsx,nsy)

C     !LOCAL VARIABLES:
c     == local variables ==
      character*(2)  adpref
      character*(80) adfname
      integer bi,bj
      integer i,j,k
      integer oldprec
      integer prec
      integer il
      integer ilnblnk
      logical writeglobalfile
      _RL  active_data_t(1-olx:snx+olx,1-oly:sny+oly,mynr,nsx,nsy)

c     == functions ==
      external ilnblnk

c     == end of interface ==
CEOP

c     force 64-bit io
      oldPrec        = readBinaryPrec
      readBinaryPrec = ctrlprec
      prec           = ctrlprec

      write(adfname(1:80),'(80a)') ' '
      adpref = 'ad'
      il = ilnblnk( active_var_file )

      write(adfname(1:2),'(a)') adpref
      write(adfname(3:il+2),'(a)') active_var_file(1:il)

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> FORWARD RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. FORWARD_SIMULATION) then

        _BEGIN_MASTER( mythid )

c       Read the active variable from file.

        call mdsreadfield_loc(
     &                     active_var_file,
     &                     prec,
     &                     'RL',
     &                     mynr,
     &                     active_var,
     &                     irec,
     &                     mythid )

        if (lAdInit) then
c         Initialise the corresponding adjoint variable on the
c         adjoint variable file. These files are tiled.

          writeglobalfile = .false.
          do bj = 1,nsy
             do bi = 1,nsx
                do k = 1, mynr
                   do j=1,sny
                      do i=1,snx
                         active_data_t(i,j,k,bi,bj)= 0. _d 0
                      enddo
                   enddo
                enddo
             enddo
          enddo

          call mdswritefield_loc(
     &                           adfname,
     &                           prec,
     &                           globalfile,
     &                           'RL',
     &                           mynr,
     &                           active_data_t,
     &                           irec,
     &                           myOptimIter,
     &                           mythid )
        endif

        _END_MASTER( mythid )

      endif

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> ADJOINT RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. REVERSE_SIMULATION) then

        _BEGIN_MASTER( mythid )

        writeglobalfile = .false.
        call mdsreadfield_loc(
     &                        active_var_file,
     &                        prec,
     &                        'RL',
     &                        mynr,
     &                        active_data_t,
     &                        irec,
     &                        mythid )

c             Add active_var from appropriate location to data.
        do bj = 1,nsy
           do bi = 1,nsx
              do k = 1, mynr
                 do j=1,sny
                    do i=1,snx
                       active_data_t(i,j,k,bi,bj) =
     &                      active_data_t(i,j,k,bi,bj) +
     &                      active_var(i,j,k,bi,bj)
                    enddo
                 enddo
              enddo
           enddo
        enddo

c             Store the result on disk.
        call mdswritefield_loc(
     &                         active_var_file,
     &                         prec,
     &                         writeglobalfile,
     &                         'RL',
     &                         mynr,
     &                         active_data_t,
     &                         irec,
     &                         myOptimIter,
     &                         mythid )

c       Set active_var to zero.
        do bj = 1,nsy
           do bi = 1,nsx
              do k=1,mynr
                 do j=1,sny
                    do i=1,snx
                       active_var(i,j,k,bi,bj) = 0. _d 0
                    enddo
                 enddo
              enddo
           enddo
        enddo

        _END_MASTER( mythid )
      endif

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> TANGENT RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. TANGENT_SIMULATION) then

        _BEGIN_MASTER( mythid )

c       Read the active variable from file.

        call mdsreadfield_loc(
     &                     active_var_file,
     &                     prec,
     &                     'RL',
     &                     mynr,
     &                     active_var,
     &                     irec,
     &                     mythid )

        _END_MASTER( mythid )
      endif

c     Reset default io precision.
      readBinaryPrec = oldPrec

      _BARRIER

      return
      end


CBOP
C     !ROUTINE: active_write_rl_loc
C     !INTERFACE:
      subroutine active_write_rl_loc(
     I                            active_var_file,
     I                            active_var,
     I                            globalfile,
     I                            irec,
     I                            mynr,
     I                            theSimulationMode,
     I                            myOptimIter,
     I                            mythid
     &                          )

C     !DESCRIPTION: \bv
c     ==================================================================
c     o Write an active _RL variable to a file.
c     started: Christian Eckert eckert@mit.edu    Jan-1999
c     ==================================================================
C     \ev

C     !USES:
      implicit none

c     == global variables ==
#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "ctrl.h"

C     !INPUT/OUTPUT PARAMETERS:
c     == routine arguments ==
c     active_var_file: filename
c     active_var:      array
c     irec:            record number
c     myOptimIter:     number of optimization iteration (default: 0)
c     mythid:          thread number for this instance
c     doglobalread:    flag for global or local read/write
c                      (default: .false.)
c     lAdInit:         initialisation of corresponding adjoint
c                      variable and write to active file
c     mynr:            vertical array dimension
c     theSimulationMode: forward mode or reverse mode simulation
      character*(*) active_var_file
      integer  mynr
      logical  globalfile
      integer  irec
      integer  theSimulationMode
      integer  myOptimIter
      integer  mythid
      _RL     active_var(1-olx:snx+olx,1-oly:sny+oly,mynr,nsx,nsy)

C     !LOCAL VARIABLES:
c     == local variables ==
      integer  i,j,k
      integer  bi,bj
      _RL  active_data_t(1-olx:snx+olx,1-oly:sny+oly,mynr,nsx,nsy)
      integer  oldprec
      integer  prec

c     == end of interface ==
CEOP

c     force 64-bit io
      oldPrec        = readBinaryPrec
      readBinaryPrec = ctrlprec
      prec           = ctrlprec

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> FORWARD RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. FORWARD_SIMULATION) then

        _BEGIN_MASTER( mythid )

          call mdswritefield_loc(
     &                        active_var_file,
     &                        prec,
     &                        globalfile,
     &                        'RL',
     &                        mynr,
     &                        active_var,
     &                        irec,
     &                        myOptimIter,
     &                        mythid )

        _END_MASTER( mythid )

      endif

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> ADJOINT RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. REVERSE_SIMULATION) then

        _BEGIN_MASTER( mythid )

        call mdsreadfield_loc(
     &                           active_var_file,
     &                           prec,
     &                           'RL',
     &                            mynr,
     &                            active_data_t,
     &                            irec,
     &                            mythid )

c             Add active_var from appropriate location to data.
        do bj = 1,nsy
           do bi = 1,nsx
              do k = 1,mynr
                 do j=1,sny
                    do i=1,snx
                       active_var(i,j,k,bi,bj) =
     &                      active_var(i,j,k,bi,bj) +
     &                      active_data_t(i,j,k,bi,bj)
                       active_data_t(i,j,k,bi,bj) = 0. _d 0
                    enddo
                 enddo
              enddo
           enddo
        enddo
        call mdswritefield_loc(
     &                            active_var_file,
     &                            prec,
     &                            globalfile,
     &                            'RL',
     &                            mynr,
     &                            active_data_t,
     &                            irec,
     &                            myOptimIter,
     &                            mythid )

        _END_MASTER( mythid )

      endif

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> TANGENT RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. TANGENT_SIMULATION) then

        _BEGIN_MASTER( mythid )

          call mdswritefield_loc(
     &                        active_var_file,
     &                        prec,
     &                        globalfile,
     &                        'RL',
     &                        mynr,
     &                        active_var,
     &                        irec,
     &                        myOptimIter,
     &                        mythid )

        _END_MASTER( mythid )

      endif

c     Reset default io precision.
      readBinaryPrec = oldPrec

      _BARRIER

      return
      end

