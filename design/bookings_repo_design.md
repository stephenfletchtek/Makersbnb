# User Model and Repository Classes Design Recipe

## 1. Design and create the Table

Already done

## 2. Create Test SQL seeds

```sql
-- (file: spec/seeds_all.sql)

TRUNCATE TABLE users, bookings RESTART IDENTITY;

INSERT INTO bookings (listing_id, user_id, date_booked, status)
  VALUES ('1', '1', '2022-12-25', 'pending')

INSERT INTO bookings (listing_id, user_id, date_booked, status)
  VALUES ('2', '3', '2022-07-30', 'confirmed')

INSERT INTO bookings (listing_id, user_id, date_booked, status)
  VALUES ('1', '2', '2022-02-14', 'denied')

```
note that original password for homer is springfield1


```sql
INSERT INTO listings (name, description, price_per_night, availability, image_url)VALUES
('Buckingham Palace', 'its alright', 35, '9-Oct-2022', 'https://drive.google.com/uc?export=view&id=1Zfoy6o9qAd-Tsqo66LkH2BhtX9-BE2L0'),
('Fawlty Towers', 'A very wonky place to stay', 40, '09-Sept-2022', 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d6/Fawlty_Towers_title_card.jpg/250px-Fawlty_Towers_title_card.jpg' ),
('Mayfair Place', 'An expensive 5 bedroom home', 100, '14-Sept-2022',' https://hubble.imgix.net/listings/uploads/spaces/1032/2015-08-20_16%2B46%2B01%2B407082_Mayfair%20Building%2050size%20.jpg' );

```


```bash
psql -h 127.0.0.1 makersbnb_test < spec/seeds_users.sql
```

## 3. Define the class names

```ruby
# Table name: users

# Model class not necessary

# Repository class
# (in lib/user_repo.rb)
class BookingRepository

def all
end

```

## 4. Implement the Model class

```
This is considered bad practice. We will receive user data as a hash directly into the BookingRepository
```

## 5. Define the Repository Class interface

```ruby
# Table name: bookings

# Repository class
# (in lib/booking_repo.rb)

class BookingRepository

  def all
    sql 'SELECT * FROM bookings;'
    results = DatabaseConnection.exec_params(sql, [])
  end

end

```

## 6. Test Examples

```ruby
#1 Find existing user
repo = UserRepository.new
user = repo.find_by_email('duck@makers.com')
user.id # => '1'
user.email # => 'duck@makers.com'
user.password # => 'quack!'

#2 Find non-existent user
repo = UserRepository.new
repo.find_by_email('ducks@makers.com') # => fail "user not found"

#3 Sign a user in 
repo = UserRepository.new
result = repo.sign_in('duck@makers.com', 'quack!')
result2 = repo.sign_in('duck@makers.com', 'wrong_password')
result3 = repo.sign_in('duckz@makers.com', 'quack!')
result # => true
result2 # => false
result3 # => false

#4 No password - might be blocked front end
repo = UserRepository.new
result = repo.sign_in('billy@silly.com', '')
result # => false

#5 Blank email - might be blocked front end
repo = UserRepository.new
repo.sign_in('', 'rubbish') # => fail "user not found"

```

## 7. Reload the SQL seeds before each test run

```ruby

# file: spec/user_repo_spec.rb

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
  connection.exec(seed_sql)
end

describe ItemRepository do
  before(:each) do 
    reset_tables
  end

  # (tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_Follow the test-driving process of red, green, refactor to implement the behaviour._
