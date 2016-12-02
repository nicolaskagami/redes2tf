from mininet.topo import Topo

class SingleSwitchTopo( Topo ):
	"Single Switch Topology"

	def build(self, count=1):
		hosts = [self.addHost( 'h%d' % i )
			for i in range( 1,count +1) ]
		s1 = self.addSwitch( 's1')
		for h in hosts:
			self.addLink( h,s1)
topos = { 'TFTopo': SingleSwitchTopo }
