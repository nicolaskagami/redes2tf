FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
	dnsutils \
	inetutils-ping \
	iproute2 \
	net-tools \
	iptables \
	tcpdump \
	iperf3


# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["/bin/bash"]
