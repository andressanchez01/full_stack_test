require 'yaml'
db_config = YAML.load_file('./config/database.yml', aliases: true)
puts db_config['development']['adapter']