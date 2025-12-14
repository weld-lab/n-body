program main
  use params
  use subrs
  use iso_fortran_env, only: real64
  implicit none

  !! V1 : Sequential code, basic stuff, energy, etc. Some opti like symmetri-
  !! zation. 
  !! V2 : OpenMP parallelisation
  !! V3 : Can we ignore race condition?

  integer :: i, j, t

  real(real64), dimension(3, Np) :: X, V, A
  real(real64), dimension(3) :: F
  real(real64) :: e_local
  real(real64), dimension(Nt) :: Ekin, Epot
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
  !$omp single
  print *, "Threads", omp_get_num_threads()
  !$omp end single
  !$omp end parallel

  Ekin = 0.0
  Epot = 0.0

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
    
  do t=1, Nt
     V = V + 0.5d0 * dt * A
     X = X + dt * V

     A = 0.0
     e_local = 0.0
     !$omp parallel private(i,j,F) shared(A) reduction(+:e_local)
     !$omp do schedule(static)
     do i=1, Np-1
        do j = i+1, Np
           F = compute_force(X(:,i), X(:,j))
           A(:,i) = A(:,i) + F/m
           A(:,j) = A(:,j) - F/m
           e_local = e_local  - compute_epot(X(:,i), X(:,j))
        end do
     end do
     !$omp end do
     !$omp end parallel

     V = V + 0.5d0 * dt * A
     Epot(t) = e_local
     
     e_local = 0.0
     !$omp parallel do reduction(+:e_local) schedule(static)
     do i = 1, Np
        e_local = e_local + 0.5d0 * m * dot_product(V(:,i), V(:,i))
     end do
     !$omp end parallel do
     Ekin(t) = e_local

     ! write
     if( mod(t, skip_frame) == 0 ) then
        print *, t, "/", Nt
        write(fdX) X
     end if
  end do

  close(fdX)

  print *, "Writing energies..."
  ! might do something better
  do t=1,Nt
     write(fdE, '(F12.6, 2F16.8)') t*dt, Ekin(t), Epot(t)
  end do
  close(fdE)
  
end program main
