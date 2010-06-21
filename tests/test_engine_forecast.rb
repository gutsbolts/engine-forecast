require 'helper'

class TestEngineForecast < Test::Unit::TestCase
  
  def setup
    @latitude, @longitude = coordinates
    @calculations = EngineForecast::Calculations.new(noaa_results.merge(usgs_results))
  end
  
  def test_get
    response = VCR.use_cassette('engine_forecast', :record => :new_episodes) do
      EngineForecast.get(@latitude, @longitude)
    end
    assert_equal @calculations, response
  end
  
  def test_get_with_altitude
    response = VCR.use_cassette('engine_forecast', :record => :new_episodes) do
      EngineForecast.get(@latitude, @longitude, 1234)
    end
    @calculations = EngineForecast::Calculations.new(noaa_results.merge({:altitude => 1234.0}))
    assert_equal @calculations, response
  end
  
end