require 'json'
require 'mongo'
require 'sequel'
require 'sqlite3'


# database and models config

Sequel::Model.plugin :json_serializer

DB = Sequel.connect('sqlite://../db/profes.db')

class Carrers < Sequel::Model(DB[:carrers])

end

class Teachers < Sequel::Model(DB[:teachers])

end

# functions

def test_json
  file = File.read('profes.json')
  data_hash = JSON.parse(file)
  # show hash if json is ok
  puts data_hash
end

def insert_carrers
  file = File.read('profes.json')
  teachers = JSON.parse(file)
  DB.transaction do
    begin
      teachers.each do |teacher|
        teacher['carrers'].each do |carrer|
          if Carrers.find(name: carrer['name']) == nil
            Carrers.create(name: carrer['name'])
          end
        end
      end
    rescue Exception => e
      Sequel::Rollback
      puts e
    end
  end
end

# insert_carrers

def insert_teachers
  file = File.read('profes.json')
  teachers = JSON.parse(file)
  DB.transaction do
    begin
      teachers.each do |teacher|
        full_name = teacher['name']
        name_array = full_name.split(', ')
        names = name_array[1]
        last_names = name_array[0]
        if Teachers.find(names: names, last_names: last_names) == nil
          Teachers.create(names: names, last_names: last_names)
        end
      end
    rescue Exception => e
      Sequel::Rollback
      puts e
    end
  end
end

insert_teachers
