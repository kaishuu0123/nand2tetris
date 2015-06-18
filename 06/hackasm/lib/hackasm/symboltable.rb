class SymbolTable
  def initialize
    @current_variable_address = 16
    @defined_symbol_table = {
      "SP"     => 0,
      "LCL"    => 1,
      "ARG"    => 2,
      "THIS"   => 3,
      "THAT"   => 4,
      "SCREEN" => 16384,
      "KBD"    => 24576
    }
    generate_register_symbol
  end

  def add_entry(symbol, address)
    @defined_symbol_table[symbol] = address
  end

  def contains(symbol)
    @defined_symbol_table.has_key? symbol
  end

  def get_address(symbol)
    @defined_symbol_table[symbol]
  end

  def add_variable_symbol(symbol)
    add_entry(symbol, @current_variable_address)
    @current_variable_address = @current_variable_address + 1
  end

  private
  def generate_register_symbol
    16.times do |i|
      @defined_symbol_table["R#{i}"] = i
    end
  end
end
