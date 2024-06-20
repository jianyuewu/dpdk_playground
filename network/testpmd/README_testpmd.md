
# test with testpmd with 2 lcores
Run with testpmd.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/network# dpdk-testpmd -l 11-15 -n 4 --socket-mem=1024,0 -- -i --forward-mode=mac --nb-cores=4
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
Interactive-mode selected
Set mac packet forwarding mode
Warning: NUMA should be configured manually by using --port-numa-config and --ring-numa-config parameters along with --numa.
testpmd: create a new mbuf pool <mb_pool_0>: n=179456, size=2176, socket=0
testpmd: preferred mempool ops selected: ring_mp_mc
Configuring Port 0 (socket 0)
ice_set_rx_function(): Using AVX2 Vector Rx (port 0).
ice_vsi_config_outer_vlan_stripping(): Single VLAN mode (SVM) does not support qinq
Port 0: B4:96:91:E6:74:F6
Configuring Port 1 (socket 0)
ice_set_rx_function(): Using AVX2 Vector Rx (port 1).
ice_vsi_config_outer_vlan_stripping(): Single VLAN mode (SVM) does not support qinq
Port 1: B4:96:91:E6:74:F7
Checking link statuses...

Port 0: link state change event

Port 1: link state change event
Done
testpmd>
```
Start test.
```bash
mac packet forwarding - ports=2 - cores=2 - streams=2 - NUMA support enabled, MP allocation mode: native
Logical Core 12 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 0) -> TX P=1/Q=0 (socket 0) peer=02:00:00:00:00:01
Logical Core 13 (socket 0) forwards packets on 1 streams:
  RX P=1/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=02:00:00:00:00:00

  mac packet forwarding packets/burst=32
  nb forwarding cores=4 - nb forwarding ports=2
  port 0: RX queue number: 1 Tx queue number: 1
    Rx offloads=0x0 Tx offloads=0x10000
    RX queue: 0
      RX desc=1024 - RX free threshold=32
      RX threshold registers: pthresh=0 hthresh=0  wthresh=0
      RX Offloads=0x0
    TX queue: 0
      TX desc=1024 - TX free threshold=32
      TX threshold registers: pthresh=32 hthresh=0  wthresh=0
      TX offloads=0x10000 - TX RS bit threshold=32
  port 1: RX queue number: 1 Tx queue number: 1
    Rx offloads=0x0 Tx offloads=0x10000
    RX queue: 0
      RX desc=1024 - RX free threshold=32
      RX threshold registers: pthresh=0 hthresh=0  wthresh=0
      RX Offloads=0x0
    TX queue: 0
      TX desc=1024 - TX free threshold=32
      TX threshold registers: pthresh=32 hthresh=0  wthresh=0
      TX offloads=0x10000 - TX RS bit threshold=32
```
Check result, note first time result is not accurate, should get from second or latter results.
```bash
testpmd> show port stats all

  ######################## NIC statistics for port 0  ########################
  RX-packets: 402402320  RX-missed: 0          RX-bytes:  25753747936
  RX-errors: 0
  RX-nombuf:  0
  TX-packets: 402296135  TX-errors: 0          TX-bytes:  25746952436

  Throughput (since last show)
  Rx-pps:      5807160          Rx-bps:   2973258968
  Tx-pps:      5804887          Tx-bps:   2972111088
  ############################################################################

  ######################## NIC statistics for port 1  ########################
  RX-packets: 402296536  RX-missed: 0          RX-bytes:  25746977760
  RX-errors: 0
  RX-nombuf:  0
  TX-packets: 402402484  TX-errors: 0          TX-bytes:  25753758432

  Throughput (since last show)
  Rx-pps:      5804825          Rx-bps:   2972063696
  Tx-pps:      5807120          Tx-bps:   2973238760
  ############################################################################
testpmd>
```
2972063696/1000/1000/1000 => Around 2.97Gb/s
Throughput looks not so good, could be core resource not enough, also this time is with DPDK debug enabled.


