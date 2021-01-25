require "pretty_print"
require "json"

json = %([1, {"id": 123}, 3])



pp Array(JSON::Any).from_json(json)

pp json.array do
    json.number 1
    json.number 2
    json.number 3
  end