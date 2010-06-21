module EngineForecast
  
  #
  # A collection of formulas and calculations used to determine, among other things,
  # the relative horsepower of an engine given different environmental conditions.
  #
  # These calculations are modeled after Richard Shelquist's Engine Tuner's Calculator, 
  # but have been re-factored to be more ruby-like. I urge you to read his technical 
  # articles on Density Altitude and Corrected Horsepower for detailed explanations of 
  # these concepts.
  #
  # In some cases I took a guess at what a method should be named based on the calculation
  # it is returning, so any better suggestions are welcomed. 
  #
  module Calculator
    class << self
      
      def density_altitude(altimeter, altitude, dew_point, temperature)          
          # Calculate geometric altitude Z (m) from geopotential altitude (m) H          
          densaltzm = self.altitude_z(altimeter, altitude, dew_point, temperature)
          unless (-5000..11000).include?(densaltzm)
            	raise "Out of range for Troposhere Algorithm: Altitude =" + densaltzm.round + " meters"
          end
          densaltzm.round
      end
      
      def dyno_correction_factor(altimeter, altitude, dew_point, temperature)        
        vapor_pressure_mb = self.vapor_pressure(dew_point)
        absolute_pressure_mb = self.absolute_pressure(altimeter, altitude)
        absolute_pressure_in = millibars_to_inches(absolute_pressure_mb)
        vapor_pressure_in = millibars_to_inches(vapor_pressure_mb)        
        p1 = 29.235 / (absolute_pressure_in - vapor_pressure_in)
      	p2 = ((temperature + 273) / 298)**0.5
      	(1.18 * (p1 * p2) - 0.18)
      end
    

      def virtual_temperature(altimeter, altitude, dew_point, temperature)        
        absolute_pressure = self.absolute_pressure(altimeter, altitude)
        vapor_pressure = self.vapor_pressure(dew_point)
        ((temperature + 273.15) / (1- (0.377995 * vapor_pressure / absolute_pressure)))-273.15
      end
    
      #
      # Polynomial from Herman Wobus       
      #
      def vapor_pressure(temperature_c)                
        values = [ 1.1112018e-17, -1.7892321e-15, 2.1874425e-13, -2.9883885e-11, 4.3884187e-09, -6.1117958e-07, 7.8736169e-05, -0.0090826951, 0.99999683 ]
        pol = values.inject(-0.30994571E-19) { |result, v| result = v + temperature_c * result }        
      	6.1078 / (pol**8)
      end
    
      def geopotential_altitude(elevation_in_meters)        
      	r = 6369E3;
        ((r * elevation_in_meters) / (r + elevation_in_meters))
      end
    
      def density(altimeter, altitude, dew_point, temperature)
      	vapor_pressure = self.vapor_pressure(dew_point)
      	absolute_pressure = self.absolute_pressure(altimeter, altitude) 
      	
      	rv, rd = 461.4964, 287.0531
      	temperature_k = temperature + 273.15
      	pv = vapor_pressure * 100
      	pd = (absolute_pressure - vapor_pressure) * 100
      	(pv / (rv * temperature_k)) + (pd / (rd * temperature_k))
      end

      def altitude(altimeter, elevation, dew_point, temperature)
        density = self.density(altimeter, elevation, dew_point, temperature)
      	g, po, to, l, r, m = 9.80665, 101325, 288.15, 6.5, 8.314320, 28.9644
      	density = density * 1000
      	p2 = ( (l * r)/(g* m - l * r) ) * Math.log( (r * to * density) / (m * po) )
      	h = -(to / l)*( Math.exp(p2) -1 )
      	h * 1000
      end
    
      def altitude_z(altimeter, elevation, dew_point, temperature)
      	altitude = self.altitude(altimeter, elevation, dew_point, temperature)
      	r = 6369E3
      	((r * altitude) / (r - altitude))
      end
    

      def absolute_pressure(altimeter, altitude)
      	k1, k2 = 0.190263, 8.417286E-5      	
      	((altimeter**k1)-(k2 * self.geopotential_altitude(altitude)))**(1/k1)
      end
    
      def relative_density(altimeter, altitude, dew_point, temperature)
        density = self.density(altimeter, altitude, dew_point, temperature)
        100 * (density / 1.225)
      end
    
      def relative_humidity(temperature, dew_point)
        (vapor_pressure(dew_point) / vapor_pressure(temperature)) * 100
      end
      
      def relative_horsepower(altimeter, altitude, dew_point, temperature)
        dyno_correction_factor = self.dyno_correction_factor(altimeter, altitude, dew_point, temperature)
        round((100 / dyno_correction_factor), 1)
      end
      
      #
      # Metric conversion methods
      #
      
      def millibars_to_inches(mb)
        mb * (1/33.86389)
      end
      
      def meters_to_feet(meters)
        meters * 3.2808399
      end
  
      def round(f, d)
        (f * 10**d).round.to_f / 10**d
      end
      
      def celsius_to_fahrenheit(temp)
        ((temp * 9.0) / 5.0) + 32.0
      end
      
    end    
    
  end
end