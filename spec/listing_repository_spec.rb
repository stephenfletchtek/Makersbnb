# frozen_string_literal: true

require 'listings_repository'

def reset_listings_table
  seed_sql = File.read('spec/schemas+seeds/seeds_listings.sql')
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

    expect(listings.length).to eq(3)
    expect(listings.first[:name]).to eq('Buckingham Palace')
    expect(listings.first[:price_per_night]).to eq('35')
  end

  it "updates a listing" do 
    repo = ListingsRepository.new

    listing = repo.find_by_id(1)
    listing[:availability] = 'available'
    repo.update(listing)
    result_listing = repo.find_by_id(1)

    expect(result_listing[:name]).to eq('Buckingham Palace')
    expect(result_listing[:availability]).to eq('available')
  end 

  #   it 'finds one listing' do
  #     repo = ListingsRepository.new

  #     listing = repo.find(3)

  #     expect(listing['id']).to eq(3)
  #     expect(listing.title).to eq('Waterloo')
  #     expect(listing.artist_id).to eq(2)
  #   end

  #   it 'creates an listing' do
  #     repo = ListingsRepository.new

  #     new_listing = listing.new
  #     new_listing.title = 'Pablo Honey'
  #     new_listing.release_year = 1993
  #     new_listing.artist_id = 1
  #     repo.create(new_listing)

  #     listings = repo.all

  #     expect(listings.length).to eq(13)
  #     expect(listings.last.title).to eq('Pablo Honey')
  #     expect(listings.last.artist_id).to eq(1)
  #   end

  #   it 'deletes an listing' do
  #     repo = ListingsRepository.new

  #     repo.delete(1)
  #     listings = repo.all

  #     expect(listings.length).to eq(11)
  #     expect(listings.first.id).to eq(2)
  #   end
end
