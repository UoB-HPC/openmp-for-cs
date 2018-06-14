
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

  ! Cut the matrix into quarters, each quarter is a block
  ! Do the diagonal operation on the top left block
  call diag(N, A, 1, N/2)
  ! Do the row operation on the top right block
  ! Arguments are the index of the top left entry where the block starts, with extent in that dimension
  ! So here, the row block starts in the first row and ends half way down,
  ! and has column indexes starting half way along until the end
  call row(N, A, 1, N/2, N/2+1, N)

  ! Do the column operation on the bottom left block
  call col(N, A, N/2+1, N, 1, N/2)

  ! Call the inner operation on the bottom right block
  ! Final pair is the start and size of the diagonal block
  call inner(N, A, N/2+1, N, N/2+1, N, 1, N/2)


  call diag(N, A, N/2+1, N)

end subroutine dgetrf

! Diagonalise the block
! This is regular Gaussian elimination
subroutine diag(N, A, i, Ni)

  implicit none
  integer :: N
  real(kind=8) :: A(N,N)
  integer :: i, Ni

  integer :: ii, jj, kk

  do ii = i, Ni
    do jj = ii+1, Ni
      A(jj,ii) = A(jj,ii) / A(ii,ii)
      do kk = ii+1, Ni
        A(jj,kk) = A(jj,kk) - (A(jj,ii)*A(ii,kk))
      end do
    end do
  end do

end subroutine diag

! Subtract multiples of rows from lower rows in the block
! Multiple factor is read from the diagonal block
subroutine row(N, A, rs, re, cs, ce)

  implicit none

  integer :: N
  real(kind=8) :: A(N,N)
  integer :: rs, re, cs, ce

  integer :: i, j, k

  do i = rs, re
    do j = i+1, re
      do k = cs, ce
        A(j,k) = A(j,k) - (A(j,i)*A(i,k))
      end do
    end do
  end do

end subroutine row

! Store L term under diagonal and subtract rows
subroutine col(N, A, rs, re, cs, ce)

  implicit none

  integer :: N
  real(kind=8) :: A(N,N)
  integer :: rs, re, cs, ce

  integer :: i, j, k

  do i = cs, ce
    do j = rs, re
      A(j,i) = A(j,i) / A(i,i)
      do k = i+1, ce
        A(j,k) = A(j,k) - (A(j,i)*A(i,k))
      end do
    end do
  end do

end subroutine col

! Subtract rows
subroutine inner(N, A, rs, re, cs, ce, ds, de)

  implicit none

  integer :: N
  real(kind=8) :: A(N,N)
  integer :: rs, re, cs, ce, ds, de

  integer :: i, j, k

  do i = ds, de
    do j = rs, re
      do k = cs, ce
        A(j,k) = A(j,k) - (A(j,i)*A(i,k))
      end do
    end do
  end do

end subroutine inner


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
  integer :: N = 1000

  integer :: i, j
  real(kind=8) :: tic, toc

  ! N must be even for recursive algorithm
  if (MOD(N,2) .ne. 0) then
    print *, "Error: N must be even"
    stop
  end if

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
