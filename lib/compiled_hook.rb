# TODO FIXME
# This is a temporary hack to get the CompiledMethod::Script before it's executed.
# Rubinius doesn't currently have a hook for that.
#
# Remove this code when the hook is added.
module Rubinius
  class CodeLoader
    @compiled_hook = Rubinius::Hook.new

    class << self
      attr_reader :compiled_hook
    end

    alias load_file_without_hook load_file

    def load_file
      result = load_file_without_hook
      CodeLoader.compiled_hook.trigger! result
      result
    end
  end
end
