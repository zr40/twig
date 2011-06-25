require 'lib/coverage_thread'
require 'lib/compiled_hook'

module Twig
  class Coverage
    def initialize
      Rubinius::CodeLoader.compiled_hook.add method :compiled
      CoverageThread.new
    end

    def compiled script
      puts "Compiled #{script.file_path}"
      add_coverage_points script.compiled_method
    end

    def add_coverage_points method
      method.child_methods.each { |child| add_coverage_points child }

      puts "Adding coverage points to #{method.name}"

      opcodes = method.iseq.opcodes

      ip = 0
      while ip != opcodes.length
        raise 'Invalid bytecode; exceeded method length' if ip > opcodes.length

        CoveragePoint.new method, ip

        ip += Rubinius::InstructionSet.opcodes[opcodes[ip]].size
      end
    end
  end
end
