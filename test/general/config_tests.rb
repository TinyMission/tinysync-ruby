require 'test_helpers'

module TinySync::GeneralTests

  class ConfigTests < Minitest::Test

    def test_invalid_dialect
      assert_raise RuntimeError do
        TinySync.configure do |config|
          config.dialect = :invalid
        end
      end
    end

  end

end