require 'httparty'
require 'nokogiri'

response = HTTParty.get('https://www.youtube.com/watch?v=6U1E5A1QwmA')

doc = Nokogiri::HTML(response.body)

File.write('demo.html', doc)

puts 'texto del title de sitio web'
puts '  ' + doc.css('title')[0].text

#puts doc.css('#watch-related')

doc.css('#watch-related', '.video-list-item .content-wrapper').each do |link|
  puts '+++++++++++++++++++++++++++++++++++++++++++++++++++'
  puts link
end

doc.css('#watch-related', '.video-list-item .thumb-wrapper a img').each do |link|
  puts '+++++++++++++++++++++++++++++++++++++++++++++++++++'
  puts link
  puts '1 ------'
  puts link.attribute('width')
  puts '2 ------'
end
