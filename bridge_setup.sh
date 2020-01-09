ip l del br0
ip l del br1

ip l add br0 type bridge
ip l add br1 type bridge

ip l set br0 up
ip l set br1 up

ip l set eth2 master br0
ip l set eth3 master br1
ip l set eth4 master br0
ip l set eth5 master br1
