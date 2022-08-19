require 'booking_repository'

def reset_tables
  seed_sql = File.read('spec/schemas+seeds/seeds_all.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe BookingRepository do
  before(:each) do 
    reset_tables
  end

  #1 
  it "gets all bookings" do 
    repo = BookingRepository.new
    results = repo.all
    expect(results.ntuples).to eq 3

    expect(results[0]['listing_id']).to eq('1')
    expect(results[0]['user_id']).to eq('1')
    expect(results[0]['date_booked']).to eq('2022-12-25')
    expect(results[0]['status']).to eq('pending')
    expect(results[1]['status']).to eq('confirmed')
    expect(results[2]['status']).to eq('denied')
  end

  # need to write this!
  it "updates a booking" do 
    repo = BookingRepository.new
    booking = repo.all[0]
    booking['status'] = 'test'
    repo.update(booking)

    results = repo.all.sort_by { |result| result['id'] }
    expect(results[0]['status']).to eq('test')
    expect(results[1]['status']).to eq('confirmed')
    expect(results[2]['status']).to eq('denied')

  end
end