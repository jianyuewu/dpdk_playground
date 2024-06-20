Just some test with DPDK processes.

# Basic multi-process(Symmetric)
## simple_mp with primary
simple_mp will create one process, with only one control thread(dpdk-simple_mp) and worker thread(rte-worker-13) running in RT cores.
Other DPDK threads like eal-intr-thread, rte_mp_handle, telemetry-v2 running in NRT cores.
It is using queues and memory pools to share info.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# ps -eLo pid,tid,psr,pri_baz,cls,comm | grep 63469
  63469   63469  12 120  TS dpdk-simple_mp
  63469   63470   5 120  TS eal-intr-thread
  63469   63471  10 120  TS rte_mp_handle
  63469   63472  13 120  TS rte-worker-13
  63469   63473  16 120  TS telemetry-v2
root@ubuntu2204:/data/repo/dpdk_playground/cpu# pstree -atp 63469
dpdk-simple_mp,63469 -c 0x3000 -n 4 --proc-type=primary
  ├─{eal-intr-thread},63470
  ├─{rte-worker-13},63472
  ├─{rte_mp_handle},63471
  └─{telemetry-v2},63473
```
Other samples:
```bash
# use cores 7-15, use 4 memory channels
# if --proc-type is not assigned, it is primary process by default.
# use file prefix to have different memory regions, differentiate with other primary processes.
dpdk-simple_mp -l 7-15 -n 4 --proc-type=auto --file-prefix "test"
```

## simple_mp with secondary
When primary send hello, secondary can receive it.
It is using ring "PRI_2_SEC" to transfer data, also slave can send to master via ring "SEC_2_PRI".

primary:
```bash
# Alloc a buffer from mem pool, fill content, enqueue to the rte_ring to secondary.
simple_mp > send hello
```

secondary:
```bash
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-simple_mp -c C000 -n 4 --proc-type=secondary
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket_63697_10c2f01c0677
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
APP: Finished Process Init.

simple_mp > Starting core 15


