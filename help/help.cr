#!/usr/bin/env crystal 
require "csv"
require "db"
require "json"
require "crustache"
require "option_parser"
require "pretty_print"
require "sqlite3"

OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end

DB.open "sqlite3::memory:" do |db|

  # create table cars from cars.csv 
  File.open("cars.csv") do |file|
    csv_cars = CSV.new(file, headers: true)
    db.exec "CREATE TABLE cars (id INT32,#{csv_cars.headers[1..-1].join(",")})"
    csv_cars.each do |row|
      db.exec "INSERT INTO cars VALUES(#{(["?"] * row.row.size).join(',')})", args: row.row.to_a
    end
  end

  # query cars
  query_result = Array(Hash(String, (Float64 | Int64 | String | Bool))).new
  db.query "SELECT  *, 1 AS isTrue, 0 AS isFalse,122 AS ID FROM cars WHERE id ORDER by price ASC" do |rs|
    idx : Int64 = 0
    rs.each do # row
      row_hash = Hash(String, (Float64 | Int64 | String | Bool)).new
      rs.each_column do |column_name|
        value = rs.read

        case value
        when Slice(UInt8)
          # map Slice(UInt8) to String
          value = value.to_s
        when Int64
          if column_name.starts_with? "is"
            value = (value != 0)
          end
        when Nil
          # ignore nil values
          next
        end

        row_hash[column_name] = value
        
      end
      row_hash["_idx"] = idx
      query_result << row_hash
      idx += 1
    end
    query_result[-1]["_last"] = true
  end
  puts query_result.to_json
end

