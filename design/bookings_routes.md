# Bookings Routes Design Recipe

## 1. Design the Route Signature

# GET '/login'

Request: 
    GET '/login'
Response: 
    status: (200)
    body: a page with these details:
                                - email 
                                - password 
                                - submit button

Request: POST '/login'

Response:
  status: (302)
  body ''
  redirect to ('/')
 _______________________________
# GET '/signup' could be added here


## 2. Design the Response

```html
<!-- GET "/add" -->
<!-- Response when the post is found: 200 OK -->


<html></html>
  <head></head>
  <body>
    <form method="POST" action="/login">
      <label class="form-label">User Email:</label>
      <input type="text" name="email" required>
      <label class="form-label">Password:</label>
      <input type="text" name="password" required>
      <button type="submit" value="submit">
    </form>
</body>
</html>
```


## 3. Write Examples
```
Request: 
    GET '/login'
Response: 
    status: (200)
    body: a page with these details:
                                - email
                                - password
                                - sumbit button
```

```
Request:
  POST '/login'
Response:
  status: (302)
  body ''
  redirect to ('/')
```


## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

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
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
