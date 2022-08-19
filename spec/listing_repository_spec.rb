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

    # this test needs to be redeveloped 
    expect(result_listing['name']).to eq('Buckingham Palace')
    cal = result_listing['availability']
    expect {cal.available?(2022, 1, 1) }.to raise_error("Date year [2022] does not match calendar year [0]")
  end 
end
