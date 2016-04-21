#!/usr/bin/env python

from pygame import mixer
import socket
import time

# THIS BELONGS ON THE PI.  AN EXACT COPY OF THIS IS ON EACH PI

host2 = socket.gethostbyname('ec2-52-90-241-171.compute-1.amazonaws.com') #GET TARGETS IP INTO THIS $
port2 = 81  #CHANGE THIS PORT SO ITS UNIQUE TO EACH PI
size2 = 2048
print host2
s2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s2.connect((host2,port2))
s2.send('Connection')
while 1:
    data = s2.recv(size2)
    if data:
        mixer.init()
        mixer.music.load('youGotmail.mp3') #this is the notification sound.  Pick something
        mixer.music.play()
        time.sleep(2)
        mixer.quit()
s2.close

