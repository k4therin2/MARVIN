#!/usr/bin/env python

import socket
import string
"""
#Possible COMMANDS for INBOX are "requestAmount" and "getMessage - number"
def readCommand(str data):
    if string.find('Inbox') == 0:
        devID = ''
        command = ''
        x = 6
        print 'Got their inbox'
        while data[x] != '|':      #This gets us the DevID in the case of an in$
            devID = devID + data[x]
            x = x + 1
        print devID  #At this point we have the DevID
        x = x + 1
        while data[x] != '|':
            command = command + data[x]
            x = x + 1
	print command # we have the command now, so we will work with this to figure out how many args we should look for
	if command == '
"""
host = ''
port = 80
backlog = 5
size = 4096
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((host,port))
s.listen(backlog)
while 1:
    client, address = s.accept()
    data = client.recv(size)
    print data
   # if string.find('Inbox') == 0:
#	devID = ''
 #       command = ''
  #      x = 6
   #     print 'Got their inbox'
#	while data[x] != '|':      #This gets us the DevID in the case of an inbox call
#	    devID = devID + data[x]
 #           x = x + 1
#	print devID  #At this point we have the DevID
#	while data[x] != '|'
    if data:
        client.send(data)
    client.close() 
