!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!    program originally writted by Elena Redaelli, A.A. 2014/2015
!!!!    and slighlty modified by FB. This vanilla version calculates the standard shock tube
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

MODULE DATA
integer :: N, i
real*8 :: pi,cmpc,cmkpc,yr,kbol,mu,mp, E0
parameter (N=501) 
parameter(pi=3.141592)
parameter(cmpc=3.085d18)
parameter(cmkpc=1000.*cmpc)
parameter(yr=3.156d7)
parameter(kbol=1.38d-16)
parameter(mu=0.61)
parameter(mp=1.67d-24)
parameter(E0=1.d51)
END MODULE DATA

PROGRAM ZEUS
USE DATA
IMPLICIT NONE
real*8 :: xa(N), xb(N), xmax, xmin, deltax, dxa(N), dxb(N)
real*8 :: d(N), e(N), v(N), P(N), s(N), Temp(N) !DENSITA', ENERGIAINTERNA, VELOCITA', PRESSIONE, MOMENTO
real*8 :: q(N) !VISCOSITA' ARTIFICIALE
real*8 :: g2a(N), g2b(N), g31a(N), g31b(N), dvl1a(N), dvl1b(N), maxpos(1)
real*8 :: F1(N), F2(N), F3(N), M(N),  dstar(N),  e_dstar(N), vstar(N) , e_d(N)
real*8 :: divV(N), Ecin, Eter, Etot, Lx
real*8 :: EIN, Rs, Rshock, ts, te
real*8 :: dtmin, tmax, t, C2, gam, Cv, k, t1, t2, t3, tcontR, tcontT, LumX, cfl, d0
real*8 :: SedLaw !Costante per la legge di Sedov
integer :: sdr, Num, stamp, ncicli, index, j, posmax
real*8, EXTERNAL :: Cool
character (len = *), parameter :: results="resultssn"
character (len = *), parameter :: dat=".dat"
character (len = 30) :: filename, ntime
character(len=8) :: fmt ! format descriptor

fmt = '(I2.2)' ! an integer of width 5 with zeros at the left

!CREAZIONE DOPPIA GRIGLIA (xa e xb)
Num=1.
xmin=0.
xmax=70*cmpc
!GRIGLIA "a"
do i=1,N
	xa(i)= xmin+(xmax-xmin)*(i-2.)/(N-1.)
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

open(20,file='gridsn.dat')
do i=1,N
   write(20,1001)xa(i)/cmpc,xb(i)/cmpc,dxa(i)/cmpc,dxb(i)/cmpc
enddo
close(20)
1001 format(4(1pe12.4))

!DEFINIZIONE FATTORI DI SCALA METRICI 
sdr=1   !! this parameter selects the type of coordinates: 0 = Cartesian



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


	
else if (sdr==1) then   !! spherical !!
	do i=1, N
	g2a(i)=xa(i)
	g31a(i)=xa(i)
	g2b(i)=xb(i)
	g31b(i)=xb(i)
	end do

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
 cv=1.99d8    !! warning: this is right for gam = 5/3 !!

 Etot=1
 tmax=1
 t=0.
 c2=3.
 cfl=0.01
d0=2.d-24
SedLaw=(2*E0/d0)**(1./5.)
d=d0
Temp=1.d4
v=0.
e=cv*d*Temp
p=(gam-1)*e
EIN=0
do i=2, N
 EIN=EIN+e(i)*(4./3.)*pi*(xa(i)**3 - xa(i-1)**3) 
end do

e(2)=E0/((4./3.)*pi*xa(4)**3)
e(3)=e(2)
Temp(2)=e(2)/(cv*d(2))
Temp(3)=Temp(2)
p(2)=(gam-1)*e(2)
p(3)=p(2)
CALL BCb(e)
CALL BCb(p)
CALL BCb(Temp)
index=10
ts=1.
te=1.
open(70, file='Sedov.dat')
open(80, file='Energy.dat')
open(90, file='Luminosity.dat')

do j=1, index
	if (j>2 .and. j<7) then
		tmax=tmax/yr/1.d4
		tmax=tmax+2
	else if (j==2) then
		tmax=tmax/yr/1.d4
		tmax=tmax+1
	else if (j>=7) then
		tmax=tmax/yr/1.d4
		tmax=tmax+10
	end if
tmax=tmax*yr*1.d4
        ncicli=0
		
	

do while (t<tmax)      !!!! HERE STARTS THE TIME INTEGRATION !!!!!
	Eter=0.
 Ecin=0.
 Etot=0.	
 Lx=0.
        ncicli=ncicli+1
!!        if(ncicli.gt.20000) goto 1111

!	do i=1, N        !! not needed for the shock tube test !!
!		P(i)=(gam-1.)*e(i)
!	end do

!CALCOLO DTMIN

        dtmin=1.d30   !! any very large value !!
        p=(gam-1.)*e
		Temp=e/(cv*d)
	do i=2, N-1
		 dtmin=min(dtmin,(xb(i)-xb(i-1))/(abs(v(i))+sqrt(gam*p(i)/d(i))))
	end do
        dtmin=cfl*dtmin
        t=t+dtmin
		cfl=min(0.5,1.1*cfl)
      !  print*,'ncicli, dtmin = ',ncicli, real(dtmin),real(t)


