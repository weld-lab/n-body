program main
  use params
  use subrs
  use iso_fortran_env, only: real64
  implicit none

  !! V1 : Sequential code, basic stuff, energy, etc. Some opti like symmetri-
  !! zation. 
  !! V2 : OpenMP parallelisation

  integer :: i, j, t

  real(real64), dimension(3, Np) :: X, V, A
  real(real64), dimension(3, Np) :: A_LOCAL
  real(real64), dimension(3) :: F
  real(real64) :: Ekin, Epot
  integer :: fdX, fdE, stat, omp_get_num_threads
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
  !$omp parallel
  print *, "#Threads", omp_get_num_threads()
  !$omp end parallel

  call init_sphere(X)
  write(fdX) X
  

  call init_rotation(X,V)
  


  A = 0.0d0
  init: do i=1, Np-1
     do j = i+1, Np
        F = compute_force(X(:,i), X(:,j))
        A(:,i) = A(:,i) + F/m
        A(:,j) = A(:,j) - F/m
     end do
  end do init
    
  do t=0, Nt
     V = V + 0.5d0 * dt * A
     X = X + dt * V

     A = 0.0
     
     !$omp parallel private(i,j,F, A_LOCAL)
     A_LOCAL = 0.0d0
     !$omp do schedule(static)
     do i=1, Np-1
        do j = i+1, Np
           F = compute_force(X(:,i), X(:,j))
           A_LOCAL(:,i) = A_LOCAL(:,i) + F/m
           A_LOCAL(:,j) = A_LOCAL(:,j) - F/m
        end do
     end do
     !$omp end do

     !$omp critical
     A = A + A_LOCAL
     !$omp end critical

     !$omp end parallel 

     V = V + 0.5d0 * dt * A

     

     ! write
     if( mod(t, skip_frame) == 0 ) then
        write(fdX) X

        ! compute energies
        Ekin = 0.
        do i=1,Np
           Ekin = Ekin + 0.5*m*dot_product(V(:,i), V(:,i))
        end do

        Epot = 0.
        do i=1,Np-1
           do j=i+1,Np
              Epot = Epot - compute_epot(X(:,i), X(:,j))
           end do
        end do
        
        write(fdE, '(F12.6, 2F16.8)') t*dt, Ekin, Epot
     end if
  end do

  close(fdX)
  close(fdE)
  
end program main
