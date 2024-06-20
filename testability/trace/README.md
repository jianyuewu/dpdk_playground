# Prepare 
```bash
root@ubuntu2204:/data/repo/dpdk-stable-22.11.1# apt install -y babeltrace
```
# Get trace
```bash
root@ubuntu2204:/data/repo/dpdk-stable-22.11.1# echo "quit" | ./build/app/test/dpdk-test --trace=.*
EAL: Detected CPU lcores: 24
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: VFIO support initialized
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.0 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.1 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.2 (socket -1)
EAL: Probe PCI driver: net_ixgbe_vf (8086:1565) device: 0000:05:10.3 (socket -1)
TELEMETRY: No legacy callbacks, legacy socket not created
APP: HPET is not enabled, using TSC as default timer
RTE>>quit
EAL: Trace dir: /root/dpdk-traces/rte-2023-07-24-PM-01-57-30
```

# Parse trace
View by babeltrace tool.
```bash
root@ubuntu2204:/data/repo/dpdk-stable-22.11.1# babeltrace /root/dpdk-traces/rte-2023-07-24-PM-01-57-30 > 22.11.log
```

View by trace compass tool.
```bash
# Seems can't open, not good
$ apt install -y eclipse-tracecompass
```
File -> Open Trace can see the trace content.


