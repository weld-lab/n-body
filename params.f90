module params
  use iso_fortran_env, only: real64
  implicit none

  ! physical parameters
  integer, parameter :: Np = 200

  real(real64), parameter :: G = 1.
  real(real64), parameter :: m = 1./Np
  real(real64), parameter :: R = 1.
  real(real64), parameter :: Omega = 0.1*sqrt(G * m * Np / R**3)
  ! integration parameters
  integer, parameter :: Nt = 20000
  real(real64), parameter :: dt = 1e-3
  real(real64), parameter :: epsilon = 0.005


  ! writing parameters
  integer, PARAMETER :: skip_frame = 10
end module params
