CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  listing_id int,
  user_id int,
  date_booked text,
  status text,
  constraint fk_listing foreign key(listing_id)
    references listings(id)
    on delete cascade,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);
