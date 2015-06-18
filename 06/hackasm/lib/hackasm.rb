require "hackasm/version"

require 'hackasm/symboltable'
require 'hackasm/parser'
require 'hackasm/code'

class HackAsm
  def initialize
    @symbol_table = SymbolTable.new
  end

  def collect_memory_location_and_label_definitions(infile)
    parser = Parser.new(infile)

    cur_address = 0
    while parser.has_more_commands
      parser.advance()

      case parser.command_type
      when Parser::A_COMMAND
        cur_address = cur_address + 1
      when Parser::C_COMMAND
        cur_address = cur_address + 1
      when Parser::L_COMMAND
        @symbol_table.add_entry(parser.symbol, cur_address)
      end
    end
  end

  def generate_code(infile)
    parser = Parser.new(infile)
    out_dir = File.expand_path(File.dirname(infile))
    out_filename = File.basename(infile, ".asm")
    outfile = File.open(out_dir + "/" + out_filename + ".hack", "w")
    while parser.has_more_commands
      parser.advance()

      case parser.command_type
      when Parser::A_COMMAND
        symbol_address = 0

        if parser.symbol =~ /^[0-9]+$/
          symbol_address = parser.symbol
        else
          if @symbol_table.contains(parser.symbol)
            symbol_address = @symbol_table.get_address(parser.symbol)
          else
            @symbol_table.add_variable_symbol(parser.symbol)
            symbol_address = @symbol_table.get_address(parser.symbol)
          end
        end

        prefix = "0"
        bin = symbol_address.to_i.to_s(2)
        outfile.puts "#{prefix}#{sprintf("%015d", bin)}"
      when Parser::C_COMMAND
        code = Code.new()
        prefix = "111"

        d = code.dest(parser.dest)
        c = code.comp(parser.comp)
        j = code.jump(parser.jump)

        outfile.puts "#{prefix}#{c}#{d}#{j}"
      when Parser::L_COMMAND

      end
    end
    outfile.close()
  end

  def assemble(infile)
    self.collect_memory_location_and_label_definitions(infile)
    self.generate_code(infile)
  end
end
