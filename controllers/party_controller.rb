require 'pry'

class PartyController < ApplicationController

# show all dining parties
get '/' do 
  @parties = Party.all 
  erb :"parties/index"
end

# add a new dining party
get '/new' do
  erb :"parties/new"
end

# add a new dining party
post '/' do
  Party.create(params[:party])
  redirect '/parties'
end

# edit a dining party
get '/:id/edit' do
  @party = Party.find(params[:id])
  erb :"parties/edit"
end

# show details of a dining party
get '/:id' do
  @foods = Food.all
  @party = Party.find(params[:id])
  @orders = Order.all
  erb :"parties/show"
end

# modify details of a dining party
patch '/:id' do 
  party = Party.find(params[:id])
  party.name = params[:party][:name]
  party.table_num = params[:party][:table_num]
  party.num_guests = params[:party][:num_guests]
  party.paid = params[:party][:paid]
  party.save
  redirect '/parties'
end

# destroy: delete a party
delete '/:id' do
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

# view and download receipt
get '/:id/receipt' do
  @party = Party.find(params[:id])
  @foods = Food.all
# binding.pry
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
patch '/:id/checkout' do
  party = Party.find(params[:id])
  party.paid = true
  party.save
  redirect "/parties/#{params[:id]}"
end

get '/download/:filename' do |filename|
  send_file "#{filename}", :filename => filename, :type => 'Application/octet-stream'
end

end