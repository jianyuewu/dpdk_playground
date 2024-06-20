
# DPDK v23.07
Clean output:
```bash
# 8-9, 12-13 is Rx, 10-11, 14-15 is Tx.
root@ubuntu2204:/data/repo/dpdk-stable-22.11.1/build/app# /usr/local/bin/pktgen -l 7-15 -n 4 --proc-type auto --socket-mem 1024 -- -P -m "[8-9:10-11].0,[12-13:14-15].1"

*** Copyright(c) <2010-2023>, Intel Corporation. All rights reserved.
*** Pktgen  created by: Keith Wiles -- >>> Powered by DPDK <<<

EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Auto-detected process type: PRIMARY
EAL: Detected shared linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: VFIO support initialized
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.0 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.1 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.2 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.3 (socket -1)
TELEMETRY: No legacy callbacks, legacy socket not created
    0: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.0
    1: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.1
    2: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.2
    3: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.3

Initialize Port 0 -- TxQ 2, RxQ 2

Src MAC 02:09:c0:78:fd:fb
 <Promiscuous mode Enabled>
Initialize Port 1 -- TxQ 2, RxQ 2

Src MAC 02:09:c0:10:fd:bd
 <Promiscuous mode Enabled> <Promiscuous mode Enabled>

  RX processing lcore:   8 rx:  1 tx:  0
  RX processing lcore:   9 rx:  1 tx:  0
  TX processing lcore:  10 rx:  0 tx:  1
  TX processing lcore:  11 rx:  0 tx:  1
  RX processing lcore:  12 rx:  1 tx:  0
  RX processing lcore:  13 rx:  1 tx:  0
  TX processing lcore:  14 rx:  0 tx:  1
  TX processing lcore:  15 rx:  0 tx:  1

| Ports 0-3 of 4   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single
Link State          :         <UP-10000-FD>         <UP-10000-FD>     ---Total Rate---
Pkts/s Rx           :                     0                     0                    0
       Tx           :                     0                     0                    0
MBits/s Rx/Tx       :                   0/0                   0/0                  0/0
Pkts/s Rx Max       :                     0                     0                    0
       Tx Max       :                     0                     0                    0
Broadcast           :                     0                     0
Multicast           :                     0                     0
Sizes 64            :                     0                     0
      65-127        :                     0                     0
      128-255       :                     0                     0
      256-511       :                     0                     0
      512-1023      :                     0                     0
      1024-1518     :                     0                     0
Runts/Jumbos        :                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0
Total Rx Pkts       :                     0                     0
      Tx Pkts       :                     0                     0
      Rx/Tx MBs     :                   0/0                   0/0
TCP Flags           :                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:           64 / 64: 64           64 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / TCP:0001       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0
IP  Destination     :           192.168.1.1           192.168.0.1
    Source          :        192.168.0.1/24        192.168.1.1/24
MAC Destination     :     02:09:c0:10:fd:bd     02:09:c0:78:fd:fb
    Source          :     02:09:c0:78:fd:fb     02:09:c0:10:fd:bd
NUMA/Vend:ID/PCI    :-1/8086:1565/0000:05:1-1/8086:1565/0000:05:10.1
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:13754) ------------
```

