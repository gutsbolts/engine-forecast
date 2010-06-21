require 'helper'

class TestServicesBroker < Test::Unit::TestCase
  
  def setup
    @latitude, @longitude = coordinates
  end
  
  def test_call
    results = observations = VCR.use_cassette('engine_forecast', :record => :new_episodes) do
      EngineForecast::ServicesBroker.call(@latitude, @longitude)
    end
    assert_equal(noaa_results.merge(usgs_results), results)
  end
  
  def test_call_with_altitude
    results = observations = VCR.use_cassette('engine_forecast', :record => :new_episodes) do
      EngineForecast::ServicesBroker.call(@latitude, @longitude, 1234)
    end
    assert_equal(noaa_results.merge({:altitude => 1234.0}), results)
  end
  
  def test_call_weather_service        
    results = observations = VCR.use_cassette('noaa', :record => :new_episodes) do
      EngineForecast::ServicesBroker.call_weather_service(@latitude, @longitude)
    end
    assert_equal(noaa_results, results)
  end
  
  def test_call_altitude_service
    results = VCR.use_cassette('usgs', :record => :new_episodes) do
      EngineForecast::ServicesBroker.call_altitude_service(@latitude, @longitude)
    end
    assert_equal(usgs_results, results)
  end
  
end