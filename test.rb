#!/usr/bin/env rbx
require 'lib/coverage'
require 'lib/coverage_point'

Twig::Coverage.new

require 'something'
a_method
a_method
a_method
