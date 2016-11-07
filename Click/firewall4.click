// You can run it at user level (as root) as
// 'userlevel/click < conf/Print-pings.click'
// or in the kernel with
// 'click-install conf/Print-pings.click'


FromDevice($DEV-eth0,METHOD LINUX, SNIFFER false, PROMISC true)	 -> ToDevice($DEV-eth1, BURST 800000);

