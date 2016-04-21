#!/usr/bin/ruby

require 'mysql'

class Messenger
  attr_accessor :db_connection, :user_table, :message_table

  def initialize
    @db_connection = Mysql.new 'localhost', 'ubuntu'
    @database = "Marvin"
    @user_table = "users"
    @message_table = "messages"
    @db_connection.query("USE UserProfiles")
  end

  def get_uid_from_name(name)
     name = name.downcase
     query="SELECT * FROM users WHERE name=\"" + name +"\";" 
     results = @db_connection.query(query)
     row = results.fetch_row
     row[0]
  end

  def get_name_from_uid(uid)
    query="SELECT name FROM users WHERE uid="+uid+";"
    result = @db_connection.query(query)
    row = result.fetch_row
    row[0]
  end
  def get_name_from_token(token)
     query="SELECT device_id FROM devices WHERE token=\"" + token +"\";" 
     results = @db_connection.query(query)
     row = results.fetch_row
     device_id= row[0]
     query="SELECT name FROM users WHERE device_id=" + device_id +";"
     name=@db_connection.query(query).fetch_row
     name[0]
  end

  def send_message(to, from, message)
    uid = get_uid_from_name(to)
    from_name = get_name_from_token(from)
    #print "\n FROM NAME: " + from_name + "\n"
    uid_from = get_uid_from_name(from_name)
    query="INSERT INTO messages (uid, uid_from, message) VALUES("+String(uid)+","+String(uid_from)+",\""+String(message)+"\");"
    #print "\n\n\n\n" + query+"\n\n\n\n"
    @db_connection.query(query)
  end

  def mark_read(mid)
    query="UPDATE messages SET is_read=TRUE WHERE mid="+String(mid)+";"
    @db_connection.query(query)
  end

  def add_user(name, token)
    name = name.downcase
    query = "INSERT INTO devices (token) VALUES(\""+token+"\");"
    @db_connection.query(query)
    query = "SELECT * FROM devices WHERE token=\"" + token + "\";"
    results = @db_connection.query(query).fetch_row
    device_id = results[0]
    query="INSERT INTO users (name, device_id) VALUES(\""+String(name)+"\","+String(device_id)+");"
    @db_connection.query(query)    
  end

  def retrieve_unread_messages(token)
    uid = get_uid_from_token(token)
    query="SELECT * FROM messages WHERE uid="+uid+" AND IS_READ=0;"  
    messages = @db_connection.query(query)
    read_messages(messages)
  end

  def retrieve_unread_messages_from(token, from)
    uid = get_uid_from_token(token)
    uid_from = get_uid_from_name(from)
    query = "select * from messages where uid="+uid+" AND uid_from="+uid_from+" AND IS_READ=0;"
  end
  
  def get_uid_from_token(token)
     did = get_did_from_token(token)
     query = "select uid from users where device_id="+did+";"
     ((@db_connection.query(query)).fetch_row)[0]
  end
  
  def get_did_from_token(token)
    query = "select device_id from devices where token=\"" + token+ "\";"
    ((@db_connection.query(query)).fetch_row)[0]
  end

  def read_messages(mysql_response)
    n = mysql_response.num_rows
#    print "ROW NUm: "+ String(n) +"\n"
    messages = []
    from = []
    n.times do 
      row = mysql_response.fetch_row
      msg = row[2]
      from_uid = row[4]
      from << get_name_from_uid(from_uid)
      messages << msg 
      print msg + "\n"
    end
    [from, messages]
  end

  def retrieve_messages(uid)
    query="SELECT * FROM messages WHERE uid="+uid+" AND IS_READ=0;"  
    @db_connection.query(query)
  end

  def build_check_messages_response(token)
     (from, messages)= retrieve_unread_messages(token)
      if messages.size == 0
        response = "You have no new messages."
      elsif messages.size == 1
        print get_from(from)
        response = "Hi! You have a message from " + get_from(from)+"."
      elsif messages.size > 1
        response = "Hello! You have messages from " + get_from(from)+"."
      end
      response
  end

 def build_read_messages_response(token)
   (from, messages)=retrieve_unread_messages(token)
   size = from.size
     response = ""
   while size > 0
     response << from[size-1] + " says " + messages[size-1] + ".  "
     size = size - 1
   end
   response
 end
 
 def build_read_message_response(token, from)
   (from, messages)=retrieve_unread_messages_from(token, from)
   size = from.size
      response =""
    while size > 0
      response << from[size-1]+" says " + messages[size-1] + ".  "
    end
    response
 end

 def get_from(from_array)
    from = from_array.uniq 
    size = from.size
    response =""
    if size == 1
      response << from[0]
    end
    while size > 1 
      if size == 2
         response << from[size-1] + " and " + from[size-2]
         size = size - 2
      else
         response << from[size-1] + ","
         size = size - 1
      end
    end
    response
 end  

end
