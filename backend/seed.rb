# seed.rb
require './app'
require './app/models/product'


Product.find(1).update(image_url: "https://fullstacktestfront.s3.us-east-2.amazonaws.com/iloveimg-converted/react.jpeg")
Product.find(2).update(image_url: "https://fullstacktestfront.s3.us-east-2.amazonaws.com/iloveimg-converted/ruby.jpg")
Product.find(3).update(image_url: "https://fullstacktestfront.s3.us-east-2.amazonaws.com/iloveimg-converted/js.jpeg")
Product.find(4).update(image_url: "https://fullstacktestfront.s3.us-east-2.amazonaws.com/iloveimg-converted/mousepad.jpg")
Product.find(5).update(image_url: "https://fullstacktestfront.s3.us-east-2.amazonaws.com/iloveimg-converted/teclado.jpeg")
Product.find(6).update(image_url: "https://fullstacktestfront.s3.us-east-2.amazonaws.com/iloveimg-converted/cable.jpg")



puts "Productos creados!"
