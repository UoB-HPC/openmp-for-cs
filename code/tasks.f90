
subroutine do_c
  print *, "Task C starting"
  call sleep(1)
  print *, "Task C finished"
end subroutine

subroutine do_d
  print *, "Task D starting"
  call sleep(1)
  print *, "Task D finished"
end subroutine

subroutine do_e
  print *, "Task E starting"
  call sleep(1)
  print *, "Task E finished"
end subroutine

subroutine do_b

  print *, "Task B starting"
  call sleep(1)

  !$omp task
  call do_d
  !$omp end task

  !$omp task
  call do_e
  !$omp end task

  print *, "Task B finished"

end subroutine

subroutine do_a

  print *, "Task A starting"
  call sleep(1)

  !$omp task
  call do_b
  !$omp end task

  !$omp task
  call do_c
  !$omp end task

  print *, "Task A finished"

end subroutine

program tasks

  implicit none

  !$omp parallel
  !$omp master
  call do_a
  !$omp end master
  !$omp end parallel

end program

