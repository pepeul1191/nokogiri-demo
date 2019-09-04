require 'httparty'
require 'nokogiri'
require 'sinatra'
require 'mongo'
require 'sequel'


# database and models config

Sequel::Model.plugin :json_serializer

DB = Sequel.connect('sqlite://db/profes.db')

class Carrers < Sequel::Model(DB[:carrers])

end

# functions

CARRERS = []
IDS = []

def generate_id
  (0...24).map { ('a'..'z').to_a[rand(26)] }.join
end

def careers_id(name)
  resp = {}
  if CARRERS.include? name
    index = CARRERS.index(name)
    resp[:_id] = IDS[index]
    resp[:name] = name
  else
    _id = generate_id()
    CARRERS.push(name)
    IDS.push(_id)
    resp[:_id] = _id
    resp[:name] = name
  end
  return resp
end

urls = [
  'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=5200',
  'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=5300',
  'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=5205',
  'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=5306',
  'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=5500',
  'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=6100',
  'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=7000',
  'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=5600',
  'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=6500',
  'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=5001',
]

# routes

get '/profes' do
  teachers = []
  # iterate urls
  urls.each do |url|
    response = HTTParty.get(url)
    doc = Nokogiri::HTML(response.body)
    # get teachers html
    teachers_html = doc.css('#triple')
    # get parts
    imgs    = teachers_html.css('div .izq a img')
    names   = teachers_html.css('div .der span strong a')
    careers = teachers_html.css('div .der p')
    # iterate parts
    teachers_lenght = names.size
    for i in 0..teachers_lenght - 1 do
        img = imgs[i].attribute('src')
        name = names[i].inner_html
        careers_string = careers[i].inner_html.slice(11, careers[i].inner_html.length)
        careers_array = careers_string.split(',')
        carrers = []
        careers_array.each do |career|
            if career[0] == ' '
                career = career.slice(1, career.length)
            end
            carrers.push(careers_id(career))
        end
        temp = {}
        temp[:_id] = generate_id()
        temp[:img] = img
        temp[:name] = name
        temp[:carrers] = carrers
        teachers.push(temp)
    end
  end
  # response
  return teachers.to_json
end
