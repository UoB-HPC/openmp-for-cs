
! 5 point stencil
program stencil

  use timer

  implicit none

  integer :: nx = 4000
  integer :: ny = 4000
  integer :: ntimes = 30
  real(kind=8), dimension(:,:), pointer :: A, Atmp, Aptr
  integer :: i, j, t
  real(kind=8) :: total_start, total_end, total
  real(kind=8) :: tic, toc

  ! Allocate memory
  allocate(A(0:nx+1,0:ny+1))
  allocate(Atmp(0:nx+1,0:ny+1))

  ! Initialise data to zero
  do j = 0, ny+1
    do i = 0, nx+1
      A(i,j) = 0.0_8
      Atmp(i,j) = 0.0_8
    end do
  end do

  ! Insert values in centre of grid
  do j = ny/4, 3*ny/4
    do i = nx/4, 3*nx/4
      A(i,j) = 1.0_8
    end do
  end do

  total_start = sum(A(:,:))

  ! Copy data to device
  !$omp target enter data map(to: A, Atmp)

  ! Start timer
  call wtime(tic)

  ! Loop a number of times
  do t = 1, ntimes

    ! Update the stencil
    total = 0.0_8
    !$omp target map(tofrom:total)
    !$omp teams distribute parallel do reduction(+:total) collapse(2)
    do j = 1, ny
      do i = 1, nx
        Atmp(i,j) = (A(i-1,j) + A(i+1,j) + A(i,j) + A(i,j-1) + A(i,j+1)) * 0.2_8
        total = total + Atmp(i,j)
      end do
    end do
    !$omp end teams distribute parallel do
    !$omp end target

    ! Print out total
    write(*,"(I0,A,F15.5)") t, ": total=", total

    ! Swap pointers
    Aptr => A
    A => Atmp
    Atmp => Aptr

  end do

  ! Stop timer
  call wtime(toc)

  ! Copy data back
  !$omp target exit data map(from: A, Atmp)

  ! Sum up grid values for rudimentary correctness check
  total_end = sum(A(:,:))

  ! Print result
  write(*,"(A)")         "------------------------------------"
  write(*,"(A,F10.3)")   "runtime:  ", toc-tic
  if (abs(total_end-total_start)/total_start > 1.0E-8) then
    write(*,"(A)")       "result: Failed"
  else
    write(*,"(A)")       "result: Passed"
  end if
  write(*,"(A)")         "------------------------------------"


  deallocate(A, Atmp)

end program stencil