# test with traffic
## Start with port 0
We can check result from MBits/s Rx/Tx row.
pkt size 1500B, around 8.4Gbps.
```bash
- Ports 0-3 of 4   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single
Link State          :         <UP-10000-FD>         <UP-10000-FD>     ---Total Rate---
Pkts/s Rx           :                     0            12,507,150           12,507,150
       Tx           :            12,507,158                     0           12,507,158
MBits/s Rx/Tx       :               0/8,404               8,404/0          8,404/8,404
Pkts/s Rx Max       :                     0            12,670,884           12,670,884
       Tx Max       :            12,670,877                     0           12,670,877
Broadcast           :                     0                     0
Multicast           :                     0                     0
Sizes 64            :                     0           704,366,224
      65-127        :                     0                     0
      128-255       :                     0                     0
      256-511       :                     0                     0
      512-1023      :                     0                     0
      1024-1518     :                     0                     0
Runts/Jumbos        :                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0
Total Rx Pkts       :                     0           703,870,970
      Tx Pkts       :           703,870,947                     0
      Rx/Tx MBs     :             0/473,001             473,001/0
TCP Flags           :                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:           64 / 64: 64           64 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / TCP:0001       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0
IP  Destination     :           192.168.1.1           192.168.0.1
    Source          :        192.168.0.1/24        192.168.1.1/24
MAC Destination     :     02:09:c0:d6:fc:eb     02:09:c0:74:1f:9e
    Source          :     02:09:c0:74:1f:9e     02:09:c0:d6:fc:eb
NUMA/Vend:ID/PCI    :-1/8086:1565/0000:05:1-1/8086:1565/0000:05:10.1
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:13349) ------------
```
Change to pkt size 8192, around 10Gbps.
```bash
Pktgen:/> set 0 size 8192
| Ports 0-3 of 4   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single
Link State          :         <UP-10000-FD>         <UP-10000-FD>     ---Total Rate---
Pkts/s Rx           :                     0               819,283              819,283
       Tx           :               819,283                     0              819,283
MBits/s Rx/Tx       :              0/10,080              10,080/0        10,080/10,080
Pkts/s Rx Max       :            11,886,380            12,647,942           23,772,164
       Tx Max       :            12,647,943            11,886,379           23,772,156
Broadcast           :                     0                     0
Multicast           :                     0                     0
Sizes 64            :         1,350,374,656         1,796,018,880
      65-127        :                     0                     0
      128-255       :                     0                     0
      256-511       :                     0                     0
      512-1023      :                     0                     0
      1024-1518     :                     0            31,729,829
Runts/Jumbos        :                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0
Total Rx Pkts       :         1,350,374,656         1,827,124,457
      Tx Pkts       :         1,827,124,561         1,350,374,656
      Rx/Tx MBs     :     907,451/1,589,648     1,589,647/907,451
TCP Flags           :                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:         1518 / 64: 64           64 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / TCP:0001       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0
IP  Destination     :           192.168.1.1           192.168.0.1
    Source          :        192.168.0.1/24        192.168.1.1/24
MAC Destination     :     02:09:c0:d2:88:93     02:09:c0:cb:f6:08
    Source          :     02:09:c0:cb:f6:08     02:09:c0:d2:88:93
NUMA/Vend:ID/PCI    :-1/8086:1565/0000:05:1-1/8086:1565/0000:05:10.1
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:14689) ------------
```

