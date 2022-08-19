require 'user_repository'

def reset_tables
  seed_sql = File.read('spec/schemas+seeds/seeds_all.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end


describe UserRepository do
  before(:each) do 
    reset_tables
  end

  #1 
  it "find by email finds existing user" do 
    repo = UserRepository.new
    user = repo.find_by_email('duck@makers.com')
    expect(user['id']).to eq "1"
    expect(user['email']).to eq 'duck@makers.com'
    expect(user['password']).to eq '$2a$12$uYZrF/quUM2RdvA2ylfs4eMTns0PUUtKy3wsdR8XtKnc/QmZD02CK'
  end

  #2 
  it "fails find_by_email finding non-existent user" do 
    repo = UserRepository.new
    expect { repo.find_by_email('ducks@makers.com') }.to raise_error "user not found - ignore this message in rspec results"
  end

  #3 
  it "finds_by_id existing user" do 
    repo = UserRepository.new
    user = repo.find_by_id('1')
    expect(user['id']).to eq "1"
    expect(user['email']).to eq 'duck@makers.com'
    expect(user['password']).to eq '$2a$12$uYZrF/quUM2RdvA2ylfs4eMTns0PUUtKy3wsdR8XtKnc/QmZD02CK'
  end

  #4
  it "fails finding (by id) non-existent user" do 
    repo = UserRepository.new
    expect { repo.find_by_id('9') }.to raise_error "user not found - ignore this message in rspec results"
  end

  #5 note that non-existent user case already covered in #2.
  it "Signs a user in" do
    repo = UserRepository.new
    result = repo.sign_in('duck@makers.com', 'quack!')
    result2 = repo.sign_in('duck@makers.com', 'wrong_password')
    expect(result).to eq true
    expect(result2).to eq false
  end

  #6 
  it " fails for No password - might be blocked front end" do 
    repo = UserRepository.new
    result = repo.sign_in('duck@makers.com', '')
    expect(result).to eq false
  end

  #7 
  it "fails for Blank email - might be blocked front end" do
    repo = UserRepository.new()
    expect{ repo.sign_in('', 'rubbish') }.to raise_error "user not found - ignore this message in rspec results"
  end

end