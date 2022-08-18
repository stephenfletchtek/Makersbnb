class BookingRepository

  def all
    sql = 'SELECT * FROM bookings;'
    results = DatabaseConnection.exec_params(sql, [])
  end

  # subject to review and testing
  def create(booking)
    sql = 'INSERT INTO bookings (listing_id, user_id, date_booked, status)
      VALUES ($1, $2, $3, $4);'
    params = []
    DatabaseConnection.exec_params(sql, params)
  end
end
