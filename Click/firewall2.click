// You can run it at user level (as root) as
// 'userlevel/click < conf/Print-pings.click'
// or in the kernel with
// 'click-install conf/Print-pings.click'


FromDevice(ethc, SNIFFER false, PROMISC true)	// read packets from device
   -> pkt :: Classifier(12/0800, -)
   -> ck :: CheckIPHeader(OFFSET 14)
   -> IPFilter( allow icmp,
		 drop all)
   -> queue :: ThreadSafeQueue(10000000)
   pkt[1] -> queue
   ck[1] -> queue
   -> ToDevice(eths, BURST 800000);

FromDevice(eths, SNIFFER false, PROMISC true)	// read packets from device
   -> pkt2 :: Classifier(12/0800, -)
   -> ck2 :: CheckIPHeader(OFFSET 14)
   -> IPFilter( allow icmp,
		 drop all)
   -> queue2 :: ThreadSafeQueue(10000000)
   pkt2[1] -> queue2
   ck2[1] -> queue2
   -> ToDevice(ethc, BURST 800000);
