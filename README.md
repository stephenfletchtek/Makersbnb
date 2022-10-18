# MakersBnB

Our team challenge was to develop a Ruby / Sinatra based BnB application over the period of 1 week.


This repo contains the seed codebase for the MakersBnB project in Ruby (using Sinatra and RSpec).

## Get Started

### Install

```bash
# Install gems
bundle install

# Install postgresql.
$ brew install postgresql

# (...)

# Run this after the installation
# to start the postgresql software
# in the background.
$ brew services start postgresql

# You should get the following output:
==> Successfully started `postgresql` (label: homebrew.mxcl.postgresql)
```

### Run

This application rack as its server.

```bash
# Run the server (better to do this in a separate terminal).
rackup
```

Now go to **http://localhost:9292/** in your web browser

### Testing

User Rspec to run unit tests and integration tests as used during development.

```bash
# Run the tests
rspec
```