simple_mp > core 15: Received 'hello'
```

secondary process info:
Also dpdk-simple_mp and rte-worker-15 run in RT cores, eal-intr-thread and rte_mp_handle run in NRT cores.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# ps -eLo pid,tid,psr,pri_baz,cls,pcpu,comm | grep 63697
  63697   63697  14 120  TS  0.0 dpdk-simple_mp
  63697   63698   2 120  TS  0.0 eal-intr-thread
  63697   63699   4 120  TS  0.0 rte_mp_handle
  63697   63700  15 120  TS  3.4 rte-worker-15
```
Control process is lessoning to some DGRAM sockets:
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# ss -a | grep 63697
u_dgr UNCONN   0      0      /var/run/dpdk/rte/mp_socket_63697_10c2f01c0677 191214                             * 0
```
And some files are open, like fbarray_memzone and memseg:
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# lsof | grep 63697
dpdk-simp 63697                             root  cwd       DIR              259,8       4096   48639972 /data/repo/dpdk_playground/dpdk/build/examples
dpdk-simp 63697                             root  rtd       DIR              259,8       4096          2 /
dpdk-simp 63697                             root  txt       REG              259,8  234501208   48644001 /data/repo/dpdk_playground/dpdk/build/examples/dpdk-simple_mp
dpdk-simp 63697                             root  mem       REG               0,24      25344       2466 /run/dpdk/rte/config
dpdk-simp 63697                             root  mem-R     REG               0,24     188416       2469 /run/dpdk/rte/fbarray_memzone
dpdk-simp 63697                             root  mem-R     REG               0,24       4096       2470 /run/dpdk/rte/fbarray_memseg-1048576k-0-0
dpdk-simp 63697                             root  mem-R     REG               0,32 1073741824     216077 /dev/hugepages/rtemap_0
dpdk-simp 63697                             root  mem-R     REG               0,24       4096       2471 /run/dpdk/rte/fbarray_memseg-1048576k-0-1
dpdk-simp 63697                             root  mem       REG               0,14                  3097 anon_inode:[vfio-device] (stat: No such file or directory)
dpdk-simp 63697                             root  mem       REG              259,8    1296312   47979091 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.3.4
dpdk-simp 63697                             root  mem       REG              259,8    2216304   47978779 /usr/lib/x86_64-linux-gnu/libc.so.6
dpdk-simp 63697                             root  mem       REG              259,8     149760   47979173 /usr/lib/x86_64-linux-gnu/libgpg-error.so.0.32.1
dpdk-simp 63697                             root  mem       REG              259,8      39024   47973168 /usr/lib/x86_64-linux-gnu/libcap.so.2.44
dpdk-simp 63697                             root  mem       REG              259,8     841808   47980141 /usr/lib/x86_64-linux-gnu/libzstd.so.1.4.8
dpdk-simp 63697                             root  mem       REG              259,8     170456   47979427 /usr/lib/x86_64-linux-gnu/liblzma.so.5.2.5
dpdk-simp 63697                             root  mem       REG              259,8    4447536   47976385 /usr/lib/x86_64-linux-gnu/libcrypto.so.3
dpdk-simp 63697                             root  mem       REG              259,8     125152   47979425 /usr/lib/x86_64-linux-gnu/liblz4.so.1.9.3
dpdk-simp 63697                             root  mem       REG              259,8     807936   47978861 /usr/lib/x86_64-linux-gnu/libsystemd.so.0.32.0
dpdk-simp 63697                             root  mem       REG              259,8     313656   47973525 /usr/lib/x86_64-linux-gnu/libdbus-1.so.3.19.13
dpdk-simp 63697                             root  mem       REG              259,8      30960   47978045 /usr/lib/x86_64-linux-gnu/libatomic.so.1.2.0
dpdk-simp 63697                             root  mem       REG              259,8     108936   47972416 /usr/lib/x86_64-linux-gnu/libz.so.1.2.11
dpdk-simp 63697                             root  mem       REG              259,8     117400   47978970 /usr/lib/x86_64-linux-gnu/libelf-0.186.so
dpdk-simp 63697                             root  mem       REG              259,8     310592   47979625 /usr/lib/x86_64-linux-gnu/libpcap.so.1.10.1
dpdk-simp 63697                             root  mem       REG              259,8      48152   47979569 /usr/lib/x86_64-linux-gnu/libnuma.so.1.0.0
dpdk-simp 63697                             root  mem       REG              259,8     940560   47979430 /usr/lib/x86_64-linux-gnu/libm.so.6
dpdk-simp 63697                             root  mem-R     REG               0,24       4096       2541 /run/dpdk/rte/fbarray_memseg-1048576k-0-1_63697
dpdk-simp 63697                             root  mem       REG              259,8     240936   47978442 /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
dpdk-simp 63697                             root  mem-R     REG               0,24       4096       2540 /run/dpdk/rte/fbarray_memseg-1048576k-0-0_63697
dpdk-simp 63697                             root    0u      CHR              136,8        0t0         11 /dev/pts/8
dpdk-simp 63697                             root    1u      CHR              136,8        0t0         11 /dev/pts/8
dpdk-simp 63697                             root    2u      CHR              136,8        0t0         11 /dev/pts/8
dpdk-simp 63697                             root    3r     FIFO               0,13        0t0     191210 pipe
dpdk-simp 63697                             root    4w     FIFO               0,13        0t0     191210 pipe
dpdk-simp 63697                             root    5u  a_inode               0,14          0       3097 [eventpoll]
dpdk-simp 63697                             root    6u  a_inode               0,14          0       3097 [timerfd]
dpdk-simp 63697                             root    7u     unix 0xffff9bafd5f7a640        0t0     191218 type=DGRAM
dpdk-simp 63697                             root    8u     unix 0xffff9bafd5f7ea40        0t0     191214 /var/run/dpdk/rte/mp_socket_63697_10c2f01c0677 type=DGRAM
dpdk-simp 63697                             root    9u      CHR             10,196        0t0        142 /dev/vfio/vfio
dpdk-simp 63697                             root   10uR     REG               0,24     188416       2469 /run/dpdk/rte/fbarray_memzone
dpdk-simp 63697                             root   11uR     REG               0,24       4096       2470 /run/dpdk/rte/fbarray_memseg-1048576k-0-0
dpdk-simp 63697                             root   12uR     REG               0,24       4096       2471 /run/dpdk/rte/fbarray_memseg-1048576k-0-1
dpdk-simp 63697                             root   13uR     REG               0,24       4096       2540 /run/dpdk/rte/fbarray_memseg-1048576k-0-0_63697
dpdk-simp 63697                             root   14uR     REG               0,24       4096       2541 /run/dpdk/rte/fbarray_memseg-1048576k-0-1_63697
dpdk-simp 63697                             root   15r     FIFO               0,13        0t0     222209 pipe
dpdk-simp 63697                             root   16uR     REG               0,32 1073741824     216077 /dev/hugepages/rtemap_0
dpdk-simp 63697                             root   17w     FIFO               0,13        0t0     222209 pipe
dpdk-simp 63697                             root   18r     FIFO               0,13        0t0     222210 pipe
dpdk-simp 63697                             root   19w     FIFO               0,13        0t0     222210 pipe
dpdk-simp 63697                             root   20u      CHR              241,0        0t0       1263 /dev/vfio/19
dpdk-simp 63697                             root   21u  a_inode               0,14          0       3097 [vfio-device]
dpdk-simp 63697                             root   22u      CHR              241,1        0t0       1265 /dev/vfio/20
dpdk-simp 63697                             root   23u  a_inode               0,14          0       3097 [vfio-device]
```

