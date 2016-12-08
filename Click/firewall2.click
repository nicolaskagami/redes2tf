// You can run it at user level (as root) as
// 'userlevel/click < conf/Print-pings.click'
// or in the kernel with
// 'click-install conf/Print-pings.click'


FromDevice(eth0, SNIFFER true, PROMISC true, BURST 8)	// read packets from device
   -> pkt :: Classifier(12/0800, -)
   -> ck :: CheckIPHeader(OFFSET 14)
   -> IPFilter(
	drop all)
   -> queue :: ThreadSafeQueue(10000)
   pkt[1] -> queue
   ck[1] -> queue
   -> ToDevice(eth0, BURST 8);
