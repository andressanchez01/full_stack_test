require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/activerecord'
require 'json'
require 'dotenv/load'
require 'rack/cors'
require 'logger'
require 'erb'
require 'yaml'
require 'sinatra/cross_origin'


# CORS settings 
use Rack::Cors do
  allow do
    origins '*'
    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :delete, :options]
  end
end

configure do
  enable :cross_origin
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept, Authorization, Origin'
end

options "*" do
  response.headers['Allow'] = 'GET, POST, PUT, DELETE, OPTIONS'
  200
end

env = ENV['RACK_ENV'] || 'development'
db_config_path = './config/database.yml'
raw_config = ERB.new(File.read(db_config_path)).result
db_config = YAML.safe_load(raw_config, aliases: true)

set :database, db_config[env]

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
  result = TransactionController.create(request_body)

  if result[:status] == 'success'
    status 201
  else
    status 422
  end

  result.to_json
end

put '/api/transactions/:id' do
  content_type :json
  request_body = JSON.parse(request.body.read)
  result = TransactionController.update(params[:id], request_body)

  if result[:status] == 'success'
    status 200
  else
    status 422
  end

  result.to_json
end

get '/api/transactions/:id' do
  content_type :json
  TransactionController.get_by_id(params[:id]).to_json
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

post '/transactions/webhook' do
  request.body.rewind
  payload = JSON.parse(request.body.read, symbolize_names: true)

  puts "🪵 Webhook recibido: #{payload.inspect}"

  # Puedes hacer validaciones aquí si quieres
  event = payload[:event]
  transaction_data = payload[:data]

  if event == "transaction.updated" && transaction_data
    # Actualiza la transacción en tu base de datos si es necesario
    transaction_id = transaction_data[:id]
    status = transaction_data[:status]

    if transaction_id && status
      begin
        transaction = Transaction.find_by(id: transaction_id)
        if transaction
          transaction.update(status: status)
          puts "✅ Transacción actualizada vía webhook: #{transaction.inspect}"
        else
          puts "⚠️ Transacción no encontrada: #{transaction_id}"
        end
      rescue => e
        puts "❌ Error al procesar webhook: #{e.message}"
      end
    end
  end

  content_type :json
  status 200
  { status: 'received' }.to_json
end

set :bind, '0.0.0.0'
set :port, 4567

puts "🌍 Running in #{env} environment"
Dotenv.load if File.exist?('.env')