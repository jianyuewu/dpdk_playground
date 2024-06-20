
```bash
taskset -c 7-11 pktgen -v -l 7-11 --proc-type auto --log-level=8 -- -P -v -m "[8:9].2,[10:11].3"
taskset -c 12-15 dpdk-testpmd -l 12-15 -n 4 --socket-mem=1024,0 -- -i --nb-cores=2 --portmask=3
```
