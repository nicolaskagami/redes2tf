AddressInfo(
    eth0-in     172.16.0.1                     10:00:00:00:00:10,
    eth0-ex     172.16.0.3                     10:00:00:00:00:20,
);

iprwp :: IPRewriterPatterns(
                            NATex eth0-ex - -,
                            NATin eth0-in - -);
FromDevice(eths, SNIFFER false, PROMISC true, BURST 32, SNAPLEN 9216)	// read packets from device
   -> pkt2 :: Classifier(12/0800, -)
   -> ck2 :: CheckIPHeader(OFFSET 14)
   -> IPFilter( 
                allow tcp,
                allow udp,
                allow icmp,
                drop all)
   -> tcp2 :: IPClassifier(tcp,udp,icmp,-)
   iprw2 :: IPRewriter(
                       pattern NATin 0 1)
   tcp2[0] -> iprw2
   tcp2[1] -> iprw2
   ip2 :: IPClassifier(tcp,udp,icmp,-)
   tcp2[2] -> ip2
   tcp2[3] -> ip2
   iprw2[1] -> ip2
   iprw2[0] -> ip2
   queue2 :: ThreadSafeQueue(8000)
   ip2[0] -> SetTCPChecksum -> queue2
   ip2[1] -> SetUDPChecksum -> queue2
   ip2[2] -> queue2
   ip2[3] -> queue2
   pkt2[1] -> queue2
   ck2[1] -> queue2 
   queue2 -> ToDevice(eth0, BURST 32);

FromDevice(eth0, SNIFFER false, PROMISC true, BURST 32, SNAPLEN 9216)	// read packets from device
   -> pkt :: Classifier(12/0800, -)
   -> ck :: CheckIPHeader(OFFSET 14)
   -> IPFilter( 
                allow tcp,
                allow udp,
                allow icmp,
                drop all)
   -> tcp :: IPClassifier(tcp,udp,icmp,-)
   iprw :: IPRewriter(
                       pattern NATex 0 1)
   tcp[0] -> iprw
   tcp[1] -> iprw
   ip :: IPClassifier(tcp,udp,icmp,-)
   tcp[2] -> icmpnat :: ICMPPingRewriter (pattern NATex 1 1) 
   icmpnat[0]-> ip
   icmpnat[1]-> ip
   tcp[3] -> ip
   iprw[0] -> ip
   iprw[1] -> ip
   queue :: ThreadSafeQueue(8000)
   ip[0] -> SetTCPChecksum -> queue
   ip[1] -> SetUDPChecksum -> queue
   ip[2] -> queue
   ip[3] -> queue
   pkt[1] -> queue 
   ck[1] -> queue
   queue -> ToDevice(eths, BURST 32);

