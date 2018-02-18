
program pi_main

  use timer
  use omp_lib

  ! Local variables
  integer, parameter :: num_steps = 100000000 ! number of steps over which to estimate pi
  real(kind=8) :: step                        ! the step size
  integer :: ii                               ! genereric counter
  real(kind=8) :: x                           ! intermediate value
  real(kind=8) :: pi = 0.0_8                  ! overall estimate
  real(kind=8), allocatable :: sum(:)         ! variable to store partial sum
  real(kind=8) :: start, end                  ! timers
  integer :: nthreads                         ! number of OpenMP threads
  integer :: tid                              ! thread id

  real(kind=8), parameter :: PI_8 = 4.0_8 * atan(1.0_8)

  ! Get number of OpenMP threads
  !$omp parallel
  nthreads = omp_get_num_threads()
  !$omp end parallel

  allocate(sum(nthreads))

  ! step size is dependent upon the number of steps
  step = 1.0_8/num_steps

  ! Start timer
  call wtime(start)

  ! main loop
  !$omp parallel private(x,tid)
  tid = omp_get_thread_num()
  sum(tid+1) = 0.0_8
  !$omp do
  do ii = 1, num_steps
    x = (ii-0.5_8)*step
    sum(tid+1) = sum(tid+1) + (4.0_8/(1.0_8+x*x))
  end do
  !$omp end do
  !$omp end parallel

  ! Total partial sums serially
  do ii = 1, nthreads
    pi = pi + sum(ii)
  end do
  pi = pi * step

  ! Stop timer
  call wtime(end)

  ! Print result
  write(*,"(A)")         "------------------------------------"
  write(*,"(A,F19.16)") "pi is:    ", pi
  write(*,"(A,F19.16)") "error is: ", abs(pi - PI_8)
  write(*,"(A,F10.3)")   "runtime:  ", end-start
  write(*,"(A)")         "------------------------------------"

  deallocate(sum)

end program pi_main
