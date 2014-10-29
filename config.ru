
require 'bundler'
Bundler.require


require './controllers/application_controller'
require './controllers/food_controller'
require './controllers/order_controller'
require './controllers/party_controller'
require './models/food'
require './models/order'
require './models/party'
require_relative 'connection.rb'


map('/foods'){ run FoodController }
map('/parties'){ run PartyController }
map('/orders'){ run OrderController }
map('/'){ run ApplicationController }