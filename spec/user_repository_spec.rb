require 'user_repository'

def reset_tables
  seed_sql = File.read('spec/schemas+seeds/seeds_users.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end


describe UserRepository do
  before(:each) do 
    reset_tables
  end

  #1 
  it "finds existing user" do 
    repo = UserRepository.new
    user = repo.find('duck@makers.com')
    expect(user['id']).to eq "1"
    expect(user['email']).to eq 'duck@makers.com'
    expect(user['password']).to eq '$2a$12$uYZrF/quUM2RdvA2ylfs4eMTns0PUUtKy3wsdR8XtKnc/QmZD02CK'
  end

  #2 
  it "fails finding non-existent user" do 
    repo = UserRepository.new
    expect { repo.find('ducks@makers.com') }.to raise_error "user not found"
  end

  #3 note that non-existent user case already covered in #2.
  it "Signs a user in" do
    repo = UserRepository.new
    result = repo.sign_in('duck@makers.com', 'quack!')
    result2 = repo.sign_in('duck@makers.com', 'wrong_password')
    expect(result).to eq true
    expect(result2).to eq false
  end

  #4 
  it " fails for No password - might be blocked front end" do 
    repo = UserRepository.new
    result = repo.sign_in('duck@makers.com', '')
    expect(result).to eq false
  end

  #5 
  it "fails for Blank email - might be blocked front end" do
    repo = UserRepository.new
    expect{ repo.sign_in('', 'rubbish') }.to raise_error "user not found"
  end

end