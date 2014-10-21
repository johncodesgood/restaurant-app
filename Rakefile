require 'bundler'
Bundler.require
require 'pry'

require 'sinatra/activerecord/rake'
require_relative 'connection.rb'

namespace :db do
  desc "Create restaurant_db database"
  task :create_db do
    conn = PG::Connection.open()
    conn.exec('CREATE DATABASE restaurant_db;')
    conn.close
  end

  desc "Drop restaurant_db database"
  task :drop_db do
    conn = PG::Connection.open()
    conn.exec('DROP DATABASE restaurant_db;')
    conn.close
  end
  #
  # desc 'migrate tables for '
  # task :migrate do
  #   conn = PG::Connection.open({dbname:'restaurant_database'})
  #   conn.exec("CREATE TABLE parties (id SERIAL PRIMARY KEY, table_number INTEGER, is_pied BOOLEAN, num_guests INTEGER);")
  #   conn.exec("CREATE TABLE foods (id SERIAL PRIMARY KEY, name VARCHAR(255), cents INTEGER, cuisine VARCHAR(255));")
  #   conn.exec("CREATE TABLE orders (id SERIAL PRIMARY KEY, party_id INTEGER, food_id INTEGER);")
  #   conn.close
  # end
  #
  desc "create junk data for development"
  task :junk_data do

    require_relative 'connection'
    require_relative 'models/food'
    require_relative 'models/party'
    require_relative 'models/order'

    Food.create({name: 'Mac & Cheese', cuisine: "Home", price: 14, allergens: "wheat"})
    Food.create({name: 'Steak', cuisine: "Meat", price: 40, allergens: "none"})
    Food.create({name: 'Kale Salad', cuisine: "Greens", price: 35, allergens: "kale"})
    Food.create({name: 'Chicken Noodle Soup', cuisine: "Home", price: 15, allergens: "nuts"})
    Food.create({name: 'Old Fashioned', cuisine: "Drink", price: 7, allergens: "alcohol"})
    Food.create({name: 'Fizzy Water', cuisine: "Drink", price: 3, allergens: "none"})

    Party.create({name: "Smitherson", table_num: 4,  num_guests: 3, paid: false})
    Party.create({name: "Bakerson", table_num: 9,  num_guests: 2, paid: false})
    Party.create({name: "Billerson", table_num: 12, num_guests: 4, paid: true})
    Party.create({name: "Motherson", table_num: 13, num_guests: 7, paid: true})
    Party.create({name: "Bannerson", table_num: 6,  num_guests: 2, paid: false})
    Party.create({name: "Plowerson", table_num: 11, num_guests: 3, paid: false})
    Party.create({name: "Morerson", table_num: 18, num_guests: 1, paid: false})

    parties = Party.all
    foods = Food.all

    parties.each do |party|
      party.num_guests.times do
        Order.create({party_id: party.id, food_id: foods.sample.id, no_charge: false}) if [true, false].sample
      end
    end
  end

  desc "Remove receipts"
  task :delete_receipts do
    File.delete("receipt.txt")
  end

end
