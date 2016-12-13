
FromDevice(eths, SNIFFER false, PROMISC true, BURST 32, SNAPLEN 9216)	// read packets from device
   -> pkt2 :: Classifier(12/0800, -)
   -> ck2 :: CheckIPHeader(OFFSET 14)
   -> IPFilter( allow all)
   -> ip2 :: IPClassifier(tcp,udp,-)
   queue2 :: ThreadSafeQueue(8000)
   ip2[0] -> SetTCPChecksum -> queue2
   ip2[1] -> SetUDPChecksum -> queue2
   ip2[2] -> queue2
   pkt2[1] -> queue2
   ck2[1] -> queue2
   -> ToDevice(eth0, BURST 32);

FromDevice(eth0, SNIFFER false, PROMISC true, BURST 32, SNAPLEN 9216)	// read packets from device
   -> pkt :: Classifier(12/0800, -)
   -> ck :: CheckIPHeader(OFFSET 14)
   -> IPFilter( allow all)
   -> ip :: IPClassifier(tcp,udp,-)
   queue :: ThreadSafeQueue(8000)
   ip[0] -> SetTCPChecksum -> queue
   ip[1] -> SetUDPChecksum -> queue
   ip[2] -> queue
   pkt[1] -> queue
   ck[1] -> queue
   -> ToDevice(eths, BURST 32);

