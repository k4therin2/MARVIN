# M.A.R.V.I.N.
*Messaging Application / Really Very Intellegent Neighbor*
----------

**What's MARVIN?**

MARVIN is an Alexa skill that allows you to message other Alexa users. MARVIN was developed for Alexa running on a Raspberry Pi (you can put one together yourself [here](https://github.com/amzn/alexa-avs-raspberry-pi/blob/master/README.md)).

**How does it work?**

When you ask for Marvin to do something, your request will be sent to the *[Alexa Skills Kit](https://developer.amazon.com/appsandservices/solutions/alexa/alexa-skills-kit) voice service*. 

The voice service will parse your request into an intent, which the service will then send to an *[AWS Lambda Function](https://aws.amazon.com/lambda/).* 

The function, written in Python, interfaces with our *[EC2 Instance](https://aws.amazon.com/ec2/)* running a server (Ruby) that talks to our Messenger application to complete the request.

Finally, if you configure our notification service (that uses [MQTT](http://mqtt.org/)), your Pi will also alert you when you have new messages waiting to be read by MARVIN.

**There's too many folders. What goes where?**

 1. `MQTT`  and `Notifications` contains the MQTT listener/server to be set up on the Pi and server.
 2.  `Cloud` includes everything that goes in the *Lamda function* (`Cloud/Lambda`) and  the *Alexa Voice Service Profile* (`Cloud/Alexa`). 
 3. `Messenger` contains the messenger application that interfaces with the database, called by `server.rb` to complete requests made by the user.

**Cool. How do I get started?**

## Pi

There are 4 major scripts that need to be running on the pi.

To begin the alexa service, first navigate to `Alexa/samples/companionService/` and

`sudo npm start`

Next, navigate to the `Alexa/samples/javaclient` folder in a terminal **WITHIN VNC** and run

`mvn exec:exec`

Follow the instructions. If this fails, try `sudo env "PATH=$PATH" mvn exec:exec`.

Remember to start the notification listener as well:

`notifcations\notification_listener.py`

## EC2

To start the server, make sure appropriate ports are open in your security group and run
`ruby server.rb`
To start the notification service, 
`notifications/notifcation_server_name.py`
Note there should be one of these scripts running for each Pi connected to the service- that means if you have 5 Pis talking to eachother, you should have 5 seperate notifcation server scripts. Make sure the ports match up!
`ruby server.rb`

## Pi

Let's go back to the pi for a moment and start the notification listener.

`sudo ./notification_listener.py `

