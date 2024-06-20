
# Bind with E810 devices
This step is only needed when running network tests.
Firstly check BDF, then use dpdk script to bind to vfio-pci driver.
## Check PCI BDF
Find bus:device.function for E810 device.
```bash
root@ubuntu2204:/data/repo/dpdk_playground# lspci -d 8086:
01:00.0 Ethernet controller: Intel Corporation Ethernet Controller E810-XXV for SFP (rev 02)
01:00.1 Ethernet controller: Intel Corporation Ethernet Controller E810-XXV for SFP (rev 02)
```
Before bind:
By default, E810 is using ice driver.
```bash
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -s

Network devices using kernel driver
===================================
0000:00:14.3 'Device 7a70' if=wlp0s20f3 drv=iwlwifi unused=vfio-pci *Active*
0000:01:00.0 'Ethernet Controller E810-XXV for SFP 159b' if=enp1s0f0 drv=ice unused=vfio-pci
0000:01:00.1 'Ethernet Controller E810-XXV for SFP 159b' if=enp1s0f1 drv=ice unused=vfio-pci
```

## Bind with driver
There are several drivers, prefer vfio-pci than igb_uio and uio_pci_generic.
Bind:
Note, between vfio and pci, it is hyphen "-".
```bash
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -b vfio-pci 0000:01:00.0
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -b vfio-pci 0000:01:00.1
```

After bind:
```bash
root@ubuntu2204:/data/repo/dpdk_playground# dpdk-devbind.py -s

Network devices using DPDK-compatible driver
============================================
0000:01:00.0 'Ethernet Controller E810-XXV for SFP 159b' drv=vfio-pci unused=ice
0000:01:00.1 'Ethernet Controller E810-XXV for SFP 159b' drv=vfio-pci unused=ice

Network devices using kernel driver
===================================
0000:00:14.3 'Device 7a70' if=wlp0s20f3 drv=iwlwifi unused=vfio-pci *Active*
```

# References
1. E810 guide https://www.intel.com/content/www/us/en/products/details/ethernet/800-controllers/e810-controllers/docs.html
2. E810 appnote https://edc.intel.com/content/www/us/en/design/products/ethernet/appnote-e810-eswitch-switchdev-mode-config-guide/