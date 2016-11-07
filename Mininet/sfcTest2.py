# coding=utf-8
from mininet.net import Containernet
from mininet.node import Controller, Docker, OVSSwitch
from mininet.cli import CLI
from mininet.topo import Topo

class TopoTrabalhoFinal( Topo ):
	def build(self):
		h1 = self.addHost( 'h1' );#cliente de vídeo
		h2 = self.addHost( 'h2' ) #Servidor de video
		#h3 = self.addHost( 'h3',cls=Docker, dimage='gmiotto/click') #Point of Presence
		h3 = self.addHost( 'h3' ) #Servidor de video
		h4 = self.addHost( 'h4' ) #End point do malicioso
		h5 = self.addHost( 'h5' ) #Malicioso

		s1 = self.addSwitch( 's1')
		s2 = self.addSwitch( 's2')
		s3 = self.addSwitch( 's3')
		s4 = self.addSwitch( 's4')
		s5 = self.addSwitch( 's5')

		# Duas interfaces para o PoP
		self.addLink( h3,s3)
		self.addLink( h3,s3)
		
		# Conexões entre switches
		self.addLink( s1,s2)

		self.addLink( s2,s3)

		self.addLink( s3,s4)

		self.addLink( s4,s5)

		# Conexões para hosts
		self.addLink( h1,s1)
		self.addLink( h2,s2)
		self.addLink( h4,s4)
		self.addLink( h5,s5)



topos = { 'TFTopo': TopoTrabalhoFinal }
