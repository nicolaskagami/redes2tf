// You can run it at user level (as root) as
// 'userlevel/click < conf/Print-pings.click'
// or in the kernel with
// 'click-install conf/Print-pings.click'


FromDevice(ethc, SNIFFER false, PROMISC true, BURST 32, SNAPLEN 9216)	// read packets from device
   -> pkt :: Classifier(12/0800, -)
   -> ck :: CheckIPHeader(OFFSET 14)
   -> ip :: IPClassifier(dst tcp port 5201,src tcp port 5201, udp,icmp type 0, ip tos 235,tcp win 10000,-)
   queue :: ThreadSafeQueue(1000000)
   ip[0] -> SetTCPChecksum -> queue
   ip[1] -> SetTCPChecksum -> queue
   ip[2] -> SetUDPChecksum -> queue
   ip[3] -> queue
   ip[4] -> Discard 
   ip[5] -> queue
   ip[6] -> queue


   pkt[1] -> queue
   -> ToDevice(eths, BURST 8);

FromDevice(eths, SNIFFER false, PROMISC true, BURST 32, SNAPLEN 9216)	// read packets from device
   -> pkt2 :: Classifier(12/0800, -)
   -> ck2 :: CheckIPHeader(OFFSET 14)
   -> ip2 :: IPClassifier(dst tcp port 5201,src tcp port 5201, udp,icmp type 0, ip tos 235,tcp win 10000,-)
   queue2 :: ThreadSafeQueue(1000000)
   ip2[0] -> SetTCPChecksum -> queue2
   ip2[1] -> SetTCPChecksum -> queue2
   ip2[2] -> SetUDPChecksum -> queue2
   ip2[3] -> queue2
   ip2[4] -> Discard
   ip2[5] -> queue
   ip2[6] -> queue

   pkt2[1] -> queue2
   -> ToDevice(ethc, BURST 8);
