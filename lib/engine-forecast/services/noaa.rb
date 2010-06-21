require 'rubygems'
require 'noaa'

module EngineForecast
  module Services    
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