System can only allow one primary process.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-simple_mp -c 0xFE -n 4 --proc-type=primary
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Cannot create lock on '/var/run/dpdk/rte/config'. Is another primary process running?
EAL: FATAL: Cannot init config
EAL: Cannot init config
EAL: Error - exiting with code: 1
  Cause: Cannot init EAL
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-simple_mp -c 0xFE -n 4 --proc-type=secondary
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket_64239_159368c770ff
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
APP: Finished Process Init.

simpStarting core 2
le_mp Starting core 3
> Starting core 4
Starting core 5
Starting core 6
Starting core 7

simple_mp > quit
```
## How it works
There are two queues(_PRI_2_SEC and _SEC_2_PRI) and a single mempool(_MSG_POOL).
```bash
if (rte_eal_process_type() == RTE_PROC_PRIMARY){
	send_ring = rte_ring_create(_PRI_2_SEC, ring_size, rte_socket_id(), flags);
	recv_ring = rte_ring_create(_SEC_2_PRI, ring_size, rte_socket_id(), flags);
	message_pool = rte_mempool_create(_MSG_POOL, pool_size,
			STR_TOKEN_SIZE, pool_cache, priv_data_sz,
			NULL, NULL, NULL, NULL,
			rte_socket_id(), flags);
} else {
	recv_ring = rte_ring_lookup(_PRI_2_SEC);
	send_ring = rte_ring_lookup(_SEC_2_PRI);
	message_pool = rte_mempool_lookup(_MSG_POOL);
}
```
Secondary process can't create objects, as it can't reserve mem zones, but it can attach to these objects at startup.

# Symmetric Multi-process
Different processes perform same tasks.
## dpdk-symmetric_mp with primary
-c means core mask, -n is memory channels, -p 3 means use port 0 and 1.
--num-procs=4 use 4 procs to perform packet processing, used to configure appropriate num of Rx queues on each port.
--proc-id=0 means this is the first process.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-symmetric_mp -c C000 -n 4 --proc-type=auto -- -p 3 --num-procs=4 --proc-id=0
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Auto-detected process type: PRIMARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_load_pkg_type(): Active package is: 1.3.26.0, ICE OS Default Package (single VLAN mode)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_load_pkg_type(): Active package is: 1.3.26.0, ICE OS Default Package (single VLAN mode)
TELEMETRY: No legacy callbacks, legacy socket not created
# Initialising port 0... Port 0 modified RSS hash function based on hardware support,requested:0xa38c configured:0x238c
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 0).
ice_vsi_config_outer_vlan_stripping(): Single VLAN mode (SVM) does not support qinq
# Initialising port 1... Port 1 modified RSS hash function based on hardware support,requested:0xa38c configured:0x238c
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 1).
ice_vsi_config_outer_vlan_stripping(): Single VLAN mode (SVM) does not support qinq

Checking link status.done
Port 0 Link up at 25 Gbps FDX Autoneg
Port 1 Link up at 25 Gbps FDX Autoneg
APP: Finished Process Init.
Lcore 15 has nothing to do
Lcore 14 using ports 0 1
lcore 14 using queue 0 of each port
```
core layout:
Also eal-intr-thread, rte_mp_handle, telemetry-v2 in NRT cores(not isolated).
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# ps -eLo pid,tid,psr,cls,comm | grep 65746
  65746   65746  14  TS dpdk-symmetric_
  65746   65747   4  TS eal-intr-thread
  65746   65748   6  TS rte_mp_handle
  65746   65749  15  TS rte-worker-15
  65746   65750  16  TS telemetry-v2
