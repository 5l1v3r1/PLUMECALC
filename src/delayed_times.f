      subroutine delayed_times
!***********************************************************************
! $Id: delayed_times.f,v 1.2 2006/06/06 20:11:36 zvd Exp $
!***********************************************************************
!  Copyright, 2002, 2004,  The  Regents of the University of California.
!  This  program  was  prepared by  the  Regents  of the  University  of
!  California  at Los Alamos National Laboratory (the  University) under
!  contract No. W-7405-ENG-36 with the U. S. Department of Energy (DOE).
!  All rights in the program are reserved by the DOE and the University.
!  Permission is  granted to the  public to copy  and  use this software
!  without  charge,  provided that this  Notice  and  any  statement  of
!  authorship are reproduced on all copies. Neither the U. S. Government
!  nor  the  University  makes any  warranty,  express  or  implied,  or
!  assumes any liability or responsibility for the use of this software.
!***********************************************************************
!     PSEUDOCODE
!        
!     FOR each cell
!        If the retardation factor is not 1
!           Set flag to denote corrections needed
!           Exit loop over each cell
!        ENDIF the retardation factor is not 1
!     ENDFOR each cell
c
!     IF corrections are needed
!        FOR each particle
!           FOR each segment of its travel path
!              IF this cell is a diffusion model cell
!                 call subroutine to compute particle travel time
!                 Compute new exit time from this cell
!              ELSE there may be sorption in a continuum model
!                 Compute new exit time from this cell
!              ENDIF this cell is a diffusion model cell
!              
!           ENDFOR each segment of its travel path
!        ENDFOR each particle
!     ENDIF corrections are needed
!***********************************************************************

      use comparttr, only : npart, n_cells, time_packed, cell_packed,
     2     adv_packed
      use comgrid, only : n_grid_points
      use comrock, only : rfac, vcf, itrc_diff, sigma_partial, 
     2     omega_partial, rd_frac, rseed, diffusion_model
      implicit none

      logical corrections
      integer i
      integer j
      integer istart
      integer iend
      real*8 time_current
      real*8 time_updated_previous
      real*8 time_original_previous
      real*8 delta_time
      real*8 delta_delay_time
      real*8 par3v
      integer tflag
      integer fm
      parameter(tflag = 3)
      real*8 sigma
      real*8 omega
      real*8 time_diffused
      real*8 rf_corr
      real*8 conc_ret

c***************** Begin executable statements here**********

      corrections = .false.
!     The adv_packed array contains the mobile ratio, defined as the 
!     delta time it takes for advection divided by total delta time
!     Initialize the advected mobile ratio to 1.
      adv_packed = 1.0d0

!     FOR each cell
      check_loop: do i = 1, n_grid_points
!     IF the cell has particle delay
         if(rfac(i).ne.1..or.diffusion_model) then
!     Set flag to denote corrections needed
            corrections = .true.
!     Exit loop over each cell
            exit check_loop
         end if
!     ENDIF the cell has particle delay
      end do check_loop
!     ENDFOR each cell

!     IF corrections are needed
      if (corrections) then

         istart = 1
!        FOR each particle
         do i = 1, npart
            iend = istart + n_cells(i)-1
            time_current = 0.
            time_updated_previous = 0.
            time_original_previous = 0.
!           FOR each segment of its travel path
            do j = istart, iend
!     Distinguish between a model with matrix diffusion and simple
!     sorption in a continuum
!     Compute new exit time from this cell
               adv_packed(j) = time_packed(j) - time_original_previous
               delta_time = adv_packed(j) * 86400.
               if(itrc_diff(cell_packed(j)).ne.0 .and. 
     &              delta_time .gt. 0) then
                  if(sigma_partial(cell_packed(j)).lt.0.) then
                     sigma=sigma_partial(cell_packed(j))
                     omega=omega_partial(cell_packed(j))
                  else
                     sigma=sigma_partial(cell_packed(j))/
     2                    sqrt(delta_time)
                     omega=omega_partial(cell_packed(j))*
     2                    sqrt(delta_time)
                  end if
                  par3v = 1.0
                  fm = 1
                  call time_delay(tflag,1,cell_packed(j),sigma,omega,
     2                 par3v,fm,rd_frac(itrc_diff(cell_packed(j))),
     3                 rseed,delta_time, conc_ret,time_diffused) 
                  time_current = time_current + 
     2                 time_diffused
               else
                  time_current = time_current + 
     2                 rfac(cell_packed(j))*delta_time
               end if
               time_original_previous = time_packed(j)
               delta_delay_time = (time_current - time_updated_previous)
     2              / 86400. 
               if (delta_delay_time .gt. 0.) then
                  adv_packed(j) = adv_packed(j) / delta_delay_time
                  adv_packed(j) = min(adv_packed(j), 1.d0)
               else
                  adv_packed(j) = 1.d0
               end if
               time_updated_previous = time_current
               time_packed(j) = time_current / 86400.
            end do
!           ENDFOR each segment of its travel path
            istart = iend + 1
         end do
!        ENDFOR each particle
      end if
!     ENDIF corrections are needed

      return
      end subroutine delayed_times
