require "json"

class TimestampArray
  include JSON::Serializable

  @[JSON::Field(converter: JSON::ArrayConverter(Time::EpochConverter))]
  property dates : Array(Time)
end

timestamp = TimestampArray.from_json(%({"dates":[1459859781,1567628762]}))
pp timestamp.dates   # => [2016-04-05 12:36:21 UTC, 2019-09-04 20:26:02 UTC]
pp timestamp.to_json # => %({"dates":[1459859781,1567628762]})


class MyConverter 
  include JSON::Serializable

  property data : Array(JSON::Any)
end