## start with port 1
Around 7.8Gbps.
```bash
- Ports 0-3 of 4   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single
Link State          :         <UP-10000-FD>         <UP-10000-FD>     ---Total Rate---
Pkts/s Rx           :            11,660,937            11,661,243           23,322,180
       Tx           :            11,661,239            11,660,936           23,322,175
MBits/s Rx/Tx       :           7,836/7,836           7,836/7,836        15,672/15,672
Pkts/s Rx Max       :            11,849,667            12,735,330           23,698,624
       Tx Max       :            12,735,335            11,849,661           23,698,618
Broadcast           :                     0                     0
Multicast           :                     0                     0
Sizes 64            :           213,791,072           446,364,588
      65-127        :                     0                     0
      128-255       :                     0                     0
      256-511       :                     0                     0
      512-1023      :                     0                     0
      1024-1518     :                     0                     0
Runts/Jumbos        :                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0
Total Rx Pkts       :           212,834,365           445,407,772
      Tx Pkts       :           445,407,739           212,834,557
      Rx/Tx MBs     :       143,024/299,314       299,314/143,024
TCP Flags           :                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:           64 / 64: 64           64 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / TCP:0001       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0
IP  Destination     :           192.168.1.1           192.168.0.1
    Source          :        192.168.0.1/24        192.168.1.1/24
MAC Destination     :     02:09:c0:10:fd:bd     02:09:c0:78:fd:fb
    Source          :     02:09:c0:78:fd:fb     02:09:c0:10:fd:bd
NUMA/Vend:ID/PCI    :-1/8086:1565/0000:05:1-1/8086:1565/0000:05:10.1
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:13754) ------------
```
## each core with one VF
```bash
root@ubuntu2204:/data/repo/dpdk-stable-22.11.1/build/app# /usr/local/bin/pktgen -l 7-15 -n 2 --proc-type auto --socket-mem 1024 -- -P -m "[8:9].0,[10:11].1,[12:13].2,[14:15].3"

*** Copyright(c) <2010-2023>, Intel Corporation. All rights reserved.
*** Pktgen  created by: Keith Wiles -- >>> Powered by DPDK <<<

EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Auto-detected process type: PRIMARY
EAL: Detected shared linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: VFIO support initialized
        EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.0 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.1 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.2 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.3 (socket -1)
        TELEMETRY: No legacy callbacks, legacy socket not created
    0: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.0
    1: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.1
    2: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.2
    3: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.3

Initialize Port 0 -- TxQ 1, RxQ 1

Src MAC 02:09:c0:16:2f:e4
 <Promiscuous mode Enabled>
Initialize Port 1 -- TxQ 1, RxQ 1

Src MAC 02:09:c0:f5:10:0b
 <Promiscuous mode Enabled> <Promiscuous mode Enabled>
Initialize Port 2 -- TxQ 1, RxQ 1

Src MAC 02:09:c0:48:70:0d
 <Promiscuous mode Enabled> <Promiscuous mode Enabled> <Promiscuous mode Enabled>
Initialize Port 3 -- TxQ 1, RxQ 1

Src MAC 02:09:c0:86:29:c5
 <Promiscuous mode Enabled> <Promiscuous mode Enabled> <Promiscuous mode Enabled> <Promiscuous mode Enabled>


  RX processing lcore:   8 rx:  1 tx:  0
  TX processing lcore:   9 rx:  0 tx:  1
  RX processing lcore:  10 rx:  1 tx:  0
  TX processing lcore:  11 rx:  0 tx:  1
  RX processing lcore:  12 rx:  1 tx:  0
  TX processing lcore:  13 rx:  0 tx:  1
  RX processing lcore:  14 rx:  1 tx:  0
  TX processing lcore:  15 rx:  0 tx:  1
```
### start port 0 and 1
```bash
Pktgen:/> set 0 size 8192
Pktgen:/> set 1 size 8192
Pktgen:/> start 0
Pktgen:/> start 1
| Ports 0-3 of 4   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single 2:P------      Single 3:P------      Single
Link State          :         <UP-10000-FD>         <UP-10000-FD>         <UP-10000-FD>         <UP-10000-FD>     ---Total Rate---
Pkts/s Rx           :                     0                     0                     0                     0                    0
       Tx           :                     0                     0                     0                     0                    0
MBits/s Rx/Tx       :                   0/0                   0/0                   0/0                   0/0                  0/0
Pkts/s Rx Max       :            10,117,626            10,656,033                     0                     0           20,229,662
       Tx Max       :            10,656,034            10,117,623                     0                     0           20,229,661
Broadcast           :                     0                     0                     0                     0
Multicast           :                     0                     0                     0                     0
Sizes 64            :           162,178,624           257,811,456                     0                     0
      65-127        :                     0                     0                     0                     0
      128-255       :                     0                     0                     0                     0
      256-511       :                     0                     0                     0                     0
      512-1023      :                     0                     0                     0                     0
      1024-1518     :                     0                     0                     0                     0
Runts/Jumbos        :                   0/0                   0/0                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0                   0/0                   0/0
Total Rx Pkts       :           162,178,624           257,811,456                     0                     0
      Tx Pkts       :           257,811,456           162,178,624                     0                     0
      Rx/Tx MBs     :       108,984/173,249       173,249/108,984                   0/0                   0/0
TCP Flags           :                .A....                .A....                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:           64 / 64: 64           64 / 64: 64           64 / 64: 64           64 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / TCP:0001       IPv4 / TCP:0001       IPv4 / TCP:0001       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0      0000/    0/    0      0000/    0/    0
IP  Destination     :           192.168.1.1           192.168.0.1           192.168.3.1           192.168.2.1
    Source          :        192.168.0.1/24        192.168.1.1/24        192.168.2.1/24        192.168.3.1/24
MAC Destination     :     02:09:c0:f5:10:0b     02:09:c0:16:2f:e4     02:09:c0:86:29:c5     02:09:c0:48:70:0d
    Source          :     02:09:c0:16:2f:e4     02:09:c0:f5:10:0b     02:09:c0:48:70:0d     02:09:c0:86:29:c5
NUMA/Vend:ID/PCI    :-1/8086:1565/0000:05:1-1/8086:1565/0000:05:1-1/8086:1565/0000:05:1-1/8086:1565/0000:05:10.3
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:14273) ------------
```
### also start port 2 and 3
Average is 3Gbps when use size 64B.
```bash
Pktgen:/> set 2 size 64
Pktgen:/> set 3 size 64
Pktgen:/> start 2
Pktgen:/> start 3
| Ports 0-v                                                                               /
  Port:Flav           0:P------      Single 1:P------      Single 2:P------      Single 3:P------      Single
Link State          :         <UP-10000-FD>         <UP-10000-FD>         <UP-10000-FD>         <UP-10000-FD>     ---Total Rate---
Pkts/s Rx           :             5,818,677             5,816,634             5,817,774             5,817,550           23,270,635
       Tx           :             5,816,633             5,818,674             5,817,552             5,817,779           23,270,638
MBits/s Rx/Tx       :           3,910/3,908           3,908/3,910           3,909/3,909           3,909/3,909        15,637/15,637
Pkts/s Rx Max       :            10,117,626            10,656,033            10,120,679            10,718,418           23,965,209
       Tx Max       :            10,656,034            10,117,623            10,718,422            10,120,682           23,965,212
Broadcast           :                     0                     0                     0                     0
Multicast           :                     0                     0                     0                     0
Sizes 64            :           511,686,807           613,175,709           488,996,527           523,885,183
      65-127        :                     0                     0                     0                     0
      128-255       :                     0                     0                     0                     0
      256-511       :                     0                     0                     0                     0
      512-1023      :                     0                     0                     0                     0
      1024-1518     :                     0                     0                     0                     0
Runts/Jumbos        :                   0/0                   0/0                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0                   0/0                   0/0
Total Rx Pkts       :           508,357,069           609,846,658           485,666,886           520,556,072
      Tx Pkts       :           609,846,641           508,357,164           520,556,055           485,666,989
      Rx/Tx MBs     :       341,615/409,816       409,816/341,616       326,368/349,813       349,813/326,368
TCP Flags           :                .A....                .A....                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:           64 / 64: 64           64 / 64: 64           64 / 64: 64           64 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / TCP:0001       IPv4 / TCP:0001       IPv4 / TCP:0001       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0      0000/    0/    0      0000/    0/    0
IP  Destination     :           192.168.1.1           192.168.0.1           192.168.3.1           192.168.2.1
    Source          :        192.168.0.1/24        192.168.1.1/24        192.168.2.1/24        192.168.3.1/24
MAC Destination     :     02:09:c0:f5:10:0b     02:09:c0:16:2f:e4     02:09:c0:86:29:c5     02:09:c0:48:70:0d
    Source          :     02:09:c0:16:2f:e4     02:09:c0:f5:10:0b     02:09:c0:48:70:0d     02:09:c0:86:29:c5
NUMA/Vend:ID/PCI    :-1/8086:1565/0000:05:1-1/8086:1565/0000:05:1-1/8086:1565/0000:05:1-1/8086:1565/0000:05:10.3
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:14273) ------------
```
After stop port 2 and 3, port 0 and 1 recover to 10Gbps.
```bash
Pktgen:/> stop 2
Pktgen:/> stop 3
Ports 0-3 of 4vvv<Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single 2:P------      Single 3:P------      Single
Link State          :         <UP-10000-FD>         <UP-10000-FD>         <UP-10000-FD>         <UP-10000-FD>     ---Total Rate---
Pkts/s Rx           :               812,782               812,554                     0                     0            1,625,336
       Tx           :               812,544               812,783                     0                     0            1,625,327
MBits/s Rx/Tx       :          10,000/9,997          9,997/10,000                   0/0                   0/0        19,998/19,998
Pkts/s Rx Max       :            10,117,626            10,656,033            10,120,679            10,718,418           23,965,209
       Tx Max       :            10,656,034            10,117,623            10,718,422            10,120,682           23,965,212
Broadcast           :                     0                     0                     0                     0
Multicast           :                     0                     0                     0                     0
Sizes 64            :           735,431,616           836,855,488           712,732,224           747,580,608
      65-127        :                     0                     0                     0                     0
      128-255       :                     0                     0                     0                     0
      256-511       :                     0                     0                     0                     0
      512-1023      :                     0                     0                     0                     0
      1024-1518     :           139,379,732           141,034,818            53,690,944            53,706,944
Runts/Jumbos        :                   0/0                   0/0                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0                   0/0                   0/0
Total Rx Pkts       :           874,557,726           977,636,725           766,423,168           801,287,552
      Tx Pkts       :           977,636,736           874,557,846           801,287,552           766,423,168
      Rx/Tx MBs     :   2,206,017/2,294,539   2,294,539/2,206,019   1,139,569/1,163,184   1,163,184/1,139,569
TCP Flags           :                .A....                .A....                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:         1518 / 64: 64         1518 / 64: 64         1518 / 64: 64         1518 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / TCP:0001       IPv4 / TCP:0001       IPv4 / TCP:0001       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0      0000/    0/    0      0000/    0/    0
IP  Destination     :           192.168.1.1           192.168.0.1           192.168.3.1           192.168.2.1
    Source          :        192.168.0.1/24        192.168.1.1/24        192.168.2.1/24        192.168.3.1/24
MAC Destination     :     02:09:c0:f5:10:0b     02:09:c0:16:2f:e4     02:09:c0:86:29:c5     02:09:c0:48:70:0d
    Source          :     02:09:c0:16:2f:e4     02:09:c0:f5:10:0b     02:09:c0:48:70:0d     02:09:c0:86:29:c5
NUMA/Vend:ID/PCI    :-1/8086:1565/0000:05:1-1/8086:1565/0000:05:1-1/8086:1565/0000:05:1-1/8086:1565/0000:05:10.3
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:14273) ------------
```

