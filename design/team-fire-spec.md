# 🔥 Project specification

We would like a web application that allows users to list spaces they have available, and to hire spaces for the night.

## Headline specifications

- Any signed-up user can list a new space.
    - Seed with a list of users (2 or 3)
- Users can list multiple spaces.
    - Show places for each user
- Users should be able to name their space, provide a short description of the space, and a price per night.
    - Place name, description and price (future feature image? )
- Users should be able to offer a range of dates where their space is available.
    
    For a given space - the available dates are listed
    
- Any signed-up user can request to hire any space for one night, and this should be approved by the user that owns that space.
    
      must be signed up to request, requests must be approved, for one night bookings 
    
- Nights for which a space has already been booked should not be available for users to book that space.
    - once its booked its removed from available dates
- Until a user has confirmed a booking request, that space can still be booked for that night.
    - space is only removed from available once confirmed

## Nice-to-haves

- Users should receive an email whenever one of the following happens:
- They sign up
- They create a space
- They update a space
- A user requests to book their space
- They confirm a request
- They request to book a space
- Their request to book a space is confirmed
- Their request to book a space is denied
- Users should receive a text message to a provided number whenever one of the following happens:
- A user requests to book their space
- Their request to book a space is confirmed
- Their request to book a space is denied
- A ‘chat’ functionality once a space has been booked, allowing users whose space-booking request has been confirmed to chat with the user that owns that space
- Basic payment implementation though Stripe.
