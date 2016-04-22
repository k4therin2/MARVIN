from __future__ import print_function
import socket

#Taken from AWS Lambda documetnation
def lambda_handler(event, context):

    
    #The JSON body of the request is provided in the event parameter.

    print("event.session.application.applicationId=" +
          event['session']['application']['applicationId'])
    
    if event['session']['new']:
        on_session_started({'requestId': event['request']['requestId']},
                           event['session'])

    if event['request']['type'] == "LaunchRequest":
        return on_launch(event['request'], event['session'])
    elif event['request']['type'] == "IntentRequest":
        return on_intent(event['request'], event['session'])
    elif event['request']['type'] == "SessionEndedRequest":
        return on_session_ended(event['request'], event['session'])

# Called on session start
#Taken from AWS Lambda documetnation
def on_session_started(session_started_request, session):
    
    print("on_session_started requestId=" + session_started_request['requestId']
          + ", sessionId=" + session['sessionId'])

#Called on skill invocation without arguments
#Taken from AWS Lambda documetnation
def on_launch(launch_request, session):

    print("on_launch requestId=" + launch_request['requestId'] +
          ", sessionId=" + session['sessionId'])
    # Dispatch to your skill's launch
    return get_welcome_response()

#Called when user gives an order to this skill
#Template taken from AWS Lambda documetnation
def on_intent(intent_request, session):

    print("on_intent requestId=" + intent_request['requestId'] +
          ", sessionId=" + session['sessionId'])

    intent = intent_request['intent']
    intent_name = intent_request['intent']['name']

    # Dispatch to your skill's intent handlers
    if intent_name == "SendToIntent":
        return send_message_to(intent, session)
    elif intent_name == "SendNowIntent":
        return send_message_now(intent, session)
    elif intent_name == "SendIntent":
        return send_prompt(intent, session)
    elif intent_name == "SendToNowIntent":
        return send_message_to_now(intent, session)
    elif intent_name == "CheckInboxIntent":
        return request_inbox(intent, session)
    elif intent_name == "ReadMessagesIntent":
        return read_messages(intent, session)
    elif intent_name == "ReadMessageIntent":
        return read_message(intent, session)
    elif intent_name == "AMAZON.HelpIntent":
        return print_something_to_console(intent, session)
    elif intent_name == "AMAZON.HelpIntent":
        return get_welcome_response()
    elif intent_name == "AMAZON.CancelIntent" or intent_name == "AMAZON.StopIntent":
        return handle_session_end_request()
    else:
        raise ValueError("Invalid intent")

#Called when should_end_session = true.  Loses all session data and exits skill
def on_session_ended(session_ended_request, session):

    print("on_session_ended requestId=" + session_ended_request['requestId'] +
          ", sessionId=" + session['sessionId'])
    # add cleanup logic here

# --------------- Functions that control the skill's behavior ------------------


def get_welcome_response():
    
    session_attributes = {}
    card_title = "Welcome"
    speech_output = "Welcome to the Messenger App. " \
                    "Do you want to send a message, or check your inbox?"
    # If the user either does not reply to the welcome message or says something
    # that is not understood, they will be prompted again with this text.
    reprompt_text = "Do you want to send a message, or check your inbox?"
    should_end_session = False
    return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))


def handle_session_end_request():
    card_title = "Session Ended"
    speech_output = "Exiting Messenger..."
    # Setting this to true ends the session and exits the skill.
    should_end_session = True
    return build_response({}, build_speechlet_response(
        card_title, speech_output, None, should_end_session))

#Called when user specifies they want to send a message without arguments
def send_prompt(intent, session):

    card_title = intent['name']
    session_attributes = {}
    should_end_session = False

    speech_output = "Who do you want to send the message to? "
    reprompt_text = "Who do you want to send the message to? "
    
    return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))
        
#Called when user specifies they want to send a message, and who to send it to
def send_message_to(intent, session):
    
    card_title = intent['name']
    session_attributes = {}
    should_end_session = False

    if 'Who' in intent['slots']:
        person = intent['slots']['Who']['value']
        session_attributes = create_recipient_attribute(person)
        speech_output = "What do you want to say to " + \
                        person 
        reprompt_text = "What do you want to say to " + \
                        person 
    else:
        speech_output = "I don't know who you want to send the message to"
        reprompt_text = "I don't know who you want to send the message to"
    return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))
        
# A debugging method, which prints a string sent to the cloud
def print_something_to_console(intent, session):

    card_title = intent['name']
    session_attributes = {}
    should_end_session = False
    host = 'ec2-52-90-241-171.compute-1.amazonaws.com'
    port = 77
    size = 4096
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host,port))
    newmessage = ''
    s.send(newmessage)
    data = s.recv(size)
    s.close()
    speech_output = "I sent the printout"
    reprompt_text = "I sent the printout"
    should_end_session = True;
    return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))
        
