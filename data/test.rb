require 'json'

file = File.read('profes.json')
data_hash = JSON.parse(file)

puts file
