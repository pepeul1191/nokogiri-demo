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

# sinatra routes

get '/fill-database' do
  # borrar toda la tabla
  DB['DELETE FROM videos;']
  # nokogiri
  url = 'https://www.youtube.com/watch?v=6U1E5A1QwmA'
  if params['url'] != nil
    url = params['url']
  end
  response = HTTParty.get(url)
  doc = Nokogiri::HTML(response.body)
  puts 'texto del title de sitio web'
  puts '  ' + doc.css('title')[0].text
  doc.css('#watch-related', '.video-list-item').each do |item_list|
    # link del video
    link = 'https://www.youtube.com' + item_list.css('.content-wrapper a').attribute('href')
    # duracion del video
    duration = item_list.css('.thumb-wrapper a .video-time')[0].text
    # imagen del video
    image = item_list.css('.thumb-wrapper a img').attribute('data-thumb')
    # nombre del video
    name = item_list.css('.content-wrapper .title').text.delete!("\n")[4..-3]
    puts '1 +++++++++++++++++++++++++++++++++++++++++++++'
    puts name
    puts '2 +++++++++++++++++++++++++++++++++++++++++++++'
    # vistas del video
    views = item_list.css('.content-wrapper .view-count').text[0..-7]
    # author del video
    author = item_list.css('.content-wrapper .attribution span').text
    # temp string
    n = Video.new(
      :link => link,
      :duration => duration,
      :image => image,
      :name => name[0..20],
      :views => views,
      :author => author,
    )
    n.save
  end
end