pkt size 8192, Average is 5Gbps.
```bash
Pktgen:/> set 2 size 64
Pktgen:/> set 3 size 64
Pktgen:/> start 2
Pktgen:/> start 3
Ports 0-3 of 4vvv<Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single 2:P------      Single 3:P------      Single
Link State          :         <UP-10000-FD>         <UP-10000-FD>         <UP-10000-FD>         <UP-10000-FD>     ---Total Rate---
Pkts/s Rx           :               406,391               406,390               412,893               412,893            1,638,567
       Tx           :               406,390               406,390               412,893               412,893            1,638,566
MBits/s Rx/Tx       :           5,000/5,000           5,000/5,078           5,080/5,080           5,080/5,080        20,160/20,239
Pkts/s Rx Max       :            10,117,626            10,656,033            10,120,679            10,718,418           23,965,209
       Tx Max       :            10,656,034            10,117,623            10,718,422            10,120,682           23,965,212
Broadcast           :                     0                     0                     0                     0
Multicast           :                     0                     0                     0                     0
Sizes 64            :           735,431,616           836,855,488           712,732,224           747,580,608
      65-127        :                     0                     0                     0                     0
      128-255       :                     0                     0                     0                     0
      256-511       :                     0                     0                     0                     0
      512-1023      :                     0                     0                     0                     0
      1024-1518     :            90,244,305            91,492,975             9,548,437             9,972,479
Runts/Jumbos        :                   0/0                   0/0                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0                   0/0                   0/0
Total Rx Pkts       :           825,312,586           927,985,111           721,923,797           757,196,206
      Tx Pkts       :           927,985,163           825,312,645           757,196,258           721,923,857
      Rx/Tx MBs     :   1,600,105/1,683,626   1,683,625/1,600,185       592,049/620,685       620,684/592,049
TCP Flags           :                .A....                .A....                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:         1518 / 64: 64         1518 / 64: 64         1518 / 64: 64         1518 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / TCP:0001       IPv4 / TCP:0001       IPv4 / TCP:0001       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0      0000/    0/    0      0000/    0/    0
IP  Destination     :           192.168.1.1           192.168.0.1           192.168.3.1           192.168.2.1
    Source          :        192.168.0.1/24        192.168.1.1/24        192.168.2.1/24        192.168.3.1/24
MAC Destination     :     02:09:c0:f5:10:0b     02:09:c0:16:2f:e4     02:09:c0:86:29:c5     02:09:c0:48:70:0d
    Source          :     02:09:c0:16:2f:e4     02:09:c0:f5:10:0b     02:09:c0:48:70:0d     02:09:c0:86:29:c5
NUMA/Vend:ID/PCI    :-1/8086:1565/0000:05:1-1/8086:1565/0000:05:1-1/8086:1565/0000:05:1-1/8086:1565/0000:05:10.3
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:14273) ------------
```

