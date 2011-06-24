#!/usr/bin/env rbx
require 'lib/coverage'
require 'lib/coverage_point'

Twig::Coverage.new

def foo
end

Twig::CoveragePoint.new method(:foo).executable, 0

foo
foo
foo
foo

require 'something'
bar
