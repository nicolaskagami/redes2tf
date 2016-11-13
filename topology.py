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
pop_cpu_percentage=90
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

    p1 = net.addHost('p1', ip='10.0.1.1', mac='00:00:00:00:01:01', cls=Docker, dimage='gmiotto/click',mem_limit=1024*1024*1024, cpu_quota=pop_cpu_percentage*100,cpu_period=10000)
    #p2 = net.addHost('p2', ip='10.0.1.2', mac='00:00:00:00:01:02', cls=Docker, dimage='progrium/stress',mem_limit=1024*1024*10, cpu_quota=pop_cpu_percentage*100,cpu_period=10000)

    #Switches
    s1 = net.addSwitch('s1')

    #PoP Hosts
    #net.addLink(p1,s1, cls=TCLink, delay=pop_link_delay,bw=pop_link_bw,loss=pop_link_loss)
    net.addLink(p1,s1)
    net.addLink(p1,s1)

    #net.addLink(p2,s1, cls=TCLink, delay=pop_link_delay,bw=pop_link_bw,loss=pop_link_loss)
    #net.addLink(p2,s1)

    #Normal Hosts
    #net.addLink(h1,s1, cls=TCLink, delay=host_switch_delay,bw=host_switch_bw,loss=host_switch_loss)
    #net.addLink(h2,s1, cls=TCLink, delay=host_switch_delay,bw=host_switch_bw,loss=host_switch_loss)
    net.addLink(h1,s1)
    net.addLink(h2,s1)

    net.start()

    for host in net.hosts:
        if "h" in host.name:
            host.cmd('ethtool -K %s-eth0 tso off' % host.name)

    for host in net.hosts:
        if "p1" in host.name:
            call("sudo bash Click/runFirewall.sh %s Click/firewall3.click " % host.name,shell=True)

    time.sleep(2)
    h2.cmd('iperf -u -s &')
    h1.cmd('sudo bash Measurement/meas.sh >> Results/standard.dat & ')
    
    time.sleep(20)
    h1.cmd('sudo bash Measurement/meas.sh >> Results/ATK1/compromised.dat & ')
    call("sudo docker run --rm --cpu-shares=512 -it progrium/stress --cpu 2 --io 1 --vm 2 --vm-bytes 128M --timeout 20s",shell=True)

    #for host in net.hosts:
    #    if "p2" in host.name:
    #        call("sudo bash Click/runCPUSpike.sh %s" % host.name,shell=True)

    #    print net.hosts[pair[0]].name, "->", net.hosts[pair[1]].name
    #    net.hosts[h_src].cmd('bash client.sh "%s" 10.0.0.%s &' % (net.hosts[h_src].name, h_tgt+1))
    #    net.hosts[h_src].cmd('echo ha')
    #    print 'bash client.sh "%s" %s &' % (net.hosts[h_src].name, net.hosts[h_tgt].name)
        

    #h1.cmd('ping -c1 10.0.1.%s &' % targets[i])
    # print "Attacking p%s" % targets[i]


    CLI(net)
    net.stop()

if __name__ == '__main__':
   setLogLevel( 'info' )
   tfTopo()