# Only send with one port
Just specify in -m with single port, with some Rx/Tx cores.
## core 8 both Tx and Rx
```bash
root@ubuntu2204:/data/repo# pktgen -v -l 7-8 --proc-type auto --log-level=8 -- -P -v -m "[8:].0"

*** Copyright(c) <2010-2023>, Intel Corporation. All rights reserved.
*** Pktgen  created by: Keith Wiles -- >>> Powered by DPDK <<<

EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: RTE Version: 'DPDK 23.07.0-rc1'
EAL: Auto-detected process type: PRIMARY
EAL: Detected shared linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: VFIO support initialized
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.0 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.1 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.2 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.3 (socket -1)
TELEMETRY: No legacy callbacks, legacy socket not created
>>> Packet Max Burst 128/128, RX Desc 1024, TX Desc 2048, mbufs/port 24576, mbuf cache 128
    0: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.0
    1: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.1
    2: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.2
    3: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.3


=== port to lcore mapping table (# lcores 2) ===
   lcore:    7       8      Total
port   0: ( D: T) ( 1: 1) = ( 1: 1)
Total   : ( 0: 0) ( 1: 1)
  Display and Timer on lcore 7, rx:tx counts per port/lcore

>>>> Configuring 4 ports, MBUF Size 10240, MBUF Cache Size 128
Lcore:
    8, RX-TX
                RX_cnt( 1): (pid= 0:qid= 0)
                TX_cnt( 1): (pid= 0:qid= 0)

Port :
    0, nb_lcores  1, private 0x556e20291dc0, lcores:  8

Initialize Port 0 -- TxQ 1, RxQ 1                                                                                                                                                                                                                 [62/990]
** Device Info (0000:05:10.0, if_index:0, flags 00000064) **
   min_rx_bufsize : 1024  max_rx_pktlen     : 9728  hash_key_size :   40
   max_rx_queues  :    4  max_tx_queues     :    4  max_vfs       :    0
   max_mac_addrs  :  128  max_hash_mac_addrs: 4096  max_vmdq_pools:   64
   vmdq_queue_base:    0  vmdq_queue_num    :    0  vmdq_pool_base:    0
   nb_rx_queues   :    0  nb_tx_queues      :    0  speed_capa    : 00000000

   flow_type_rss_offloads:0000000000038d34  reta_size             :   64
   rx_offload_capa       :VLAN_STRIP IPV4_CKSUM UDP_CKSUM TCP_CKSUM VLAN_FILTER SCATTER KEEP_CRC RSS_HASH
   tx_offload_capa       :VLAN_INSERT IPV4_CKSUM UDP_CKSUM TCP_CKSUM SCTP_CKSUM TCP_TSO MULTI_SEGS
   rx_queue_offload_capa :0000000000000001  tx_queue_offload_capa :0000000000000000
   dev_capa              :0000000000000000

  RX Conf:
     pthresh        :    8 hthresh          :    8 wthresh        :    0
     Free Thresh    :   32 Drop Enable      :    0 Deferred Start :    0
     offloads       :0000000000000000
  TX Conf:
     pthresh        :   32 hthresh          :    0 wthresh        :    0
     Free Thresh    :   32 RS Thresh        :   32 Deferred Start :    0
     offloads       :0000000000000000
  Rx: descriptor Limits
     nb_max         : 4096  nb_min          :   32  nb_align      :    8
     nb_seg_max     :    0  nb_mtu_seg_max  :    0
  Tx: descriptor Limits
     nb_max         : 4096  nb_min          :   32  nb_align      :    8
     nb_seg_max     :   40  nb_mtu_seg_max  :   40
  Rx: Port Config
     burst_size     :    0  ring_size       :    0  nb_queues     :    0
  Tx: Port Config
     burst_size     :    0  ring_size       :    0  nb_queues     :    0
  Switch Info: (null)
     domain_id      :65535  port_id         :    0

    Create: 'Default RX  0:0 ' - Memory used (MBUFs  24576 x size  10240) = 245761 KB
      Set RX queue stats mapping pid 0, q 0, lcore 8


    Create: 'Latency TX  0:0 ' - Memory used (MBUFs    512 x size  10240) =   5121 KB
    Create: 'Special TX  0:0 ' - Memory used (MBUFs    512 x size  10240) =   5121 KB

    Create: 'Default TX  0:0 ' - Memory used (MBUFs  24576 x size  10240) = 245761 KB
    Create: 'Range TX    0:0 ' - Memory used (MBUFs  24576 x size  10240) = 245761 KB
    Create: 'Rate TX     0:0 ' - Memory used (MBUFs  24576 x size  10240) = 245761 KB
    Create: 'Sequence TX 0:0 ' - Memory used (MBUFs  24576 x size  10240) = 245761 KB

                                                                       Port memory used = 1239047 KB
Src MAC 02:09:c0:e5:dc:b2
 <Promiscuous mode Enabled>
                                                                      Total memory used = 1239047 KB


=== Display processing on lcore 7
  RX/TX processing lcore:   8 rx:  1 tx:  1
For RX found 1 port(s) for lcore 8
For TX found 1 port(s) for lcore 8

/ Ports 0-3 of 4siz<Main Page>  Copyright(c) <2010-2023>, Intel Corporation                                                                                                                                                                        [0/989]
  Port:Flags        : 0:P------      Single
Link State          :         <UP-10000-FD>     ---Total Rate---
Pkts/s Rx           :                     0                    0
       Tx           :               812,780              812,780
MBits/s Rx/Tx       :              0/10,000             0/10,000
Pkts/s Rx Max       :                     0                    0
       Tx Max       :            10,642,260           10,642,260
Broadcast           :                     0
Multicast           :                     0
Sizes 64            :                     0
      65-127        :                     0
      128-255       :                     0
      256-511       :                     0
      512-1023      :                     0
      1024-1518     :                     0
Runts/Jumbos        :                   0/0
ARP/ICMP Pkts       :                   0/0
Errors Rx/Tx        :                   0/0
Total Rx Pkts       :                     0
      Tx Pkts       :            82,129,878
      Rx/Tx MBs     :             0/329,339
TCP Flags           :                .A....
TCP Seq/Ack         :           74616/74640
Pattern Type        :               abcd...
Tx Count/% Rate     :         Forever /100%
Pkt Size/Rx:Tx Burst:         1518 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0
IP  Destination     :           192.168.1.1
    Source          :        192.168.0.1/24
MAC Destination     :     00:00:00:00:00:00
    Source          :     02:09:c0:e5:dc:b2
NUMA/Vend:ID/PCI    :-1/8086:1565/0000:05:10.0
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:10980) ------------


** Version: DPDK 23.07.0-rc1, Command Line Interface without timers
Pktgen:/> str
Pktgen:/> set 0 size 8192
```
## Rx with core 8 and Tx with core 9
```bash
root@ubuntu2204:/data/repo# pktgen -v -l 7-9 --proc-type auto --log-level=8 -- -P -v -m "[8:9].0"

*** Copyright(c) <2010-2023>, Intel Corporation. All rights reserved.
*** Pktgen  created by: Keith Wiles -- >>> Powered by DPDK <<<

EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: RTE Version: 'DPDK 23.07.0-rc1'
EAL: Auto-detected process type: PRIMARY
EAL: Detected shared linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: VFIO support initialized
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.0 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.1 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.2 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.3 (socket -1)
TELEMETRY: No legacy callbacks, legacy socket not created
>>> Packet Max Burst 128/128, RX Desc 1024, TX Desc 2048, mbufs/port 24576, mbuf cache 128
    0: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.0
    1: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.1
    2: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.2
    3: net_ixgbe_vf    0     -1   8086:1565/0000:05:10.3


=== port to lcore mapping table (# lcores 3) ===
   lcore:    7       8       9      Total
port   0: ( D: T) ( 1: 0) ( 0: 1) = ( 1: 1)
Total   : ( 0: 0) ( 1: 0) ( 0: 1)
  Display and Timer on lcore 7, rx:tx counts per port/lcore

>>>> Configuring 4 ports, MBUF Size 10240, MBUF Cache Size 128
Lcore:
    8, RX-Only
                RX_cnt( 1): (pid= 0:qid= 0)
    9, TX-Only
                TX_cnt( 1): (pid= 0:qid= 0)

    0, nb_lcores  2, private 0x56397e57adc0, lcores:  8  9


Initialize Port 0 -- TxQ 1, RxQ 1
** Device Info (0000:05:10.0, if_index:0, flags 00000064) **
   min_rx_bufsize : 1024  max_rx_pktlen     : 9728  hash_key_size :   40
   max_rx_queues  :    4  max_tx_queues     :    4  max_vfs       :    0
   max_mac_addrs  :  128  max_hash_mac_addrs: 4096  max_vmdq_pools:   64
   vmdq_queue_base:    0  vmdq_queue_num    :    0  vmdq_pool_base:    0
   nb_rx_queues   :    0  nb_tx_queues      :    0  speed_capa    : 00000000

   flow_type_rss_offloads:0000000000038d34  reta_size             :   64
   rx_offload_capa       :VLAN_STRIP IPV4_CKSUM UDP_CKSUM TCP_CKSUM VLAN_FILTER SCATTER KEEP_CRC RSS_HASH
   tx_offload_capa       :VLAN_INSERT IPV4_CKSUM UDP_CKSUM TCP_CKSUM SCTP_CKSUM TCP_TSO MULTI_SEGS
   rx_queue_offload_capa :0000000000000001  tx_queue_offload_capa :0000000000000000
   dev_capa              :0000000000000000

  RX Conf:
     pthresh        :    8 hthresh          :    8 wthresh        :    0
     Free Thresh    :   32 Drop Enable      :    0 Deferred Start :    0
     offloads       :0000000000000000
  TX Conf:
     pthresh        :   32 hthresh          :    0 wthresh        :    0
     Free Thresh    :   32 RS Thresh        :   32 Deferred Start :    0
     offloads       :0000000000000000
  Rx: descriptor Limits
     nb_max         : 4096  nb_min          :   32  nb_align      :    8
     nb_seg_max     :    0  nb_mtu_seg_max  :    0
  Tx: descriptor Limits
     nb_max         : 4096  nb_min          :   32  nb_align      :    8
     nb_seg_max     :   40  nb_mtu_seg_max  :   40
  Rx: Port Config
     burst_size     :    0  ring_size       :    0  nb_queues     :    0
  Tx: Port Config
     burst_size     :    0  ring_size       :    0  nb_queues     :    0
  Switch Info: (null)
     domain_id      :65535  port_id         :    0

    Create: 'Default RX  0:0 ' - Memory used (MBUFs  24576 x size  10240) = 245761 KB
      Set RX queue stats mapping pid 0, q 0, lcore 8


    Create: 'Latency TX  0:0 ' - Memory used (MBUFs    512 x size  10240) =   5121 KB
    Create: 'Special TX  0:0 ' - Memory used (MBUFs    512 x size  10240) =   5121 KB

    Create: 'Default TX  0:0 ' - Memory used (MBUFs  24576 x size  10240) = 245761 KB
    Create: 'Range TX    0:0 ' - Memory used (MBUFs  24576 x size  10240) = 245761 KB
    Create: 'Rate TX     0:0 ' - Memory used (MBUFs  24576 x size  10240) = 245761 KB
    Create: 'Sequence TX 0:0 ' - Memory used (MBUFs  24576 x size  10240) = 245761 KB

                                                                       Port memory used = 1239047 KB
Src MAC 02:09:c0:62:19:f2
 <Promiscuous mode Enabled>
                                                                      Total memory used = 1239047 KB


=== Display processing on lcore 7
  RX processing lcore:   8 rx:  1 tx:  0
For RX found 1 port(s) for lcore 8
  TX processing lcore:   9 rx:  0 tx:  1
For TX found 1 port(s) for lcore 9

```

