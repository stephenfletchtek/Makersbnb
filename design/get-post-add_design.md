# GET/POST '/add' Route Design Recipe
## 1. Design the Route Signature

Request: 
    GET "/add"
Response: 
    status: (200)
    body: a form with fields
          - name 
          - description 
          - price_per_night
          - availability

Request: 
    POST "/add"
Response: 
    status: (200)
    body: ""
    redirect: to get "/"

## 2. Design the Response

```html
<!-- GET "/add" -->
<!-- Response when the post is found: 200 OK -->

<html>
  <head></head>
  <body>
    <h1>Add Accommodation</h1>
      <form action="/add" method="POST">
        <label>Name</label>
        <input type="text" name="name">
        <label>Description</label>
        <input type="text" name="description">
        <label> Price per Night: </label>
        <input type="text" name="price_per_night">
        <label>Availability</label>
        <input type="text" name="availability">
        <input type="submit" value="Add Listing"/>
      </form>
  </body>
</html>

<!-- POST "/add" -->

redirect to GET "/"
```
## 3. Write Examples
```
# Request: 
    GET "/add"
# Response: 
    status: (200)
    body: a form with fields
          - name 
          - description 
          - price_per_night
          - availability


Request: 
    POST "/add"
Response: 
    status: (200)
    body: ""
    redirect: to get "/"
```


## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /add" do
    it 'returns 200 OK' do
      response = get('/posts?id=1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<input type="submit" value="Add Listing"/>')
      expect(response.body).to include('<form action="/add" method="POST">')
      expect(response.body).to include('<input type="text" name="price_per_night">')
    end

  end
  
  context "POST /add" do
    it 'returns 200 OK if a completed form is submitted' do
      response = post('/add', name: "test_name", description: "test_description", price_per_night: "test_price", availability: "test_date")
      expect(response.status).to eq(200)
      expect(response.body).to eq('')
      confirm = get('/')
      expect(confirm.status).to eq(200)
      expect(confirm.body).to include('test_name')
      expect(confirm.body).to include('test_description')
    end

    it "doesn't add if form is incomplete" do
      response = post('/add', name: "test_name", description: "test_description", price_per_night: "", availability: "")
      expect(response.status).to eq(200)
      expect(response.body).to include('<p>You must enter a price per night</p>')
      expect(response.body).to include('<p>You must enter a availability</p>')
    end
  end
  
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
