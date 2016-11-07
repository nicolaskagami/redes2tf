# coding=utf-8
from mininet.net import Containernet
from mininet.node import Controller, Docker, OVSSwitch
from mininet.cli import CLI
from mininet.topo import Topo

class TopoTrabalhoFinal( Topo ):
	def build(self):
	  s1 = self.addSwitch('s1')
	  s2 = self.addSwitch('s2')
	  s3 = self.addSwitch('s3')
	  s4 = self.addSwitch('s4')
	  s5 = self.addSwitch('s5')
	  s6 = self.addSwitch('s6')
	  s7 = self.addSwitch('s7')
	  s8 = self.addSwitch('s8')
	  s9 = self.addSwitch('s9')
	  s10 = self.addSwitch('s10')
	  s11 = self.addSwitch('s11')
	  s12 = self.addSwitch('s12')
	  s13 = self.addSwitch('s13')
	  s14 = self.addSwitch('s14')

	  # Adding nodes
	  # h1 - h99 - Host / End-user
	  # h100 - Video server
	  h1 = self.addHost('h1', ip='10.0.0.1', mac='00:00:00:00:00:01')
	  h2 = self.addHost('h2', ip='10.0.0.2', mac='00:00:00:00:00:02')
	  h99 = self.addHost('h99', ip='10.0.0.99', mac='00:00:00:00:00:99')



	  # Creating links between hosts and switches
	  self.addLink(h1, s1)
	  self.addLink(h1, s2)
	  self.addLink(h1, s3)
	  self.addLink(h2, s4)
	  self.addLink(h2, s5)
	  self.addLink(h2, s6)
	  self.addLink(h99, s13)

	  #Creating links between switches
	  #Level 1 - RAN
	  self.addLink(s1, s7)
	  self.addLink(s2, s7)
	  self.addLink(s3, s8)
	  self.addLink(s4, s9)
	  self.addLink(s5, s10)
	  self.addLink(s6, s10)

	  #Level 2 - Access
	  self.addLink(s7, s11)
	  self.addLink(s7, s12)
	  self.addLink(s8, s11)
	  self.addLink(s8, s12)
	  self.addLink(s9, s11)
	  self.addLink(s9, s12)
	  self.addLink(s10, s11)
	  self.addLink(s10, s12)

	  #Level 3 - Core
	  self.addLink(s11, s12)
	  self.addLink(s11, s13)
	  self.addLink(s11, s14)
	  self.addLink(s12, s13)
	  self.addLink(s12, s14)
	  self.addLink(s13, s14)




topos = { 'TFTopo': TopoTrabalhoFinal }
