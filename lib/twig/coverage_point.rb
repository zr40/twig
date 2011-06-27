module Twig
  class CoveragePoint
    attr_reader :cmethod
    attr_reader :ip

    def initialize cm, ip, coverage
      @cmethod = cm
      @ip = ip
      @coverage = coverage

      @hit = false
      @branched_to = [false, false]

      opcodes = cm.iseq.opcodes
      opcode = Rubinius::InstructionSet.opcodes[opcodes[ip]]

      @conditional_branch = [:goto_if_false, :goto_if_true].member? opcode.opcode

      enable
    end

    def enable
      @cmethod.set_breakpoint @ip, self
    end

    def disable
      @cmethod.clear_breakpoint @ip
    end

    def disable_if_hit
      disable if @hit
    end

    def hit _self, thread, channel, vm_locations
      @coverage.reach self

      if @conditional_branch
        @coverage.branch = self
      else
        @hit = true
      end

      disable_if_hit
    end

    def branch_to branch
      @branched_to[branch] = true

      @hit = (@branched_to[0] and @branched_to[1])

      disable_if_hit
    end

    def hit?
      @hit
    end

    def conditional_branch?
      @conditional_branch
    end

    def branched_to? branch
      @branched_to[branch]
    end
  end
end
