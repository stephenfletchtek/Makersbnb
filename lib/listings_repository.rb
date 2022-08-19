require './lib/calendar'

# BnB listings repository class
class ListingsRepository
  def all
    sql = 'SELECT * FROM listings'
    DatabaseConnection.exec_params(sql, [])
  end

  def create(listing)
    sql = 'INSERT INTO listings (name, description, price_per_night, availability, image_url)
      VALUES ($1, $2, $3, $4, $5)'

    cal_obj = listing['availability']
    cal_text = cal_obj.instance_variable_get(:@cal)
  
    params = [
      listing['name'],
      listing['description'],
      listing['price_per_night'],   
      cal_text,
      listing['image_url']
    ]
    DatabaseConnection.exec_params(sql, params)
  end

  def find_by_id(id)
    sql = 'SELECT * FROM listings WHERE id = $1;'
    result = DatabaseConnection.exec_params(sql, [id])
    raise 'record not found' if result.ntuples.zero?
    output = result[0]
    cal = Calendar.new(output['availability'])

    # temporary bookings
    # cal.book(2022, 8, 2)
    # cal.book(2022, 8, 3)
    # cal.book(2022, 8, 24)
    # cal.book(2022, 8, 27)
    # cal.book(2022, 8, 28)
    
    output['availability'] = cal
    output
  end

  def update(listing)
    sql = 'UPDATE listings SET name = $1, description = $2, price_per_night = $3, availability = $4, image_url = $5 WHERE id = $6;'

    cal_obj = listing['availability']
    cal_text = cal_obj.instance_variable_get(:@cal)

    params = [
      listing['name'],
      listing['description'],
      listing['price_per_night'],
      cal_text,
      listing['image_url'],
      listing['id']
    ]
    DatabaseConnection.exec_params(sql, params)
  end
end
