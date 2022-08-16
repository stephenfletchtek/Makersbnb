# class Listing
#     # Replace the attributes by your own columns.
#     attr_accessor :id, :name, :description, :price_per_night, :availability
# end

class ListingRepository
    def all
      listings = []
  
      # Send the SQL query and get the result set.
      sql = 'SELECT * FROM listings'
      result_set = DatabaseConnection.exec_params(sql, [])
      
      # The result set is an array of hashes.
      # Loop through it to create a model
      # object for each record hash.
      result_set.each do |record|
  
        # Create a new model object
        # with the record data.
        listing = {}
        id: record['id'].to_i
        name: = record['name']
        listing.price_per_night = record['price_per_night']
        listing.availability = record['availability']
  
        listings << listing
        
      end
      listings
    end
    
end