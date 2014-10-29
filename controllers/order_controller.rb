require 'pry'

class OrderController < ApplicationController

# debug code to view orders
get '/' do 
  @parties = Party.all
  @foods = Food.all
  @orders = Order.all 
  erb :"orders/index"
end

# debug code to create new orders
#get '/orders/new' do
# @foods = Food.all 
# @parties = Party.all
#   erb :"orders/new"
#end

# create new order
post '/' do
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
patch '/:id/orders_page' do 
  order = Order.find(params[:id])
  order.no_charge = true
  order.save
  redirect '/orders'
end

# change order to no charge
patch '/:id/party_page' do 
  order = Order.find(params[:id])
  order.no_charge = true
  order.save
  redirect "/parties/#{order.party_id}"
end

# change order to no charge
patch '/:id/receipt_page' do 
  order = Order.find(params[:id])
  order.no_charge = true
  order.save
  redirect "/parties/#{order.party_id}/receipt"
end

# delete order
delete '/:id' do
  Order.destroy(params[:id])
  redirect '/orders'
end

end