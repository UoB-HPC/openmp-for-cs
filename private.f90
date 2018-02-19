
program private

  USE omp_lib

  implicit none

  integer :: i        ! Loop index
  integer :: nthreads ! Number of threads
  integer :: N=10     ! Number of iterations
  integer :: x=-1     ! Original variable

  write(*,"(A)") "------------------------------------"

  !$omp parallel
    nthreads = omp_get_num_threads()
  !$omp end parallel
  write (*,"(A,I0)") "num threads: ", nthreads
  write (*,*)

  write (*,"(A,I0)") "original: x=", x
  write (*,*)

  ! Private clause
  x=-1
  write (*,"(A,I0)") "private:"
  write (*,"(1X,A,I0)") "before: x=", x
  !$omp parallel do private(x)
  do i = 1, N
    write (*,"(2X,A,I0,A,I0,A,I0)") "Thread ", omp_get_thread_num(), " setting x=", x, " to ", i
    x = i
  end do
  !$omp end parallel do
  write (*,"(1X,A,I0)") "after: x=", x
  write (*,*)

  ! First private clause
  x=-1
  write (*,"(A,I0)") "firstprivate:"
  write (*,"(1X,A,I0)") "before: x=", x
  !$omp parallel do firstprivate(x)
  do i = 1, N
    write (*,"(2X,A,I0,A,I0,A,I0)") "Thread ", omp_get_thread_num(), " setting x=", x, " to ", i
    x = i
  end do
  !$omp end parallel do
  write (*,"(1X,A,I0)") "after: x=", x
  write (*,*)

  ! Last private clause
  x=-1
  write (*,"(A,I0)") "firstprivate:"
  write (*,"(1X,A,I0)") "before: x=", x
  !$omp parallel do lastprivate(x)
  do i = 1, N
    write (*,"(2X,A,I0,A,I0,A,I0)") "Thread ", omp_get_thread_num(), " setting x=", x, " to ", i
    x = i
  end do
  !$omp end parallel do
  write (*,"(1X,A,I0)") "after: x=", x

  write(*,"(A)") "------------------------------------"

end program private
