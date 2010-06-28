require 'rubygems'
require 'noaa'
require 'savon'

$LOAD_PATH.unshift(File.dirname(__FILE__))

require "engine-forecast/calculations"
require "engine-forecast/calculator"
require 'engine-forecast/services_broker'
require 'engine-forecast/services/noaa'
require 'engine-forecast/services/usgs'

#
# An engine's efficiency can be impacted by environmental factors such as 
# altitude and temperature. EngineForecast first collects environmental data 
# based on the supplied latitude and longitude and then returns a set of calculations
# to determine how great that impact is. 
#
module EngineForecast
  
  def self.get(latitude, longitude, altitude = nil)
    observations = EngineForecast::ServicesBroker.call(latitude, longitude, altitude)
    EngineForecast::Calculations.new(observations)
  end
  
end