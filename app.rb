require 'httparty'
require 'nokogiri'

response = HTTParty.get('https://www.youtube.com/watch?v=6U1E5A1QwmA')

doc = Nokogiri::HTML(response.body)

# File.write('demo.html', doc)

puts 'texto del title de sitio web'
puts '  ' + doc.css('title')[0].text

#puts doc.css('#watch-related')
"""

doc.css('#watch-related', '.video-list-item .content-wrapper').each do |link|
  puts '+++++++++++++++++++++++++++++++++++++++++++++++++++'
  puts link
end

puts '+++++++++++++++++++++++++++++++++++++++++++++++++++'

doc.css('#watch-related', '.video-list-item .thumb-wrapper a img').each do |link|
  puts '1 ------'
  puts link
  puts link.attribute('data-thumb')
  puts '2 ------'
end

"""

doc.css('#watch-related', '.video-list-item').each do |item_list|
  # link del video
  link = 'https://www.youtube.com' + item_list.css('.content-wrapper a').attribute('href')
  # duracion del video
  duration = item_list.css('.thumb-wrapper a').text
  # imagen del video
  image = item_list.css('.thumb-wrapper a img').attribute('data-thumb')
  # nombre del video
  name = item_list.css('.content-wrapper .title').text.delete!("\n")[4..-3]
  # vistas del video
  views = item_list.css('.content-wrapper .view-count').text[0..-7]
  # author del video
  author = item_list.css('.content-wrapper .attribution span').text
  # temp string
  temp = 'INSERT INTO videos (link, duration, image, name, views, author) ' +
    '("%s", "%s", "%s", "%s", "%s", "%s")' % [link, duration, image, name, views, author]
  puts temp
end