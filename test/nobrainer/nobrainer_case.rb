require 'test_helpers'
require 'nobrainer/models'

module TinySync::NoBrainerTests

  class NoBrainerCase < Test::Unit::TestCase

    def setup
      NoBrainer.configure do |config|
        config.rethinkdb_url          = 'tinysync_test'
        config.logger                 = Logger.new $stdout
        config.warn_on_active_record  = true
        config.auto_create_databases  = true
        config.auto_create_tables     = true
        config.cache_documents        = true
        config.max_reconnection_tries = 10
      end

      TinySync.configure do |config|
        config.dialect = :nobrainer
      end
    end

  end

end