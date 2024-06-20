# Check pci DBDF and if already binded by DPDK
lspci | grep -i mellanox
dpdk-devbind.py -s | grep -i mlx
# bind pci DBDF
modprobe vfio-pci
dpdk-devbind.py -b vfio-pci 0000:08:00.2
dpdk-devbind.py -b vfio-pci 0000:08:00.3
# Check if pci had been binded
dpdk-devbind.py -s
