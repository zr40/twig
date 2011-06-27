require 'yaml'
require 'json'

tests = YAML::load_file 'test/tests.yaml'

tests.each do |test_file,expected|
  test test_file do
    result = JSON(`./test_runner.rb test/#{test_file}.rb`)
    
    expected.each do |expectation|
      case expectation
      when 'success'
        overall = result['overall']
        assert_equal overall['instructions'], overall['instructions_reached']
        assert_equal overall['branches'], overall['both_branches_taken']
      else
        flunk "Unknown expectation #{expectation}"
      end
    end
  end
end
