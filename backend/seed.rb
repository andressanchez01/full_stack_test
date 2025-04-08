# seed.rb
require './app'
require './app/models/product'

Product.delete_all
Product.create(name: "Camiseta React", description: "Camiseta con logo de React", price: 29900, stock_quantity: 10)
Product.create(name: "Taza Ruby", description: "Taza con logo de Ruby", price: 15500, stock_quantity: 25)
Product.create(name: "Sticker JS", description: "Sticker divertido de JavaScript", price: 3900, stock_quantity: 100)

puts "Productos creados!"
