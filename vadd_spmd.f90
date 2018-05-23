
! Vector addition
program vadd

  use timer
  use omp_lib

  implicit none

  integer :: N=50000000
  real(kind=8), allocatable :: A(:), B(:), C(:)
  integer :: i
  integer :: tid, nthreads
  real(kind=8) :: start, end

  ! Allocate memory
  allocate(A(N))
  allocate(B(N))
  allocate(C(N))

  ! Initilise data
  do i = 1, N
    A(i) = 1.0_8
    B(i) = 2.0_8
    C(i) = 0.0_8
  end do

  ! Start timer
  call wtime(start)

  ! Open parallel region
  ! tid variable must be private to each thread
  !$omp parallel private(tid)

  ! Get thread number
  tid = omp_get_thread_num()

  ! Get total number of threads
  nthreads = omp_get_num_threads()

  ! Vector addition
  ! Share iteration space based on thread ID
  do i = 1+(tid*N/nthreads), (tid+1)*N/nthreads
    C(i) = A(i) + B(i)
  end do

  ! End parallel region
  !$omp end parallel

  ! Stop timer
  call wtime(end)

  ! Print result
  write(*,"(A)")         "------------------------------------"
  write(*,"(A,F10.3)")   "runtime:  ", end-start
  if (any(C .ne. 3.0_8)) then
    write(*,"(A)")       "WARNING: results incorrect"
  end if
  write(*,"(A)")         "------------------------------------"

  ! Free memory
  deallocate(A,B)

end program vadd
