# frozen_string_literal: true

# BnB listings repository class
class ListingsRepository
  def all
    sql = 'SELECT * FROM listings'
    result_set = DatabaseConnection.exec_params(sql, [])
    result_set.map { |record| make_listing(record) }
  end

  def create(listing)
    sql = 'INSERT INTO listings (name, description, price_per_night, availability, image_url)
      VALUES ($1, $2, $3, $4, $5)'
    params = [listing[:name], listing[:description], listing[:price_per_night], listing[:availability], listing[:image_url]]
    DatabaseConnection.exec_params(sql, params)
  end

  def find_by_id(id)
    sql = 'SELECT * FROM listings WHERE id = $1;'
    result = DatabaseConnection.exec_params(sql, [id])
    raise 'record not found' if result.ntuples.zero?
    result.map { |record| make_listing(record) }[0]
  end

  def update(listing)
    sql = 'UPDATE listings SET name = $1, description = $2, price_per_night = $3, availability = $4, image_url = $5 WHERE id = $6;'

    params = [listing[:name], listing[:description], listing[:price_per_night], listing[:availability], listing[:image_url], listing[:id]]
    DatabaseConnection.exec_params(sql, params)
    return
  end

  private

  # Only done here and has caused confusion
  # This is the only repo that returns results hash with symbols

  def make_listing(record)
    {
      id: record['id'].to_i,
      name: record['name'],
      description: record['description'],
      price_per_night: record['price_per_night'],
      availability: record['availability'],
      image_url: record['image_url']
    }
  end
end
