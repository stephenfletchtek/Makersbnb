# User Model and Repository Classes Design Recipe

## 1. Design and create the Table

```sql
-- (file: design/tables.sql)
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email text UNIQUE,
  password text
);
```

## 2. Create Test SQL seeds

```sql
-- (file: spec/seeds_users.sql)

TRUNCATE TABLE users RESTART IDENTITY;

INSERT INTO users (email, password) VALUES ('duck@makers.com', 'quack!');
INSERT INTO users (email, password)
  VALUES ('duck2@makers.com', '$2a$12$qmO3XbZHMXhymqZBstr48O0rW8ubyqAITgm9T.cIoQrk0CMEEfECm');
INSERT INTO users (email, password)
  VALUES ('homer@simpsons.com', '$2a$12$GKyE/JG3VsUfVeaPzfoNu.4U2DLkXo9uPbq1/K2MohAgAC2Qw4sTm');
git 
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
class UserRepository

def find(email)
end

def sign_in(email, password)
end


```

## 4. Implement the Model class

It would be this:
```ruby
class User
  attr_accessor :id, :email, :password
end
```
But this is considered bad practice. We will receive user data as a hash directly into the UserRepository

## 5. Define the Repository Class interface

```ruby
# Table name: users

# Repository class
# (in lib/user_repo.rb)

class UserRepository

  def sign_in(email, submitted_password)
    user = find_by_email(email)

    return nil if user.nil?
    
    my_password = BCrypt::Password.new(user['password'])

    if my_password == submitted_password
      # login success
    else
      # wrong password
    end
  end

  def find_by_email(email)
    # sql = 'SELECT * FROM users WHERE email = $1;'
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
