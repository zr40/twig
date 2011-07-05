#!/usr/bin/env ruby
$:.unshift 'lib'

require 'rubygems'
require 'json'

require 'twig/coverage'
require 'compiler/printers'

coverage = Twig::Coverage.new

begin
  require ARGV.shift
rescue Exception => e
  STDERR.puts "#{file}: unhandled #{e}"
end

report = coverage.report

json = {
  :overall => report.overall,
  :lines => report.lines,
}.to_json

puts json
