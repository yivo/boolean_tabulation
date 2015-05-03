require './lib/patches'
require './lib/resources'
require './lib/helper'
require './lib/simplificator'
require './lib/truth_table'

func  = ARGV.first.dup
debug = ARGV.include?('--debug')

simplificator = Simplificator.new
func = simplificator.simplify_all func, debug: debug
puts "Simplified function to #{func}"

truth_table = TruthTable.new
truth_table.print func