module Twig
  class Report
    def initialize coverage_points
      STDERR.puts 'twig: processing coverage data...'

      @coverage_points = coverage_points
      @branches = find_branches

      calculate_overall
      calculate_line_coverage coverage_points
      # TODO
    end

    def find_branches
      branch_opcodes = [Rubinius::InstructionSet.opcodes_map[:goto_if_true], Rubinius::InstructionSet.opcodes_map[:goto_if_false]]

      branches = {}

      @coverage_points.each_value do |cp|
        branches[cp] = [cp.ip + 2, cp.cmethod.iseq[cp.ip + 1]] if branch_opcodes.index cp.cmethod.iseq[cp.ip]
      end

      branches
    end

    attr_reader :overall

    def calculate_overall
      instructions_hit = 0
      both_branches_taken = 0

      opcodes = Rubinius::InstructionSet.opcodes

      @coverage_points.each_value do |cp|
        instructions_hit += 1 if cp.hit?
      end

      @branches.each do |cp, targets|
        both_branches_taken += 1 if @coverage_points[[cp.cmethod, targets[0]]].hit? and @coverage_points[[cp.cmethod, targets[1]]].hit?
      end

      @overall = {
        :instructions => @coverage_points.length,
        :branches => @branches.length,
        :instructions_hit => instructions_hit,
        :both_branches_taken => both_branches_taken,
      }
    end

    attr_reader :lines

    def calculate_line_coverage coverage_points
      hit = {}
      branched = {}

      @coverage_points.each_value do |cp|
        key = "#{cp.cmethod.file}:#{cp.cmethod.line_from_ip cp.ip}"

        hit[key] ||= cp.hit?
      end

      @branches.each_pair do |cp,targets|
        key = "#{cp.cmethod.file}:#{cp.cmethod.line_from_ip cp.ip}"

        target0 = @coverage_points[[cp.cmethod, targets[0]]]
        target1 = @coverage_points[[cp.cmethod, targets[1]]]

        branched[key] ||= (target0.hit? && target1.hit?) if cp.hit?
      end

      @lines = {:hit => hit, :branched => branched}
    end
  end
end
