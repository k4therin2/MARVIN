#!/usr/bin/ruby

require 'mysql'

class Messenger
  attr_accessor :db_connection, :user_table, :message_table

  def initialize
    @db_connection = Mysql.new 'localhost', 'ubuntu'
    @database = "UserProfiles"
    @user_table = "users"
    @message_table = "messages"
    @db_connection.query("USE UserProfiles")
  end

  def send_message(to, from, message)
    query="INSERT INTO messages (uid, uid_from, message) VALUES("+String(to)+","+String(from)+",\""+String(message)+"\");"
    @db_connection.query(query)
  end

  def mark_read(mid)
    query="UPDATE messages SET is_read=1 WHERE mid="+String(mid)+";"
    @db_connection.query(query)
  end

  def add_user(name, device_id)
    query="INSERT INTO users (name, device_id) VALUES(\""+String(name)+"\","+String(device_id)+");"
    @db_connection.query(query)    
  end

  def retrieve_unread_messages(uid)
    query="SELECT * FROM messages WHERE uid="+uid+" AND IS_READ=0;"  
    messages = @db_connection.query(query)
    read_messages(messages)
  end
  
  def read_messages(mysql_response)
    n = mysql_response.num_rows
    n.times do 
      puts mysql_response.fetch_row
    end
  end

  def retrieve_messages(uid)
    query="SELECT * FROM messages WHERE uid="+uid+" AND IS_READ=0;"  
    @db_connection.query(query)
  end
end 

messenger = Messenger.new
messages = messenger.retrieve_unread_messages("1")

