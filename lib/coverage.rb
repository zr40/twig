require 'rubinius/debugger'
require 'lib/coverage_thread'
require 'lib/compiled_hook'

module Twig
  class Coverage
    def initialize
      Rubinius::CodeLoader.compiled_hook.add method :compiled
      CoverageThread.new self
    end

    def compiled script
      puts "Compiled #{script}"
    end

    def hit data
      breakpoint, thread, channel, vm_locations = data

      puts "DEBUG: #{breakpoint} #{thread} #{vm_locations}"

      breakpoint.remove!

      channel << true
    end
  end
end
