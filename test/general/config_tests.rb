require 'test_helpers'

module TinySync::GeneralTests

  class ConfigTests < Test::Unit::TestCase

    def test_invalid_dialect
      assert_raise RuntimeError do
        TinySync.configure do |config|
          config.dialect = :invalid
        end
      end
    end

  end

end