!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!    program originally writted by Elena Redaelli, A.A. 2014/2015
!!!!    and slighlty modified by FB. This vanilla version calculates the standard shock tube
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

MODULE DATA
   integer :: N, i
   real*8 :: pi,cmpc,cmkpc,yr,kbol,mu,mp, msol
   !parameter(sdr=0)
   parameter(sdr=1)
   !parameter (N=101)
   parameter (N=501)
   !parameter (N=3001)
   parameter(pi=3.141592)
   parameter(cmpc=3.085d18)
   parameter(cmkpc=1000.*cmpc)
   parameter(yr=3.156d7)
   parameter(kbol=1.38d-16)
   parameter(mu=0.61)
   parameter(mp=1.67d-24)
   parameter(msol=1.99d33)
END MODULE DATA

PROGRAM SN
   USE DATA
   IMPLICIT NONE
   real*8 :: xa(N), xb(N), xmax, xmin, deltax, dxa(N), dxb(N) !xa step interi, xb seminteri
   real*8 :: d(N), e(N), v(N), P(N), s(N), Temp(N) !DENSITA', ENERGIAINTERNA, VELOCITA', PRESSIONE, MOMENTO, TEMPERATURA
   real*8 :: q(N) !VISCOSITA' ARTIFICIALE
   real*8 :: g2a(N), g2b(N), g31a(N), g31b(N), dvl1a(N), dvl1b(N)
   real*8 :: F1(N), F2(N), F3(N), M(N),  dstar(N),  e_dstar(N), vstar(N) , e_d(N)
   real*8 :: divV(N)
   real*8, dimension(:), allocatable :: Ecin, Eter,  Etot, lum_x
   real*8 :: dtmin, tmax, t, C2, gam, Cv, k, t1, t2, t3, tcontR, tcontT, LumX, cfl, rho0, T0, E0, inj_en, E_init
   real*8 :: SedLaw !Costante per la legge di Sedov
   real*8 :: times(10) = (/1,2,4,6,8,10,20,30,40,50/)
   character(len=2) :: times_string(10) = (/"01","02","04","06","08","10","20","30","40","50"/)
   integer :: labels(10) = (/20,21,22,23,24,25,26,27,28,29/)
   integer :: Num, Num2,stamp, cycling
   integer :: size_energies
   real*8 :: Temperature, dTemperature
   real*8, EXTERNAL :: Cool
   logical :: cooling

   write(*,*) 'To cool or not to cool, that is the question (True or False)'
   read(*,*)  cooling

   !CREAZIONE DOPPIA GRIGLIA (xa e xb)

   xmin=0.*cmpc
   xmax=70.*cmpc

   !GRIGLIA "a"
   do i=1,N
      xa(i)= xmin+(xmax-xmin)*(i-2)/(N-1.)
   end do

   deltax=xa(3)-xa(2)

   !GRIGLIA "b"
   do i=1, N-1
      xb(i)=0.5*(xa(i)+xa(i+1))
   end do
   xb(N)=xb(N-1)+(xb(N-1)-xb(N-2))   !! add the last calculated Delta_xb to xb(N-1)

   do i=2, N-1
      dxa(i)=xa(i+1)-xa(i)
      dxb(i)=xb(i)-xb(i-1)
   end do

   dxa(1)=xa(2)-xa(1)
   dxa(N)=dxa(N-1)
   dxb(1)=dxb(2)
   dxb(N)=xb(N)-xb(N-1)

   open(20,file='grid_sn.dat')
   do i=1,N
      write(20,1001)xa(i)/cmpc,xb(i)/cmpc,dxa(i)/cmpc,dxb(i)/cmpc
   enddo
   close(20)
