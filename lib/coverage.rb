require 'lib/compiled_hook'
require 'lib/coverage_point'
require 'lib/coverage_thread'
require 'lib/report'

module Twig
  class Coverage
    def initialize
      Rubinius::CodeLoader.compiled_hook.add method :compiled
      CoverageThread.new

      @coverage_points = {}
    end

    def compiled script
      add_coverage_points script.compiled_method
    end

    def report
      Report.new @coverage_points
    end 

    def add_coverage_points method
      method.child_methods.each { |child| add_coverage_points child }

      opcodes = method.iseq.opcodes

      ip = 0
      while ip != opcodes.length
        raise 'Invalid bytecode; exceeded method length' if ip > opcodes.length

        cp = CoveragePoint.new method, ip, self
        @coverage_points[[method, ip]] = cp

        ip += Rubinius::InstructionSet.opcodes[opcodes[ip]].size
      end
    end

    # store the branch origin to determine the branch direction at the next
    # breakpoint (see reach)
    def branch= cp
      @branch_origin = cp
      @branch_target_0 = @coverage_points[[cp.cmethod, cp.ip + 2]]
      @branch_target_1 = @coverage_points[[cp.cmethod, cp.cmethod.iseq.opcodes[cp.ip + 1]]]

      @branch_target_0.enable
      @branch_target_1.enable
    end

    # record branch taken
    def reach cp
      if cp == @branch_target_0
        @branch_origin.branched_to 0
        @branch_target_1.disable_if_hit
        @branch_origin = nil
      elsif cp == @branch_target_1
        @branch_origin.branched_to 1
        @branch_target_0.disable_if_hit
        @branch_origin = nil
      elsif @branch_origin
        raise 'Branch origin is set but current location is not a branch target'
      end
    end
  end
end
