require 'listing_repository'

def reset_listings_table
  seed_sql = File.read('spec/schemas+seeds/seeds_listings.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe ListingRepository do
  before(:each) do 
    reset_listings_table
  end

  it 'finds all listings' do
    repo = ListingRepository.new

    listings = repo.all
    
    expect(listings.length).to eq(3)
    expect(listings.first.name).to eq('Buckingham Palace')
    expect(listings.first.price_per_night).to eq("35")
  end

#   it 'finds one listing' do
#     repo = ListingRepository.new

#     listing = repo.find(3)
    
#     expect(listing.id).to eq(3)
#     expect(listing.title).to eq('Waterloo')
#     expect(listing.artist_id).to eq(2)
#   end

#   it 'creates an listing' do
#     repo = ListingRepository.new

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
#     repo = ListingRepository.new

#     repo.delete(1)
#     listings = repo.all

#     expect(listings.length).to eq(11)
#     expect(listings.first.id).to eq(2)
#   end
end