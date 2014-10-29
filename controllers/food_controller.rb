class FoodController < ApplicationController

# view all foods on menu
get '/' do 
  @foods = Food.all 
  erb :"foods/index"
end

# add new foods to menu
get '/new' do
  erb :"foods/new"
end

# add new foods to menu
post '/' do
  food = Food.create(params[:food])
  if food.valid?
      redirect '/foods'
    else
      @errors = food.errors.full_messages
      erb :"foods/new"
    end
end

# edit foods on menu
get '/:id/edit' do
  @food = Food.find(params[:id])
  erb :"foods/edit"
end

# show details of food item
get '/:id' do
  @food = Food.find(params[:id])
  @parties = Party.all
  @orders = Order.all
  erb :"foods/show"
end


# change details of food item
patch '/:id' do 
  food = Food.find(params[:id])
  food.name = params[:food][:name]
  food.cuisine = params[:food][:cuisine]
  food.price = params[:food][:price]
  food.allergens = params[:food][:allergens]
  food.save
  redirect '/foods'
end

# destroy: delete a food item
delete '/:id' do
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


end