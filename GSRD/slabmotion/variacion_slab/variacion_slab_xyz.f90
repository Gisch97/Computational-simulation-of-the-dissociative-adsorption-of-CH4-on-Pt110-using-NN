!! Programa utilizado para hacer un shift a configuraciones obtenidas de slabmotions que no convergen.
program sumoz
implicit none
integer :: i
real(8),allocatable :: x_ref(:), y_ref(:),z_ref(:)
real(8) :: x,y,z

open(10,file='systemdata.in', status='old')
!allocate(x_ref(20), y_ref(20),z_ref(20))
do i=1,68
   if (i<=47) then
      read(*,*)x,y,z
!
   if i>20 then
!   read(10,*)x_ref(:), y_ref(:),z_ref(:)
!   if (i==1) shift=z
!   if (i <= 12) then
!      write(*,*)x,y,z-shift,' F F F'
!   else
!      write(*,*)x,y,z-shift,' T T T'
   endif
enddo
close(10)
!write(20,*)'  4.7020649105944274        3.5451374627682810        20.8222483809770758      T T T'
!write(20,*)'  3.4384435610795014        2.2815601561981489        20.8222584542356444      T T T'
!write(20,*)'  4.7019475455655577        2.2815587204181540        22.0859325380777847      T T T'
!write(20,*)'  3.4381334594848862        3.5452746264160711        22.0857728987941755      T T T'
!write(20,*)'  4.0702570725264264        2.9132825770511208        21.4540823266182699      T T T'
!close(10)
!
!open(20,file='variacion_xyz.out', status='new')
!write(20,*)'nsnap x  y  z  delta_x  delta_y  delta_z'        
!open(11,file='slabmotion.in', status='old')

end program sumoz