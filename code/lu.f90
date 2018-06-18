
! Compute the A=LU
! Stores LU in the same storage as A
! L is assumed to have a diagonal of 1 (so isn't stored)
! The method uses Gaussian Elimination
! A is a column major matrix, that is A(i,j)
! references the jth entry on the ith row
subroutine dgetrf(N, A)

  implicit none

  integer :: N
  real(kind=8) :: A(N,N)

  integer :: i, j, k

  ! For each row in the matrix
  do i = 1, N
    ! Loop over lower rows
    do j = i+1, N
      ! Store the Gaussian Elimination factor to form the ith column of L
      A(j,i) = A(j,i) / A(i,i)

      ! Loop over entries on the lower row to create ith row of U
      ! Subtract multiples of the ith row from the jth row (eliminating entries left of the diagonal)
      do k = i+1, N
        A(j,k) = A(j,k) - (A(j,i) * A(i,k))
      end do
    end do
  end do

end subroutine dgetrf


logical function check(N, A, Agold) result(ok)

  implicit none

  integer :: N
  real(kind=8) :: A(N,N), Agold(N,N)
  integer :: i, j, k
  real(kind=8), allocatable :: Atmp(:,:)

  allocate(Atmp(N,N))

  ! Multiply L*U to form A and check against Agold
  do i = 1, N
    do j = 1, N
      Atmp(i,j) = 0.0_8
      do k = 1, min(i-1,j)
        Atmp(i,j) = Atmp(i,j) + A(i,k)*A(k,j)
      end do
      if (j .ge. i) then
        Atmp(i,j) = Atmp(i,j) + 1.0_8 * A(i,j)
      end if
    end do
  end do

  if (any(abs(Atmp-Agold) > 1.0E-6)) then
    ok = .false.
  else
    ok = .true.
  end if

  deallocate(Atmp)

end function check


program lu

  use timer

  implicit none
  logical :: check
  logical :: valid

  real(kind=8), allocatable :: A(:,:)
  real(kind=8), allocatable :: Agold(:,:)
  integer :: N = 1024

  integer :: i, j
  real(kind=8) :: tic, toc

  ! Initilise the matrix A
  allocate(A(N,N))
  do j = 1, N
    do i = 1, N
      call random_number(A(i,j))
    end do
  end do

  ! Copy A for checking later
  allocate(Agold(N,N))
  Agold(:,:) = A(:,:)

  ! Start timer
  call wtime(tic)

  ! Factorise A = LU
  call dgetrf(N, A)

  ! Stop timer
  call wtime(toc)

  valid = check(N, A, Agold)

  ! Print result
  write(*,"(A)")         "------------------------------------"
  write(*,"(A,I0,A,I0)") "Matrix size: ", N, "x", N
  write(*,"(A,F10.3)")   "runtime:  ", toc-tic
  if (valid) then
    write(*,"(A)")       "Results correct"
  else
    write(*,"(A)")       "Results incorrect"
  end if
  write(*,"(A)")         "------------------------------------"

end program lu

