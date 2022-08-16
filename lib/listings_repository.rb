# frozen_string_literal: true

# class Listing
#     # Replace the attributes by your own columns.
#     attr_accessor :id, :name, :description, :price_per_night, :availability
# end

class ListingsRepository
  def all
    listings = []
    sql = 'SELECT * FROM listings'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      listing = {
        id: record['id'].to_i,
        name: record['name'],
        description: record['description'],
        price_per_night: record['price_per_night'],
        availability: record['availability']
      }

      listings << listing
    end

    listings
  end

  def create(listing)
    # sql = 'INSERT INTO listings (name, desription, price_per_night, availability)
    #   VALUES $1, $2, $3, $4'
    # params = [listing[:name], listing[:description], listing[:price_per_night], listing[:availability]]
    # DatabaseConnection.exec_params(sql, params)
  end

  def find_by_id(id)
    sql = 'SELECT * FROM listings WHERE id = $1;'
    result = DatabaseConnection.exec_params(sql, [id])
    p result
    fail "record not found" if result.ntuples == 0
    listing = {
        id: result[0]['id'].to_i,
        name: result[0]['name'],
        description: result[0]['description'],
        price_per_night: result[0]['price_per_night'],
        availability: result[0]['availability']
      }
  end
  
  private

  def make_listing(record)
    listing = {
      id: record['id'].to_i,
      name: record['name'],
      description: result[0]['description'],
      price_per_night: record['price_per_night'],
      availability: record['availability']
    }
    listing
  end
end
