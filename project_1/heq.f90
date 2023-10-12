!******************************************************************
!  this program solves the hydrostatic equilibrium equation
!  for an isothermal gas in a NFW halo
!*****************************************************************
program heq


parameter(jmax=5000)
implicit real*8 (a-h,o-z)
real*8, dimension(jmax) :: r(jmax),rr(jmax),vol(jmax),mnfw(jmax),&
        rhost(jmax),rho(jmax),mhern(jmax),rhonfw(jmax),mdark(jmax),& !rhost is currently not used
        grvnfw(jmax),lnd(jmax)
real*8 :: msol,mu,mp,rmin,rmax,mvir,rvir,mbgc,ahern

!  constants

msol = 1.989d33
cmkpc = 3.084e21
mu=0.62
boltz=1.38066e-16
guniv=6.6720e-8
mp=1.67265e-24

!    set the grid

rmin = 0.*cmkpc
rmax = 3000.*cmkpc
do j=1,jmax
   r(j)=rmin+(j-1)*rmax/(jmax-1)
enddo
do j=1,jmax-1
   rr(j)=r(j)+0.5*(r(j+1)-r(j))
enddo
rr(jmax)=rr(jmax-1)+(rr(jmax-1)-rr(jmax-2))
open(10,file='grid.dat',status='unknown')
do j=1,jmax
   write(10,*)real(r(j)/cmkpc),real(rr(j)/cmkpc)
enddo
close(10)

vol(1)=4.1888*r(1)**3
do j=2,jmax
   vol(j)=4.1888*(r(j)**3-r(j-1)**3)    !! centrato a rr(j-1) !!
enddo

!  parametri del problema

rho0nfw=7.35d-26
rs=435.7*cmkpc
rho0=2.882d-26 !this should be changed
ticm=8.9e7

rvir=2797.*cmkpc
fc=1.138799
mvir=1.3e15*msol
mbgc=1.d12*msol
ahern=10.*cmkpc/(1.+2.**(0.5))

do j=1,jmax
   x=rr(j)/rs
   rhonfw(j)=rho0nfw/(x*(1.+x)**2)
enddo

open(20,file='masse.dat')
mnfw(1)=0.
do j=2,jmax
   x=r(j)/rs
   mnfw(j)=mnfw(j-1)+rhonfw(j-1)*vol(j) !the mass is centered at rr(j-1)
   mdark(j)=mvir*(log(1.+x)-x/(1.+x))/fc                                     !Per ora devo vedere fino a qui
   mhern(j)=mbgc*r(j)**2/(r(j)+ahern)**2
   write(20,1001)r(j)/cmkpc,mnfw(j)/msol,mdark(j)/msol,mhern(j)/msol
enddo
1001 format(4(1pe12.4))
close(20)

open(20,file='grv.dat')
grvnfw(1)=0.          !! ok per alone NFW, isotermo o beta-model
do j=2,jmax
   grvnfw(j)=guniv*(mnfw(j)+mhern(j))/r(j)**2
   write(20,1002)r(j)/cmkpc,grvnfw(j)/msol
enddo
1002 format(2(1pe12.4))
close(20)

!     calculate the gas density, assuming ticm

lnd(1)=log(rho0)          !! mette il gas in eq. con il potenziale
do j=2,jmax
   gg=grvnfw(j)
   lnd(j)=lnd(j-1)-gg*(mu*mp)*(rr(j)-rr(j-1))/(boltz*ticm)
enddo

do j=1,jmax
   rho(j)=exp(lnd(j))
enddo

open(20,file='density.dat',status='unknown')
do j=1,jmax
   write(20,1000)rr(j)/cmkpc,rho(j),rhonfw(j)
enddo
close(20)
1000 format(3(1pe12.4))

stop
end
