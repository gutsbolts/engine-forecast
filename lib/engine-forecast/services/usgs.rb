module EngineForecast
  module Services    
    
    #
    # Connects to the USGS web service to determine altitude base on the supplied  
    # longitude and latitude.
    #
    class USGSService
      
      WSDL = "http://gisdata.usgs.gov/xmlwebservices2/elevation_service.asmx?WSDL"
      
      def self.collect(latitude, longitude)        
        response = self.call_service(latitude, longitude)
        {:altitude => self.extract_elevation(response).to_f.round * 1.0}        
      end
      
      def self.call_service(latitude, longitude)
        client = Savon::Client.new(WSDL)
        Savon::Request.log = false
        response = client.get_elevation do |soap| 
          soap.version = 2
          soap.namespaces["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
          soap.namespaces["xmlns:xsd"] = "http://www.w3.org/2001/XMLSchema"
          soap.namespaces["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/"
          soap.input = [ "getElevation", { "xmlns" => "http://gisdata.usgs.gov/XMLWebServices2" } ]
          soap.body = { 'wsdl:X_Value' => longitude.to_s, 
                        'wsdl:Y_Value' => latitude.to_s,
                        'wsdl:Elevation_Units' => 'METERS' }
        end        
      end
      
      #
      # Extracts altitude out of the web service response.
      #
      def self.extract_elevation(response)
        response.to_hash[:get_elevation_response][:get_elevation_result][:usgs_elevation_web_service_query][:elevation_query][:elevation]
      end
    end
  end
end