#The final step, declared when
def send_message_now(intent, session):

    speech_output = 'error here'
    reprompt_text = 'error here'
    id = session['user']['userId']
    card_title = intent['name']
    session_attributes = {}
    should_end_session = False
    if 'attributes' in session:
        if 'recipient' in session['attributes']:
            recipient = session['attributes']['recipient']
    else:
        speech_output = "I don't know who you want to send the message to.  " + \
                        "Please say who you want to send a message to"
        reprompt_text = "I don't know who you want to send the message to.  " + \
                        "Please say who you want to send a message to"
        return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))
    if 'Message' in intent['slots']:
        message = intent['slots']['Message']['value']
        host = 'ec2-52-90-241-171.compute-1.amazonaws.com'
        port = 77
        size = 4096
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((host,port))
        newmessage = '' + \
                     id + \
                     '|sendMessage|' + \
                     str(recipient) + \
                     '|' + \
                     str(message) + \
                     '|'
        s.send(newmessage)
        data = s.recv(size)
        s.close()
        speech_output = "I sent " + \
                        recipient + \
                        " the message " + \
                        message
        reprompt_text = "I sent " + \
                        recipient + \
                        " the message " + \
                        message
        should_end_session = True;
    else:
        speech_output = "I don't understand the message"
        reprompt_text = "I don't understand the message"
    return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))

def send_message_to_now(intent, session):
    """ Sets the color in the session and prepares the speech to reply to the
    user.
    """
    id = session['user']['userId']
    card_title = intent['name']
    session_attributes = {}
    should_end_session = False
    if 'Message' in intent['slots']:
        message = intent['slots']['Message']['value']
        if 'Who' in intent['slots']:
            recipient = intent['slots']['Who']['value']
        else:
            speech_output = "I don't know who to send it to"
            reprompt_text = "I don't know who to send it to"
            return build_response(session_attributes, build_speechlet_response(
                card_title, speech_output, reprompt_text, should_end_session))
        host = 'ec2-52-90-241-171.compute-1.amazonaws.com'
        port = 77
        size = 4096
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((host,port))
        newmessage = '' + \
                     id + \
                     '|sendMessage|' + \
                     str(recipient) + \
                     '|' + \
                     str(message) + \
                     '|'
        s.send(newmessage)
        data = s.recv(size)
        s.close()
        speech_output = "I sent " + \
                        recipient + \
                        " the message " + \
                        message
        reprompt_text = "I sent " + \
                        recipient + \
                        " the message " + \
                        message
        should_end_session = True;
    else:
        speech_output = "I don't understand the message"
        reprompt_text = "I don't understand the message"
    return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))
        
def request_inbox(intent, session):
    """ Sets the color in the session and prepares the speech to reply to the
    user.
    """
    id = session['user']['userId']
    session_attributes = {}
    card_title = intent['name']
    
    should_end_session = False
    host = 'ec2-52-90-241-171.compute-1.amazonaws.com'
    port = 77
    size = 4096
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host,port))
    s.send('' + \
            id + \
            '|checkMessages|')
    data = s.recv(size)
    s.close()
    speech_output = str(data)
    reprompt_text = str(data)
    should_end_session = False;
    return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))
        
#Responds with all new messages from bob, starting from oldest first
def read_message(intent, session):

    id = session['user']['userId']
    card_title = intent['name']
    session_attributes = {}
    should_end_session = False

    if 'Who' in intent['slots']:
        who = intent['slots']['Who']['value']
        host = 'ec2-52-90-241-171.compute-1.amazonaws.com'
        port = 77
        size = 8192
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((host,port))
        s.send('' + \
                id + \
                '|readMessage|' + \
                who + \
                '|')
        data = s.recv(size)
        s.close()
        speech_output = str(data)
        reprompt_text = str(data)
        should_end_session = False;
    else:
        speech_output = "I couldn't get those messages"
        reprompt_text = "I couldn't get those messages"
    return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))
        
#Reads all messages
def read_messages(intent, session):

    id = session['user']['userId']
    card_title = intent['name']
    session_attributes = {}
    should_end_session = False
    
    host = 'ec2-52-90-241-171.compute-1.amazonaws.com'
    port = 77
    size = 8192
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host,port))
    s.send('' + \
            id + \
            '|readMessages|')
    data = s.recv(size)
    s.close()
    speech_output = str(data)
    reprompt_text = str(data)
    should_end_session = False;
    return build_response(session_attributes, build_speechlet_response(
        card_title, speech_output, reprompt_text, should_end_session))

def create_recipient_attribute(person):
    return {"recipient": person}


# --------------- Helpers that build all of the responses ----------------------


def build_speechlet_response(title, output, reprompt_text, should_end_session):
    return {
        'outputSpeech': {
            'type': 'PlainText',
            'text': output
        },
        'card': {
            'type': 'Simple',
            'title': 'SessionSpeechlet - ' + title,
            'content': 'SessionSpeechlet - ' + output
        },
        'reprompt': {
            'outputSpeech': {
                'type': 'PlainText',
                'text': reprompt_text
            }
        },
        'shouldEndSession': should_end_session
    }


def build_response(session_attributes, speechlet_response):
    return {
        'version': '1.0',
        'sessionAttributes': session_attributes,
        'response': speechlet_response
    }
