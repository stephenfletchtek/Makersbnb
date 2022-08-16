require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/add' do
    return erb(:add_form)
  end

  post '/add' do
    p params['name']
    listing = { 
    name: params['name'], 
    description: params['description'],
    price_per_night: params['price_per_night'],
    availability: params['availability'] 
    }
    return erb(:add_form_error) unless listing_valid?(listing) 
    repo = ListsRepository.new
    repo.create(listing)
    redirect('/')
  end
  
  private
  
  def listing_valid?(listing)
    return false if listing.values.any? { |v| v.nil? || v.empty? || v != v.strip }
    true
  end
  
end