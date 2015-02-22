class TruthTable

  attr_reader :helper

  attr_accessor :iteration_number

  def initialize
    @helper = Helper.new
  end

  def print(func)
    @iteration_number = 0
    @variables = helper.function_variables func
    max = 2 ** @variables.length

    print_header

    (iteration_number...max).each do
      @variables.each do |var|
        value = instance_eval "#{var}"
        Kernel.print value.to_i.to_s.center(var.length + 1)
      end
      Kernel.print eval(func).to_i.to_s.center(7)
      puts
      @iteration_number += 1
    end
  end

  protected

  def print_header
    @variables.each { |var| Kernel.print var, ' ' }
    puts 'f(...)'
  end

  def method_missing(name, *args)
    position = @variables.index name.to_s
    position.nil? ? super : iteration_number[@variables.length - position - 1].to_b
  end

end