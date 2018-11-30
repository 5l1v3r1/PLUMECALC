      subroutine initdata2( in_number,
     2     out_number,
     3     npoints,
     4     narrays,
     6     itype,
     7     default,
     8     readflag,
     9     macro,
     t     igroup,
     1     ireturn, r8_1, r8_2, r8_3, r8_4, r8_5,i4_1, 
     2     i4_2, i4_3, i4_4, i4_5 )
!***********************************************************************
! $Id: initdata2.f,v 1.2 2006/09/20 19:51:24 zvd Exp $
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
!  
!   PURPOSE
!  
!   To read in an arbitrary number of lines of data and set parameter
!   values at given nodes.
!
!   Developed originally for FEHM.
!  
!***********************************************************************
CD3
CD3 INTERFACES
CD3
CD3 Formal Calling Parameters
CD3
CD3 Identifier        Type     Use  Description
CD3 
CD3 in_number         int       I   Tape number of input file
CD3 out_number        int       I   Tape number for writing error
CD3                                     checking information
CD3 npoints           int       I   Number of nodes at which values
CD3                                    are set
CD3 narrays           int       I   Number of values to read (i.e.
CD3                                    number of arrays being
CD3                                    initialized)
CD3 itype             int       I   Flag denoting whether array is
CD3                                     integer or real*8
CD3 default           int       I   Default value to set for all
CD3                                     positions in array
CD3 readflag          logical   I   Flag denoting if data
CD3                                     initialization is being
CD3                                     performed
CD3 macro             char      I   Macro being read
CD3 igroup            int       I   Group number within macro
CD3 ireturn           int       O   Return flag
CD3
CD3 Interface Tables
CD3
CD3 None
CD3
CD3 Files
CD3 
CD3 Identifier    Use  Description
CD3
CD3 in_number      I   Main input file containing the data
CD3
C**********************************************************************
CD4
CD4 GLOBAL OBJECTS
CD4
CD4 Global Constants
CD4
CD4 Identifier  Type     Description
CD4 
CD4
CD4 Global Types
CD4
CD4 NONE
CD4
CD4 Global Variables
CD4 
CD4 
CD4                      COMMON
CD4 Identifier   Type    Block   Description
CD4 
CD4 
CD4 
CD4 Global Subprograms
CD4 
CD4 Identifier   Type   Description
CD4 
CD4 welbor       N/A    Compute wellbore solution
CD4
C**********************************************************************
CD5
CD5 LOCAL IDENTIFIERS
CD5
CD5 Local Constants
CD5
CD5 Identifier   Type        Description
CD5
CD5
CD5 Local Types
CD5
CD5 None
CD5
CD5 Local Variables
CD5
CD5 Identifier   Type        Description
CD5 
CD5 
CD5 
CD5 Local Subprograms
CD5 
CD5 None
CD5 
C**********************************************************************
CPS
CPS PSEUDOCODE
CPS
CPS BEGIN initdata
CPS 
CPS allocate storage in temporary arrays
CPS initialize values in arrays to 0
CPS 
CPS FOR each array
CPS 
CPS   IF this array is a real*8
CPS     Set pointer for real*8 array
CPS     
CPS     IF initialization is to be performed
CPS       FOR each node
CPS           Set parameter values to their default values
CPS       ENDFOR
CPS     ENDIF
CPS   
CPS   ELSEIF this array is an integer
CPS     Set pointer for integer array
CPS     
CPS     IF initialization is to be performed
CPS       FOR each node
CPS         Set parameter values to their default values
CPS       ENDFOR
CPS     ENDIF
CPS   
CPS   ELSE there is an error
CPS     Set error flag to indicate unsuccessful read
CPS     ERROREXIT
CPS   ENDIF
CPS   
CPS ENDFOR each array
CPS   
CPS Initialize count of number of lines to 0
CPS 
CPS LOOP to read in a group of data
CPS     
CPS   null1 - determine if there is more data to read
CPS       
CPS EXITIF there was no data to read
CPS     
CPS   Read next line of data
CPS   
CPS   EXITIF the first loop index is 0 (no more data, old input format)
CPS   
CPS   EXITIF there is a read error after setting error flag
CPS   
CPS   Add one to the running total of the number of lines read
CPS   
CPS   IF input is by zone
CPS     FOR each node
CPS       IF this node is in this zone
CPS         Set flag to indicate parameter value has been...
CPS         ... explicitly set
CPS         FOR each array
CPS 
CPS           IF this array is a real*8
CPS           
CPS             Set pointer for real*8 array
CPS             Set parameter value
CPS           
CPS           ELSE this array is an integer
CPS             Set pointer for integer array
CPS           
CPS             Set pointer for integer array
CPS             Set parameter value
CPS           
CPS           ENDIF
CPS   
CPS         ENDFOR
CPS         
CPS       ENDIF
CPS     ENDFOR
CPS   ELSE input is by node
CPS   
CPS     IF the values are to be set at every node
CPS       Reset do loop indexes
CPS     ENDIF
CPS     
CPS     FOR each specified node
CPS     
CPS       IF this node number is within the range of possible node...
CPS       ... numbers
CPS         Set flag to indicate parameter value has been...
CPS         ... explicitly set
CPS         FOR each array
CPS 
CPS           IF this array is a real*8
CPS             Set pointer for real*8 array
CPS             Set parameter value
CPS             Set flag to indicate parameter value has been...
CPS             ... explicitly set 
CPS           ELSE this array is an integer
CPS             Set pointer for real*8 array
CPS             Set parameter value
CPS             Set flag to indicate parameter value has been...
CPS             ... explicitly set 
CPS           ENDIF
CPS         
CPS         ENDFOR
CPS         
CPS       ENDIF
CPS         
CPS     ENDFOR
CPS   ENDIF
CPS   
CPS ENDLOOP
CPS 
CPS Initialize node counters
CPS 
CPS FOR each node
CPS   IF the value was not explicitly set at this node
CPS     Store node number
CPS     Increase counter by 1
CPS   ELSE the value was explicitly set
CPS     Store node number
CPS     Increase counter by 1
CPS   ENDIF
CPS ENDFOR
CPS 
CPS IF all values were explicitly set
CPS   Write message
CPS ELSEIF no values were explicitly set
CPS   Write message
CPS ELSEIF more values were set than not set
CPS   Write node numbers at which values were not explicitly set
CPS ELSE more values were not set than set
CPS   Write node numbers at which values were explicitly set
CPS ENDIF
CPS   
CPS ERRORSEGMENT
CPS   deallocate space in temporary arrays
CPS   IF there was an error in specifying the data types or reading data
CPS      Write error message to error output
CPS      IF tty output is being used
CPS         Write error message to tty
CPS      END IF
CPS      IF the error was in specifying data type
CPS         Write error message to error output
CPS         IF tty output is being used
CPS            Write error message to tty
CPS         END IF
CPS      ELSE IF there was a read error
CPS         Write error message to error output
CPS         IF tty output is being used
CPS            Write error message to tty
CPS         END IF
CPS      END IF
CPS      terminate program
CPS   ENDIF
CPS ENDSEGMENT
CPS 
CPS END initdata
CPS 
C**********************************************************************

      use comunits, only : error_unit_number
      use comgrid, only : izonef
      implicit none

      logical null1,readflag
      integer inode,max_arrays, ierr, iptty
      parameter(max_arrays = 10 )
      integer in_number,out_number,npoints,narrays,ireturn
      integer itype(*),iarray,ipoint,inumber,ja,jb,jc,icode,nfound
      integer nnotfound,igroup
      real*8 default(max_arrays),values(max_arrays)
      integer n_realcount, n_intcount
      character*80 strtot
      character*4 macro
      integer, allocatable :: ifind(:)
      integer, allocatable :: isset(:)
      integer, allocatable :: notset(:)
      real*8, optional :: r8_1(:)
      real*8, optional :: r8_2(:)
      real*8, optional :: r8_3(:)
      real*8, optional :: r8_4(:)
      real*8, optional :: r8_5(:)
      integer, optional :: i4_1(:)
      integer, optional :: i4_2(:)
      integer, optional :: i4_3(:)
      integer, optional :: i4_4(:)
      integer, optional :: i4_5(:)

      allocate(ifind(npoints),isset(npoints),notset(npoints))
      ierr = error_unit_number
      iptty = 6
      ifind=0
      isset=0
      notset=0
      
