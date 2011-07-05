module Twig
  class CoverageThread
    def initialize
      wait_channel = Rubinius::Channel.new
      
      @thread = Thread.new do
        begin
          debugger_channel = Rubinius::Channel.new
          @thread.setup_control! debugger_channel

          data = [nil, nil, wait_channel, nil]

          while true
            data[2] << true
            data = debugger_channel.receive
            data[0].hit *data
          end
        rescue Exception => e
          STDERR.puts "Twig coverage thread exception: #{e}"
          STDERR.puts e.message
          STDERR.puts e.backtrace
          raise
        end
      end

      # ensure the thread has called setup_control!
      wait_channel.receive

      Thread.current.set_debugger_thread @thread
    end
  end
end
