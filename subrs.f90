module subrs
  use iso_fortran_env, only: real64
  use params
  implicit none
contains
  subroutine init_sphere(X)
    real(real64), dimension(3,Np), intent(inout) :: X

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
       X(1,i) = R * dx
       X(2,i) = R * dy
       X(3,i) = R * dz
    end do
  end subroutine init_sphere

  subroutine init_rotation(X, V)
    real(real64), dimension(3, Np), intent(in) :: X
    real(real64), dimension(3, Np), intent(inout) :: V
    integer :: i

    V = 0.0d0
    do i=1,Np
       V(1,i) = -Omega * X(2,i) ! - Omega y
       V(2,i) = Omega * X(1,i) ! Omega x
    end do
  end subroutine init_rotation

  function compute_epot(Xi, Xj) result(E)
    real(real64), intent(in) :: Xi(:), Xj(:)
    real(real64), dimension(3) :: dx
    real(real64) :: E, rij

    dx = Xj(:) - Xi(:)
    rij = sqrt(dot_product(dx,dx) + epsilon*epsilon)
    E = G*m*m/rij
  end function compute_epot
  
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ! function compute_force(Xi, Xj) result(F)   !
  !   real(real64), intent(in) :: Xi(:), Xj(:) !
  !   real(real64), dimension(3) :: F          !
  !                                            !
  !   real(real64) :: d,rsqrt                  !
  !   real(real64), dimension(3) :: Xji        !
  !   Xji = Xj - Xi                            !
  !   d  = sqrt(dot_product(Xji, Xji))         !
  !   rsqrt = sqrt((d*d + epsilon*epsilon))    !
  !                                            !
  !   F = (G * m*m / rsqrt*rsqrt*rsqrt)) * Xji !
  ! end function compute_force                 !
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


  function compute_force(Xi, Xj) result(F)
    real(real64), intent(in) :: Xi(3), Xj(3)
    real(real64) :: F(3)

    real(real64) :: dx, dy, dz
    real(real64) :: r2, inv_r, inv_r3
    real(real64), parameter :: one = 1.0
    real(real64), parameter :: eps2 = epsilon*epsilon

    dx = Xj(1) - Xi(1)
    dy = Xj(2) - Xi(2)
    dz = Xj(3) - Xi(3)

    r2   = dx*dx + dy*dy + dz*dz + eps2
    inv_r  = one / sqrt(r2)
    inv_r3 = inv_r * inv_r * inv_r

    F(1) = dx * (G * m * m * inv_r3)
    F(2) = dy * (G * m * m * inv_r3)
    F(3) = dz * (G * m * m * inv_r3)
  end function compute_force
end module subrs
