

# Start pktgen cmdline
Firstly, need bind with ethernet card device.
Run with core 7-15, while 8-15 are isolated cores, and core 7 is used for control core.
8-9,10-11 cores are used for port 0, 12-13,14-15 are used for port 1.
```bash
root@ubuntu2204:/data/repo/pktgen-dpdk# ./usr/local/bin/pktgen -l 7-15 -n 4 --proc-type auto --socket-mem 1024 -- -P -m "[8-9:10-11].0,[12-13:14-15].1"

*** Copyright(c) <2010-2023>, Intel Corporation. All rights reserved.
*** Pktgen  created by: Keith Wiles -- >>> Powered by DPDK <<<

EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Auto-detected process type: PRIMARY
EAL: Detected shared linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_load_pkg_type(): Active package is: 1.3.26.0, ICE OS Default Package (single VLAN mode)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_load_pkg_type(): Active package is: 1.3.26.0, ICE OS Default Package (single VLAN mode)
TELEMETRY: No legacy callbacks, legacy socket not created
    0: net_ice         0     -1   8086:159b/0000:01:00.0
    1: net_ice         0     -1   8086:159b/0000:01:00.1

Initialize Port 0 -- TxQ 2, RxQ 2

Src MAC b4:96:91:e6:74:f6
 <Promiscuous mode Enabled>
Initialize Port 1 -- TxQ 2, RxQ 2

Src MAC b4:96:91:e6:74:f7
 <Promiscuous mode Enabled> <Promiscuous mode Enabled>

ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 0).
ice_vsi_config_outer_vlan_stripping(): Single VLAN mode (SVM) does not support qinq
ice_set_rx_function(): Using AVX2 OFFLOAD Vector Rx (port 1).
ice_vsi_config_outer_vlan_stripping(): Single VLAN mode (SVM) does not support qinq

  RX processing lcore:   8 rx:  1 tx:  0
  RX processing lcore:   9 rx:  1 tx:  0
  TX processing lcore:  10 rx:  0 tx:  1
  TX processing lcore:  11 rx:  0 tx:  1
  RX processing lcore:  12 rx:  1 tx:  0
  RX processing lcore:  13 rx:  1 tx:  0
  TX processing lcore:  14 rx:  0 tx:  1
  TX processing lcore:  15 rx:  0 tx:  1
```
Output is:
```bash
/ Ports 0-1 of 2   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation
Link State          : 0:P------      Single 1:P------      Single     ---Total Rate---
Pkts/s Rx           :         <UP-25000-FD>         <UP-25000-FD>                    0
       Tx           :                     0                     0                    0
MBits/s Rx/Tx       :                     0                     0                    0
Pkts/s Rx Max       :                   0/0                   0/0                  0/0
       Tx Max       :                     0                     0                    0
Broadcast           :                     0                     0                    0
Multicast           :                     0                     0
Sizes 64            :                     0                     0
      65-127        :                     0                     0
      128-255       :                     0                     0
      256-511       :                     0                     0
      512-1023      :                     0                     0
      1024-1518     :                     0                     0
Runts/Jumbos        :                     0                     0
ARP/ICMP Pkts       :                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0
Total Rx Pkts       :                   0/0                   0/0
      Tx Pkts       :                     0                     0
      Rx/Tx MBs     :                     0                     0
TCP Flags           :                   0/0                   0/0
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
MAC Destination     :     b4:96:91:e6:74:f7     b4:96:91:e6:74:f6
    Source          :     b4:96:91:e6:74:f6     b4:96:91:e6:74:f7
NUMA/Vend:ID/PCI    :-1/8086:159b/0000:01:0-1/8086:159b/0000:01:00.1
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:5816) -------------

** Version: DPDK 23.07.0-rc1, Command Line Interface without timers
Pktgen:/>
```

