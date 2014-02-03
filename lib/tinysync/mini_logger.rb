# A tiny little logger that can used as a drop-in replacement for the ruby or rails logger and can generate JSON
class MiniLogger

  attr_accessor :entries

  def initialize
    @entries = []
  end

  def log(level, message)
    @entries << {level: level, message: message}
  end

  def debug(message)
    log :debug, message
  end

  def warn(message)
    log :warn, message
  end

  def error(message)
    log :error, message
  end

  def error_record(record, message)
    @entries << {level: level, message: message, record: record, errors: record.errors}
  end

end