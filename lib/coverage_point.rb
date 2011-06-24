module Twig
  class CoveragePoint
    def initialize method, ip
      @method = method
      @ip = ip

      method.set_breakpoint ip, self
    end

    def hit _self, thread, channel, vm_locations
      puts 'hit'

      @method.clear_breakpoint @ip

      channel << true
    end
  end
end
