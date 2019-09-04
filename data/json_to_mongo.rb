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
  field :carrers, type: Array, :default => []
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

def insert_teachers
  file = File.read('profes.json')
  teachers = JSON.parse(file)
  begin
    teachers.each do |teacher|
      full_name = teacher['name']
      name_array = full_name.split(', ')
      names = name_array[1]
      last_names = name_array[0]
      if Teacher.find_by(names: names, last_names: last_names) == nil
        carrers_ids = []
        teacher['carrers'].each do |carrer|
          carrer_db = Carrer.find_by(name: carrer['name'])
          carrers_ids.push(carrer_db._id)
        end
        n = {
          :names => names,
          :last_names => last_names,
          :img => teacher['img'],
          :carrers => carrers_ids,
        }
        Teacher.create(n)
      end
    end
  rescue Exception => e
    puts e
  end
end

# insert_carrers
insert_teachers
