// You can run it at user level (as root) as
// 'userlevel/click < conf/Print-pings.click'
// or in the kernel with
// 'click-install conf/Print-pings.click'


FromDevice($DEV-eth0, SNIFFER false, PROMISC true)	// read packets from device
   -> pkt :: Classifier(12/0800, -)
   -> ck :: CheckIPHeader(OFFSET 14)
   -> IPFilter( allow icmp,
		 allow tcp && dst port 8000,	
		 allow tcp && dst port 5001,	
		 allow udp && dst port 5201,
		 allow tcp && dst port 5201,
		 allow udp && src port 5201,
		 allow tcp && src port 5201,
		 drop all)
   -> queue :: ThreadSafeQueue(10000000)
   pkt[1] -> queue
   ck[1] -> queue
   -> ToDevice($DEV-eth1, BURST 800000);

