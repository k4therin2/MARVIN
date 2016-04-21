require_relative '../messenger.rb'


describe Messenger do
  #setup
  before(:all) do
    @messenger = Messenger.new
    @mid = nil
    @token = "amzn1.ask.account.AFP3ZWPOS2BGJR7OWJZ3DHPKMOMNWY4AY66FUR7ILBWANIHQN73QHBUI3GAR6SOUXNHQIYV2E2R67VOQDEVZU7XA6KFLJSI3OQOL7HCPVYAN5LHGVL6IYZ67VC3IUI7AHKE434ZO55OPXE6TNUHTF72US3K4XPELLJ2VHGH72223UFIPEF7WG7WJIOOJNGLDJFM2TSNZRGND5JI"
    @r = Random.new_seed
    @messenger.send_message("austin",@token,"test message: " + String(@r))
    @result = @messenger.db_connection.query("select * from messages where message= \"test message: "+ String(@r) +"\";")
    @mid=(@result.fetch_row)[0]
  end

  #tests
  it 'can connect to a database' do
   expect{Messenger.new}.to_not raise_error
  end
  it 'can get uid from name' do
    expect(@messenger.get_uid_from_name("austin")).to eq "2"
  end
  it 'can get name from token' do
    expect(@messenger.get_name_from_token(@token)).to eq "bob"
  end
  it 'can send a message' do
    expect(@mid).to_not eq nil
  end
  it 'can mark message read' do 
    @messenger.mark_read(@mid)
    is_read = (@messenger.db_connection.query("select is_read from messages where mid="+@mid+";").fetch_row)[0]
    expect(is_read).to eq "1"
  end
  it 'can add user' do 
   @messenger.add_user("user"+String(@r), "token"+String(@r))
   newuser =@messenger.db_connection.query("select * from users where name=\"user"+String(@r)+"\";")
   expect(newuser).to_not eq nil
  end
  it 'can retrieve messages' do
    expect{@messenger.retrieve_messages("1")}.to_not raise_error
  end   
  it 'can build appropriate response' do
    response = @messenger.build_check_messages_response('sheep')
    print "\n |respnse: " + response + "|\n"
    expect(true).to eq true
  end
end
