// You can run it at user level (as root) as
// 'userlevel/click < conf/Print-pings.click'
// or in the kernel with
// 'click-install conf/Print-pings.click'



FromDevice(eths, SNIFFER false, PROMISC true)	// read packets from device
   -> pkt2 :: Classifier(12/0800, -)
   -> ck2 :: CheckIPHeader(OFFSET 14)
   -> IPFilter( allow all)
   -> SetTCPChecksum
   -> queue2 :: Queue(800)
   pkt2[1] -> queue2
   ck2[1] -> queue2
   -> ToDevice(ethc, BURST 800);
