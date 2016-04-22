require_relative '../messenger.rb'

describe Messenger do
  # setup
  before(:all) do
    @messenger = Messenger.new
    @user_name = 'test_user'
    @messenger.delete_user_by_name(@user_name) # in case previous test crashed
  end

  # shutdown
  after(:all) do
    @messenger.db_connection.close
  end

  # test init
  it 'can connect to a database' do
    expect { Messenger.new }.to_not raise_error
  end

  #========== ADD A USER ==============
  it 'can add a user' do
    token = 'test_token1'
    @messenger.add_user(@user_name, token)
    users_check = @messenger.db_connection.query('select name from users where token="' + token + '";')
    name = users_check.fetch_row[0]
    expect(name).to eq @user_name
    @messenger.delete_user_by_name(@user_name)
  end

  #======= GET UID METHODS =============
  # get_uid_from_name
  it 'can get uid from name' do
    token = 'test_token2'
    @messenger.add_user(@user_name, token)
    users_check = @messenger.db_connection.query('select uid from users where token="' + token + '";')
    uid = users_check.fetch_row[0]
    expect(@messenger.get_uid_from_name(@user_name)).to eq uid
    @messenger.delete_user_by_name(@user_name)
  end

  # get_uid_from_token
  it 'can get uid from token' do
    token = 'test_token3'
    @messenger.add_user(@user_name, token)
    users_check = @messenger.db_connection.query('select uid from users where token="' + token + '";')
    uid = users_check.fetch_row[0]
    expect(@messenger.get_uid_from_token(token)).to eq uid
    @messenger.delete_user_by_name(@user_name)
  end

  #======= GET NAME METHODS =============
  # get_name_from_uid
  it 'can get name from uid' do
    token = 'test_token5'
    @messenger.add_user(@user_name, token)
    users_check = @messenger.db_connection.query('select name from users where token=' + token + ';')
    name = users_check.fetch_row[0]
    uid_check = @messenger.db_connection.query('select uid from users where token=' + token + ';')
    uid = uid_check.fetch_row[0]
    expect(@messenger.get_name_from_uid(uid)).to eq name
    @messenger.delete_user_by_name(@user_name)
  end

  # get_name_from_token
  it 'can get name from token' do
    token = 'test_token6'
    @messenger.add_user(@user_name, token)
    users_check = @messenger.db_connection.query('select name from users where token="' + token + '";')
    name = users_check.fetch_row[0]
    expect(@messenger.get_name_from_token(token)).to eq name
    @messenger.delete_user_by_name(@user_name)
  end

  #======= ALTERING/RETRIEVEING MESSAGE METHODS TESTED MANUALLY =============
end

