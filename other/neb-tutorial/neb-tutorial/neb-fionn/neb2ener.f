      program neb2ener

      implicit none

      integer         na, nneb
      integer         maxna, maxneb
      parameter       (maxna=1000)
      parameter       (maxneb=100)
      double precision  xaneb(3,maxna,maxneb), faneb(3,maxna,maxneb)
      double precision  fineb(maxneb), dist(maxneb)
      double precision  Eneb(maxneb), Ang, eV, disttmp


      character*20 :: fname
      character :: cdum, cdum2
      integer   nauxr, i, idum, n, ia, ix

      Ang    = 1.d0 / 0.529177d0
      eV     = 1.d0 / 13.60580d0

      write(*,*) "Input the file name"
      read(*,*) fname
      write(*,*) "Input the number of beads"
      read(*,*) nneb
      write(*,*) "Input the number of atoms"
      read(*,*) na

      open( 11, file=trim(adjustl(fname)))
      do n = 1,nneb+2
      read(11,*) cdum, idum, cdum, Eneb(n)
      read(11,*) (idum, (xaneb(ix,ia,n),ix=1,3),
     .              (faneb(ix,ia,n),ix=1,3), ia=1,na)
      enddo
      close(11)
      do n = 1, nneb+2
        Eneb(n) = Eneb(n) * eV
        do ia = 1, na
          do ix = 1, 3
            xaneb(ix,ia,n) = xaneb(ix,ia,n) * Ang
            faneb(ix,ia,n) = faneb(ix,ia,n) *eV/Ang
          enddo
        enddo
      enddo

      dist(:) = 0.d0
      do n = 2, nneb+2
        disttmp = 0.d0
        do ia = 1, na
          do ix = 1, 3
            disttmp = disttmp + (xaneb(ix,ia,n)-xaneb(ix,ia,n-1)) *
     .                          (xaneb(ix,ia,n)-xaneb(ix,ia,n-1))
          enddo
        enddo
        disttmp = dsqrt(disttmp)
        dist(n) = dist(n-1) + disttmp
      enddo

      call exforce(na, nneb, xaneb(1:3,1:na,:nneb+2),
     .             faneb(1:3,1:na,:nneb+2), fineb(:nneb+2))

      open(12,file="potential")
      write(12,'(3a14)') "#Distance(Ang)"," E_KS(eV)"," Potential(eV)"
      do n = 1, nneb+2
        write(12,'(3f14.6)') dist(n)/Ang, (Eneb(n)-Eneb(1))/eV, 
     .                       fineb(n)/eV
      enddo
      close(12)

      stop
      end

      subroutine exforce(na, nneb, xaneb, faneb, fineb)

      implicit none

      integer         na, nneb, ix, ina, ineb, npart, nmid, ind, i, n
      parameter       (nmid=10000)
      parameter       (npart=50)
      double precision  xaneb(3,na,nneb+2), faneb(3,na,nneb+2)
      double precision  fineb(nneb+2), fmid(3,nmid), xmid(3,nmid)
      double precision  emid(3,nmid), fsam1(3), fsam2(3)
      double precision  dist, fdist, sumdist, val, eV, Ang

      Ang    = 1.d0 / 0.529177d0
      eV     = 1.d0 / 13.60580d0

      fmid(:,:) = 0.d0
      xmid(:,:) = 0.d0
      emid(:,:) = 0.d0
      fineb(:) = 0.d0
      ind = 1

      do ineb = 1, nneb+1
        do ix = 1, 3
          sumdist = 0.d0
          do ina = 1, na
C measure the distance
            dist=xaneb(ix,ina,ineb+1)-xaneb(ix,ina,ineb)
            fdist = faneb(ix,ina,ineb+1) - faneb(ix,ina,ineb)
            sumdist = sumdist + dist * dist

C interpolate the force
            do i=ind+1, ind+npart
              fmid(ix,i) = faneb(ix,ina,ineb) + fdist*(i-ind)/npart
            enddo

C Integrate forces
            do i = 1, npart
              call simpson(val,fmid(ix,ind:ind+i),
     .              (dist/npart), i+1)
              emid(ix,i+ind) = emid(ix,i+ind) - val
            enddo

          enddo
          sumdist = dsqrt(sumdist)
          do i=ind+1, ind+npart
            xmid(ix,i) = xmid(ix,ind) + sumdist*(i-ind)/npart
            emid(ix,i) = emid(ix,ind) + emid(ix,i)
          enddo
        enddo
        ind = ind + npart
        fineb(ineb+1) = emid(1,ind)+emid(2,ind)+emid(3,ind)
      enddo

C Option: pringting results
      open(13, file="landscape")
      do i=1,ind
        write(13,'(5f12.6)') dsqrt(xmid(1,i)*xmid(1,i) + 
     .                            xmid(2,i)*xmid(2,i) +
     .                            xmid(3,i)*xmid(3,i) )/Ang ,
     .                (emid(1,i)+emid(2,i)+emid(3,i))/eV,
     .    emid(1,i)/eV, emid(2,i)/eV, emid(3,i)/eV
      enddo
      close(13)

      end subroutine

      subroutine simpson(vint,v,delta,ngrid)
c
c---- Alternative extended Simpson formula of numerical integral----
c (real data array) 
c

c
c vint : output=integral value 
c v    : input, output=data array of integrated function on grid points
c delta: input, output=grid space
c ngrid: input, output=# of grid points 
c

      implicit real*8 (a,b,d-h,o-z)
      implicit complex*16 (c)

      dimension v(ngrid)

      if (ngrid.lt.9) then
        vint=0.0d0
        do i=1, ngrid
          vint=vint+v(i)
        end do
C
        vint=vint*delta
        return
      end if

      aconst1=17.0d0/48.0d0
      aconst2=59.0d0/48.0d0
      aconst3=43.0d0/48.0d0
      aconst4=49.0d0/48.0d0

      vint=0.0d0
      do i=5,ngrid-4
        vint=vint+v(i)
      end do

      vint=vint+aconst1*v(1)
      vint=vint+aconst2*v(2)
      vint=vint+aconst3*v(3)
      vint=vint+aconst4*v(4)

      vint=vint+aconst4*v(ngrid-3)
      vint=vint+aconst3*v(ngrid-2)
      vint=vint+aconst2*v(ngrid-1)
      vint=vint+aconst1*v(ngrid)

      vint=vint*delta

      end  subroutine simpson 

