
# Capture rx only
```bash
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-pdump -n 4 -- --pdump 'port=0,queue=*,rx-dev=./rx-pcap.pcap'
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket_61999_10409ff2f035
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_set_rx_function(): Using AVX2 Vector Rx (port 0).
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_set_rx_function(): Using AVX2 Vector Rx (port 1).
Port 2 MAC: 02 70 63 61 70 03
 core (0), capture for (1) tuples
 - port 0 device ((null)) queue 65535
^C

Signal 2 received, preparing to exit...
##### PDUMP DEBUG STATS #####
 -packets dequeued:                     12577124
 -packets transmitted to vdev:          12577124
 -packets freed:                        0
```
It will listen to port 0, all queues, save capture results to file rx-pcap.pcap.
Note, don't capture too long, as it will generate big file, and capture file will cause OOM in system.

## pcap content
We can also use wireshark to open the captured file.
```bash
apt install -y wireshark
```
One packet output is:
```bash
Frame 1: 64 bytes on wire (512 bits), 64 bytes captured (512 bits)
Ethernet II, Src: IntelCor_e6:74:f7 (b4:96:91:e6:74:f7), Dst: 02:00:00:00:00:01 (02:00:00:00:00:01)
    Destination: 02:00:00:00:00:01 (02:00:00:00:00:01)
        Address: 02:00:00:00:00:01 (02:00:00:00:00:01)
        .... ..1. .... .... .... .... = LG bit: Locally administered address (this is NOT the factory default)
        .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
    Source: IntelCor_e6:74:f7 (b4:96:91:e6:74:f7)
        Address: IntelCor_e6:74:f7 (b4:96:91:e6:74:f7)
        .... ..0. .... .... .... .... = LG bit: Globally unique address (factory default)
        .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
    Type: IPv4 (0x0800)
Internet Protocol Version 4, Src: 198.18.0.1, Dst: 198.18.0.2
    0100 .... = Version: 4
    .... 0101 = Header Length: 20 bytes (5)
    Differentiated Services Field: 0x00 (DSCP: CS0, ECN: Not-ECT)
    Total Length: 50
    Identification: 0x0000 (0)
    Flags: 0x00
    ...0 0000 0000 0000 = Fragment Offset: 0
    Time to Live: 64
    Protocol: UDP (17)
    Header Checksum: 0xee93 [validation disabled]
    [Header checksum status: Unverified]
    Source Address: 198.18.0.1
    Destination Address: 198.18.0.2
User Datagram Protocol, Src Port: 9, Dst Port: 9
    Source Port: 9
    Destination Port: 9
    Length: 30
    Checksum: 0x0000 [zero-value ignored]
    [Stream index: 0]
    [Timestamps]
    UDP payload (22 bytes)
Data (22 bytes)
    Data: 00000000000000000000000000000000000000000000
    [Length: 22]
```

# capture both Rx and Tx
1. Put tx and rx in separate file
```bash
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-pdump -n 4 -- --pdump 'port=1,queue=*,rx-dev=./rx-pcap.pcap,tx-dev=./tx-pcap.pcap,ring-size=32768,mbuf-size=2176,total-num-mbufs=65535'
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket_62154_112a5348f2bc
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_set_rx_function(): Using AVX2 Vector Rx (port 0).
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_set_rx_function(): Using AVX2 Vector Rx (port 1).
Port 2 MAC: 02 70 63 61 70 04
Port 3 MAC: 02 70 63 61 70 05
 core (0), capture for (1) tuples
 - port 1 device ((null)) queue 65535
^C

Signal 2 received, preparing to exit...
##### PDUMP DEBUG STATS #####
 -packets dequeued:                     23797027
 -packets transmitted to vdev:          23797027
 -packets freed:                        0
```
We can also use tcpdump to check directly, this time dump with port 1, with extra params.
```bash
root@ubuntu2204:/data/repo/dpdk_playground# tcpdump -er tx-pcap.pcap | head
reading from file tx-pcap.pcap, link-type EN10MB (Ethernet), snapshot length 65535
16:03:40.431278 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431278 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431278 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431278 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431278 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431278 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431278 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431278 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431278 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431279 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
tcpdump: Unable to write output: Broken pipe
root@ubuntu2204:/data/repo/dpdk_playground# tcpdump -er rx-pcap.pcap | head
reading from file rx-pcap.pcap, link-type EN10MB (Ethernet), snapshot length 65535
16:03:40.431262 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431262 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431262 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431262 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431262 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431262 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431262 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431262 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431262 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:03:40.431263 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
tcpdump: Unable to write output: Broken pipe
```
2. Put Tx and Rx in one file:
```bash
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-pdump -n 4 -- --pdump 'port=1,queue=*,rx-dev=./all.pcap,tx-dev=./all.pcap,ring-size=32768,mbuf-size=2176,total-num-mbufs=65535'
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket_62450_130f60edb46d
EAL: Selected IOVA mode 'VA'
EAL: VFIO support initialized
EAL: Using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.0 (socket -1)
ice_set_rx_function(): Using AVX2 Vector Rx (port 0).
EAL: Probe PCI driver: net_ice (8086:159b) device: 0000:01:00.1 (socket -1)
ice_set_rx_function(): Using AVX2 Vector Rx (port 1).
Port 2 MAC: 02 70 63 61 70 08
 core (0), capture for (1) tuples
 - port 1 device ((null)) queue 65535
^C

Signal 2 received, preparing to exit...
##### PDUMP DEBUG STATS #####
 -packets dequeued:                     17958939
 -packets transmitted to vdev:          17958939
 -packets freed:                        0
```
Output is:
```bash
root@ubuntu2204:/data/repo/dpdk_playground# tcpdump -er all.pcap | head -100
reading from file all.pcap, link-type EN10MB (Ethernet), snapshot length 65535
16:13:49.923757 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:13:49.923757 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:13:49.923757 b4:96:91:e6:74:f6 (oui Unknown) > 02:00:00:00:00:00 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
...
16:13:49.923771 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:13:49.923771 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
16:13:49.923771 b4:96:91:e6:74:f7 (oui Unknown) > 02:00:00:00:00:01 (oui Unknown), ethertype IPv4 (0x0800), length 64: 198.18.0.1.discard > 198.18.0.2.discard: UDP, length 22
```

We can also capture Tx only, just put tx-dev in parameter, without rx-dev.

# Reference
https://doc.dpdk.org/guides/tools/pdump.html