c     initialize integer and real counters

      n_realcount = 0
      n_intcount = 0

c     Set values to default values for all positions in each array

      do iarray = 1, narrays
         if( itype(iarray) .eq. 8 ) then
            n_realcount = n_realcount + 1
            if( .not. readflag ) then
               if(n_realcount.eq.1) then
                  r8_1(1:npoints) = default(iarray)
               elseif(n_realcount.eq.2) then
                  r8_2(1:npoints) = default(iarray)
               elseif(n_realcount.eq.3) then
                  r8_3(1:npoints) = default(iarray)
               elseif(n_realcount.eq.4) then
                  r8_4(1:npoints) = default(iarray)
               elseif(n_realcount.eq.5) then
                  r8_5(1:npoints) = default(iarray)
               else
                  write(out_number, 100) 'real'
                  write(out_number, 110)
                  stop
               end if
            end if
         elseif( itype(iarray) .eq. 4 ) then
            n_intcount = n_intcount + 1
            if( .not. readflag ) then
               if(n_intcount.eq.1) then
                  i4_1(1:npoints) = nint(default(iarray))
               elseif(n_intcount.eq.2) then
                  i4_2(1:npoints) = nint(default(iarray))
               elseif(n_intcount.eq.3) then
                  i4_3(1:npoints) = nint(default(iarray))
               elseif(n_intcount.eq.4) then
                  i4_4(1:npoints) = nint(default(iarray))
               elseif(n_intcount.eq.5) then
                  i4_5(1:npoints) = nint(default(iarray))
               else
                  write(out_number, 100) 'integer'
                  write(out_number, 110)
                  stop
               end if
            end if
         else
            ireturn = -1
            goto 9000
         end if
      end do
 100  format ('Fatal error, too many ', a7, ' inputs to initdata2')
 110  format ('STOPPING execution')
      ireturn = 0

