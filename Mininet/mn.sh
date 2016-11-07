#mn --topo single,3 --mac --switch ovsk,protocols=OpenFlow13 --controller remote
#mn --custom Mininet/topology.py --topo TFTopo --mac --switch ovsk,protocols=OpenFlow13 --controller remote
mn --custom Mininet/sfcTest.py --topo TFTopo --mac --switch ovsk,protocols=OpenFlow13 --controller remote --arp
#mn --custom Mininet/topology.py --topo TFTopo --mac --switch ovsk,protocols=OpenFlow13
 #mn --custom topology.py --topo TFTopo --mac --switch ovsk,protocols=OpenFlow13
#sudo python Mininet/custom.py
#mn --custom Mininet/TOPO.py --topo TFTopo --mac --switch ovsk,protocols=OpenFlow13 --controller remote