```
Run with 4 instances, each run in one core:
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# dpdk-symmetric_mp -l 1 -n 4 --proc-type=auto -- -p 3 --num-procs=4 --proc-id=0
root@ubuntu2204:/data/repo/dpdk_playground/cpu# dpdk-symmetric_mp -l 2 -n 4 --proc-type=auto -- -p 3 --num-procs=4 --proc-id=1
root@ubuntu2204:/data/repo/dpdk_playground/cpu# dpdk-symmetric_mp -l 3 -n 4 --proc-type=auto -- -p 3 --num-procs=4 --proc-id=2
root@ubuntu2204:/data/repo/dpdk_playground/cpu# dpdk-symmetric_mp -l 4 -n 4 --proc-type=auto -- -p 3 --num-procs=4 --proc-id=3
```

## dpdk-symmetric_mp with secondary
```bash
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-symmetric_mp -c 3000 -n 4 --proc-type=auto -- -p 3 --num-procs=4 --proc-id=1
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Auto-detected process type: SECONDARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket_65873_1ad9e8afad81
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 0).
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 1).
APP: Finished Process Init.
Lcore 13 has nothing to do
Lcore 12 using ports 0 1
lcore 12 using queue 0 of each port
```
core layout:
Also eal-intr-thread, rte_mp_handle in NRT cores(not isolated).
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# ps -eLo pid,tid,psr,cls,comm | grep 65873
  65873   65873  12  TS dpdk-symmetric_
  65873   65874   4  TS eal-intr-thread
  65873   65875   2  TS rte_mp_handle
  65873   65876  13  TS rte-worker-13
```

## How it works
Primary process creates all the memory structures needed for all processes.
since all processes work in the same manner, once the hugepage shared memory and the network ports are initialized, it is not necessary to restart all processes if the primary instance dies.
Auto-detection will detect no primary processes running and therefore attempt to re-initialize shared memory.
fork() -> rte_eal_init() -> init driver -> probing devices -> rte_eal_remote_launch() -> rte_eal_wait_lcore() -> rte_eal_cleanup() -> rte_eal_finish().
The structures for the initialized network ports are stored in shared memory and therefore will be accessible by the secondary process as it initializes.
primary: create.
secondary: lookup.

# Client-Server Multi-process(Asymmetric)
Different processes perform different tasks. Server receives packets from ethernet by Rx queues, and client send packets to Tx queues.
## Server
-n 2 means number of clients.
-c 3000, means core mask, 3000 means core 12 and 13. Core 12 recv pkts, and core 13 print statistics.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-mp_server -c 3000 -n 4 -- -p 3 -n 2
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_load_pkg_type(): Active package is: 1.3.26.0, ICE OS Default Package (single VLAN mode)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_load_pkg_type(): Active package is: 1.3.26.0, ICE OS Default Package (single VLAN mode)
TELEMETRY: No legacy callbacks, legacy socket not created
Creating mbuf pool 'MProc_pktmbuf_pool' [7936 mbufs] ...
Port 0 init ... ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 0).
ice_vsi_config_outer_vlan_stripping(): Single VLAN mode (SVM) does not support qinq
done:
Port 1 init ... ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 1).
ice_vsi_config_outer_vlan_stripping(): Single VLAN mode (SVM) does not support qinq
done:

Checking link statusdone
Port 0 Link up at 25 Gbps FDX Autoneg
Port 1 Link up at 25 Gbps FDX Autoneg
APP: Finished Process Init.
Core 13 displaying statistics

---------------
PORTS
-----
Port 0: 'B4:96:91:E6:74:F6'     Port 1: 'B4:96:91:E6:74:F7'

Port 0 - rx:         0  tx:         0
Port 1 - rx:         0  tx:         0

CLIENTS
-------
Client  0 - rx:         0, rx_drop:         0
            tx:         0, tx_drop:         0
Client  1 - rx:         0, rx_drop:         0
            tx:         0, tx_drop:         0

```
core deployment:
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# ps -eLo pid,tid,psr,pri_baz,cls,pcpu,pcpu,comm | grep 66329
  66329   66329  12 120  TS 99.6 99.6 dpdk-mp_server
  66329   66330   2 120  TS  0.0  0.0 eal-intr-thread
  66329   66331   0 120  TS  0.0  0.0 rte_mp_handle
  66329   66332  13 120  TS  0.0  0.0 rte-worker-13
  66329   66333  16 120  TS  0.0  0.0 telemetry-v2
