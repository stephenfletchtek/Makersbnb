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
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /' do
    it 'returns 200 OK and return correct html' do
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include('<title>MakersBnB</title>')
      expect(response.body).to include('<nav class="navbar navbar-default">')
    end
  end

  context 'GET /add' do
    it 'returns 200 OK and return correct html' do
      response = get('/add')

      expect(response.status).to eq(200)
      expect(response.body).to include('<input type="submit" value="Add Listing"/>')
      expect(response.body).to include('<form action="/add" method="POST">')
      expect(response.body).to include('<input type="text" name="price_per_night">')
    end
  end

  context 'POST /add' do
    it 'returns 200 OK if a completed form is submitted' do
      response = post('/add', name: 'test_name', description: 'test_description', price_per_night: 'test_price',
                              availability: 'test_date')
      expect(response.status).to eq(302)
      expect(response.body).to eq('')
      # confirm = get('/')
      # expect(confirm.status).to eq(200)
      # expect(confirm.body).to include('test_name')
      # expect(confirm.body).to include('test_description')
    end

    it "doesn't add if form is incomplete" do
      response = post('/add', name: 'test_name', description: 'test_description', price_per_night: '', availability: '')
      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Listing form invalid!</p>')
    end
  end
end
