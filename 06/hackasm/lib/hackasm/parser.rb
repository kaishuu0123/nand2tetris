class Parser
  A_COMMAND=0
  C_COMMAND=1
  L_COMMAND=2

  def initialize(infile=nil)
    @infile_path = infile
    @infile_fp = File.open(infile)
    @cur_cmd_type = nil
    @cur_dest = ""
    @cur_symbol = ""
    @cur_jump = ""
  end

  def advance
    line = @infile_fp.gets.strip

    line.slice!(%r!//.+$!) if line =~ %r!//!

    case line
    when %r!^//!, %r!^[\s]+$!, "" then
      @cur_cmd_type = ""
    when %r!\(([0-9a-zA-Z_\.\$:]+)\)!
      @cur_cmd_type = L_COMMAND
      @cur_symbol = $1
    when %r!^@([0-9a-zA-Z_\.\$:]+)$!
      @cur_cmd_type = A_COMMAND
      @cur_symbol = $1
    else
      @cur_cmd_type = C_COMMAND
      if line.include?("=")
        @cur_jump = ""
        @cur_dest, @cur_comp = line.split("=")
        @cur_dest.strip!
        @cur_comp.strip!
      elsif line.include?(";")
        @cur_dest = ""
        @cur_comp, @cur_jump = line.split(";")
        @cur_comp.strip!
        @cur_jump.strip!
      end
    end
  end

  def has_more_commands
    if @infile_fp.eof?
      @infile_fp.close
      return false
    end
    true
  end

  def command_type
    @cur_cmd_type
  end

  def dest
    @cur_dest
  end

  def symbol
    @cur_symbol
  end

  def comp
    @cur_comp
  end

  def jump
    @cur_jump
  end
end
