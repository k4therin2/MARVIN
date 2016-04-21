#!/usr/bin/env python

import socket
import paho.mqtt.client as mqtt

#THIS FILE BELONGS ON THE CLOUD, AND IS ONE OF SEVERAL NOTIFICATION SERVICES, ONE FOR EACH PI

host = ''
port = 81  #CHANGE THIS PORT TO MATCH THE TARGET PI'S PORT
#ENSURE THE PI'S USER MATCHES THE NAME WE ARE SUBSCRIBED TO
print host
backlog = 5
size = 2048
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((host,port))
s.listen(backlog)
client, address = s.accept()
data = client.recv(size)
print data
#client.send(data)
#client.close()

def on_message(client3, userdata, msg):
    client.send(data)

client2 = mqtt.Client()

client2.on_message = on_message

client2.connect('localhost', 1883, 60)

client2.subscribe('test') #SUBSCRIBE TO THE NAME OF THE PERSON

client2.loop_forever()


