# Single Tables Design Recipe Template

## 1. Extract nouns from the user stories or specification

```
One airbnb, many bookings 
One User, many bookings 
One booking, one location, one renter


```

```
Nouns:

Listing-
     name, description, price_per_night, dates
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| listings               name, description, price_per_night, availabilty


## 3. Decide the column types.
```
# EXAMPLE:

Table: listings
id: SERIAL
name: text
description: text
price_per_night: int 
availabilty: text
```

## 3. Write the SQL.

```sql

CREATE TABLE listings (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price_per_night int,
  availabilty text
);



```

## 4. Create the tables.

```bash
psql -h 127.0.0.1 makersbnb_test < lists_table.sql
```