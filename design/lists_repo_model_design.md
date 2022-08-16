# listings Model and Repository Classes Design Recipe

## 1. Design and create the Table

```

| Record                | Properties          |
| --------------------- | ------------------  |
| listings               name, description, price_per_night, availabilty


```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql

TRUNCATE TABLE listings RESTART IDENTITY; 

INSERT INTO listings (name, description, price_per_night, availability)VALUES
('Buckingham palace', 'its alright', 35, '9-Oct-2022' ),
('Fawlty Towers', 'A very wonky place to stay', 40, '09-Sept-2022' ),
('Mayfair place', 'An expensive 5 bedroom home', 100, '14-Sept-2022' );


```

```bash
psql -h 127.0.0.1 makersbnb_test < seeds_listings.sql
```

## 3. Define the class names
```ruby

class Listing
end

# Repository class
# (in lib/listing_repository.rb)
class ListingRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: listings


TO BE PUT INSIDE ListingRepository
class Listing

  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :description, :price_per_night, :availability
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: listings

# Repository class
# (in lib/listing_repository.rb)

class ListingRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT all attr

    # Returns an array of Listing objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, cohort_name FROM listings WHERE id = $1;

    # Returns a single Listing object.
  end

    def find_by_name(name)
    # Executes the SQL query:
    # SELECT id, name, cohort_name FROM listings WHERE id = $1;

    # Returns a single Listing object.
  end

  # Add more methods below for each operation you'd like to implement.

  # def create (Listing)
  # end

  # def update (Listing)
  # end

  # def delete (Listing)
  # end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all students

repo = listingRepository.new

listings = repo.all

listings.length # =>  2

listings[0].id # =>  1
listings[0].name # =>  'David'
listings[0].cohort_name # =>  'April 2022'

listings[1].id # =>  2
listings[1].name # =>  'Anna'
listings[1].cohort_name # =>  'May 2022'

# 2
# Get a single listing

repo = listingRepository.new

listing = repo.find(1)

listing.id # =>  1
listing.name # =>  'David'
listing.cohort_name # =>  'April 2022'

# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/listing_repository_spec.rb

def reset_listings_table
  seed_sql = File.read('spec/seeds_listings.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'listings' })
  connection.exec(seed_sql)
end

describe listingRepository do
  before(:each) do 
    reset_listings_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._