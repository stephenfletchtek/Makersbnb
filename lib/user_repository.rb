require 'BCrypt'

class UserRepository
  def initialize(enc = BCrypt::Password)
    @enc = enc
  end
  
  def find_by_email(email)
    sql = 'SELECT * FROM users WHERE email = $1;'
    sql_params = [email]
    result = DatabaseConnection.exec_params(sql, sql_params)
    fail "user not found - ignore this message in rspec results" if result.ntuples.zero?
    result[0]
  end

  def find_by_id(id)
    sql = 'SELECT * FROM users WHERE id = $1;'
    sql_params = [id]
    result = DatabaseConnection.exec_params(sql, sql_params)
    fail "user not found - ignore this message in rspec results" if result.ntuples.zero?
    result[0]
  end

  def sign_in(email, password)
    user = find_by_email(email)
    @enc.new(user['password']) == password 
  end

end