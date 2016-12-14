// You can run it at user level (as root) as
// 'userlevel/click < conf/Print-pings.click'
// or in the kernel with
// 'click-install conf/Print-pings.click'


FromDevice(eth0, SNIFFER false, PROMISC true, BURST 32, SNAPLEN 9216)	// read packets from device
   -> pkt :: Classifier(12/0800, -)
   -> ck :: CheckIPHeader(OFFSET 14)
   -> ip :: IPClassifier(
                        icmp type 0,
                        ip tos 235,
                        tcp win 10000,
                        dst tcp port 5201, 
                        src tcp port 5201, 
                        dst udp port 5201,
                        src udp port 5201,
                        udp,
                        -)
   queue :: ThreadSafeQueue(1000000)
   ip[0] -> queue
   ip[1] -> Discard 
   ip[2] -> queue
   ip[3] -> SetTCPChecksum -> queue
   ip[4] -> SetTCPChecksum -> queue
   ip[5] -> SetUDPChecksum -> queue
   ip[6] -> SetUDPChecksum -> queue
   ip[7] -> SetUDPChecksum -> queue
   ip[8] -> queue


   pkt[1] -> queue
   queue -> ToDevice(eths, BURST 32);

FromDevice(eths, SNIFFER false, PROMISC true, BURST 32, SNAPLEN 9216)	// read packets from device
   -> pkt2 :: Classifier(12/0800, -)
   -> ck2 :: CheckIPHeader(OFFSET 14)
   -> ip2 :: IPClassifier(
                        icmp type 0,
                        ip tos 235,
                        tcp win 10000,
                        dst tcp port 5201, 
                        src tcp port 5201, 
                        dst udp port 5201,
                        src udp port 5201,
                        udp,
                        -)
   queue2 :: ThreadSafeQueue(1000000)
   ip2[0] -> queue2
   ip2[1] -> Discard
   ip2[2] -> queue2
   ip2[3] -> SetTCPChecksum -> queue2
   ip2[4] -> SetTCPChecksum -> queue2
   ip2[5] -> SetUDPChecksum -> queue2
   ip2[6] -> SetUDPChecksum -> queue2
   ip2[7] -> SetUDPChecksum -> queue2
   ip2[8] -> queue2

   pkt2[1] -> queue
   queue2 -> ToDevice(eth0, BURST 32);
