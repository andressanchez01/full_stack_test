# db_console.rb
require 'active_record'
require 'yaml'
require 'erb'

env = ENV['RACK_ENV'] || 'development'

# Carga la configuración de base de datos
db_config = YAML.safe_load(
  ERB.new(File.read('config/database.yml')).result,
  aliases: true,
  permitted_classes: [Symbol]
)

# Conexión a la base de datos en entorno development
ActiveRecord::Base.establish_connection(db_config['development'])

# Muestra las tablas existentes
puts "Tablas en la base de datos:"
puts ActiveRecord::Base.connection.tables
