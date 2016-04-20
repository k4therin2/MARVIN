#!/usr/bin/env python

import socket
import mosquitto

host = ''
port = 81
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

def on_message(obj, msg):
    client.send(data)    
    
mqttc = mosquitto.Mosquitto('python')

mqttc.on_message = on_message

mqttc.connect('localhost', 1883, 60, True)

mqttc.subscribe('test',2)

while mqttc.loop() == 0:
    pass
