require 'sequel'
DB = Sequel.sqlite("./db/#{ENV.fetch(RACL_ENV, 'development')}.db")