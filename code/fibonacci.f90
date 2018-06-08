
recursive integer function fib(n) result(res)

  implicit none

  integer :: n, i, j
  
  if (n .lt. 2) then
    res = n
  else
    !$omp task shared(i)
    i = fib(n-1)
    !$omp end task
    
    !$omp task shared(j)
    j = fib(n-2)
    !$omp end task
    
    !$omp taskwait
    res = i+j
  end if 
end function

program fibonacci

  use timer

  implicit none

  integer :: fib ! Declare function
  integer :: num = 40
  integer :: res
  real(kind=8) :: tic, toc

  ! Start timer
  call wtime(tic)

  !$omp parallel
    !$omp master
    res = fib(num)
    !$omp end master
  !$omp end parallel

  ! Stop timer
  call wtime(toc)


  ! Print result
  write(*,"(A)")         "------------------------------------"
  write(*,"(I0,A,I0)")   num, "th Fibonacci is ", res
  write(*,"(A,F10.3)")   "runtime:  ", toc-tic
  write(*,"(A)")         "------------------------------------"

end program

