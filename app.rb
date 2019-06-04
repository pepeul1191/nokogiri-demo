require 'httparty'
require 'nokogiri'

response = HTTParty.get('https://www.youtube.com/watch?v=6U1E5A1QwmA')

doc = Nokogiri::HTML(response.body)

File.write('demo.html', doc)

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
  # puts item_list.css('.content-wrapper a').attribute('href')
  # duracion del video
  # puts item_list.css('.thumb-wrapper a').text
  #item_list.css('.thumb-wrapper')
end