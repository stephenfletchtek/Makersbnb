# frozen_string_literal: true
require 'spec_helper'
require 'rack/test'
require_relative '../../app'
require 'json'

def reset_listings_table
  seed_sql = File.read('spec/schemas+seeds/seeds_listings.sql')
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
      # expect(confirm.body).to include('test_name')
      # expect(confirm.body).to include('test_description')
    end

    it "doesn't add if form is incomplete" do
      response = post('/add', name: 'test_name', description: 'test_description', price_per_night: '', availability: '')
      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Listing form invalid!</p>')
    end
  end

  context 'GET /listing/:id' do
    it 'returns 200 OK when a listing is found' do
      response = get('/listing/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h5 class="card-title">Buckingham Palace</h5>')
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
      expect(response.body).to include('<label class="form-label">Is this listing currently available? :</label>')
      expect(response.body).to include('<input type="text" class="form-control" id="availability" placeholder="current availablity" name="availability" required>')
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
    xit "logs in" do

    end

    xit "doesn't log in wrong password" do
    end

    xit "doesn't log in non existant email" do
    end

    xit "log in user_2 causes user_1 to log out" do
    end
  end
end