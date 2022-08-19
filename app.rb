# frozen_string_literal: true

require './lib/database_connection'
require 'sinatra/base'
require 'sinatra/reloader'
require './lib/listings_repository'
require './lib/user_repository'
require './lib/booking_repository'
require './lib/calendar'

if ENV['ENV'] == 'test'
  DatabaseConnection.connect('makersbnb_test')
else
  DatabaseConnection.connect('makersbnb')
end

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

    blank_2022 = '2022-'\
    '0000000000000000000000000000000-'\
    '0000000000000000000000000000-'\
    '0000000000000000000000000000000-'\
    '000000000000000000000000000000-'\
    '0000000000000000000000000000000-'\
    '000000000000000000000000000000-'\
    '0000000000000000000000000000000-'\
    '0000000000000000000000000000000-'\
    '000000000000000000000000000000-'\
    '0000000000000000000000000000000-'\
    '000000000000000000000000000000-'\
    '0000000000000000000000000000000'

    blank_cal = Calendar.new(blank_2022)

    listing = {
      'name' => params['name'],
      'description' => params['description'],
      'price_per_night' => params['price_per_night'],
      'image_url' => params['image_url']
    } 

    return erb(:add_form_error) unless listing_valid?(listing)

    listing['availability'] = blank_cal

    # may not be needed if we ditch the toggle
    listing[:availability] = 'false' if listing[:availability] == nil

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

  get '/listing/:id/book' do
    return erb(:not_logged_in) unless session[:user_email]
    @id = params[:id]
    @listing = ListingsRepository.new.find_by_id(params[:id])
    return erb(:book_date)
  end

  post '/listing/:id/book' do
    return erb(:not_logged_in) unless session[:user_email]
    booking_repo = BookingRepository.new
    user_repo = UserRepository.new
    listing_id = params[:id]
    user_id = user_repo.find_by_email(session[:user_email])['id']
    booking = {
      'listing_id' => listing_id,
      'user_id' => user_id,
      'date_booked' => params[:availability],
      'status' => 'pending'
    }
    booking_repo.create(booking)
    redirect('/bookings')
  end

  get '/listing/:id' do
    repo = ListingsRepository.new
    begin
      @id = params[:id]
      @listing = repo.find_by_id(params[:id])

      # A calendar picker thingy would go here instead of
      # this list that simply shows next week

      # The erb file evaluates @listing['availability'] from the database
      # against this particular week from the 'calendar picker'

      @calendar_picker = [
        '2022-08-22',
        '2022-08-23',
        '2022-08-24',
        '2022-08-25',
        '2022-08-26',
        '2022-08-27',
        '2022-08-28',
      ]

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
