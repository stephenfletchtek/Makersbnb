# frozen_string_literal: true

require 'listings_repository'

def reset_listings_table
  seed_sql = File.read('spec/schemas+seeds/seeds_all.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe ListingsRepository do
  before(:each) do
    reset_listings_table
  end

  it 'finds all listings' do
    repo = ListingsRepository.new

    listings = repo.all

    expect(listings.ntuples).to eq(4)
    expect(listings.first['name']).to eq('Buckingham Palace')
    expect(listings.first['price_per_night']).to eq('35')
  end

  it "updates a listing" do 
    repo = ListingsRepository.new

    listing = repo.find_by_id(1)
    listing['availability'] = 'available'
    repo.update(listing)
    result_listing = repo.find_by_id(1)

    expect(result_listing['name']).to eq('Buckingham Palace')
    expect(result_listing['availability']).to eq('available')
  end 

  it "check extra smurfcal seeds file loads" do
    repo = ListingsRepository.new
    listing = repo.find_by_id(4)
    dates = listing['availability']
    expect(dates[0..3]).to eq('2022')
  end
end
