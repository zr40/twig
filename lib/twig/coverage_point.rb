module Twig
  class CoveragePoint
    attr_reader :cmethod
    attr_reader :ip

    def initialize cm, ip
      @cmethod = cm
      @ip = ip
      @hit = false

      @cmethod.set_breakpoint @ip, self
    end

    def hit _self, thread, channel, vm_locations
      @cmethod.clear_breakpoint @ip
      @hit = true
    end

    def hit?
      @hit
    end
  end
end
