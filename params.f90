module params
  use iso_fortran_env, only: real64
  implicit none

  ! physical parameters
  integer, parameter :: Np = 500

  real(real64), parameter :: G = 1.
  real(real64), parameter :: m = 1./Np
  real(real64), parameter :: R = 1.
  real(real64), parameter :: Omega = 0.3*sqrt(G * m * Np / R**3)
  ! integration parameters
  integer, parameter :: Nt = 20000
  real(real64), parameter :: dt = 1e-5
  real(real64), parameter :: epsilon = 0.005


  ! writing parameters
  integer, PARAMETER :: skip_frame = 100
end module params
