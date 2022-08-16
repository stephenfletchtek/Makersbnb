# frozen_string_literal: true

require './lib/database_connection'
require 'sinatra/base'
require 'sinatra/reloader'
require './lib/listings_repository'

DatabaseConnection.connect('makersbnb_test')

# MakersBnb web app
class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    repo = ListingsRepository.new
    @all = repo.all
    return erb(:index)
  end

  get '/add' do
    return erb(:add_form)
  end

  post '/add' do
    listing = {
      name: params['name'],
      description: params['description'],
      price_per_night: params['price_per_night'],
      availability: params['availability']
    }
    return erb(:add_form_error) unless listing_valid?(listing)

    repo = ListingsRepository.new
    repo.create(listing)
    redirect('/')
  end

  get '/listing/:id' do
    repo = ListingsRepository.new
    @listing = repo.find_by_id(params[:id])
    return erb(:listing_id)
  end

  private

  def listing_valid?(listing)
    return false if listing.values.any? { |v| v.nil? || v.empty? || v != v.strip }

    true
  end
end
