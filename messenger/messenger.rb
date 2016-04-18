#!/usr/bin/ruby

require 'mysql'

class Messenger
  attr_accessor :db_connection, :user_table, :message_table

  def initialize
    @db_connection = Mysql.new 'localhost', 'ubuntu'
    @database = "UserProfiles"
    @user_table = "users"
    @message_table = "messages"
  end

  def send_message(message)

  end
end 
