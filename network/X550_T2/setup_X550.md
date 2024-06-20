
# Bind with X550 devices
This step is only needed when running network tests.
Firstly check BDF, then use dpdk script to bind to vfio-pci driver.

## Check ethernet interface
We can see X552 interfaces are enp5s0f0 and enp5s0f1.
```bash
root@ubuntu2204:/data/repo/dpdk-kmods/linux/igb_uio# ip l
8: enp5s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 9c:69:b4:63:73:cb brd ff:ff:ff:ff:ff:ff
9: enp5s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 9c:69:b4:63:73:ca brd ff:ff:ff:ff:ff:ff
root@ubuntu2204:/data/repo/dpdk_playground/network/X550_T2# ip l set dev enp5s0f0 mtu 8192
root@ubuntu2204:/data/repo/dpdk_playground/network/X550_T2# ip l set dev enp5s0f1 mtu 8192
root@ubuntu2204:/data/repo/dpdk_playground/network/X550_T2# ip l set dev enp5s0f0 up
root@ubuntu2204:/data/repo/dpdk_playground/network/X550_T2# ip l set dev enp5s0f1 up
```

## Setup IP addr
```bash
root@ubuntu2204:/data/repo/dpdk_playground/network/X550_T2# ip addr add 192.168.31.200/24 dev enp5s0f0
root@ubuntu2204:/data/repo/dpdk_playground/network/X550_T2# ip addr add 192.168.31.201/24 dev enp5s0f1
root@ubuntu2204:/data/repo/dpdk_playground/network/X550_T2# ip a
8: enp5s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 9c:69:b4:63:73:cb brd ff:ff:ff:ff:ff:ff
    inet 192.168.31.201/24 scope global enp5s0f1
       valid_lft forever preferred_lft forever
9: enp5s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 9c:69:b4:63:73:ca brd ff:ff:ff:ff:ff:ff
    inet 192.168.31.200/24 scope global enp5s0f0
       valid_lft forever preferred_lft forever
root@ubuntu2204:/data/repo/dpdk_playground/network# ping 192.168.31.201 -I 192.168.31.200
PING 192.168.31.201 (192.168.31.201) from 192.168.31.200 : 56(84) bytes of data.
64 bytes from 192.168.31.201: icmp_seq=1 ttl=64 time=0.017 ms
64 bytes from 192.168.31.201: icmp_seq=2 ttl=64 time=0.009 ms
```

## Check PCI BDF
Find bus:device.function for X550 device.
```bash
root@ubuntu2204:/data/repo/dpdk_playground# lspci -d 8086:
05:00.0 Ethernet controller: Intel Corporation Ethernet Controller 10G X550T (rev 01)
05:00.1 Ethernet controller: Intel Corporation Ethernet Controller 10G X550T (rev 01)
```
Before bind:
By default, X550 is using ixgbe driver.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/network# dpdk-devbind.py -s

Network devices using kernel driver
===================================
0000:00:14.3 'Device 7a70' if=wlp0s20f3 drv=iwlwifi unused=vfio-pci *Active*
0000:05:00.0 'Ethernet Controller 10G X550T 1563' if=enp5s0f0 drv=ixgbe unused=vfio-pci
0000:05:00.1 'Ethernet Controller 10G X550T 1563' if=enp5s0f1 drv=ixgbe unused=vfio-pci
```

# Check settings
```bash
root@ubuntu2204:/data/repo/dpdk_playground/network# ethtool enp5s0f0
Settings for enp5s0f0:
        Supported ports: [ TP ]
        Supported link modes:   100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
                                2500baseT/Full
                                5000baseT/Full
        Supported pause frame use: Symmetric
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 10000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: Unknown
        Supports Wake-on: d
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes
```

## Bind with driver
There are several drivers, prefer vfio-pci than igb_uio and uio_pci_generic.
### Option 1 PF Bind with vfio-pci(not suggested):
Note, between vfio and pci, it is hyphen "-".
```bash
# use vfio-pci driver
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -b vfio-pci 0000:05:00.0
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -b vfio-pci 0000:05:00.1
# Or use igb_uio driver
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -b igb_uio 05:00.0
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -b igb_uio 05:00.1
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -s

