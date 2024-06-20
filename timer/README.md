
1. 
2. timer_secondary_autotest is used for testing alternative timer.

Timer related:
```bash
RTE>>timer_secondary_autotest
Running binary with argv[]:'build/app/test/dpdk-test' '-c' '4' '--proc-type=secondary' '--file-prefix=rte' 
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket_112415_48d1a195c60
EAL: Selected IOVA mode 'VA'
Test OK
RTE>>timer_autotest
Start timer stress tests
TESTTIMER: core 1 finished
TESTTIMER: core 17 finished
TESTTIMER: core 7 finished
TESTTIMER: core 19 finished
TESTTIMER: core 22 finished
TESTTIMER: core 6 finished
TESTTIMER: core 0 finished
TESTTIMER: core 21 finished
TESTTIMER: core 4 finished
TESTTIMER: core 3 finished
TESTTIMER: core 2 finished
TESTTIMER: core 16 finished
TESTTIMER: core 20 finished
TESTTIMER: core 5 finished
TESTTIMER: core 18 finished
TESTTIMER: core 23 finished

Start timer stress tests 2
- 3577 timer reset collisions (OK)
Test OK

Start timer basic tests
TESTTIMER: 5448366048527: callback id=3 count=1 on core 1
TESTTIMER: 5448366046966: callback id=0 count=1 on core 0
TESTTIMER: 5448366248624: callback id=2 count=1 on core 0
TESTTIMER: 5449220450299: callback id=1 count=1 on core 0
TESTTIMER: 5449220446418: callback id=3 count=2 on core 1
TESTTIMER: 5449220885186: callback id=2 count=2 on core 0
TESTTIMER: 5450074843950: callback id=2 count=3 on core 0
TESTTIMER: 5450074846387: callback id=3 count=3 on core 1
TESTTIMER: core 5 finished
TESTTIMER: core 0 finished
TESTTIMER: core 2 finished
TESTTIMER: core 3 finished
TESTTIMER: core 21 finished
TESTTIMER: core 17 finished
TESTTIMER: core 16 finished
TESTTIMER: core 20 finished
TESTTIMER: core 4 finished
TESTTIMER: core 1 finished
TESTTIMER: core 7 finished
TESTTIMER: core 19 finished
TESTTIMER: core 18 finished
TESTTIMER: core 6 finished
TESTTIMER: core 23 finished
TESTTIMER: core 22 finished
No timer statistics, RTE_LIBRTE_TIMER_DEBUG is disabled
Test OK
RTE>>timer_perf_autotest
Appending 100 timers
Time for 100 timers: 41446 (0ms), Time per timer: 414 (0us)
Time for 100 callbacks: 9759 (0ms), Time per callback: 97 (0us)
Resetting 100 timers
Time for 100 timers: 33774 (0ms), Time per timer: 337 (0us)

Appending 1000 timers
Time for 1000 timers: 330720 (0ms), Time per timer: 330 (0us)
Time for 1000 callbacks: 64810 (0ms), Time per callback: 64 (0us)
Resetting 1000 timers
Time for 1000 timers: 409288 (0ms), Time per timer: 409 (0us)

Appending 10000 timers
Time for 10000 timers: 3732177 (1ms), Time per timer: 373 (0us)
Time for 10000 callbacks: 640395 (0ms), Time per callback: 64 (0us)
Resetting 10000 timers
Time for 10000 timers: 5231558 (2ms), Time per timer: 523 (0us)

Appending 100000 timers
Time for 100000 timers: 40126633 (12ms), Time per timer: 401 (0us)
Time for 100000 callbacks: 6507256 (2ms), Time per callback: 65 (0us)
Resetting 100000 timers
Time for 100000 timers: 90165730 (26ms), Time per timer: 901 (0us)

Appending 1000000 timers
Time for 1000000 timers: 478950488 (140ms), Time per timer: 478 (0us)
Time for 1000000 callbacks: 66413323 (19ms), Time per callback: 66 (0us)
Resetting 1000000 timers
Time for 1000000 timers: 1671222129 (489ms), Time per timer: 1671 (0us)

All timers processed ok

Time per rte_timer_manage with zero timers: 16 cycles
Time per rte_timer_manage with zero callbacks: 40 cycles
Test OK
RTE>>timer_racecond_autotest
Start timer manage race condition test (4 seconds)
Starting main loop on core 1
Starting main loop on core 2
Starting main loop on core 3
Starting main loop on core 4
Starting main loop on core 5
Starting main loop on core 6
Starting main loop on core 7
Starting main loop on core 16
Starting main loop on core 17
Starting main loop on core 18
Starting main loop on core 19
Starting main loop on core 20
Starting main loop on core 21
Starting main loop on core 22
Starting main loop on core 23
Stopping timer manage race condition test
- core 3, 41 reset collisions (OK)
- core 20, 29 reset collisions (OK)
- core 1, 41 reset collisions (OK)
- core 4, 42 reset collisions (OK)
- core 6, 31 reset collisions (OK)
- core 7, 29 reset collisions (OK)
- core 2, 41 reset collisions (OK)
- core 5, 28 reset collisions (OK)
- core 17, 29 reset collisions (OK)
- core 18, 28 reset collisions (OK)
- core 19, 28 reset collisions (OK)
- core 16, 28 reset collisions (OK)
- core 22, 28 reset collisions (OK)
- core 23, 28 reset collisions (OK)
- core 21, 29 reset collisions (OK)
Test OK
```

