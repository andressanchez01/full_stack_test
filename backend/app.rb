require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/activerecord'
require 'json'
require 'dotenv/load'
require 'rack/cors'
require 'logger'
require 'erb'
require 'yaml'

Dotenv.load

env = ENV['RACK_ENV'] || 'development'
db_config_path = './config/database.yml'
raw_config = ERB.new(File.read(db_config_path)).result
db_config = YAML.safe_load(raw_config, aliases: true)

set :database, db_config[env]

# CORS settings
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end

# DB settings
set :database_file, './config/database.yml'

# Cargar modelos, controladores y servicios
Dir["./app/models/*.rb"].each { |file| require file }
Dir["./app/repositories/*.rb"].each { |file| require file }
Dir["./app/services/*.rb"].each { |file| require file }
Dir["./app/controllers/*.rb"].each { |file| require file }

# products routes
get '/api/products' do
  content_type :json
  ProductController.get_all.to_json
end

get '/api/products/:id' do
  content_type :json
  ProductController.get_by_id(params[:id]).to_json
end

# transactions routes
post '/api/transactions' do
  content_type :json
  request_body = JSON.parse(request.body.read)
  TransactionController.create(request_body).to_json
end

put '/api/transactions/:id' do
  content_type :json
  request_body = JSON.parse(request.body.read)
  TransactionController.update(params[:id], request_body).to_json
end

# customer routes
post '/api/customers' do
  content_type :json
  request_body = JSON.parse(request.body.read)
  CustomerController.create(request_body).to_json
end

# delivery routes
post '/api/deliveries' do
  content_type :json
  request_body = JSON.parse(request.body.read)
  DeliveryController.create(request_body).to_json
end

options "*" do
  response.headers["Allow"] = "GET, POST, PUT, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Headers"] = "Origin, Content-Type, Accept, Authorization, Token"
  200
end