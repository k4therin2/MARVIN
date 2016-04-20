require_relative '../messenger.rb'


describe Messenger do
  #setup
  messenger = nil
  #tests
  it 'can connect to a database' do
   expect{messenger = Messenger.new}.to_not raise_error
  end
  it 'can get uid from name' do
    expect(messenger.get_uid_from_name("austin")).to eq "2"
  end
  it 'can send a message' do
    r = Random.new_seed
    messenger.send_message("austin","amzn1.ask.account.AFP3ZWPOS2BGJR7OWJZ3DHPKMOMNWY4AY66FUR7ILBWANIHQN73QHBUI3GAR6SOUXNHQIYV2E2R67VOQDEVZU7XA6KFLJSI3OQOL7HCPVYAN5LHGVL6IYZ67VC3IUI7AHKE434ZO55OPXE6TNUHTF72US3K4XPELLJ2VHGH72223UFIPEF7WG7WJIOOJNGLDJFM2TSNZRGND5JI","test message: " + String(r))
    result = messenger.db_connection.query("select * from messages where message= \"test message: "+ String(r) +"\";")
    expect((result.fetch_row)[0]).to_not eq nil
  end
end
