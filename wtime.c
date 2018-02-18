#include <sys/time.h>

/* Get the current time in seconds since the Epoch */
void wtime(double *time)
{
  struct timeval tv;
  gettimeofday(&tv, NULL);
  *time = tv.tv_sec + tv.tv_usec*1e-6;
}
