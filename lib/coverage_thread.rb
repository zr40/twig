module Twig
  class CoverageThread
    def initialize coverage
      wait_channel = Rubinius::Channel.new
      
      @thread = Thread.new do
        begin
          debugger_channel = Rubinius::Channel.new
          @thread.setup_control! debugger_channel
          wait_channel << true

          # receive debugger callbacks
          coverage.hit debugger_channel.receive while true
        rescue Exception => e
          puts e
        end
      end

      # ensure the thread has called setup_control!
      wait_channel.receive

      Thread.current.set_debugger_thread @thread
    end
  end
end
