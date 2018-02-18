!
! Implementation of the iterative Jacobi method.
!
! Given a known, diagonally dominant matrix A and a known vector b, we aim to
! to find the vector x that satisfies the following equation:
!
!     Ax = b
!
! We first split the matrix A into the diagonal D and the remainder R:
!
!     (D + R)x = b
!
! We then rearrange to form an iterative solution:
!
!     x' = (b - Rx) / D
!
! More information:
! -> https://en.wikipedia.org/wiki/Jacobi_method
!

! Module which contains the Jacobi solver subrountine
module solve_mod

  contains

  ! Solve Ax=b according to the Jacobi method
  subroutine solve(N, A, b, x, xtmp, itr, MAX_ITERATIONS, CONVERGENCE_THRESHOLD)

    implicit none

    ! Input variables
    integer :: N                          ! Matrix order
    real(kind=8) :: A(N,N)                ! The matrix
    real(kind=8) :: b(N)                  ! The right hand side vector
    real(kind=8), pointer :: x(:)         ! Initial solution
    real(kind=8), pointer :: xtmp(:)      ! Next solution
    integer :: itr                        ! Iterations to solve
    integer :: MAX_ITERATIONS             ! Iteration limit
    real(kind=8) :: CONVERGENCE_THRESHOLD ! Convergence criteria

    ! Local variables
    real(kind=8), pointer :: ptrtmp(:) ! Used for pointer swapping
    integer :: row, col                ! Matrix index
    real(kind=8) :: dot
    real(kind=8) :: diff, sqdiff=huge(0.0_8)

    ! Loop until converged or maximum iterations reached
    itr = 0
    do while (itr .lt. MAX_ITERATIONS .and. sqrt(sqdiff) .gt. CONVERGENCE_THRESHOLD)
      ! Perfom Jacobi iteration
      do row = 1, N
        dot = 0.0_8
        do col = 1, N
          if (row .ne. col) then
            dot = dot + (A(row,col) * x(col))
          end if
        end do
        xtmp(row) = (b(row) - dot) / A(row,row)
      end do

      ! Swap pointers
      ptrtmp => x
      x      => xtmp
      xtmp   => ptrtmp

      ! Check for convergence
      sqdiff = 0.0_8
      do row = 1, N
        diff = xtmp(row) - x(row)
        sqdiff = sqdiff + (diff * diff)
      end do

      itr = itr + 1
    end do

  end subroutine solve
end module solve_mod