## Test with 100MB traffic
```bash
- Ports 0-3 of 4   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation                                                                                                                              [0/220]
  Port:Flags        : 0:P------      Single
Link State          :         <UP-10000-FD>     ---Total Rate---
Pkts/s Rx           :                     0                    0
       Tx           :               150,208              150,208
MBits/s Rx/Tx       :                 0/100                0/100
Pkts/s Rx Max       :                     1                    1
       Tx Max       :               152,384              152,384
Broadcast           :                     0
Multicast           :                    18
Sizes 64            :                     0
      65-127        :                     0
      128-255       :                     0
      256-511       :                    18
      512-1023      :                     0
      1024-1518     :                     0
Runts/Jumbos        :                   0/0
ARP/ICMP Pkts       :                   0/0
Errors Rx/Tx        :                   0/0
Total Rx Pkts       :                    18
      Tx Pkts       :             3,730,624
      Rx/Tx MBs     :               0/2,506
TCP Flags           :                .A....
TCP Seq/Ack         :           74616/74640
Pattern Type        :               abcd...
Tx Count/% Rate     :           Forever /1%
Pkt Size/Rx:Tx Burst:           64 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678
Pkt Type:VLAN ID    :      IPv4 / ICMP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0
IP  Destination     :           192.168.1.1
    Source          :        192.168.0.1/24
MAC Destination     :     02:09:c0:79:aa:61
    Source          :     02:09:c0:79:aa:60
NUMA/Vend:ID/PCI    :-1/8086:1565/0000:05:10.0
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:25657) ------------

** Version: DPDK 23.07.0-rc1, Command Line Interface without timers
# Here rate 1 means 1%, so 10G eth is 100M
Pktgen:/> set 0 rate 1
Pktgen:/> set 0 src mac 02:09:c0:79:aa:60
Pktgen:/> set 0 dst mac 02:09:c0:79:aa:61
Pktgen:/> set 0 type ipv4
Pktgen:/> set 0 proto icmp
Pktgen:/> str
```
Check packet content
```bash
Pktgen:/> set 0 dump 10
# Check log page to see the pkt content
Pktgen:/> page log
\                  <Logged messages>  Copyright(c) <2010-2023>, Intel Corporation                                                                                                                        [0/385]
L     Time Function                         Message                                                     
I 14:37:01 pktgen_print_packet_dump         Port 0, packet with length 334:
        000000: ff ff ff ff ff ff 9c 69  b4 63 73 cb 08 00 45 c0        .......i.cs...E.
        000010: 01 3c 00 00 40 00 40 11  38 f2 00 00 00 00 ff ff        .<..@.@.8.......
        000020: ff ff 00 44 00 43 01 28  43 f9 01 01 06 00 b3 11        ...D.C.(C.......
        000030: bd 35 00 07 00 00 00 00  00 00 00 00 00 00 00 00        .5..............
        000040: 00 00 00 00 00 00 9c 69  b4 63 73 cb 00 00 00 00        .......i.cs.....                
        000050: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        000060: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        000070: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        000080: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        000090: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        0000a0: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        0000b0: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        0000c0: 00 00 00 00 00             
I 14:37:09 pktgen_print_packet_dump         Port 0, packet with length 334:                             
        000000: ff ff ff ff ff ff 9c 69  b4 63 73 cb 08 00 45 c0        .......i.cs...E.                
        000010: 01 3c 00 00 40 00 40 11  38 f2 00 00 00 00 ff ff        .<..@.@.8.......                
        000020: ff ff 00 44 00 43 01 28  3b 7d 01 01 06 00 12 b9        ...D.C.(;}......                
        000030: 66 01 00 10 00 00 00 00  00 00 00 00 00 00 00 00        f...............                
        000040: 00 00 00 00 00 00 9c 69  b4 63 73 cb 00 00 00 00        .......i.cs.....                
        000050: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        000060: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        000070: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        000080: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        000090: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        0000a0: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        0000b0: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00        ................                
        0000c0: 00 00 00 00 00             
Pktgen:/> page main
```

