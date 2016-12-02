#!/usr/bin/python
# coding=utf-8

import getopt
import sys
import time
import random

opts, args = getopt.getopt(sys.argv[1:], "", ["flows=", "dos="])
for o, a in opts:
    if o == "--flows":
        number_of_flows=int(a)
        print "Flows: ",a
    elif o in ("--dos"):
        number_of_dos=int(a)
        print "DoS: ",a

#Flows 
random.seed()
hs = [1,2,3,4,5,6,7,8,9,10]
random.shuffle(hs)
for i in range(0,number_of_flows):
    h_src = hs[2*i] 
    h_tgt = hs[2*i+1]
    print h_src,"->", h_tgt
    
targets = [1,2,3,4,5]
random.shuffle(targets)
for i in range(0,number_of_dos):
    print "Attacking p%s" % targets[i]