1001 format(4(1pe12.4))

   !DEFINIZIONE FATTORI DI SCALA METRICI

   if (sdr==0) then  !! Cartesian !!

      do i=1, N
         g2a(i)=1.
         g2b(i)=1.
         g31a(i)=1.
         g31b(i)=1.

      end do
      do i=1, N-1
         dvl1a(i)=xa(i+1)-xa(i)   !! Note that is centered in xb(i)
      end do
      dvl1a(N)=dvl1a(N-1)
      do i=2, N
         dvl1b(i)=xb(i)-xb(i-1)  !! Note that it is centered in xa(i)
      end do
      dvl1b(1)=dvl1b(2)


   else    !! spherical !!
      do i=1, N
         g2a(i)=xa(i)
         g31a(i)=xa(i)
         g2b(i)=xb(i)
         g31b(i)=xb(i)
      end do

      ! vedi pag. 11 (slide superiore), i seguenti "volumi" servono per la divergenza

      do i=1, N-1
         dvl1a(i)=(xa(i+1)**3-xa(i)**3)/3.
      end do
      dvl1a(N)=dvl1a(N-1)
      do i=2, N
         dvl1b(i)=(xb(i)**3-xb(i-1)**3)/3.
      end do
      dvl1b(1)=dvl1b(2)

   end if


   !IMPLEMENTAZIONE CONDIZIONI INIZIALI

   gam=5./3.
   rho0 = 2.d-24
   T0 = 1.d4
   E0 = 1.d51
   cv=2.d8    !! warning: this is right for gam = 5/3 !!
   t=0.
   tmax= 5.2d5*yr

   !! Check for Sedov Law
   write(*,1357) (2*E0/rho0)**(1./5.)/(cmpc*yr**(-0.4))
1357 format('Amplitude (analytical Sedov law) = ' 1pe12.4 ' (time in yr, distance in pc)')

   c2=3 ! artificial viscosity coefficient
   cfl=0.01

   d = rho0
   Temp = T0
   e = cv*d*Temp
   v = 0.
   P = (gam - 1.)*e

   E_init = 0.
   do i = 2, N-1
      E_init = E_init + e(i)*(4./3.*pi*xa(i+1)**3 - 4./3. *pi*xa(i)**3)
   end do

   inj_en = E0/(4./3.*pi*xa(4)**3)
   e(2) = inj_en
   e(3) = inj_en

   P(2) = (gam-1.)*e(2)
   P(3) = (gam -1.)*e(3)

   Temp(2) = e(2)/(cv*d(2))
   Temp(3) = e(3)/(cv*d(3))

   !inj_en = E0/(4./3.*pi*xa(6)**3)
   !e(2) = inj_en
   !e(3) = inj_en
   !e(4) = inj_en
   !e(5) = inj_en
!
   !P(2) = (gam-1.)*e(2)
   !P(3) = (gam -1.)*e(3)
   !P(4) = (gam -1.)*e(4)
   !P(5) = (gam -1.)*e(5)
