FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
	dnsutils \
	inetutils-ping \
	iproute2 \
	net-tools \
    ethtool \
	iptables

ADD click ./click

# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["/bin/bash"]
