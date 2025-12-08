module subrs
  use iso_fortran_env, only: real64
  use params
  implicit none
contains
  subroutine init_sphere(X)
    real(real64), dimension(Np, 3), intent(inout) :: X

    integer :: i
    real(real64) :: dx, dy, dz, dr
    X = 0.0d0
    do i=1,Np

       do !rejection sampling
          call random_number(dx)
          call random_number(dy)
          call random_number(dz)

          dx = 2.0d0 * dx - 1.0d0
          dy = 2.0d0 * dy - 1.0d0
          dz = 2.0d0 * dz - 1.0d0
          
          dr = sqrt(dx*dx + dy*dy + dz*dz)
          if(dr <= 1.0 .and. dr > 0.0d0) exit
       end do

       ! might need a scaling to really put it uniformly
       ! plotting an histogram might be a good thing to do
       X(i, 1) = R * dx
       X(i, 2) = R * dy
       X(i, 3) = R * dz
    end do
  end subroutine init_sphere

  subroutine init_rotation(X, V)
    real(real64), dimension(Np, 3), intent(in) :: X
    real(real64), dimension(Np, 3), intent(inout) :: V
    integer :: i

    V = 0.0d0
    do i=1,Np
       V(i,1) = -Omega * X(i,2) ! - Omega y
       V(i,2) = Omega * X(i,1) ! Omega x
    end do
  end subroutine init_rotation

  function compute_force(Xi, Xj) result(F)
    real(real64), intent(in) :: Xi(:), Xj(:)
    real(real64), dimension(3) :: F

    real(real64) :: d
    real(real64), dimension(3) :: Xji
    Xji = Xj - Xi
    d  = sqrt(dot_product(Xji, Xji))

    F = (G * m*m / (d*d + epsilon*epsilon)**(3./2.)) * Xji
  end function compute_force
end module subrs