# test with traffic
## Start with port 0
```bash
Pktgen:/> start 0
```
output is:
```bash
| Ports 0-1 of 2   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single
Link State          :         <UP-25000-FD>         <UP-25000-FD>     ---Total Rate---
Pkts/s Rx           :                     0            28,687,391           28,687,391
       Tx           :            28,687,536                     0           28,687,536
MBits/s Rx/Tx       :              0/19,278              19,277/0        19,277/19,278
Pkts/s Rx Max       :            29,653,722            29,615,265           59,136,906
       Tx Max       :            29,620,499            29,653,898           59,137,221
Broadcast           :                     0                     0
Multicast           :                     0                     0
Sizes 64            :           237,311,488         3,413,305,532
      65-127        :                     0                     0
      128-255       :                     0                     0
      256-511       :                     0                     0
      512-1023      :                     0                     0
      1024-1518     :                     0                     0
Runts/Jumbos        :                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0
Total Rx Pkts       :           237,311,488         3,413,303,223
      Tx Pkts       :         3,413,371,356           237,311,488
      Rx/Tx MBs     :     159,473/2,293,785     2,293,773/159,473
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
MAC Destination     :     b4:96:91:e6:74:f7     b4:96:91:e6:74:f6
    Source          :     b4:96:91:e6:74:f6     b4:96:91:e6:74:f7
NUMA/Vend:ID/PCI    :-1/8086:159b/0000:01:0-1/8086:159b/0000:01:00.1
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:6228) -------------
```

Stop traffic:
```bash
Pktgen:/> stop 0
```

## start with port 1
We can see that with default 64B payload, it can reach max 19Gbps, so configure with bigger size like 8192, to reach 25Gbps.
```bash
Pktgen:/> set 1 size 8192
Pktgen:/> start 1
```
output is:
```bash
- Ports 0-1 of 2   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single
Link State          :         <UP-25000-FD>         <UP-25000-FD>     ---Total Rate---
Pkts/s Rx           :             2,031,867                     0            2,031,867
       Tx           :                     0             2,031,865            2,031,865
MBits/s Rx/Tx       :              25,000/0              0/25,000        25,000/25,000
Pkts/s Rx Max       :             2,063,995                     0            2,063,995
       Tx Max       :                     0             2,063,995            2,063,995
Broadcast           :                     0                     0
Multicast           :                     0                     0
Sizes 64            :                     0                     0
      65-127        :                     0                     0
      128-255       :                     0                     0
      256-511       :                     0                     0
      512-1023      :                     0                     0
      1024-1518     :            61,696,604                     0
Runts/Jumbos        :                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0
Total Rx Pkts       :            59,709,769                     0
      Tx Pkts       :                     0            59,709,802
      Rx/Tx MBs     :             734,668/0             0/734,669
TCP Flags           :                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:           64 / 64: 64         1518 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / TCP:0001       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0
IP  Destination     :           192.168.1.1           192.168.0.1
    Source          :        192.168.0.1/24        192.168.1.1/24
MAC Destination     :     b4:96:91:e6:74:f7     b4:96:91:e6:74:f6
    Source          :     b4:96:91:e6:74:f6     b4:96:91:e6:74:f7
NUMA/Vend:ID/PCI    :-1/8086:159b/0000:01:0-1/8086:159b/0000:01:00.1
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:6385) -------------
```
We can see that it almost reach at 25Gbps, because pktgen calc 24Bytes(7preamble+1sfd+4crc+12ifg) extra ethernet cost.
Note testpmd only calc 4B crc, instead of 24Byes.
This build is without debug.

