if true
  if false
    if true
    end
  end
end

def foo
  if true
    def bar
      if false
        baz
      end
    end
  end

  if false
    def baz
      if true
      end
    end
  end
end

foo
bar
