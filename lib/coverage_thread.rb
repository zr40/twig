module Twig
  class CoverageThread
    def start return_channel
      @debugger_channel = Rubinius::Channel.new
      @return_channel = return_channel

      @channel = @return_channel
      
      @thread = Thread.new do
        begin
          @thread.setup_control! @debugger_channel

          while true
            listen
          end
        rescue Exception => e
          puts e
        end
      end

      # ensure the thread has called setup_control!
      @return_channel.receive

      Thread.current.set_debugger_thread @thread
    end

    # receive a debugger callback
    def listen
      @channel << true
      breakpoint, thread, @channel, vm_locations = @debugger_channel.receive

      breakpoint.remove!
      puts "DEBUG: #{breakpoint} (#{breakpoint.instance_variable_get :@temp}), #{thread}, #{vm_locations}"
    end
  end
end
