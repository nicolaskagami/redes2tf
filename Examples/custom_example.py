from mininet.net import Mininet
from mininet.cli import CLI

net = Mininet() # net is a Mininet() object
h1 = net.addHost( 'h1' ) # h1 is a Host() object
h2 = net.addHost( 'h2' ) # h2 is a Host()
s1 = net.addSwitch( 's1' ) # s1 is a Switch() object
c0 = net.addController( 'c0' ) # c0 is a Controller()
net.addLink( h1, s1 ) # creates a Link() object
net.addLink( h2, s1 )
net.start()
print h1.cmd( 'ping -c1', h2.IP() )
CLI( net )
net.stop() 
