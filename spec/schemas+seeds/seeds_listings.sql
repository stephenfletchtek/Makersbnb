TRUNCATE TABLE listings RESTART IDENTITY; 

INSERT INTO listings (name, description, price_per_night, availability, image_url)VALUES
('Buckingham Palace', 'its alright', 35, '9-Oct-2022', 'https://drive.google.com/uc?export=view&id=1Zfoy6o9qAd-Tsqo66LkH2BhtX9-BE2L0'),
('Fawlty Towers', 'A very wonky place to stay', 40, '09-Sept-2022', 'https://images.squarespace-cdn.com/content/v1/5cc6fcdf29f2cc769fa2800b/1656413376126-WMCCU[…]A152ZGAIGYN/DT-Fawlty-Towers-1_auto_x2.jpg?format=2500w' ),
('Mayfair Place', 'An expensive 5 bedroom home', 100, '14-Sept-2022',' https://hubble.imgix.net/listings/uploads/spaces/1032/2015-08-20_16%2B46%2B01%2B407082_Mayfair%20Building%2050size%20.jpg' );
