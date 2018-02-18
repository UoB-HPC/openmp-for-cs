
! Vector addition
program vadd

  use timer

  implicit none

  integer :: N=50000000
  real(kind=8), allocatable :: A(:), B(:), C(:)
  integer :: i
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

  ! Vector addition
  !$omp parallel do
  do i = 1, N
    C(i) = A(i) + B(i)
  end do
  !$omp end parallel do

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
