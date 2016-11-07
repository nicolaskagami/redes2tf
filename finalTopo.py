#!/usr/bin/python

#Executar com o comando:
# sudo mn --custom finalTopo.py --topo finaltopo [...]

from mininet.topo import Topo
from mininet.net import Mininet
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel

class FinalTopo (Topo):
    "My Topo for multipath"

    def __init__( self ):

        Topo.__init__( self )

        h1 = self.addHost('h1')
        h2 = self.addHost('h2')

        ap2 = self.addSwitch('ap2')
        ap3 = self.addSwitch('ap3')
        ap4 = self.addSwitch('ap4')
        ap5 = self.addSwitch('ap5')
        ap7 = self.addSwitch('ap7')
        ap8 = self.addSwitch('ap8')
        ap9 = self.addSwitch('ap9')
        ap10 = self.addSwitch('ap10')

        topMiddleSwitch = self.addSwitch('s1')
        topLeftSwitch = self.addSwitch('s7')
        topRightSwitch = self.addSwitch('s8')

        topMiddleLeftSwitch = self.addSwitch('s2')
        topMiddleRightSwitch = self.addSwitch('s3')

        bottomMiddleLeftSwitch = self.addSwitch('s4')
        bottomMiddleRightSwitch = self.addSwitch('s5')

        bottomLeftSwitch = self.addSwitch('s9')
        bottomMiddleSwitch = self.addSwitch('s6')
        bottomRightSwitch = self.addSwitch('s10')

        self.addLink(h1, topMiddleSwitch)
        self.addLink(h2, bottomMiddleSwitch)

        self.addLink(topLeftSwitch, topMiddleSwitch) #s7-s1
        self.addLink(topLeftSwitch, topMiddleLeftSwitch) #s7-s2
        self.addLink(topMiddleSwitch, topMiddleLeftSwitch) #s1-s2
        self.addLink(topMiddleSwitch, topRightSwitch) #s1-s8
        self.addLink(topMiddleSwitch, topMiddleRightSwitch) #s1-s3
        self.addLink(topMiddleSwitch, bottomMiddleSwitch) #s1-s6
        self.addLink(topRightSwitch, topMiddleRightSwitch) #s8-s3
        self.addLink(topMiddleLeftSwitch, bottomMiddleRightSwitch) #s2-s5
        self.addLink(topMiddleLeftSwitch, bottomMiddleLeftSwitch) #s2-s4
        self.addLink(topMiddleRightSwitch, bottomMiddleRightSwitch) #s3-s5
        self.addLink(topMiddleRightSwitch, bottomMiddleLeftSwitch) #s3-s4
        self.addLink(bottomMiddleLeftSwitch, bottomLeftSwitch) #s4-s9
        self.addLink(bottomMiddleLeftSwitch, bottomMiddleSwitch) #s4-s6
        self.addLink(bottomMiddleRightSwitch, bottomMiddleSwitch) #s5-s6
        self.addLink(bottomMiddleRightSwitch, bottomRightSwitch) #s5-s10
        self.addLink(bottomLeftSwitch, bottomMiddleSwitch) #s9-s6
        self.addLink(bottomRightSwitch, bottomMiddleSwitch) #s10-s6

        self.addLink(ap2, topMiddleLeftSwitch)
        self.addLink(ap3, topMiddleRightSwitch)
        self.addLink(ap4, bottomMiddleLeftSwitch)
        self.addLink(ap5, bottomMiddleRightSwitch)
        self.addLink(ap7, topLeftSwitch)
        self.addLink(ap8, topRightSwitch)
        self.addLink(ap9, bottomLeftSwitch)
        self.addLink(ap10, bottomRightSwitch)


topos = {'finaltopo' : (lambda: MyTopo() ) }
