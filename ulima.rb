require 'httparty'
require 'nokogiri'

url = 'http://fresno.ulima.edu.pe/bu_dbdirexp01.nsf/planadocentewebcat?openview=&carrera=6500'

response = HTTParty.get(url)
doc = Nokogiri::HTML(response.body)

teachers = doc.css('#triple')

imgs    = teachers.css('div .izq a img')
names   = teachers.css('div .der span strong a')
careers = teachers.css('div .der p')

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
        carrers.push(career)
    end
    puts 'XD'
    puts carrers
end