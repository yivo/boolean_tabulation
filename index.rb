require './lib/patches'
require './lib/resources'
require './lib/helper'
require './lib/simplificator'
require './lib/truth_table'

func = gets

simplificator = Simplificator.new
func = simplificator.simplify_all func
puts func

truth_table = TruthTable.new
truth_table.print func