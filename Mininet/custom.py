from mininet.net import Mininet
from mininet.cli import CLI

net = Mininet() # net is a Mininet() object
h1 = net.addHost( 'h1' ) # h1 is a Host() object
h2 = net.addHost( 'h2' ) # h2 is a Host()
h3 = net.addHost( 'h3' ) # h1 is a Host() object
h4 = net.addHost( 'h4' ) # h1 is a Host() object
h5 = net.addHost( 'h5' ) # h1 is a Host() object
s1 = net.addSwitch( 's1' ) # s1 is a Switch() object
s2 = net.addSwitch( 's2' ) # s1 is a Switch() object
s3 = net.addSwitch( 's3' ) # s1 is a Switch() object
s4 = net.addSwitch( 's4' ) # s1 is a Switch() object
s5 = net.addSwitch( 's5' ) # s1 is a Switch() object
c0 = net.addController( 'c0' ) # c0 is a Controller()
net.addLink( h1, s1 ) # creates a Link() object
net.addLink( h2, s4 )
net.addLink( h3, s5 )
net.addLink( h4, s1 )
net.addLink( h5, s2 )

net.addLink( s1, s2 )
net.addLink( s1, s3 )
net.addLink( s1, s4 )

net.addLink( s2, s3 )
net.addLink( s2, s5 )

net.addLink( s3, s4 )
net.addLink( s3, s5 )

net.addLink( s4, s5 )

net.start()
#print h1.cmd( 'ping -c1', h2.IP() )
CLI( net )
net.stop() 
