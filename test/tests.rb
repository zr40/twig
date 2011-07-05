require 'pathname'
require 'yaml'
require 'json'

tests = YAML::load_file 'test/tests.yaml'

tests.each do |test_file,expected|
  describe "#{test_file}.rb" do
    result = JSON(`./test_runner.rb test/#{test_file}.rb`)

    overall = result['overall']
    lines = result['lines']

    expected.each do |expectation|
      type, data = expectation

      case type
      when 'success'

        it 'is fully covered' do
          overall['instructions_hit'].should == overall['instructions']
          overall['both_branches_taken'].should == overall['branches']

          lines['hit'].each_value do |hit|
            hit.should == true
          end

          lines['branched'].each_value do |branched|
            branched.should == true
          end
        end


      when 'not reached'
        it "has #{data.length} unreached lines" do

          overall['instructions_reached'].should_not == overall['instructions']

          file = nil

          lines['hit'].each_pair do |line, hit|
            file, lineno = line.split ':'
            next unless file.end_with? "#{test_file}.rb"

            lineno = lineno.to_i

            data.should_not include lineno if hit
            data.should include lineno unless hit
          end

          data.map {|x| "#{file}:#{x}"}.each do |x|
            lines['hit'].keys.should include x
          end
        end

      when 'not branched'
        it "has #{data.length} branches not both taken" do

          overall['both_branches_taken'].should_not == overall['branches']

          file = nil

          lines['branched'].each_pair do |line, hit|
            file, lineno = line.split ':'
            next unless file.end_with? "#{test_file}.rb"

            lineno = lineno.to_i

            data.should_not include lineno if hit
            data.should include lineno unless hit
          end

          data.map {|x| "#{file}:#{x}"}.each do |x|
            lines['branched'].keys.should include x
          end
        end

      else
        raise "Unknown expectation #{expectation}"
      end
    end
  end
end
