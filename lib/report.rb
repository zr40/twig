module Twig
  class Report
    def initialize coverage_points
      puts 'twig: processing coverage data...'

      hit = 0
      partial = 0

      opcodes = Rubinius::InstructionSet.opcodes

      coverage_points.each_value do |cp|
        if cp.hit?
          hit += 1
        else
          loc = "#{cp.cmethod.file}:#{cp.cmethod.line_from_ip cp.ip} (#{cp.cmethod.name}) -- IP@#{cp.ip}: #{opcodes[cp.cmethod.iseq[cp.ip]].name}"
 
          if cp.conditional_branch?
            partial += 1
            if cp.branched_to? 0
              puts "Never jumped: #{loc}"
            else
              puts "Always jumped: #{loc}"
            end
          else
            puts "Not reached: #{loc}"
          end
        end
      end

      puts "#{coverage_points.length} instructions"
      puts "#{hit + partial} reached"
      puts "#{partial} branches not taken"
      # TODO
    end
  end
end
