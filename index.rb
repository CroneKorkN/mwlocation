#!/usr/bin/ruby

require "geocoder"
require "cgi"
require "sqlite3"
require "slim"
require "date"

# init cgi
class CGI_
  def r
    rand(1000).to_f/1000
  end
  def params
    {
      "lon" => [50+r],
      "lat" => [8+r]
    }
  end
  def header
  end
end
cgi = CGI.new
puts cgi.header

# init db
db = SQLite3::Database.new "locations.db"

# app
if cgi.params.key? "lon"
  puts cgi.params
  puts date = Time.now.to_s
  puts lon = cgi.params['lon'][0].to_f
  puts lat = cgi.params['lat'][0].to_f
  puts location = Geocoder.address([lon, lat]).to_s
  
  print q = "INSERT INTO locations (date,lon,lat,location) VALUES (?,?,?,?);"
  
  print db.query(q, date, lon, lat, location)
  puts "hallo MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
else
  @result = db.execute "
    SELECT *
    FROM `locations`
    ORDER BY date DESC
    LIMIT 100;
  "
  puts Slim::Template.new('template.slim').render(self)
end