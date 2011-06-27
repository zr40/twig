def called_by_foo
end

def called_by_foo_if_true
  def accept_a_block
    yield
  end
end

def called_by_foo_if_false
  def create_another_method
    def bar
      baz true
    end
  end
end

def baz param=false
end

def foo param
  called_by_foo
  if param
    called_by_foo_if_true
  else
    called_by_foo_if_false
  end
end

baz
foo true
foo false

accept_a_block { create_another_method }
bar
