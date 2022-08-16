
TRUNCATE TABLE listings RESTART IDENTITY; 

INSERT INTO listings (name, description, price_per_night, availability)VALUES
('Buckingham Palace', 'its alright', 35, '9-Oct-2022' ),
('Fawlty Towers', 'A very wonky place to stay', 40, '09-Sept-2022' ),
('Mayfair Place', 'An expensive 5 bedroom home', 100, '14-Sept-2022' );
