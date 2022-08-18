require 'BCrypt'

class UserRepository
  
  def find(email)
    sql = 'SELECT * FROM users WHERE email = $1;'
    sql_params = [email]
    result = DatabaseConnection.exec_params(sql, sql_params)
    fail "user not found" if result.ntuples.zero?
    result[0]
  end

  def sign_in(email, password)
    user = find(email)
    BCrypt::Password.new(user['password']) == password 
  end

end