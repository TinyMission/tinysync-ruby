
class TinySync::Config

  attr_accessor :dialect

  def initialize
    @dialect = :nobrainer
  end


  @dialects = [:nobrainer]

  def self.possible_dialects
    @dialects
  end

  def dialect=(d)
    unless TinySync::Config.possible_dialects.index(d)
      raise "Invalid dialect: #{d}"
    end
    @dialect = d
  end

end