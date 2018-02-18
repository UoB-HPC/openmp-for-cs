
program pi_main

  ! Local variables
  integer, parameter :: num_steps = 100000000 ! number of steps over which to estimate pi
  real(kind=8) :: step                        ! the step size
  integer :: ii                               ! genereric counter
  real(kind=8) :: x                           ! intermediate value
  real(kind=8) :: pi = 0.0_8                  ! overall estimate
  real(kind=8) :: sum = 0.0_8                 ! variable to store partial sum

  real(kind=8), parameter :: PI_8 = 4.0_8 * atan(1.0_8)

  ! step size is dependent upon the number of steps
  step = 1.0_8/num_steps

  ! main loop
  do ii = 1, num_steps
    x = (ii+0.5_8)*step
    sum = sum + (4.0_8/(1.0_8+x*x))
  end do
  pi = step * sum

  write(*,"(A,F19.16)") "pi is:    ", pi
  write(*,"(A,F19.16)") "error is: ", abs(pi - PI_8)

end program pi_main
