// You can run it at user level (as root) as
// 'userlevel/click < conf/Print-pings.click'
// or in the kernel with
// 'click-install conf/Print-pings.click'


FromDevice(ethc, SNIFFER false, PROMISC true)	// read packets from device
   -> SetTCPChecksum
   -> ToDevice(eths, BURST 800000);

FromDevice(eths, SNIFFER false, PROMISC true)	// read packets from device
   -> SetTCPChecksum
   -> ToDevice(ethc, BURST 800000);
