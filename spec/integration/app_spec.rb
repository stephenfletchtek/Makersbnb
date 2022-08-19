# frozen_string_literal: true
require 'spec_helper'
require 'rack/test'
require_relative '../../app'
require 'json'

def reset_listings_table
  seed_sql = File.read('spec/schemas+seeds/seeds_all.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

RSpec.describe Application do
  before(:each) do
    reset_listings_table
  end

  include Rack::Test::Methods

  let(:app) { Application.new }

  context 'GET /' do
    it 'returns 200 OK and return correct html' do
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include('<title>MakersBnB</title>')
      expect(response.body).to include('<nav class="navbar navbar-expand-md bg-light navbar-light">')
    end
  end

  context 'GET /add' do
    it 'returns 200 OK and return correct html' do
      response = get('/add')

      expect(response.status).to eq(200)
      expect(response.body).to include(' <title>Add accomodation</title>')
      expect(response.body).to include('<form action="/add" method="POST" class="">')
      expect(response.body).to include('<input type="text" class="form-control" id="price_per_night" placeholder="Price per night..." name="price_per_night" required>')
    end
  end

  context 'POST /add' do
    it 'returns 302 OK if a completed form is submitted' do
      response = post('/add', name: 'test_name', description: 'test_description', price_per_night: 23,
        availability: 'test_date', image_url: 'https://i2-prod.mylondon.news/incoming/article19572361.ece/ALTERNATES/s615/1937_SUR105926_IMG_00_0000jpegjpgBarnard-Marcus.jpg')

      expect(response.status).to eq(302)
      expect(response.body).to eq('')
      confirm = get('/')
      expect(confirm.status).to eq(200)
   
      expect(confirm.body).to include('test_name')
      expect(confirm.body).to include('test_description')
      

    end

    it "doesn't add if form is incomplete" do
      response = post('/add', name: 'test_name', description: 'test_description', price_per_night: '', availability: '')
      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Listing form invalid!</p>')
    end
  end

  context 'GET /listing/:id' do
    it 'returns 200 OK when a listing is found' do
      response = get('/listing/4')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h5 class="card-title">Portaloo</h5>')
      expect(response.body).to include('<a class="nav-link" href="#">Log In</a>')
    end

    it 'responds to a listing not found' do
      response = get('/listing/10')
      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Description: record not found</p>')
    end
  end
  
  context 'GET /listing/:id/add_dates' do
    it 'returns 200 OK when a listing is found' do
      response = get('/listing/1/add_dates')

      expect(response.status).to eq(200)
      expect(response.body).to include('<label class="form-label">Is this listing currently available?</label>')
      expect(response.body).to include('Is this listing currently available?')
    end
  end

  context "POST /listing:id/add_dates" do
    it "posts true/false in the listing" do
      response = post('/listing/1/add_dates', availability: 'available')
      expect(response.status).to eq(302)
      expect(response.body).to eq('')
      details = get('listing/1')
      expect(details.body).to include('<a class="nav-link" href="#">Log In</a>')
    end
  end

  context "GET /login" do
    it "gets login form" do
      response = get('/login')
      expect(response.status).to eq(200)
      expect(response.body).to include('method="POST"')
      expect(response.body).to include('action="/login"')
      expect(response.body).to include('name="email"')
    end
  end

  context "POST /login" do
    it "logs in" do
      response = post('/login', email: 'duck@makers.com', password: 'quack!')
      expect(response.status).to eq(302)
      expect(response.body).to eq('')
      homepage = get('/')
      expect(homepage.body).to include('duck@makers.com')
    end

    it "doesn't log in with wrong password" do
      response = post('/login', email: 'duck@makers.com', password: 'woof!')
      expect(response.status).to eq(302)
      expect(response.body).to eq('')
      homepage = get('/')
      expect(homepage.body).not_to include('duck@makers.com')
    end

    it "doesn't log in with non existent email" do
      response = post('/login', email: 'dog@makers.com', password: 'quack!')
      expect(response.status).to eq(302)
      expect(response.body).to eq('')
      homepage = get('/')
      expect(homepage.body).not_to include('dog@makers.com')
    end

    it "log in user_2 causes user_1 to log out" do
      response = post('/login', email: 'duck@makers.com', password: 'quack!')
      response = post('/login', email: 'homer@simpsons.com', password: 'springfield1')
      expect(response.status).to eq(302)
      expect(response.body).to eq('')
      homepage = get('/')
      expect(homepage.body).not_to include('duck@makers.com')
      expect(homepage.body).to include('homer@simpsons.com')
    end
  end  

  context "bookings page" do 
    it "GET '/bookings" do 
      response = get('/bookings')
      expect(response.status).to eq 200 
      expect(response.body).to include "Buckingham Palace" 
      expect(response.body).to include "duck@makers.com" 
      expect(response.body).to include "2022-12-25"
      expect(response.body).to include "pending"
      expect(response.body).to include "confirmed"
      expect(response.body).to include "denied"
     end
  end
  
  context "get book a listing" do
    it "when logged in - listing/1/book" do
      post('/login', email: 'duck@makers.com', password: 'quack!')
      response = get('listing/1/book')
      expect(response.status).to eq(200)
      expect(response.body).to include('Buckingham Palace')
    end

    it "when not logged in - listing/1/book" do
      response = get('listing/1/book')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>You need to log in to perform this action</h1>')
    end
  end

  context "post book a listing" do
    it "when logged in - listing/4/book" do
      post('/login', email: 'duck@makers.com', password: 'quack!')
      response = post('listing/4/book', availability: '2022-12-24')
      expect(response.status).to eq(302)
      expect(response.body).to eq ('')
      expect(BookingRepository.new.all[3]['date_booked']).to eq('2022-12-24')
      response2 = get('/bookings')
      expect(response2.body).to include '2022-12-24'
      expect(response2.body).to include 'duck@makers.com'
      expect(response2.body).not_to include 'quack!'
    end

    it "when not logged in - listing/1/book" do
      response = post('listing/1/book', availability: '2022-12-24')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>You need to log in to perform this action</h1>')
    end
  end
end
