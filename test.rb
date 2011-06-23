#!/usr/bin/env rbx
require 'lib/coverage_thread'
require 'rubinius/debugger'

Twig::CoverageThread.new.start Rubinius::Channel.new

def foo
end

bp = Rubinius::Debugger::BreakPoint.new :foo, method(:foo).executable, 0, 0
bp.activate

foo
foo
foo
foo
