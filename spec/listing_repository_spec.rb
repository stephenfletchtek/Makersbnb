# frozen_string_literal: true
require 'listings_repository'
require 'calendar'

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

  # [happens in app] user makes booking, booking data retrieved from form, form data converted 
  # to calendar object 
  # [happens in repo class] get calendar object, turn back into string, post to database 
  it "updates a listing" do 

    year_2022 = '2022-'\
        '1000000000000000000000000000000-'\
        '0000000000000000000000000000-'\
        '0000000000000000000000000000000-'\
        '000000000000000000000000000000-'\
        '0000000000000000000000000000000-'\
        '000000000000000000000000000000-'\
        '0000000000000000000000000000000-'\
        '0000000000000000000000000000000-'\
        '000000000000000000000000000000-'\
        '0000000000000000000000000000000-'\
        '000000000000000000000000000000-'\
        '0000000000000000000000000000000'

    cal = Calendar.new(year_2022)
   
    repo = ListingsRepository.new
    listing = repo.find_by_id(1)
    listing['availability'] = cal
    
    repo.update(listing)

    listing = repo.find_by_id(1)
    cal_obj = listing['availability']
    expect(cal_obj.available?(2022, 1, 1)).to eq(false)
    expect(cal_obj.available?(2022, 1, 2)).to eq(true)
  end 

  it "creates a new listing" do 
    year_2022 = '2022-'\
    '0000000000000000000000000000000-'\
    '1000000000000000000000000000-'\
    '0000000000000000000000000000000-'\
    '000000000000000000000000000000-'\
    '0000000000000000000000000000000-'\
    '000000000000000000000000000000-'\
    '0000000000000000000000000000000-'\
    '0000000000000000000000000000000-'\
    '000000000000000000000000000000-'\
    '0000000000000000000000000000000-'\
    '000000000000000000000000000000-'\
    '0000000000000000000000000000000'

    cal = Calendar.new(year_2022)

    repo = ListingsRepository.new
    listing_from_sinatra = {
      'name' => 'test_house',
      'description' => 'fake',
      'price_per_night' => 10,
      'availability' => cal,
      'image_url' => 'https://somefake'   
    }
    repo.create(listing_from_sinatra)

    listing = repo.find_by_id(5)
    cal_obj = listing['availability']
    expect(listing['name']).to eq('test_house')
    expect(cal_obj.available?(2022, 2, 1)).to eq(false)
    expect(cal_obj.available?(2022, 2, 2)).to eq(true)
  end 

end
