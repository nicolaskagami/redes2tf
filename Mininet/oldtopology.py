#!/usr/bin/python
# coding=utf-8

from mininet.topo import Topo
from mininet.net import Containernet
from mininet.node import RemoteController, Host, OVSKernelSwitch, OVSSwitch, Docker
from mininet.util import dumpNodeConnections
from mininet.cli import CLI
from mininet.log import setLogLevel, info
from subprocess import call


def tfTopo():
 net = Containernet( topo=None, controller=RemoteController, switch=OVSKernelSwitch )

 net.addController( 'c0', RemoteController, ip="127.0.0.1", port=6633 )

 # Hosts 
 h1 = net.addHost('h1', ip='10.0.0.1', mac='00:00:00:00:00:01')
 h2 = net.addHost('h2', ip='10.0.0.2', mac='00:00:00:00:00:02')
 h3 = net.addHost('h3', ip='10.0.0.3', mac='00:00:00:00:00:03', cls=Docker, dimage='gmiotto/click',mem_limit=1024*1024*10)
 h4 = net.addHost('h4', ip='10.0.0.4', mac='00:00:00:00:00:04')
 h5 = net.addHost('h5', ip='10.0.0.5', mac='00:00:00:00:00:05')

 #Switches
 s1 = net.addSwitch('s1')
 s2 = net.addSwitch('s2')
 s3 = net.addSwitch('s3')
 s4 = net.addSwitch('s4')
 s5 = net.addSwitch('s5')

 net.addLink(h3,s3)
 net.addLink(h3,s3)

 net.addLink(s1,s2)
 net.addLink(s2,s3)
 net.addLink(s3,s4)
 net.addLink(s4,s5)
 
 net.addLink(h1,s1)
 net.addLink(h2,s2)
 net.addLink(h4,s4)
 net.addLink(h5,s5)
 


 net.start()

 for host in net.hosts:
     if "h" in host.name:
         host.cmd('ethtool -K %s-eth0 tso off' % host.name)
 #call("echo  %s "% 'ha',shell=True)
 
 CLI(net)
 net.stop()

if __name__ == '__main__':
   setLogLevel( 'info' )
   tfTopo()
