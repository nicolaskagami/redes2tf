
FromDevice(eths, SNIFFER false, PROMISC true, BURST 32, SNAPLEN 9216)	// read packets from device
   -> pkt2 :: Classifier(12/0800, -)
   -> ck2 :: CheckIPHeader(OFFSET 14)
   -> IPFilter( 
                allow tcp && src port 5201,
                allow tcp && dst port 5201,
                allow udp && src port 5201,
                allow udp && dst port 5201,
                allow src 143.54.12.49,
                allow tcp && src 172.16.0.2,
                allow icmp,
                drop all)
   -> ip2 :: IPClassifier(tcp,udp,icmp,-)
   queue2 :: ThreadSafeQueue(8000)
   ip2[0] -> SetTCPChecksum -> queue2
   ip2[1] -> SetUDPChecksum -> queue2
   ip2[2] -> queue2
   ip2[3] -> Discard
   pkt2[1] -> Discard
   ck2[1] -> Discard 
   queue2 -> ToDevice(eth0, BURST 32);

FromDevice(eth0, SNIFFER false, PROMISC true, BURST 32, SNAPLEN 9216)	// read packets from device
   -> pkt :: Classifier(12/0800, -)
   -> ck :: CheckIPHeader(OFFSET 14)
   -> IPFilter( 
                allow tcp && src port 5201,
                allow tcp && dst port 5201,
                allow udp && src port 5201,
                allow udp && dst port 5201,
                allow src 143.54.12.49,
                allow tcp && src 172.16.0.2,
                allow icmp,
                drop all)
   -> ip :: IPClassifier(tcp,udp,icmp,-)
   queue :: ThreadSafeQueue(8000)
   ip[0] -> SetTCPChecksum -> queue
   ip[1] -> SetUDPChecksum -> queue
   ip[2] -> queue
   ip[3] -> Discard
   pkt[1] -> Discard
   ck[1] -> Discard
   queue -> ToDevice(eths, BURST 32);

