require 'tinysync/version'
require 'tinysync/util'
require 'tinysync/config'
require 'tinysync/wrappers/nobrainer_wrapper'

module TinySync

  class << self

    attr_accessor :config

    def configure(&block)
      @config = Config.new unless @config
      block.call(@config)
    end

    def wrapper
      case @config.dialect
        when :nobrainer
          NoBrainerWrapper.new
        else
          raise "There's no wrapper for dialect #{@config.dialect}"
      end
    end

    def schema
      self.wrapper.get_schema @config
    end

  end

end
