require 'json'
require 'mongo'
require 'sequel'
require 'sqlite3'


# database and models config

Sequel::Model.plugin :json_serializer

DB = Sequel.connect('sqlite://../db/profes.db')

class Carrer < Sequel::Model(DB[:carrers])

end

class Teacher < Sequel::Model(DB[:teachers])

end

class TeacherCarrer < Sequel::Model(DB[:teachers_carrers])

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
          if Carrer.find(name: carrer['name']) == nil
            n = Carrer.new(
              :name => carrer['name'],
            )
            n.save
          end
        end
      end
    rescue Exception => e
      Sequel::Rollback
      puts e
    end
  end
end

insert_carrers

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
        if Teacher.find(names: names, last_names: last_names) == nil
          n = Teacher.new(
            :names => names,
            :last_names => last_names,
            :img => teacher['img'],
          )
          n.save
        end
      end
    rescue Exception => e
      Sequel::Rollback
      puts e
    end
  end
end

insert_teachers

def insert_teachers_carrers
  file = File.read('profes.json')
  teachers = JSON.parse(file)
  DB.transaction do
    begin
      teachers.each do |teacher|
        full_name = teacher['name']
        name_array = full_name.split(', ')
        names = name_array[1]
        last_names = name_array[0]
        teacher_db = Teacher.find(names: names, last_names: last_names)
        teacher['carrers'].each do |carrer|
          carrer_db = Carrer.find(name: carrer['name'])
          n = TeacherCarrer.new(
            :teacher_id => teacher_db.id,
            :carrer_id => carrer_db.id,
          )
          n.save
        end
      end
    rescue Exception => e
      Sequel::Rollback
      puts e
    end
  end
end

insert_teachers_carrers
