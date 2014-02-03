require 'test_helpers'

module TinySync::NoBrainerTests

  class NoBrainerCase < Test::Unit::TestCase

    def setup
      NoBrainer.configure do |config|
        config.rethinkdb_url          = 'rethinkdb://localhost/tinysync_test'
        config.logger                 = Logger.new $stdout
        config.warn_on_active_record  = true
        config.auto_create_databases  = true
        config.auto_create_tables     = true
        config.max_reconnection_tries = 2
      end


      TinySync.configure do |config|
        config.dialect = :nobrainer
      end
    end

    def drop_all
      NoBrainer::Document.all.each do |doc|
        doc.delete_all
      end
    end

  end

end