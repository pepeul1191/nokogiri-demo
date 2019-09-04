require 'json'

# functions

def test_json
  file = File.read('profes.json')
  data_hash = JSON.parse(file)
  # show hash if json is ok
  puts data_hash
end

test_json
