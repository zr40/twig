require 'twig/coverage_point'
require 'twig/coverage_thread'
require 'twig/report'

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

        opcode = Rubinius::InstructionSet.opcodes[opcodes[ip]]

        cp = CoveragePoint.new method, ip
        @coverage_points[[method, ip]] = cp

        ip += opcode.size
      end
    end
  end
end