Network devices using DPDK-compatible driver
============================================
0000:05:00.0 'Ethernet Controller 10G X550T 1563' drv=igb_uio unused=ixgbe,vfio-pci
0000:05:00.1 'Ethernet Controller 10G X550T 1563' drv=igb_uio unused=ixgbe,vfio-pci
```
### Option 3 PF Bind with ixgbe kernel driver, VF bind with igb_uio/vfio-pci(suggested):
```bash
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -b ixgbe 05:00.0
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -b ixgbe 05:00.1
```
#### Configure VFs
setup 2 VFs for each PF
```bash
root@ubuntu2204:/data/repo/dpdk_playground/network# echo 2 > /sys/bus/pci/devices/0000:05:00.0/sriov_numvfs
root@ubuntu2204:/data/repo/dpdk_playground/network# echo 2 > /sys/bus/pci/devices/0000:05:00.1/sriov_numvfs
root@ubuntu2204:/data/repo/dpdk_playground/network# cat !$
cat /sys/bus/pci/devices/0000:05:00.1/sriov_numvfs
2
root@ubuntu2204:/data/repo/dpdk_playground/network# cat /sys/bus/pci/devices/0000:05:00.0/sriov_numvfs
2
root@ubuntu2204:/data/repo/dpdk_playground/network# lspci | grep Eth
01:00.0 Ethernet controller: Intel Corporation Ethernet Controller E810-XXV for SFP (rev 02)
01:00.1 Ethernet controller: Intel Corporation Ethernet Controller E810-XXV for SFP (rev 02)
05:00.0 Ethernet controller: Intel Corporation Ethernet Controller 10G X550T (rev 01)
05:00.1 Ethernet controller: Intel Corporation Ethernet Controller 10G X550T (rev 01)
05:10.0 Ethernet controller: Intel Corporation X550 Virtual Function
05:10.1 Ethernet controller: Intel Corporation X550 Virtual Function
05:10.2 Ethernet controller: Intel Corporation X550 Virtual Function
05:10.3 Ethernet controller: Intel Corporation X550 Virtual Function
07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller (rev 05)
root@ubuntu2204:/data/repo/dpdk_playground/network# lspci -v -s 05:10.0
05:10.0 Ethernet controller: Intel Corporation X550 Virtual Function
        Subsystem: Intel Corporation X550 Virtual Function
        Flags: bus master, fast devsel, latency 0, IOMMU group 27
        Memory at 80a00000 (64-bit, non-prefetchable) [virtual] [size=16K]
        Memory at 80b00000 (64-bit, non-prefetchable) [virtual] [size=16K]
        Capabilities: [70] MSI-X: Enable+ Count=3 Masked-
        Capabilities: [a0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
        Capabilities: [1a0] Transaction Processing Hints
        Capabilities: [1b0] Access Control Services
        Kernel driver in use: ixgbevf
        Kernel modules: ixgbevf
```
#### Bind VFs to igb_uio driver
```bash
root@ubuntu2204:/data/repo/dpdk_playground/network# dpdk-devbind.py -b igb_uio 05:10.0
root@ubuntu2204:/data/repo/dpdk_playground/network# dpdk-devbind.py -b igb_uio 05:10.1
root@ubuntu2204:/data/repo/dpdk_playground/network# dpdk-devbind.py -b igb_uio 05:10.2
root@ubuntu2204:/data/repo/dpdk_playground/network# dpdk-devbind.py -b igb_uio 05:10.3
root@ubuntu2204:/data/repo/dpdk_playground/network# dpdk-devbind.py -s

Network devices using DPDK-compatible driver
============================================
0000:05:10.0 'X550 Virtual Function 1565' drv=igb_uio unused=ixgbevf,vfio-pci
0000:05:10.1 'X550 Virtual Function 1565' drv=igb_uio unused=ixgbevf,vfio-pci
0000:05:10.2 'X550 Virtual Function 1565' drv=igb_uio unused=ixgbevf,vfio-pci
0000:05:10.3 'X550 Virtual Function 1565' drv=igb_uio unused=ixgbevf,vfio-pci
```

After bind:
```bash
root@ubuntu2204:/data/repo/dpdk_playground/network# dpdk-devbind.py -s

Network devices using DPDK-compatible driver
============================================
0000:05:00.0 'Ethernet Controller 10G X550T 1563' drv=vfio-pci unused=ixgbe
0000:05:00.1 'Ethernet Controller 10G X550T 1563' drv=vfio-pci unused=ixgbe
```

# References
1. X550 guide https://www.intel.com/content/www/us/en/products/details/ethernet/800-controllers/e810-controllers/docs.html
2. X550 appnote https://edc.intel.com/content/www/us/en/design/products/ethernet/appnote-e810-eswitch-switchdev-mode-config-guide/
