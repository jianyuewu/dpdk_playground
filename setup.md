Here is an example for E810 ethernet card setup.

# Prepare startup cmdline
Mainly setup for cmdline, so each boot, will reserve hugepage automatically, also prevent additional workloads, timers, RCU processing and IRQs from running on those cores.
Change /etc/default/grub file.
```bash
local_cores=8-15
GRUB_CMDLINE_LINUX="transparent_hugepage=never default_hugepagesz=1G hugepagesz=1G hugepages=16 idle=poll intel_idle.max_cstate=0 pcie_aspm=off intel_iommu=on iommu=pt intel_pstate=disable processor.max_cstate=1 numa_balancing=disable mce=off isolcpus=domain,managed_irq,$local_cores nohz_full=$local_cores rcu_nocbs=$local_cores vt.handoff=1 irqaffinity=0-3 systemd.unified_cgroup_hierarchy=1 cgroup_no_v1=all"

GRUB_CMDLINE_LINUX_DEFAULT="　quiet splash"
```
Meaning of starup parameters:
1. default_hugepagesz=1G - Specifies the default 1GB size for Huge Pages.
2. hugepagesz=1G - Specifies the size of Huge Pages.
3. hugepages=32 - Specifies the number of Huge Pages that the system will try to allocate at boot time.
4. idle=poll - Changes the CPU idle loop to poll mode, which can decrease the latency of wakeups at the expense of power efficiency.
5. intel_idle.max_cstate=0 - Limits the maximum C-state of the Intel Idle driver, preventing the system from entering power saving states. This can sometimes increase performance in latency-sensitive applications.
6. pcie_aspm=off - Disables the PCIe Active State Power Management (ASPM), which is a power saving feature that can cause latency and compatibility issues with some hardware.
7. intel_iommu=on and iommu=pt - Enables the IOMMU (Input-Output Memory Management Unit), a system specific component of the processor that controls I/O devices and memory management. The pt flag stands for pass-through and enables a fast-path for IOMMU translations.
8. intel_pstate=disable - Disables the Intel P-state driver, a power scaling driver specific to Intel processors.
9. processor.max_cstate=1 - Sets the maximum C-state for all processors to 1, limiting power saving states, which can be useful for real-time or latency-sensitive applications.
10. numa_balancing=disable - Disables automatic NUMA balancing, which can improve performance for certain workloads on NUMA systems.
11. mce=off - Disables Machine Check Exception, a mechanism used by CPUs to report hardware errors.
12. isolcpus=$local_cores - Isolates certain CPUs from the Linux scheduler, meaning that no tasks will be scheduled onto them unless specifically bound to them. The cores to isolate are represented by the $local_cores variable.
13. nohz_full=$local_cores - Disables the timer tick for specific CPUs, which can be useful for real-time or latency-sensitive workloads. The cores to apply this to are represented by the $local_cores variable.
14. rcu_nocbs=$local_cores - Specifies that the specified cores should not handle RCU callback functions, instead offloading them to other cores.
15. vt.handoff=1 - This is related to the kernel taking over the console output from the bootloader. The exact behavior can depend on the specifics of your system.
After change:
```
root@ubuntu2204:/# update-grub
root@ubuntu2204:/# reboot
```
After reboot:
```bash
root@ubuntu2204:/data/repo/dpdk_playground# cat /proc/cmdline
BOOT_IMAGE=/boot/vmlinuz-6.2.0-39-generic root=UUID=82d7024f-109d-43c6-8e52-f1e4b8ecf908 ro default_hugepagesz=1G hugepagesz=1G hugepages=16 idle=poll intel_idle.max_cstate=0 pcie_aspm=off intel_iommu=on iommu=pt intel_pstate=disable processor.max_cstate=1 numa_balancing=disable mce=off isolcpus=domain,managed_irq,8-23 nohz_full=8-23 rcu_nocbs=8-23 vt.handoff=1 irqaffinity=0-3 systemd.unified_cgroup_hierarchy=1 cgroup_no_v1=all
```

# Build DPDK
Install build dependencies like meson tool.
```bash
apt install -y build-essential python3-pyelftools libnuma-dev meson
```
See build.sh in same directory.
After build finish, can run some tests with dpdk_test tool, like mbuf_autotest or ring_autotest.
```bash
dump mbuf at 0x17fd463c0, iova=0x17fd46440, buf_len=2048
  pkt_len=64, ol_flags=0, nb_segs=1, port=65535, ptype=0
  segment at 0x17fd463c0, data=0x17fd464b2, len=64, off=114, refcnt=1
  Dump data at [0x17fd464b2], len=64
00000000: DE DE DE DE DE DE DE DE DE DE DE DE DE DE CC CC | ................
00000010: CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC | ................
00000020: CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC | ................
00000030: CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC | ................
```
Or can run with dpdk-helloworld example.
```bash
root@ubuntu2204:/data/repo/dpdk_playground/dpdk/build/examples# ./dpdk-helloworld
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
hello from core 1
hello from core 2
hello from core 3
hello from core 4
hello from core 6
hello from core 5
hello from core 7
hello from core 8
hello from core 9
hello from core 10
hello from core 11
hello from core 16
hello from core 17
hello from core 18
hello from core 19
hello from core 20
hello from core 21
hello from core 22
hello from core 23
hello from core 0
```

# References
1. DPDK build guide https://doc.dpdk.org/guides/linux_gsg/build_dpdk.html
2. DPDK core isolation https://doc.dpdk.org/guides/linux_gsg/enable_func.html#using-linux-core-isolation-to-reduce-context-switches
