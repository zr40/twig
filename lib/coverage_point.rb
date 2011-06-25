module Twig
  class CoveragePoint
    def initialize method, ip
      @method = method
      @ip = ip
      @hit = false

      opcodes = method.iseq.opcodes
      opcode = Rubinius::InstructionSet.opcodes[opcodes[ip]]

      @conditional_branch = [:goto_if_false, :goto_if_true].member? opcode.opcode
      puts opcode.opcode if @conditional_branch

      method.set_breakpoint ip, self
    end

    def hit _self, thread, channel, vm_locations
      puts "hit #{@method.name} @ #{@ip}"
      if @conditional_branch
        puts "TODO: determine branch direction"
      else
        @hit = true
      end

      @method.clear_breakpoint @ip if @hit

      channel << true
    end
  end
end
