require 'bundler'
Bundler.require


Dir.glob('./{helpers,models,controllers}/*.rb').each do |file|
	require file
	puts "required #{file}"
end

require_relative 'connection.rb'

map('/sessions'){ run UserController }
map('/foods'){ run FoodController }
map('/parties'){ run PartyController }
map('/orders'){ run OrderController }
map('/'){ run ApplicationController }
