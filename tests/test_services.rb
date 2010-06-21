require 'helper'

class TestServices < Test::Unit::TestCase
  
  def setup
    @latitude, @longitude = coordinates
  end
  
  def test_noaa
    observations = VCR.use_cassette('noaa', :record => :new_episodes) do
      EngineForecast::Services::NOAAService.collect(@latitude, @longitude)
    end
    assert_equal(noaa_results, observations)
  end
  
  def test_usgs
    response = VCR.use_cassette('usgs', :record => :new_episodes) do
      EngineForecast::Services::USGSService.collect(@latitude, @longitude)
    end    
    assert_equal(usgs_results, response)
  end
  
end