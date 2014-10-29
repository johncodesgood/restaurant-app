class ApplicationController < Sinatra::Base

  set :views, File.expand_path("../../views", __FILE__)
  enable :sessions, :method_override

  # menu of app and links to current parties
  get '/' do
    @parties = Party.all
    @foods = Food.all
    @orders = Order.all
    erb :home
  end

   not_found do
     halt 404, "I can't find that"
   end
end