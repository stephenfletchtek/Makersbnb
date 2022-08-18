# Single Tables Design Recipe Template

## 1. Extract nouns from the user stories or specification

```
One listing, many bookings 
One User, many bookings 
One booking, one listing, one renter

```

```
Nouns:

Booking, listing, user
     
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties                                 |
| --------------------- | ------------------------------------------ |
| bookings              | listing_id, user_id, date_booked, status   |


## 3. Decide the column types.
```
# EXAMPLE:

Table: bookings
id: SERIAL
listing_id: int
user_id: int
date_booked: text 
status: text
```

## 3. Write the SQL.

```sql

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


```

## 4. Create the tables.

```bash
psql -h 127.0.0.1 makersbnb_test < bookings_table.sql
```