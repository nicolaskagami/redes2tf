#!/usr/bin/python
# coding=utf-8

from mininet.topo import Topo
from mininet.net import Containernet
from mininet.node import RemoteController, Host, OVSKernelSwitch, OVSSwitch, Docker
from mininet.util import dumpNodeConnections
from mininet.link import TCLink, Link
from mininet.cli import CLI
from mininet.log import setLogLevel, info
from subprocess import call


def tfTopo():
 net = Containernet( topo=None, controller=RemoteController, switch=OVSKernelSwitch )

 net.addController( 'c0', RemoteController, ip="127.0.0.1", port=6633 )

 # Hosts 
 h1 = net.addHost('h1', ip='10.0.0.1', mac='00:00:00:00:00:01')
 h2 = net.addHost('h2', ip='10.0.0.2', mac='00:00:00:00:00:02')
 h3 = net.addHost('h3', ip='10.0.0.3', mac='00:00:00:00:00:03', cls=Docker, dimage='gmiotto/click',mem_limit=1024*1024*10, cpu_shares=2)
 h4 = net.addHost('h4', ip='10.0.0.4', mac='00:00:00:00:00:04', cls=Docker, dimage='gmiotto/click',mem_limit=1024*1024*10, cpu_shares=10)
 h5 = net.addHost('h5', ip='10.0.0.5', mac='00:00:00:00:00:05', cls=Docker, dimage='gmiotto/click',mem_limit=1024*1024*10, cpu_shares=10)
 h6 = net.addHost('h6', ip='10.0.0.6', mac='00:00:00:00:00:06')
 h7 = net.addHost('h7', ip='10.0.0.7', mac='00:00:00:00:00:07')
 h8 = net.addHost('h8', ip='10.0.0.8', mac='00:00:00:00:00:08')
 h9 = net.addHost('h9', ip='10.0.0.9', mac='00:00:00:00:00:09')

 #Switches
 s1 = net.addSwitch('s1')
 s2 = net.addSwitch('s2')
 s3 = net.addSwitch('s3')
 s4 = net.addSwitch('s4')
 s5 = net.addSwitch('s5')
 s6 = net.addSwitch('s6')
 s7 = net.addSwitch('s7')
 s8 = net.addSwitch('s8')
 s9 = net.addSwitch('s9')

 net.addLink(h3,s3)
 net.addLink(h3,s3)

 net.addLink(h4,s4)
 net.addLink(h4,s4)

 net.addLink(h5,s5)
 net.addLink(h5,s5)

 net.addLink(s1,s6)
 net.addLink(s1,s7)

 #net.addLink(s6, s3, cls=TCLink, delay="100ms", bw=0.5, loss=0)
 net.addLink(s6,s3)
 net.addLink(s6, s4, cls=TCLink, delay="1ms", bw=2, loss=0)
 #net.addLink(s6,s4)
 net.addLink(s6,s5)
 net.addLink(s7,s3)
 net.addLink(s7,s5)
 
 net.addLink(s3,s8)
 net.addLink(s3,s9)
 net.addLink(s4,s8, cls=TCLink, delay="1ms", bw=2, loss=0)
 net.addLink(s4,s9)
 net.addLink(s5,s9)
 
 net.addLink(s8,s2)
 net.addLink(s9,s2)
 
 net.addLink(h1,s1)
 net.addLink(h2,s2)
 net.addLink(h6,s6)
 net.addLink(h7,s7)
 net.addLink(h8,s8)
 net.addLink(h9,s9)
 


 net.start()

 for host in net.hosts:
     if "h" in host.name:
         host.cmd('ethtool -K %s-eth0 tso off' % host.name)
 call("sudo bash Click/runFirewall.sh h3 Click/firewall3.click ",shell=True)
 call("sudo bash Click/runFirewall.sh h4 Click/firewall3.click ",shell=True)
 call("sudo bash Click/runFirewall.sh h5 Click/firewall3.click ",shell=True)
 
 h2.cmd('python -m SimpleHTTPServer 80 &')

 CLI(net)
 net.stop()

if __name__ == '__main__':
   setLogLevel( 'info' )
   tfTopo()
