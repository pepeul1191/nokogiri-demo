require 'json'
require 'mongo'
require 'mongoid'


# database and models config

Mongoid.configure do |config|
  config.clients.default = {
    hosts: ['localhost:27017'],
    database: 'profes',
  }
  config.log_level = :warn
end

Mongoid.logger.level = Logger::DEBUG
Mongo::Logger.logger.level = Logger::INFO
Mongoid.raise_not_found_error = false

class Teacher
  include Mongoid::Document
  store_in collection: 'teachers', database: 'profes'
  field :names, type: String
  field :last_names, type: String
  field :img, type: String
  # embeds_many :hours
end

class Carrer
  include Mongoid::Document
  store_in collection: 'carrers', database: 'profes'
  field :name, type: String
end

# functions

def insert_carrers
  file = File.read('profes.json')
  teachers = JSON.parse(file)
  begin
    teachers.each do |teacher|
      teacher['carrers'].each do |carrer|
        if Carrer.find_by(name: carrer['name']) == nil
          n = {
            :name => carrer['name'],
          }
          Carrer.create(n)
        end
      end
    end
  rescue Exception => e
    puts e
  end
end

insert_carrers
