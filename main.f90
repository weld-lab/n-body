program main
  use params
  use subrs
  use iso_fortran_env, only: real64
  implicit none

  integer :: i, j, t

  real(real64), dimension(Np, 3) :: X, V, A
  real(real64), dimension(3) :: F, dx
  real(real64) :: Ekin, Epot, rij
  integer :: fdX, fdE, stat
  character(len=512) :: msg


  open(newunit=fdX, file="x.dat", status="replace", access="stream", form="unformatted", iostat=stat, iomsg=msg)
  if(stat /= 0) then
     print *, "Error while opening file ", trim(msg)
     stop 1
  end if


  open(newunit=fdE, file="e.dat", status="replace", iostat=stat, iomsg=msg)
  if(stat /= 0) then
     print *, "Error while opening file: ", trim(msg)
     stop 1
  end if

  print *, "Np ", Np
  print *, "Nt ", Nt
  print *, "R", R
  print *, "epsilon", epsilon
  print *, "Omega", Omega

  call init_sphere(X)
  write(fdX) X
  

  call init_rotation(X,V)
  


  A = 0.0d0
  init: do i=1, Np-1
     do j = i+1, Np
        F = compute_force(X(i,:), X(j,:))
        A(i,:) = A(i,:) + F/m
        A(j,:) = A(j,:) - F/m
     end do
  end do init
    

  do t=0, Nt
     V = V + 0.5d0 * dt * A
     X = X + dt * V

     A = 0.0d0
     do i=1, Np-1
        do j = i+1, Np
           F = compute_force(X(i,:), X(j,:))
           A(i,:) = A(i,:) + F/m
           A(j,:) = A(j,:) - F/m
        end do
     end do

     V = V + 0.5d0 * dt * A

     ! compute energies
     Ekin = 0.
     do i=1,Np
        Ekin = Ekin + 0.5*m*dot_product(V(i,:), V(i,:))
     end do

     Epot = 0.
     do i=1,Np-1
        do j=i+1,Np
           dx = X(j,:) - X(i,:)
           rij = sqrt(dot_product(dx,dx) + epsilon*epsilon)
           Epot = Epot - G*m*m / rij
        end do
     end do

     

     ! write
     if( mod(t, skip_frame) == 0 ) then
        write(fdX) X
        write(fdE, '(F12.6, 2F16.8)') t*dt, Ekin, Epot
     end if
  end do

  close(fdX)
  
end program main
