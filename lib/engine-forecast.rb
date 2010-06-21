$LOAD_PATH.unshift(File.dirname(__FILE__))

require "engine-forecast/calculations"
require "engine-forecast/calculator"
require 'engine-forecast/services_broker'
require 'engine-forecast/services/noaa'
require 'engine-forecast/services/usgs'

module EngineForecast
  
  def self.get(latitude, longitude, altitude = nil)
    observations = EngineForecast::ServicesBroker.call(latitude, longitude, altitude)
    EngineForecast::Calculations.new(observations)
  end
  
end