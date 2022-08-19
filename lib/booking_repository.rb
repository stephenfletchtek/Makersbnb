class BookingRepository

  def all
    sql = 'SELECT * FROM bookings;'
    results = DatabaseConnection.exec_params(sql, [])
  end

  def create(booking)
    sql = 'INSERT INTO bookings (listing_id, user_id, date_booked, status)
      VALUES ($1, $2, $3, $4);'
    params = [
      booking['listing_id'],
      booking['user_id'],
      booking['date_booked'],
      booking['status']
    ]
    DatabaseConnection.exec_params(sql, params)
  end

  # not tested - match on 3 parameters
  def update(booking)
    sql = 'UPDATE bookings SET status = "confirmed"
      WHERE listing_id = $1 
      AND user_id = $2
      AND date_booked = $3;'
      
    params = [
      booking['listing_id'],
      booking['user_id'],
      booking['date_booked']
    ]
    DatabaseConnection.exec_params(sql, params)
  end
end
