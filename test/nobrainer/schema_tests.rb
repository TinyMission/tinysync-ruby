require 'nobrainer/nobrainer_case'

require 'nobrainer/models'

module TinySync::NoBrainerTests

  class SchemaTests < NoBrainerCase

    def setup
      super
      @schema = TinySync.schema
      @tables = @schema[:tables]
      @comments = @tables.select_named 'comments'
      @posts = @tables.select_named 'posts'
      @authors = @tables.select_named 'authors'
    end

    def test_basic
      assert_equal 3, @tables.count
    end

    def test_timestamps
      fields = @tables.first[:fields]
      created_at_field = fields.select_named 'created_at'
      updated_at_field = fields.select_named 'updated_at'
      assert_equal 'time', created_at_field[:type]
      assert_equal 'time', updated_at_field[:type]
    end

    def test_defaults
      assert_equal 'First Post!', @comments[:fields].select_named('body')[:default]
    end

    def test_nullability
      assert !@posts[:fields].select_named('title')[:null]
    end

    def test_inclusion
      assert_equal %w(junior senior), @authors[:fields].select_named('seniority')[:in]
    end

    def test_syncable
      sync_state_field = @comments[:fields].select_named('sync_state')
      assert_not_nil sync_state_field
      assert_equal 'string', sync_state_field[:type]
    end

    def test_sync_roots
      assert @posts[:is_root]
      assert !@comments[:is_root]
    end

  end

end