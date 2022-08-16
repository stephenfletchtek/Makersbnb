# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require './lib/listings_repository'

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
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

  private

  def listing_valid?(listing)
    return false if listing.values.any? { |v| v.nil? || v.empty? || v != v.strip }

    true
  end
end
