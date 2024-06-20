# Check E810 pci and if binded
lspci -d 8086: | grep E810
dpdk-devbind.py -s | grep E810
# bind E810 pci DBDF
modprobe vfio-pci
dpdk-devbind.py -b vfio-pci 0000:01:00.0
dpdk-devbind.py -b vfio-pci 0000:01:00.1
# Check if E810 pci had been binded
dpdk-devbind.py -s

