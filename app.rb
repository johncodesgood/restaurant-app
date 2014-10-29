require 'bundler'
Bundler.require
require 'pry'

# require 'sinatra/activerecord/rake'
require_relative 'connection.rb'

require_relative 'models/food'
require_relative 'models/order'
require_relative 'models/party'

# ***** Helpers *****
# require_relative 'helpers/link_helper'
# helpers ActiveSupport::Inflector


# menu of app and links to current parties
get '/' do
	@parties = Party.all
	@foods = Food.all
	@orders = Order.all
	erb :home
end

# view all foods on menu
get '/foods' do 
	@foods = Food.all 
	erb :"foods/index"
end

# add new foods to menu
get '/foods/new' do
	erb :"foods/new"
end

# add new foods to menu
post '/foods' do
	food = Food.create(params[:food])
	if food.valid?
    	redirect '/foods'
  	else
    	@errors = food.errors.full_messages
    	erb :"foods/new"
  	end
end

# edit foods on menu
get '/foods/:id/edit' do
	@food = Food.find(params[:id])
	erb :"foods/edit"
end

# show details of food item
get '/foods/:id' do
	@food = Food.find(params[:id])
	@parties = Party.all
	@orders = Order.all
	erb :"foods/show"
end

# change details of food item
patch '/foods/:id' do 
	food = Food.find(params[:id])
	food.name = params[:food][:name]
	food.cuisine = params[:food][:cuisine]
	food.price = params[:food][:price]
	food.allergens = params[:food][:allergens]
	food.save
	redirect '/foods'
end

# destroy: delete a food item
delete '/foods/:id' do
	#binding.pry
	@food = Food.find(params[:id])
	@orders = Order.all
	Food.destroy(params[:id])
	@orders.each do |order|
		if order.food_id == @food.id
			Order.destroy(order.id)
		end 
	end
	redirect '/foods'
end

# show all dining parties
get '/parties' do 
	@parties = Party.all 
	erb :"parties/index"
end

# add a new dining party
get '/parties/new' do
	erb :"parties/new"
end

# add a new dining party
post '/parties' do
	Party.create(params[:party])
	redirect '/parties'
end

# edit a dining party
get '/parties/:id/edit' do
	@party = Party.find(params[:id])
	erb :"parties/edit"
end

# show details of a dining party
get '/parties/:id' do
	@foods = Food.all
	@party = Party.find(params[:id])
	@orders = Order.all
	erb :"parties/show"
end

# modify details of a dining party
patch '/parties/:id' do 
	party = Party.find(params[:id])
	party.name = params[:party][:name]
	party.table_num = params[:party][:table_num]
	party.num_guests = params[:party][:num_guests]
	party.paid = params[:party][:paid]
	party.save
	redirect '/parties'
end

# destroy: delete a party
delete '/parties/:id' do
	@party = Party.find(params[:id])
	@orders = Order.all
	Party.destroy(params[:id])
	@orders.each do |order|
		if order.party_id == @party.id
			Order.destroy(order.id)
		end 
	end
	redirect '/parties'
end

# debug code to view orders
get '/orders' do 
	@parties = Party.all
	@foods = Food.all
	@orders = Order.all 
	erb :"orders/index"
end

# debug code to create new orders
#get '/orders/new' do
#	@foods = Food.all 
#	@parties = Party.all
#   erb :"orders/new"
#end

# create new order
post '/orders' do
	@parties = Party.all
	@party = Party.find(params[:order][:party_id])
    if @parties.find(params[:order][:party_id]).paid == true
    	@error_already_paid = "The party has already paid!"
    	@foods = Food.all
    	@orders = Order.all
    	erb :"parties/show"
	else
		Order.create(params[:order])
		redirect "/parties/#{@party.id}"
	end
	
end

# change order to no charge
patch '/orders/:id/orders_page' do 
	order = Order.find(params[:id])
	order.no_charge = true
	order.save
	redirect '/orders'
end

# change order to no charge
patch '/orders/:id/party_page' do 
	order = Order.find(params[:id])
	order.no_charge = true
	order.save
	redirect "/parties/#{order.party_id}"
end

# change order to no charge
patch '/orders/:id/receipt_page' do 
	order = Order.find(params[:id])
	order.no_charge = true
	order.save
	redirect "/parties/#{order.party_id}/receipt"
end

# delete order
delete '/orders/:id' do
	Order.destroy(params[:id])
	redirect '/orders'
end

# view and download receipt
get '/parties/:id/receipt' do
	@party = Party.find(params[:id])
	@foods = Food.all
#	binding.pry
	file = File.open("receipt.txt", "w")
		total = 0
		file.write("RESTAURANT RECEIPT\n\n")
		file.write("Food\t\tCost\t\tNo Charge\n")
		@party.orders.each do |order|
			file.write("#{@foods.find(order.food_id).name}\t\t$#{@foods.find(order.food_id).price}\t\t#{order.no_charge}\n")
			total += @foods.find(order.food_id).price if order.no_charge != true
		end
		file.write("TOTAL = $#{total}\n")
		file.write("Tip Suggestions: 15% = $#{(total * 0.15).round(2)}\n")
		file.write("Tip Suggestions: 20% = $#{(total * 0.20).round(2)}\n")
		file.write("Tip Suggestions: 25% = $#{(total * 0.25).round(2)}\n")	
  	file.close
	erb :"parties/receipt"
end

# change party status to "paid"
patch '/parties/:id/checkout' do
	party = Party.find(params[:id])
	party.paid = true
	party.save
	redirect "/parties/#{params[:id]}"
end

get '/download/:filename' do |filename|
  send_file "#{filename}", :filename => filename, :type => 'Application/octet-stream'
end

