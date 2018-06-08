! Timing module, used to call the C timer
module timer

  use ISO_C_BINDING

  implicit none

  interface

    subroutine wtime_c(time) bind(C, name='wtime')
      use ISO_C_BINDING
      real(C_DOUBLE) :: time
    end subroutine
  end interface

  contains

  subroutine wtime(time)

    real(kind=8) :: time

    call wtime_c(time)

  end subroutine wtime

end module timer
