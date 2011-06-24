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
    end
  end
end
