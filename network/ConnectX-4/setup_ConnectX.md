# Bind connectX VFs to DPDK
This step is only needed when running network tests.
Firstly check BDF, then use dpdk script to bind to vfio-pci driver.

## Check PCI BDF
Find bus:device.function for ConnectX device.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/network/ConnectX-4# lspci -d 15b3:
08:00.0 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
08:00.1 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
```

## Create VFs
```
root@ubuntu2204:/data/repo/dpdk_playground/network # echo 2 > /sys/bus/pci/devices/0000:08:00.0/sriov_numvfs
root@ubuntu2204:/data/repo/dpdk_playground/network # echo 2 > /sys/bus/pci/devices/0000:08:00.1/sriov_numvfs
root@ubuntu2204:/data/repo/dpdk_playground/network # lspci | grep Eth
08:00.0 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
08:00.1 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
08:00.2 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx Virtual Function]
08:00.3 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx Virtual Function]
08:01.2 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx Virtual Function]
08:01.3 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx Virtual Function]
```

## Before bind:
By default, connectX is using mlx5_core driver.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/network/X550_T2# dpdk-devbind.py -s

Network devices using kernel driver
===================================
0000:08:00.0 'MT27710 Family [ConnectX-4 Lx] 1015' if=enp8s0f0np0 drv=mlx5_core unused=vfio-pci 
0000:08:00.1 'MT27710 Family [ConnectX-4 Lx] 1015' if=enp8s0f1np1 drv=mlx5_core unused=vfio-pci 
0000:08:00.2 'MT27710 Family [ConnectX-4 Lx Virtual Function] 1016' if=enp8s0f0v0 drv=mlx5_core unused=vfio-pci 
0000:08:00.3 'MT27710 Family [ConnectX-4 Lx Virtual Function] 1016' if=enp8s0f0v1 drv=mlx5_core unused=vfio-pci 
0000:08:01.2 'MT27710 Family [ConnectX-4 Lx Virtual Function] 1016' if=enp8s0f1v0 drv=mlx5_core unused=vfio-pci 
0000:08:01.3 'MT27710 Family [ConnectX-4 Lx Virtual Function] 1016' if=enp8s0f1v1 drv=mlx5_core unused=vfio-pci
```

## Bind VFs with vfio-pci driver
There are several drivers, prefer vfio-pci than igb_uio and uio_pci_generic.
Bind:
Note, between vfio and pci, it is hyphen "-".
```bash
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -b vfio-pci 0000:08:00.2
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -b vfio-pci 0000:08:00.3
```

## After bind:
```bash
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -s

Network devices using DPDK-compatible driver
============================================
Network devices using DPDK-compatible driver
============================================
0000:08:00.2 'MT27710 Family [ConnectX-4 Lx Virtual Function] 1016' drv=vfio-pci unused=mlx5_core
0000:08:00.3 'MT27710 Family [ConnectX-4 Lx Virtual Function] 1016' drv=vfio-pci unused=mlx5_core
```

# Bind connectX VFs back to mlx5_core driver
```bash
root@ubuntu2204:/data/repo/dpdk_playground/network/X550_T2# dpdk-devbind.py -b mlx5_core 0000:08:00.2
root@ubuntu2204:/data/repo/dpdk_playground/network/X550_T2# dpdk-devbind.py -b mlx5_core 0000:08:00.3
```
# References
