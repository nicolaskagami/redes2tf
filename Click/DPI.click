// You can run it at user level (as root) as
// 'userlevel/click < conf/Print-pings.click'
// or in the kernel with
// 'click-install conf/Print-pings.click'


FromDevice($DEV-eth0, SNIFFER false, PROMISC true)	// read packets from device
   -> pkt :: Classifier(12/0800, -)
   -> ck :: CheckIPHeader(OFFSET 14)
   -> ip :: IPClassifier(dst tcp port 5202,icmp type 0, ip tos 235,tcp win 10000,-)
   queue :: ThreadSafeQueue(1000000)
   ip[0] -> Discard
   ip[1] -> queue
   ip[2] -> queue
   ip[3] -> queue
   ip[4] -> queue

   pkt[1] -> queue
   -> ToDevice($DEV-eth1, BURST 8);
