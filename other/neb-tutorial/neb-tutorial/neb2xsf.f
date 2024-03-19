C    neb2xsf,  a quick script to reformat the NEB file 
C             with lattice/coordinates into a XCrysden xsf file.
C
C             Written by Tatsuhiko OHTO,  May 2009
C
      program neb2xsf
      implicit none 
      integer ii1,ii2,io1
      parameter (ii1=11,ii2=12,io1=14)
      integer ii,jj,iat,nat,ityp,nz,nneb,n
      character inpfil*60,outfil*60,syslab*30,suffix*6
      character inpfil2*60,outfil3*60
      character cdum, cdum2, cdum3
      double precision b2ang,cc_bohr(3,3),cc_ang(3,3),coord(3)
      double precision energy
      parameter (b2ang=0.529177)   !  Bohr to Angstroem
C
C     string manipulation functions in Fortran used below:
C     len_trim(string): returns the length of string 
C                       without trailing blank characters,

      write (6,701,advance="no")
  701 format(" Specify  SystemLabel (or 'siesta' if none): ")
      read (5,*) syslab
      write (6,702,advance="no")
  702 format(" Specify Number of Beads for NEB: ")
      read (5,*) nneb
      inpfil = syslab(1:len_trim(syslab))//'.XV'
      open (ii1,file=inpfil,form='formatted',status='old',err=801)
      write (6,*) 'Found and opened: ',inpfil
      inpfil2 = syslab(1:len_trim(syslab))//'.NEB'
      open (ii2,file=inpfil2,form='formatted',status='old',err=806)
      write (6,*) 'Found and opened: ',inpfil2
      outfil = syslab(1:len_trim(syslab))//'.AXSF'
      open (io1,file=outfil,form='formatted',status='new',err=802)
      write (6,*) 'Opened as new:    ',outfil
C --  read in translation vectors, convert into Ang:
      do ii=1,3
        read  (ii1,*,end=803,err=803)  (cc_bohr(jj,ii),jj=1,3)
      enddo
      cc_ang = cc_bohr*b2ang
      read  (ii1,*,end=804,err=804)  nat
      write (io1,*) '# crystal structure from ',
     .       syslab(1:len_trim(syslab))
      write (io1,'(a10, i3)') ' ANIMSTEPS', nneb+2
      write (io1,*) 'CRYSTAL'
      write (io1,*) '# Cell vectors in Angstroem:'
      write (io1,*) 'PRIMVEC'
      do ii=1,3
        write  (io1,'(3f12.7)')  (cc_ang(jj,ii),jj=1,3)
      enddo

      do n = 1, nneb+2
        read (ii2,*) cdum, cdum2, cdum3, energy
        write (io1,'(a10, i3)') ' PRIMCOORD', n
        write (io1,'(2i5)') nat,1
        do iat=1,nat
          read  (ii2,*,end=805,err=805) nz, (coord(ii),ii=1,3)
          write (io1,'(i4,3f20.8)') nz, (coord(ii),ii=1,3)
        enddo
      enddo

      close (ii1)
      close (ii2)
      close (io1)
      stop
  
  801 write (6,*) ' Error opening file ',
     .            inpfil(1:len_trim(inpfil)),' as old formatted'
      stop
  802 write (6,*) ' Error opening file ',
     .            outfil(1:len_trim(outfil)),' as new formatted'
      stop
  803 write (6,*) ' End/Error reading XV for cell vector ',ii
      stop
  804 write (6,*) ' End/Error reading XV for number of atoms line'
      stop
  805 write (6,*) ' End/Error reading XV for atom number ',iat
      stop
  806 write (6,*) ' Error opening file ',
     .            inpfil2(1:len_trim(inpfil2)),' as old formatted'
      stop
      end

