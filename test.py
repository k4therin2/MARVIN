#!/usr/bin/env python
import socket

host2 = socket.gethostbyname('proxy7.yoics.net') #GET TARGETS IP INTO THIS FIELD SOMEHOW
port2 = 35854
size2 = 2048
print host2
s2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s2.connect((host2,32016))
print s2.send('Activate the thing')
s2.send('ok cmon now jesues')
s2.close

