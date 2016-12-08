sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.default.rp_filter=0
sysctl -w net.ipv4.conf.lo.rp_filter=0
sysctl -w net.ipv4.conf.docker0.rp_filter=0
sysctl -w net.ipv4.conf.eno2.rp_filter=0
sysctl -w net.ipv4.ip_forward=1
