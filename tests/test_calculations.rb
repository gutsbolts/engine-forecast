require 'helper'

class TestCalculations < Test::Unit::TestCase
  
  def setup
    @calculations = EngineForecast::Calculations.new(observations)
  end
    
  correct_answers.each do |method, answer|

    # List of methods inside correct answers hash that are not exposed
    # on the Calculations object so don't create a test for them
    exceptions = [:geopotential_altitude, :altitude, :altitude_z]
    
    unless exceptions.include?(method)
      define_method "test_calculations_#{method}" do
        assert_equal round(answer, 13), round(@calculations.send(method), 13)
      end
    end
  end
  
  def test_vapor_pressure_inches
    @calculations.metric = false
    assert_equal 0.780463233775887, round(@calculations.vapor_pressure, 15)
  end
  
  def test_absolute_pressure_inches
    @calculations.metric = false
    assert_equal 29.4008221939348, round(@calculations.absolute_pressure, 13)
  end
  
  def test_virtual_temperature_fahrenheit
    @calculations.metric = false
    assert_equal 95.1673006976555, round(@calculations.virtual_temperature, 13)
  end

  def test_density_altitude_feet
    @calculations.metric = false
    assert_equal 2874.0157524, round(@calculations.density_altitude, 7)
  end
  
end