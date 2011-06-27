def a_method
  if true
    puts 'bar'
  end
  if false
    puts 'bar'
  end
end

class AClass
  def self.class_method
    def foo
    end
  end

  def instance_method
  end
end

module AModule
  def method_in_module
  end
end

def accept_a_block
end

accept_a_block {
}