c     Loop over all lines of data to read
 1000 continue
         read(in_number, '(a80)') strtot
         if( null1(strtot) .eqv. .TRUE. ) goto 2000
         backspace in_number
         read(in_number, *, ERR = 3000) ja, jb, jc, 
     2        (values(iarray), iarray = 1, narrays )
         if (ja .eq. 0) goto 2000
         goto 4000
 3000    continue
         inumber = ireturn + 1
         ireturn = -2
         goto 9000
 4000    continue
         ireturn = ireturn + 1
c     Input by zones is first, or else input is by node
         if( ja .lt. 0 ) then
            do inode = 1, npoints
               if( izonef(inode) .eq. abs(ja) ) then
                  ifind(inode) = 1
                  n_realcount = 0
                  n_intcount = 0
                  do iarray = 1, narrays
                     if( itype(iarray) .eq. 8 ) then
                        n_realcount = n_realcount + 1
                        if(n_realcount.eq.1) then
                           r8_1(inode) = values(iarray)
                        elseif(n_realcount.eq.2) then
                           r8_2(inode) = values(iarray)
                        elseif(n_realcount.eq.3) then
                           r8_3(inode) = values(iarray)
                        elseif(n_realcount.eq.4) then
                           r8_4(inode) = values(iarray)
                        elseif(n_realcount.eq.5) then
                           r8_5(inode) = values(iarray)
                        end if
                     else
                        n_intcount = n_intcount + 1
                        if(n_intcount.eq.1) then
                           i4_1(inode) = nint(values(iarray))
                        elseif(n_intcount.eq.2) then
                           i4_2(inode) = nint(values(iarray))
                        elseif(n_intcount.eq.3) then
                           i4_3(inode) = nint(values(iarray))
                        elseif(n_intcount.eq.4) then
                           i4_4(inode) = nint(values(iarray))
                        elseif(n_intcount.eq.5) then
                           i4_5(inode) = nint(values(iarray))
                        end if
                     end if
                  end do
               end if
            end do
         else
            if( ja .eq. 1 .and. jb .eq. 0 .and. jc .eq. 0 ) then
               ja = 1
               jb = npoints
               jc = 1
            end if
            if( jb .gt. npoints ) jb = npoints
            ifind(ja:jb:jc) = 1

            n_realcount = 0
            n_intcount = 0
            
            do iarray = 1, narrays
               if( itype(iarray) .eq. 8 ) then
                  n_realcount = n_realcount + 1
                  if(n_realcount.eq.1) then
                     r8_1(ja:jb:jc) = values(iarray)
                  elseif(n_realcount.eq.2) then
                     r8_2(ja:jb:jc) = values(iarray)
                  elseif(n_realcount.eq.3) then
                     r8_3(ja:jb:jc) = values(iarray)
                  elseif(n_realcount.eq.4) then
                     r8_4(ja:jb:jc) = values(iarray)
                  elseif(n_realcount.eq.5) then
                     r8_5(ja:jb:jc) = values(iarray)
                  end if
               else
                  n_intcount = n_intcount + 1
                  if(n_intcount.eq.1) then
                     i4_1(ja:jb:jc) = nint(values(iarray))
                  elseif(n_intcount.eq.2) then
                     i4_2(ja:jb:jc) = nint(values(iarray))
                  elseif(n_intcount.eq.3) then
                     i4_3(ja:jb:jc) = nint(values(iarray))
                  elseif(n_intcount.eq.4) then
                     i4_4(ja:jb:jc) = nint(values(iarray))
                  elseif(n_intcount.eq.5) then
                     i4_5(ja:jb:jc) = nint(values(iarray))
                  end if
               end if
            end do
         end if
         goto 1000
 2000 continue

