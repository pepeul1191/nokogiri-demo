require 'httparty'
require 'nokogiri'
require 'sequel'
require 'mysql2'
require 'sinatra'

# database and models config

Sequel::Model.plugin :json_serializer

DB = Sequel.connect(
  adapter: 'mysql2', 
  host: 'localhost', 
  database: 'noko', 
  user: 'root', 
  password: '',
  port: 3306,
)

class Video < Sequel::Model(DB[:videos])

end

# sinatra config

set :public_folder, File.dirname(__FILE__) + '/public'
set :layout, 'views/layouts'

before do
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
  headers['Content-type'] = 'text/html; charset=UTF-8'
  headers['server'] = 'Ruby, Ubuntu'
end

# sinatra routes

get '/fill-database' do
  status = 200
  rpta = 'Se ha creado ha actualizado la base de datos'
  mensaje_class = 'success'
  # nokogiri
  url = 'https://www.youtube.com/watch?v=NjQYm5LneEo'
  if params['url'] != nil || params['url'] == ''
    url = params['url']
  end
  response = HTTParty.get(url)
  doc = Nokogiri::HTML(response.body)
  puts 'texto del title de sitio web'
  puts '  ' + doc.css('title')[0].text
  DB.transaction do
    # borrar toda la tabla
    videos = Video.all.to_a
    for d in videos
      d.delete
    end
    # grabar nuevos registros
    begin
      contador = 0
      doc.css('#watch-related', '.video-list-item').each do |item_list|
        if contador != 0
          # link del video
          link = 'https://www.youtube.com' + item_list.css('.content-wrapper a').attribute('href')
          # duracion del video
          duration = item_list.css('.thumb-wrapper a .video-time')[0].text
          # imagen del video
          image = item_list.css('.thumb-wrapper a img').attribute('data-thumb')
          # nombre del video
          name = item_list.css('.content-wrapper .title').text.delete!("\n")[4..-3]
          # vistas del video
          views = item_list.css('.content-wrapper .view-count').text[0..-7]
          # author del video
          author = item_list.css('.content-wrapper .attribution span').text
          # temp string
          n = Video.new(
            :link => link,
            :duration => duration,
            :image => image,
            :name => name,
            :views => views,
            :author => author,
          )
          n.save
        else
          contador = 1
        end
      end
    rescue Exception => e
      Sequel::Rollback
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en cargar los datos de la url ' + url,
          e.message
        ]}.to_json
      mensaje_class = 'danger'
    end
  end
  status status
  locals = {
    :title => 'Bienvenido',
    :mensaje => rpta,
    :mensaje_class => mensaje_class,
    :videos => Video.all.to_a,
  }
  erb :'index', :layout => :'layouts/blank', :locals => locals
end

get '/' do
  locals = {
    :title => 'Bienvenido',
    :mensaje => '',
    :videos => Video.all.to_a,
    :mensaje_class => '',
  }
  erb :'index', :layout => :'layouts/blank', :locals => locals
end

get '/generar' do
  locals = {
    :title => 'Generar Base de Datos',
    :mensaje => '',
  }
  erb :'generar', :layout => :'layouts/blank', :locals => locals
end

get '/eliminar/:id' do
  status = 200
  rpta = 'Se ha creado ha actualizado la base de datos'
  mensaje_class = 'success'
  DB.transaction do
    begin
      Video.where(:id => params['id']).delete
    rescue Exception => e
      Sequel::Rollback
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en eliminar el video',
          e.message
        ]}.to_json
      mensaje_class = 'danger'
    end
  end
  status status
  locals = {
    :title => 'Bienvenido',
    :mensaje => rpta,
    :mensaje_class => mensaje_class,
    :videos => Video.all.to_a,
  }
  erb :'index', :layout => :'layouts/blank', :locals => locals
end