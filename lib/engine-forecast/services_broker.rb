module EngineForecast
  
  #
  # Central broker to coordinate and collect data from various web service 
  # calls.
  #
  module ServicesBroker
    
    # 
    # Returns a hash of all the observations collected from the various
    # 3rd-party services required for the calculations.
    # 
    def self.call(latitude, longitude, altitude = nil)
      altitude = altitude ? { :altitude => altitude * 1.0 } : call_altitude_service(latitude, longitude) 
      self.call_weather_service(latitude, longitude).merge altitude
    end
    
    def self.call_weather_service(latitude, longitude)
      EngineForecast::Services::NOAAService.collect(latitude, longitude)
    end
    
    def self.call_altitude_service(latitude, longitude)
      EngineForecast::Services::USGSService.collect(latitude, longitude)
    end
    
  end
  
end