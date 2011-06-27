#!/usr/bin/env ruby
$:.unshift 'lib'

require 'rubygems'
require 'json'

require 'twig/coverage'

coverage = Twig::Coverage.new

require ARGV.shift

report = coverage.report

json = {
  :overall => {
    :instructions => report.instructions,
    :branches => report.branches,
    :instructions_reached => report.instructions_reached,
    :both_branches_taken => report.both_branches_taken,
  }
}.to_json

puts json
