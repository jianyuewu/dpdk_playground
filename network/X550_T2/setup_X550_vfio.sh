ip l set dev enp5s0f0 mtu 8192 
ip l set dev enp5s0f1 mtu 8192 
ip l
ip l set dev enp5s0f0 up
ip l set dev enp5s0f1 up
ip a
ip addr add 192.168.31.200/24 dev enp5s0f0
ip addr add 192.168.31.201/24 dev enp5s0f1
ip a

modprobe vfio-pci

# set to 0 firstly, to make sure later set OK
echo 0 > /sys/bus/pci/devices/0000:05:00.0/sriov_numvfs
echo 0 > /sys/bus/pci/devices/0000:05:00.1/sriov_numvfs
# set to 2 VFs for each PF
echo 2 > /sys/bus/pci/devices/0000:05:00.0/sriov_numvfs
echo 2 > /sys/bus/pci/devices/0000:05:00.1/sriov_numvfs
lspci -d 8086:
# Add VF for 05:00.0(enp5s0f0)
dpdk-devbind.py -b vfio-pci 05:10.0
dpdk-devbind.py -b vfio-pci 05:10.1
# Add VF for 05:11.0(enp5s0f1)
dpdk-devbind.py -b vfio-pci 05:10.2
dpdk-devbind.py -b vfio-pci 05:10.3

exit 0
# set to 8 VFs for each PF
echo 8 > /sys/bus/pci/devices/0000:05:00.0/sriov_numvfs
echo 8 > /sys/bus/pci/devices/0000:05:00.1/sriov_numvfs
lspci -d 8086:
# Add VF for 05:00.0(enp5s0f0)
dpdk-devbind.py -b vfio-pci 05:10.0
dpdk-devbind.py -b vfio-pci 05:10.1
dpdk-devbind.py -b vfio-pci 05:10.2
dpdk-devbind.py -b vfio-pci 05:10.3
dpdk-devbind.py -b vfio-pci 05:10.4
dpdk-devbind.py -b vfio-pci 05:10.5
dpdk-devbind.py -b vfio-pci 05:10.6
dpdk-devbind.py -b vfio-pci 05:10.7
# Add VF for 05:11.0(enp5s0f1)
dpdk-devbind.py -b vfio-pci 05:11.0
dpdk-devbind.py -b vfio-pci 05:11.1
dpdk-devbind.py -b vfio-pci 05:11.2
dpdk-devbind.py -b vfio-pci 05:11.3
dpdk-devbind.py -b vfio-pci 05:11.4
dpdk-devbind.py -b vfio-pci 05:11.5
dpdk-devbind.py -b vfio-pci 05:11.6
dpdk-devbind.py -b vfio-pci 05:11.7
dpdk-devbind.py -s

