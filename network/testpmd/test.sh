# forward with port 0 and 1(portmask 3)
sudo dpdk-testpmd -l 11-15 -n 4 --socket-mem=1024,0 -- -i --nb-cores=2 --portmask=3 --auto-start
#sudo dpdk-testpmd -l 11-15 -n 4 --socket-mem=1024,0 -- -i --forward-mode=mac --nb-cores=2 --portmask=3
# forward with port 7 and 8(portmask 180)
#sudo dpdk-testpmd -l 11-15 -n 4 --socket-mem=1024,0 -- -i --forward-mode=mac --nb-cores=2 --portmask=180
# portmask is hex, so 0x300 mean port 8 and port 9, auto start means start forwarding mode, but not generate new packets.
#sudo dpdk-testpmd -l 11-15 -n 4 --socket-mem=1024,0 -- -i --forward-mode=mac --nb-cores=2 --portmask=300 --auto-start
