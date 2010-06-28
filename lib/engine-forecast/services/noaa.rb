module EngineForecast
  module Services    
    
    #
    # Connects to NOAA via the awesome noaa gem and collects current conditions
    # based on the supplied latitude and longitude.
    #
    class NOAAService
      def self.collect(latitude, longitude)
        conditions = NOAA.current_conditions(latitude, longitude)
        { :temperature => conditions.temperature(:c) * 1.0, 
          :altimeter => conditions.pressure(:mb) * 1.0,
          :dew_point => conditions.dew_point(:c) * 1.0 }
      end                  
    end
  end
end