```

## Client
Client 1:
Run in lcore 14.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-mp_client -c 4000 -n 4 --proc-type=auto -- -n 0
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Auto-detected process type: SECONDARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket_66381_1e132147643a
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 0).
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 1).
APP: Finished Process Init.

Client process 0 handling packets
[Press Ctrl-C to quit ...]
```
core deployment:
Seems client doesn't have worker process, if there is only 1 isolated core in this coremask parameter.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# ps -eLo pid,tid,psr,pri_baz,cls,pcpu,pcpu,comm | grep 66381
  66381   66381  14 120  TS  100  100 dpdk-mp_client
  66381   66382   6 120  TS  0.0  0.0 eal-intr-thread
  66381   66383   9 120  TS  0.0  0.0 rte_mp_handle
```
Client 2:
Run in lcore 15.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-mp_client -c 8000 -n 4 --proc-type=auto -- -n 1
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Auto-detected process type: SECONDARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket_66384_1e2d99494f18
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 0).
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 1).
APP: Finished Process Init.

Client process 1 handling packets
[Press Ctrl-C to quit ...]
```
When there are 2 isolated RT cores, there will be one for control process dpdk-mp_client, another for rte-worker.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-mp_client -c C000 -n 4 --proc-type=auto -- -n 0
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Auto-detected process type: SECONDARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket_66494_1eecd542cdca
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 0).
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 1).
APP: Finished Process Init.

Client process 0 handling packets
[Press Ctrl-C to quit ...]
```
core deployment, with one rte-worker running in core 15:
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# ps -eLo pid,tid,psr,pri_baz,cls,pcpu,pcpu,comm | grep 66494
  66494   66494  14 120  TS  100  100 dpdk-mp_client
  66494   66495   2 120  TS  0.0  0.0 eal-intr-thread
  66494   66496   0 120  TS  0.0  0.0 rte_mp_handle
  66494   66497  15 120  TS  0.0  0.0 rte-worker-15
```
## How it works
If the server application dies and needs to be restarted, all client applications also need to be restarted, as there is no support in the server application for it to run as a secondary process.
Any client processes that need restarting can be restarted without affecting the server process.
The server process performs the network port and data structure initialization much as the symmetric multi-process application does when run as primary.
One additional enhancement in this sample application is that the server process stores its port configuration data in a memory zone in hugepage shared memory.

# Master-slave Multi-process
Should use l2fwd_fork as example, but didn't find it in newest DPDK, so replace with dpdk_l2fwd test case.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-l2fwd -c 3000 -n 4 -- -p 1
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_load_pkg_type(): Active package is: 1.3.26.0, ICE OS Default Package (single VLAN mode)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_load_pkg_type(): Active package is: 1.3.26.0, ICE OS Default Package (single VLAN mode)
TELEMETRY: No legacy callbacks, legacy socket not created
MAC updating enabled
Notice: odd number of ports in portmask.
Lcore 12: RX port 0 TX port 0
Initializing port 0... ice_set_rx_function(): Using AVX2 Vector Rx (port 0).
ice_vsi_config_outer_vlan_stripping(): Single VLAN mode (SVM) does not support qinq
done:
Port 0, MAC address: B4:96:91:E6:74:F6

Skipping disabled port 1

Checking link status..........................................................................................done
Port 0 Link down
L2FWD: lcore 13 has nothing to do
L2FWD: entering main loop on lcore 12
L2FWD:  -- lcoreid=12 portid=0
```
core deployment:
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# ps -eLo pid,tid,psr,pri_baz,cls,pcpu,pcpu,comm | grep 66875
  66875   66875  12 120  TS 98.8 98.8 dpdk-l2fwd
  66875   66876  10 120  TS  0.0  0.0 eal-intr-thread
  66875   66877   4 120  TS  0.0  0.0 rte_mp_handle
  66875   66878  13 120  TS  0.0  0.0 rte-worker-13
  66875   66879  16 120  TS  0.0  0.0 telemetry-v2
```
taskset to migrate process.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/cpu# taskset -p 0x3000 67070
pid 67070's current affinity mask: ff0fff
pid 67070's new affinity mask: 3000
root@ubuntu2204:/data/repo/dpdk_playground/cpu# taskset -p 0x3000 67072
pid 67072's current affinity mask: ff0fff
pid 67072's new affinity mask: 3000
```

# Multiple independent groups of processes
Secondary processes can use --file-prefix to select which primary process to connect to.

# References
https://doc.dpdk.org/guides/sample_app_ug/multi_process.html
https://doc.dpdk.org/guides/prog_guide/multi_proc_support.html
https://elixir.bootlin.com/dpdk/latest/source/examples/multi_process/