## start with both port 0 and 1
```bash
# Configure src IP and mac, note src IP address should contain subnet value, default /32 for IPv4
Pktgen:/> set 0 src ip 192.168.31.200/24
Pktgen:/> set 0 src mac 02:00:00:00:00:00
# Use udp to send
Pktgen:/> set 0 proto udp
# Send to target IP 192.168.31.201 and mac 02:00:00:00:00:01
Pktgen:/> set 0 dst ip 192.168.31.201
Pktgen:/> set 0 dst mac 02:00:00:00:00:01
# size container 4B crc, so total is 8192 - 4
Pktgen:/> set 0 size 8192
# Use port 1 to recv, port 1 can also run with testpmd instead of pktgen
Pktgen:/> set 1 src ip 192.168.31.201/24
Pktgen:/> set 1 src mac 02:00:00:00:00:01
# Start port 0
Pktgen:/> start 0
```
output is:
```bash
| Ports 0-1 of 2   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single
Link State          :         <UP-25000-FD>         <UP-25000-FD>     ---Total Rate---
Pkts/s Rx           :                     0             2,063,696            2,063,696
       Tx           :             2,063,694                     0            2,063,694
MBits/s Rx/Tx       :              0/25,391              25,391/0        25,391/25,391
Pkts/s Rx Max       :                     0             2,064,022            2,064,022
       Tx Max       :             2,064,023                     0            2,064,023
Broadcast           :                     0                     0
Multicast           :                     0                     0
Sizes 64            :                     0                     0
      65-127        :                     0                     0
      128-255       :                     0                     0
      256-511       :                     0                     0
      512-1023      :                     0                     0
      1024-1518     :                     0            60,394,893
Runts/Jumbos        :                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0
Total Rx Pkts       :                     0            59,354,692
      Tx Pkts       :            59,354,568                     0
      Rx/Tx MBs     :             0/730,298             730,300/0
TCP Flags           :                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:         1518 / 64: 64           64 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / UDP:0001       IPv4 / TCP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0
IP  Destination     :        192.168.31.201           192.168.0.1
    Source          :     192.168.31.200/24     192.168.31.201/24
MAC Destination     :     02:00:00:00:00:01     b4:96:91:e6:74:f6
    Source          :     02:00:00:00:00:00     02:00:00:00:00:01
NUMA/Vend:ID/PCI    :-1/8086:159b/0000:01:0-1/8086:159b/0000:01:00.1
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:6667) -------------
```
Port 1 also start transmit.
```bash
Pktgen:/> set 1 dst ip 192.168.31.200
Pktgen:/> set 1 dst mac 02:00:00:00:00:00
Pktgen:/> set 1 size 8192
Pktgen:/> set 1 proto udp
# Str means start all ports transmit
Pktgen:/> str
```
We can see total throughput is smaller, around 20Gbps, < 25Gbps(single Tx/Rx).
```bash
- Ports 0-1 of 2   <Main Page>  Copyright(c) <2010-2023>, Intel Corporation
  Port:Flags        : 0:P------      Single 1:P------      Single
Link State          :         <UP-25000-FD>         <UP-25000-FD>     ---Total Rate---
Pkts/s Rx           :             1,631,744             1,615,220            3,246,964
       Tx           :             1,615,227             1,631,731            3,246,958
MBits/s Rx/Tx       :         20,076/19,873         19,873/20,076        39,950/39,950
Pkts/s Rx Max       :             1,658,790             2,064,220            3,297,621
       Tx Max       :             2,064,219             1,658,804            3,297,615
Broadcast           :                     0                     0
Multicast           :                     0                     0
Sizes 64            :                     0                     0
      65-127        :                     0                     0
      128-255       :                     0                     0
      256-511       :                     0                     0
      512-1023      :                     0                     0
      1024-1518     :            89,313,140           220,433,408
Runts/Jumbos        :                   0/0                   0/0
ARP/ICMP Pkts       :                   0/0                   0/0
Errors Rx/Tx        :                   0/0                   0/0
Total Rx Pkts       :            88,291,456           219,418,243
      Tx Pkts       :           219,418,099            88,291,465
      Rx/Tx MBs     :   1,086,338/2,699,720   2,699,722/1,086,338
TCP Flags           :                .A....                .A....
TCP Seq/Ack         :           74616/74640           74616/74640
Pattern Type        :               abcd...               abcd...
Tx Count/% Rate     :         Forever /100%         Forever /100%
Pkt Size/Rx:Tx Burst:         1518 / 64: 64         1518 / 64: 64
TTL/Port Src/Dest   :        64/ 1234/ 5678        64/ 1234/ 5678
Pkt Type:VLAN ID    :       IPv4 / UDP:0001       IPv4 / UDP:0001
802.1p CoS/DSCP/IPP :             0/  0/  0             0/  0/  0
VxLAN Flg/Grp/vid   :      0000/    0/    0      0000/    0/    0
IP  Destination     :        192.168.31.201        192.168.31.200
    Source          :     192.168.31.200/24     192.168.31.201/24
MAC Destination     :     02:00:00:00:00:01     02:00:00:00:00:00
    Source          :     02:00:00:00:00:00     02:00:00:00:00:01
NUMA/Vend:ID/PCI    :-1/8086:159b/0000:01:0-1/8086:159b/0000:01:00.1
-- Pktgen 23.03.1 (DPDK 23.07.0-rc1)  Powered by DPDK  (pid:6882) -------------
```
Stop all ports transfer and quit.
```bash
# clear screen
Pktgen:/> clr
# stop all ports transfer
Pktgen:/> stp
# quit pktgen
Pktgen:/> quit
```
