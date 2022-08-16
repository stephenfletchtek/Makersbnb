# GET '/listing/id' Route Design Recipe
## 1. Design the Route Signature

Request: 
    GET 'listing/:id'
Response: 
    status: (200)
    body: a page with these details:
                                - name 
                                - description 
                                - price_per_night
                                - availability


## 2. Design the Response

```html
<!-- GET "/add" -->
<!-- Response when the post is found: 200 OK -->

<html></html>
  <head></head>
  <body>
    <h1>Details for: <%= @listing[:name] %></h1>
    <p>Description: <%= @listing[:description] %></p>  
    <p>Price per night: <%= @listing[:price_per_night] %></p>  
    <p>Available dates: <%= @listing[:availability] %></p>  
  </body>
</html>
```
## 3. Write Examples
```
Request: 
    GET 'listing/:id'
Response: 
    status: (200)
    body: a page with these details:
                                - name 
                                - description 
                                - price_per_night
                                - availability
```


## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /listing/:id" do
    it 'returns 200 OK when a listing is found' do
      response = get('/listing/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Details for: Buckingham Palace</h1>')
      expect(response.body).to include('<p>Description: its alright</p>')
    end

    it 'responds to a listing not found' do 
      response = get('/listing/10')
      expect(response.status).to eq(404) 
    end
  end
  
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
