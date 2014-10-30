class UserController < ApplicationController

get '/newuser' do
  erb:'users/new'
end

post '/new' do
  user = User.find_by({username: params[:username]})
  if !user
  elsif user.password == params[:password]
    session[:current_user] = user.id
  end
  redirect '/'
end

post '/newuser' do
  user = User.new(params[:user])
  user.password = params[:password]
  user.save!
  redirect '/'
end

delete '/' do
  session[:current_user] = nil
  redirect '/'
end

end
