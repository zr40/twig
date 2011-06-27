module Twig
  class Report
    def initialize coverage_points
      $stderr.puts 'twig: processing coverage data...'

      calculate_overall coverage_points
      # TODO
    end

    attr_reader :instructions, :branches, :instructions_reached, :both_branches_taken

    def calculate_overall coverage_points
      @instructions = coverage_points.length
      @branches = 0
      @instructions_reached = 0
      @both_branches_taken = 0

      opcodes = Rubinius::InstructionSet.opcodes

      coverage_points.each_value do |cp|
        if cp.conditional_branch?
          @branches += 1
        end

        if cp.hit?
          @instructions_reached += 1
          @both_branches_taken += 1 if cp.conditional_branch?
        elsif false
          loc = "#{cp.cmethod.file}:#{cp.cmethod.line_from_ip cp.ip} (#{cp.cmethod.name}) -- IP@#{cp.ip}: #{opcodes[cp.cmethod.iseq[cp.ip]].name}"
 
          if cp.conditional_branch? and (cp.branched_to? 0 or cp.branched_to? 1)
            if cp.branched_to? 0
              $stderr.puts "Never jumped: #{loc}"
            else
              $stderr.puts "Always jumped: #{loc}"
            end
          else
            $stderr.puts "Not reached: #{loc}"
          end
        end
      end
    end
  end
end