c     Error checking for irregular input (missing nodes, etc.)
! Skip over this for now
      goto 9000
      nfound = 0
      nnotfound = 0
      do inode = 1, npoints
         if( ifind(inode) .eq. 0 ) then
            nnotfound = nnotfound + 1
            notset(nnotfound) = inode
         else
            nfound = nfound + 1
            isset(nfound) = inode
         end if
      end do
      write(out_number,*)
      write(out_number,*) 'Macro: ', macro, '  Group:', igroup
      if( nfound .eq. npoints) then
         write(out_number,*) 'Values were explicitly set for each node'
         write(out_number,*)
      elseif(nnotfound .eq. npoints) then
         write(out_number,*) 'Values were set to defaults for each node'
         write(out_number,*) 'or were set in a previous invokation of th
     2is macro'
         write(out_number,*)
      elseif(nfound .ge. nnotfound) then
         write(out_number,*) 'Data not explicitly set for the following 
     2nodes:'
         write(out_number,9004) (notset(inode), inode = 1, nnotfound)
         write(out_number,*) 'Default values used for these nodes'
         write(out_number,*) 
         write(out_number,*) 'or were set in a previous invokation of th
     2is macro'
      else
         write(out_number,*) 'Data explicitly set only for the following
     2 nodes:'
         write(out_number,9004) (isset(inode), inode = 1, nfound)
         write(out_number,*) 'The remainder are set to the default value
     2'
         write(out_number,*) 'or were set in a previous invokation of th
     2is macro'
         write(out_number,*)
      end if

 9000 continue
      deallocate(ifind,isset,notset)
      if(ireturn .eq. -1 .or. ireturn .eq. -2) then
         write (ierr, 9001) iarray, macro, igroup
         if (iptty .ne. 0) write (iptty, 9001) iarray, macro, igroup
         if (ireturn .eq. -1) then
            write (ierr, 9002)
            if (iptty .ne. 0) write (iptty, 9002)
         else if ( ireturn .eq. -2 ) then
            write (ierr, 9003) inumber
            if (iptty .ne. 0) write (iptty, 9003) inumber
         end if
         stop
      end if
 9001 format (/, 'Fatal error - for array number ', i8,
     .     /, 'macro - ', a4, /, 'Group number - ', i8)
 9002 format ('Something other than a real or integer has been',
     .     ' specified')
 9003 format ('Line number - ', i8, /, 'Bad input, check this line')
 9004 format (1x,10i8) 
      end