!
   !Temp(2) = e(2)/(cv*d(2))
   !Temp(3) = e(3)/(cv*d(3))
   !Temp(4) = e(3)/(cv*d(4))
   !Temp(5) = e(3)/(cv*d(5))


   call BCb(e)
   call BCb(P)
   call BCb(Temp)

   do i = 1, 10
      open(labels(i), file = trim("results_")//trim(times_string(i))//trim(".dat"))
   enddo

   open(42, file = 'Sedov.dat')

   Num = 1
   Num2 = 1
   size_energies = int(tmax/(1.d3*yr))

   allocate(Ecin(size_energies))
   allocate(Eter(size_energies))
   allocate(Etot(size_energies))

   Ecin = 0.
   Eter = 0.
   Etot = 0.

   allocate(lum_x(size_energies))

   lum_x = 0.

   Temperature = 1.d2
   dTemperature = 1.d4

   open(44, file = 'cooling.dat')

   do while (Temperature <= 1.d9)
      write(44,1111) Temperature, Cool(Temperature)
      Temperature = Temperature + dTemperature
   end do

1111 format(2(1pe12.4))
   close(44)

   open(43, file = 'energies.dat')
   open(45, file = 'luminosity_x.dat')
   open(46, file = 'luminosity_x_ad.dat')


   do while (t<tmax)      !!!! HERE STARTS THE TIME INTEGRATION !!!!!
      !!        if(ncicli.gt.20000) goto 1111

      !	do i=1, N        !! not needed for the shock tube test !!
      !		P(i)=(gam-1.)*e(i)
      !	end do

      !CALCOLO DTMIN

      dtmin=1.d30   !! any very large value !!

      p = (gam - 1.)*e
      Temp = e/(cv*d)

      do i=2, N-1
         dtmin=min(dtmin,(xb(i)-xb(i-1))/(abs(v(i))+sqrt(gam*p(i)/d(i))))
      end do

      cfl = min(0.5, 1.1*cfl)
      dtmin=cfl*dtmin
      t=t+dtmin

      !SOURCE STEP
      !SUBSTEP I: AGGIORNAMENTO DELLA VELOCITÀ PER GRADIENTE DI P

      do i=2, N-1
         v(i)=v(i)-dtmin*2.*(P(i)-P(i-1))/((d(i)+d(i-1))*dxb(i))
      end do
      CALL BCa(v)


      !CALCOLO Q
      do i=2, N-1
         if ((v(i+1)-v(i))<0.) then
            q(i)=C2*d(i)*(v(i+1)-v(i))**2
         else
            q(i)=0.
         end if
      end do
      CALL BCb(q)

      !SUBSTEP II: AGGIORNAMENTO PER VISCOSITÀ ARTIFICIALE

      do i=2, N-1
         v(i)=v(i)-dtmin*2.*(q(i)-q(i-1))/((d(i)+d(i-1))*dxb(i))
      end do
      CALL BCa(v)

      do i=2, N-1
         e(i)=e(i)-dtmin*q(i)*(v(i+1)-v(i))/dxa(i)
      end do
      CALL BCb(e)

      !SUBSTEP III: AGGIORNAMENTO PER RISCALDAMENTO DA COMPRESSIONE
      do i=2,N-1
         divV(i)=(g2a(i+1)*g31a(i+1)*v(i+1)-g2a(i)*g31a(i)*v(i))/dvl1a(i)
      end do
      CALL BCa(divV)

      do i=2, N-1
         e(i)=e(i)*(1.-0.5*dtmin*(gam-1.)*divV(i))/(1.+0.5*dtmin*(gam-1.)*divV(i))
      end do
      CALL BCb(e)

      !!  Here update T when needed (not needed for the shock tube)



      !!!!!!TRANSPORT STEP (use Upwind first order only)

      do i=2, N-1       !! here define the momentum density
         s(i)=0.5*(d(i)+d(i-1))*v(i)  !! this is at "i" !!
      end do

      CALL BCa(s)

      !AGGIORNAMENTO DENSITÀ

      do i=2, N-1       !! here select the value of the density at the interface "i"
         if (v(i)>0.) then
            dstar(i)=d(i-1)     !! at i !!
         else
            dstar(i)=d(i)
         end if
      end do
      dstar(N)=dstar(N-1)
      dstar(1)=dstar(3)

      do i=2, N
         F1(i)=dstar(i)*v(i)*g2a(i)*g31a(i)    !! at i !!
      end do

      !AGGIORNAMENTO ENERGIA

      do i=2, N-1
         M(i)=dstar(i)*v(i)
      end do
      CALL BCa(M)


      do i=2, N-1
         if (v(i)>0.) then
            e_dstar(i)=e(i-1)/d(i-1)   !! at i !!
         else
            e_dstar(i)=e(i)/d(i)
         end if
      end do
      e_dstar(N)=e_dstar(N-1)
      e_dstar(1)=e_dstar(3)

      !ORA AGGIORNO LA DENSITÀ
      do i=2, N-1
         d(i)=d(i)-dtmin*(F1(i+1)-F1(i))/dvl1a(i)
      end do
      CALL BCb(d)


      do i=2, N
         F2(i)=e_dstar(i)*M(i)*g2a(i)*g31a(i)
      end do
      CALL BCa(F2)

      do i=2, N-1
         e(i)=e(i)-dtmin*(F2(i+1)-F2(i))/dvl1a(i)
      end do

      CALL BCb(e)


      !AGGIORNAMENTO MOMENTO

      do i=2, N-1
         if ((v(i-1)+v(i))*0.5>0) then
            vstar(i)=v(i-1)       !! at i-1/2  !!
         else
            vstar(i)=v(i)
         end if
      end do

      CALL BCb (vstar)

      do i=1, N-1
         F3(i)=vstar(i+1)*0.5*(M(i)+M(i+1))*g2b(i)*g31b(i)   !! questo e' a i+1/2, occhio !!
      end do

      do i=2, N-1
         s(i)=s(i)-dtmin/dvl1b(i)*(F3(i)-F3(i-1))
      end do

      CALL BCa(s)

      do i=2, N-1
         v(i)=2.*s(i)/(d(i)+d(i-1))
      end do

      CALL BCa(v)

      !! AGGIORNIAMO L'ENERGIA A CAUSA DEL RADIATIVE COOLING !!

      if(cooling) then

         do i = 2, N-1
            e(i) = e(i) - dtmin*(d(i)/2.17d-24)**2 * Cool(Temp(i))
         end do

         CALL BCb(e)

         do i = 2, N - 1
            Temp(i) = max(1.d4, e(i)/(cv*d(i)))
         end do

         CALL BCb(Temp)

         e = cv*d*Temp

         CALL BCb(e)

         p = (gam - 1.)*e

         CALL BCb(p)

      end if

      !! Printing results at different times !!

      if (t >= times(Num)*1.d4*yr .and. Num < 11) then

         do i = 1, N - 1
            write(labels(Num), 1002) xa(i)/cmpc, xb(i)/cmpc, d(i)/rho0, Temp(i), P(i), v(i)
         end do

         close(labels(Num))

         Num = Num + 1

      end if

      !! Testing the Sedov law and energies !!

      if (t >= dble(Num2)*1.d3*yr) then
         write(42,1003) t/yr, xb(maxloc(d))/cmpc, (2*E0/rho0)**(1./5.) * t**(2./5.)/cmpc

         if(Num2 <= size_energies) then

            do i = 2, N - 1
               Eter(Num2) = Eter(Num2) + e(i)*(4./3.*pi*xa(i+1)**3 - 4./3. *pi*xa(i)**3)
               Ecin(Num2) = Ecin(Num2) + 0.5**3*d(i)*(v(i) + v(i+1))**2*(4./3.*pi*xa(i+1)**3 - 4./3. *pi*xa(i)**3)

               if(Temp(i) >= 1.d6 ) then
                  lum_x(Num2) = lum_x(Num2) + (d(i)/mp)**2 * Cool(Temp(i)) * (4./3.*pi*xa(i+1)**3 - 4./3. *pi*xa(i)**3)
               end if

            end do

            Etot(Num2) = Eter(Num2) + Ecin(Num2) - E_init

            write(43,1005) t/yr, (Eter(Num2) - E_init)/E0, Ecin(Num2)/E0, Etot(Num2)/E0

            if(cooling) then
               write(45,1234) t/yr, lum_x(Num2)
            else
               write(46,1234) t/yr, lum_x(Num2)
            end if
         end if

         Num2 = Num2 + 1

      end if

   enddo       !! here the "do while" ends !!

   close(43)
   close(45)
   close(46)

1002 format(6(1pe12.4))
1003 format(3(1pe12.4))
1005 format(4(1pe12.4))
1234 format(2(1pe12.4))

END PROGRAM SN


SUBROUTINE BCa(z1) !corrette BC per velocità e momento (riflessione)
   USE DATA
   IMPLICIT NONE
   real*8, dimension (N) :: z1

   if(sdr == 1) then
      z1(2)=0.
      z1(1)=-z1(3)
      z1(N)=z1(N-1)
   else if(sdr == 0) then
      z1(1)=z1(2)       !! ouflow !!
      z1(N)=z1(N-1)
   endif

END SUBROUTINE BCa

SUBROUTINE BCb(z2) ! BC di outflow tradizionali
   USE DATA
   IMPLICIT NONE
   real*8, dimension (N) :: z2
   z2(1)=z2(2)
   z2(N)=z2(N-1)
END SUBROUTINE BCb

Real*8 FUNCTION Cool(Temp1)
   USE DATA
   IMPLICIT NONE
   Real*8:: Temp1
   Real*8:: conv = 1.16d7
   Real*8:: Tkev
   Tkev = Temp1/conv
   if (Tkev > 0.02) then
      Cool=1.d-22*(8.6d-3*Tkev**(-1.7) + 0.058*Tkev**0.5 + 0.063)
   else if (Tkev <= 0.02 .AND. Tkev >= 0.0017235) then
      Cool = 6.72d-22*(Tkev/0.02)**0.6
   else
      Cool = 1.544d-22*(Tkev/0.0017235)**6
   end if

END FUNCTION Cool



