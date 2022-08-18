TRUNCATE TABLE users, listings, bookings  RESTART IDENTITY;


INSERT INTO listings (name, description, price_per_night, availability, image_url)VALUES
('Buckingham Palace', 'its alright', 35, '9-Oct-2022', 'https://drive.google.com/uc?export=view&id=1Zfoy6o9qAd-Tsqo66LkH2BhtX9-BE2L0'),
('Fawlty Towers', 'A very wonky place to stay', 40, '09-Sept-2022', 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d6/Fawlty_Towers_title_card.jpg/250px-Fawlty_Towers_title_card.jpg' ),
('Mayfair Place', 'An expensive 5 bedroom home', 100, '14-Sept-2022',' https://hubble.imgix.net/listings/uploads/spaces/1032/2015-08-20_16%2B46%2B01%2B407082_Mayfair%20Building%2050size%20.jpg' );

INSERT INTO users (email, password) VALUES
('duck@makers.com', '$2a$12$uYZrF/quUM2RdvA2ylfs4eMTns0PUUtKy3wsdR8XtKnc/QmZD02CK'),
('duck2@makers.com', '$2a$12$qmO3XbZHMXhymqZBstr48O0rW8ubyqAITgm9T.cIoQrk0CMEEfECm'),
('homer@simpsons.com', '$2a$12$GKyE/JG3VsUfVeaPzfoNu.4U2DLkXo9uPbq1/K2MohAgAC2Qw4sTm');

INSERT INTO bookings (listing_id, user_id, date_booked, status) VALUES
('1', '1', '2022-12-25', 'pending'),
('2', '3', '2022-07-30', 'confirmed'),
('1', '2', '2022-02-14', 'denied');