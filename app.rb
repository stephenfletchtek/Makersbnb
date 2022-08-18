# frozen_string_literal: true

require './lib/database_connection'
require 'sinatra/base'
require 'sinatra/reloader'
require './lib/listings_repository'
require './lib/user_repository'
require './lib/booking_repository'


DatabaseConnection.connect('makersbnb_test')

# MakersBnb web app
class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions

  get '/' do
    repo = ListingsRepository.new
    @all = repo.all
    @user = session[:user_email]
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
      availability: params['availability'],
      image_url: params['image_url']
    } 
    listing[:availability] = 'false' if listing[:availability] == nil
    return erb(:add_form_error) unless listing_valid?(listing)

    repo = ListingsRepository.new
    repo.create(listing)
    redirect('/')
  end

  get '/login' do
    return erb(:login)
  end

  post '/login' do
    email = params[:email]
    password = params[:password]
    return redirect('/login') unless sign_in(email, password) == true
    session[:user_email] = email
    redirect('/')
  end

  get '/listing/:id/add_dates' do
    @id = params[:id]
    return erb(:add_date)
  end

  post '/listing/:id/add_dates' do
    repo = ListingsRepository.new
    listing = repo.find_by_id(params[:id])
    listing[:availability] = params['availability']
    listing[:availability] = 'false' if listing[:availability] == nil
    repo.update(listing)
    redirect("/listing/#{params[:id]}")
  end 

  get '/listing/:id' do
    repo = ListingsRepository.new
    begin
      @listing = repo.find_by_id(params[:id])
      return erb(:listing_id)
    rescue => e
      @error = e
      erb(:listing_id_error)
    end
  end

  get '/bookings' do
    lrepo = ListingsRepository.new
    urepo = UserRepository.new

    #  get an @array of all the bookings for erb
    #  add display values to each booking hash 

    bookings = BookingRepository.new.all

    @display_bookings = bookings.map do |booking|
      {
        # :name needs to be a symbol because the way listings_repo is structured
        name: lrepo.find_by_id(booking['listing_id'])['name'],
        email: urepo.find_by_id(booking['user_id'])['email'],
        date: booking['date_booked'],
        status: booking['status'],
        image_url: lrepo.find_by_id(booking['listing_id'])['image_url']
      }
    end

    return erb(:bookings)
  end

  private

  def listing_valid?(listing)
    return false if listing.values.any? { |v| v.nil? || v.empty? || v != v.strip }
    true
  end

  def sign_in(email, password)
    begin
      repo = UserRepository.new
      return repo.sign_in(email, password)
    rescue => e
      # change this line to alert for user not found
      puts "error: #{e}"
      false
    end
  end
end