!SOURCE STEP
!SUBSTEP I: AGGIORNAMENTO DELLA VELOCITÀ PER GRADIENTE DI P

	do i=2, N-1
		v(i)=v(i)-dtmin*2.*(P(i)-P(i-1))/((d(i)+d(i-1))*dxb(i))	
	end do
	CALL BCa(v, sdr)


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
	CALL BCa(v, sdr)

	do i=2, N-1
		e(i)=e(i)-dtmin*q(i)*(v(i+1)-v(i))/dxa(i)
	end do
	CALL BCb(e)

!SUBSTEP III: AGGIORNAMENTO PER RISCALDAMENTO DA COMPRESSIONE
	do i=2,N-1
		divV(i)=(g2a(i+1)*g31a(i+1)*v(i+1)-g2a(i)*g31a(i)*v(i))/dvl1a(i)
	end do
	CALL BCa(divV, sdr)

	do i=2, N-1
		e(i)=e(i)*(1.-0.5*dtmin*(gam-1.)*divV(i))/(1.+0.5*dtmin*(gam-1.)*divV(i))
	end do
	CALL BCb(e)

!!  Here update T when needed (not needed for the shock tube)



!!!!!!TRANSPORT STEP (use Upwind first order only)

	do i=2, N-1       !! here define the momentum density
		s(i)=0.5*(d(i)+d(i-1))*v(i)  !! this is at "i" !!
	end do	

	CALL BCa(s, sdr)

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
	CALL BCa(M, sdr)
	
	
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
	CALL BCa(F2, sdr)

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

	CALL BCa(s, sdr)

	do i=2, N-1
		v(i)=2.*s(i)/(d(i)+d(i-1))
	end do

	CALL BCa(v, sdr)
	
!Check energy conservation
	do i=2, N
		Eter=(Eter+e(i)*(4./3.)*pi*(xa(i)**3 - xa(i-1)**3) )
		Ecin=(Ecin+0.5*0.5*0.5*(4./3.)*pi*(xa(i)**3 - xa(i-1)**3) *d(i)*(v(i)+v(i-1))**2)
		
		if (Temp(i)>1d6) then
			Lx=Lx+(d(i)/d0)**2*Cool(Temp(i))*(4./3.)*pi*(xa(i)**3 - xa(i-1)**3) 
			else 
			Lx=Lx
			end if
	end do
	Eter=Eter-EIN
	Etot=Ecin+Eter
	if (t>Num*yr .and. t<=1.d3*yr) then
		write(90, 2003) t/yr, Lx
		Num=Num+100
		end if
		if (t>te*1.d3*yr) then
		
		  write(80, 2002) t/yr, Etot/E0, Eter/E0, Ecin/E0
			write(90, 2003) t/yr, Lx
		
		te=te+1
		end if
!Sedov law	

	if (t>ts*1.d3*yr) then
		maxpos=maxloc(d)
		posmax=maxpos(1)
		Rs=xb(posmax)
		ts=ts+1.
	else
		Rs=0
	end if
	Rshock=SedLaw*t**(2./5.)
	write(70, 2001)t/yr, Rshock/cmpc, Rs/cmpc
	
	
enddo   !! here the "do while" ends !!
  
if (sdr==0) then
open(20,file='results.dat')

do i=1,N  !! write the results in the file "results.dat"
	write (20,1000) xa(i),xb(i),d(i),v(i),e(i)/d(i),p(i), s(i)
	
end do

1000 format(7(1pe12.4))

close(20)
end if
write (ntime,fmt) j
filename=results//trim(ntime)//dat
filename=trim(filename)
if (sdr==1) then
	open(30,file=filename)
	
	do i=1,N  !! write the results in the file "results.dat"
		write (30,2000) xa(i)/cmpc,xb(i)/cmpc,d(i),v(i),e(i)/d(i),p(i),Temp(i)
	end do
	2000 format(7(1pe12.4))
	
	close(30)
	end if


enddo
2001 format(3(1pe12.4))
close(70)  
2002 format(4(1pe12.4))
close(80) 
2003 format(2(1pe12.4))
close(90)   
END PROGRAM ZEUS


SUBROUTINE BCa(z1, coord) !corrette BC per velocità e momento (riflessione)
USE DATA
IMPLICIT NONE
real*8, dimension (N) :: z1
integer :: coord
if (coord==0) then
	z1(1)=z1(2)       !! ouflow !!
z1(N)=z1(N-1)
end if
if (coord == 1) then
z1(2)=0.
z1(1)=-z1(3)
z1(N)=z1(N-1)     
z1(N)=-z1(N-2)
z1(N-1)=0
end if
coord=coord
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
		if (Temp1>0.02*1.16d7) then
			Cool=1.d-22*(8.6*1.d-3*(Temp1/1.16d7)**(-1.7)+0.058*(Temp1/1.16d7)**0.5+0.063)
		else if (Temp1<=0.02*1.16d7 .AND. Temp1>=0.0017235*1.16d7) then
			Cool=6.72*1.d-22*(Temp1/1.16d7/0.02)**0.6			
		else if (Temp1<0.0017235*1.16d7) then
			Cool=1.544*1.d-22*(Temp1/0.0017235/1.16d7)**6
		end if

END FUNCTION Cool


