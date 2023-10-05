program orbit

!*******************************************************************
!  Solve the dynamical eq. for orbits around the Sun - Euler method
!  This assume circular orbits with radius 1 A.U.
!*******************************************************************

real*8 :: msol,mu,mp, lsol,h,me,Ekin,Epot,m,Etot

! useful constants

 pi=3.14159265359
 msol = 1.989d33
 cmkpc = 3.084d21      !! 1 kpc !!
 cmau=1.495978707d13   !! 1 AU !!
 years=3.156d7
 mu=0.61
 boltz=1.38066e-16
 guniv=6.6720e-8
 mp=1.67265e-24

open(20,file='orbitell.dat')
! INITIAL CONDITIONS 

x=1.*cmau
y=0.
r=sqrt(x**2+y**2)
vx=0.
vy=0.5*sqrt(guniv*msol/r)
vel=sqrt(vx**2+vy**2)
m=1
period=2.*pi*r/vel
dt=0.002*period
time=0.
Ekin=0.5*m*vel**2
Epot=-guniv*msol*m/r
Etot=Ekin+Epot
write(20,1000)time/years,x/cmau,y/cmau,vx/1.e5,vy/1.e5,Ekin,Epot,Etot  !! write the I.C. !!

print*,'Initial vel (km/s) = ',vel/1.e5
print*,'Period (yr) = ',period/years, 2.*pi*r

ncicli=0
do while (time <= 2*period)

 ncilcli=ncicli+1

 time=time+dt
 r=sqrt(x**2+y**2)
 ax=-guniv*msol/r**2*x/r
 ay=-guniv*msol/r**2*y/r

 !!print*,ncicli,time/years,r/cmau,ax,ay

 vxold=vx    !!  for Euler method !!
 vyold=vy

 vx=vx+dt*ax
 vy=vy+dt*ay
 vel=sqrt(vx**2+vy**2)
 x=x+dt*vxold
 y=y+dt*vyold

 Ekin=0.5*m*vel**2
 Epot=-guniv*msol*m/r
 Etot=Ekin+Epot
 write(20,1000)time/years,x/cmau,y/cmau,vx/1.e5,vy/1.e5,Ekin,Epot,Etot
!! things to do: calculate Ekin and Epot and check conservation

enddo

close(20)
1000 format(8(1pe12.4))

stop
end
