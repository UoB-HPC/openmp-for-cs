
! 5 point stencil
program stencil

  use timer

  implicit none

  integer :: nx = 4000
  integer :: ny = 4000
  integer :: ntimes = 30
  real(kind=8), dimension(:,:), pointer :: A, Atmp, Aptr
  integer :: i, j, t
  real(kind=8) :: tic, toc

  ! Allocate memory
  allocate(A(0:nx+1,0:ny+1))
  allocate(Atmp(0:nx+1,0:ny+1))

  ! Initilise data
  do i = 0, nx+1
    do j = 0, ny+1
      A(i,j) = i+j
      Atmp(i,j) = 0.0_8
    end do
  end do

  ! Start timer
  call wtime(tic)

  ! Loop a number of times
  do t = 1, ntimes

    ! Update the stencil
    do i = 1, nx
      do j = 1, ny
        Atmp(i,j) = (A(i-1,j) + A(i+1,j) + A(i,j-1) + A(i,j+1)) / 4.0_8
      end do
    end do

    ! Swap pointers
    Aptr => A
    A => Atmp
    Atmp => Aptr

  end do

  ! Stop timer
  call wtime(toc)

  ! Print result
  write(*,"(A)")         "------------------------------------"
  write(*,"(A,F10.3)")   "runtime:  ", toc-tic
  write(*,"(A)")         "------------------------------------"


  deallocate(A, Atmp)

end program stencil

