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

import sys
import getopt
import time
import random

#Parameters
pop_cpu_percentage=50
pop_link_bw=1000
pop_link_loss=0
pop_link_delay="0ms"

inter_switch_bw=1000
inter_switch_loss=0
inter_switch_delay="0ms"

host_switch_bw=1000
host_switch_loss=0
host_switch_delay="0ms"

def tfTopo():
    net = Containernet( topo=None, controller=RemoteController, switch=OVSKernelSwitch )

    net.addController( 'c0', RemoteController, ip="127.0.0.1", port=6633 )

    #Arguments
    opts, args = getopt.getopt(sys.argv[1:], "", ["flows=", "dos="])
    for o, a in opts:
        if o == "--flows":
            number_of_flows=int(a)
            print "Flows: ",a
        elif o in ("--dos"):
            number_of_dos=int(a)
            print "DoS: ",a

# Hosts 
    h1 = net.addHost('h1', ip='10.0.0.1', mac='00:00:00:00:00:01')
    h2 = net.addHost('h2', ip='10.0.0.2', mac='00:00:00:00:00:02')

    p1 = net.addHost('p1', ip='10.0.1.1', mac='00:00:00:00:01:01', cls=Docker, dimage='gmiotto/click',mem_limit=1024*1024*1024, cpu_shares=1024, cpu_quota=pop_cpu_percentage*100,cpu_period=10000,device_write_bps='/dev/sda:512mb',device_write_iops='/dev/sda:1000')
    #p2 = net.addHost('p2', ip='10.0.1.2', mac='00:00:00:00:01:02', cls=Docker, dimage='progrium/stress',mem_limit=1024*1024*10, cpu_quota=pop_cpu_percentage*100,cpu_period=10000)

    #Switches
    s1 = net.addSwitch('s1')

    #PoP Hosts
    #net.addLink(p1,s1, cls=TCLink, delay=pop_link_delay,bw=pop_link_bw,loss=pop_link_loss)
    net.addLink(p1,s1)
    net.addLink(p1,s1)

    #Normal Hosts
    net.addLink(h1,s1)
    net.addLink(h2,s1)

    net.start()
    call("sudo ovs-ofctl add-flow s1 in_port=3,actions=output:1",shell=True)
    call("sudo ovs-ofctl add-flow s1 in_port=2,actions=output:4",shell=True)
    call("sudo ovs-ofctl add-flow s1 in_port=4,actions=output:3",shell=True)

    for host in net.hosts:
        if "h" in host.name:
            host.cmd('ethtool -K %s-eth0 tso off' % host.name)

    for host in net.hosts:
        if "p1" in host.name:
            call("sudo bash Click/runClickFunction.sh %s Click/DPI.click " % host.name,shell=True)

    test_duration = 20
    interval_duration = 5
    cgroup_options = "--cpu-quota=5000 --cpu-period=10000 --memory='1073741824' --device-write-bps='/dev/sda:512mb' --device-write-iops='/dev/sda:1000' --device-read-bps='/dev/sda:512mb' --device-read-iops='/dev/sda:1000' --memory-swappiness='0' --shm-size='0'"
    h2.cmd('iperf3 -s &')

    
    CLI(net)
    net.stop()

if __name__ == '__main__':
   setLogLevel( 'info' )
   tfTopo()