! Main program
program jacobi

  use ISO_C_BINDING ! Link to C timing routine
  use solve_mod     ! Include solver (above)

  implicit none

  ! Interface to C timing routine
  interface
    subroutine wtime(time) bind(C, name='wtime')
      use ISO_C_BINDING
      real(C_DOUBLE) :: time
    end subroutine
  end interface

  ! Solver settings
  integer :: MAX_ITERATIONS=20000
  real(kind=8) :: CONVERGENCE_THRESHOLD=0.0001

  ! Timers
  real(kind=8) :: total_start, total_end
  real(kind=8) :: solve_start, solve_end

  ! Matrix size
  integer :: N=1000

  ! Data arrays
  real(kind=8), allocatable :: A(:,:) ! The matrix
  real(kind=8), allocatable :: b(:)   ! The right hand size vector
  real(kind=8), pointer :: x(:)       ! Initial solution
  real(kind=8), pointer :: xtmp(:)    ! Temporary solution storage
  integer :: itr                      ! Iteration count

  ! Local variables
  integer :: row, col
  real(kind=8) :: rowsum, value
  real(kind=8) :: err, tmp

  ! Read in any command line arguments which set problem variables
  call parse_arguments(MAX_ITERATIONS, CONVERGENCE_THRESHOLD, N)

  ! Allocate memory
  allocate(A(N,N))
  allocate(b(N))
  allocate(x(N))
  allocate(xtmp(N))

  ! Print header
  write(*,"(A)")         "------------------------------------"
  write(*,"(A,I0,A,I0)") "Matrix size:           ", N, " x ", N
  write(*,"(A,I0)")      "Maximum iterations:    ", MAX_ITERATIONS
  write(*,"(A,F7.5)")    "Convergence threshold: ", CONVERGENCE_THRESHOLD
  write(*,"(A)")         "------------------------------------"
  write(*,*)

  ! Start the program timer
  call wtime(total_start)

  ! Initialize data randomly
  ! A needs to be a diagonally dominant square matrix, so diagonal entries are biased
  do row = 1, N
    rowsum = 0.0_8
    do col = 1, N
      call random_number(value)
      A(row,col) = value
      rowsum = rowsum + value
    end do
    A(row,row) = A(row,row) + rowsum
    call random_number(b(row))
    x(row) = 0.0_8
  end do

  ! Run Jacobi solver
  call wtime(solve_start)
  call solve(N, A, b, x, xtmp, itr, MAX_ITERATIONS, CONVERGENCE_THRESHOLD)
  call wtime(solve_end)

  ! Check error of final solution
  err = 0.0_8
  do row = 1, N
    tmp = 0.0_8
    do col = 1, N
      tmp = tmp + (A(row,col) * x(col))
    end do
    tmp = b(row) - tmp
    err = err + (tmp*tmp)
  end do
  err = sqrt(err)

  ! Stop the program timer
  call wtime(total_end)

  ! Print results
  write(*,"(A,G13.7)") "Solution error = ", err
  write(*,"(A,I0)")    "Iterations     = ", itr
  write(*,"(A,G10.3)") "Total runtime  = ", total_end-total_start
  write(*,"(A,G10.3)") "Solver runtime = ", solve_end-solve_start
  if (itr .eq. MAX_ITERATIONS) write(*,"(A)") "WARNING: solution did not converge"
  write(*,"(A)")       "------------------------------------"

  ! Free memory
  deallocate(A, b, x, xtmp)

end program jacobi

! Parse the command line arguments, setting the problem size, etc.
subroutine parse_arguments(MAX_ITERATIONS, CONVERGENCE_THRESHOLD, N)

  implicit none

  integer :: MAX_ITERATIONS
  real(kind=8) :: CONVERGENCE_THRESHOLD
  integer :: N

  character(len=32) :: arg

  integer :: i=1
  integer :: err

  do while (i .le. command_argument_count())
    call get_command_argument(i, arg)
    arg = trim(arg)

    if ("--convergence" .eq. arg .or. &
        "-c"            .eq. arg) then
      i = i + 1
      call get_command_argument(i, arg, status=err)
      if (err .ne. 0) then
        write (*,*) "Error: no convergence threshold given"
        stop
      end if
      read(arg,*) CONVERGENCE_THRESHOLD

    else if ("--iterations" .eq. arg .or. &
             "-i" .eq. arg) then
      i = i + 1
      call get_command_argument(i, arg, status=err)
      if (err .ne. 0) then
        write (*,*) "Error: no max iterations given"
        stop
      end if
      read(arg,*) MAX_ITERATIONS

    else if ("--norder" .eq. arg .or. &
             "-n" .eq. arg) then
      i = i + 1
      call get_command_argument(i, arg, status=err)
      if (err .ne. 0) then
        write (*,*) "Error: no matrix order given"
        stop
      end if
      read(arg,*) N

    else if ("--help" .eq. arg) then
      write(*,"(A)") "Usage: ./jacobi [OPTIONS]"
      write(*,*)
      write(*,"(A)") "Options:"
      write(*,"(2X,A)") "-h  --help               Print this message"
      write(*,"(2X,A)") "-c  --convergence  C     Set convergence threshold"
      write(*,"(2X,A)") "-i  --iterations   I     Set maximum number of iterations"
      write(*,"(2X,A)") "-n  --norder       N     Set maxtrix order"
      write(*,*)
      stop

    else
      write (*,"(A,A)") "Unrecognized argument (try '--help'): ", arg
      stop
    end if

    i = i + 1
  end do
end subroutine parse_arguments
