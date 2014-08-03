require 'nobrainer/nobrainer_case'
require 'json'
require 'nobrainer/models'
require 'tinysync/util'
require 'active_support/all'


module TinySync::NoBrainerTests

  class SyncTests < NoBrainerCase

    def setup
      super
      NoBrainer.update_indexes

      drop_all

      @author1 = Author.create! name: 'Author 1', age: 42
      @author2 = Author.create! name: 'Author 2', age: 21
    end

    def test_server_new
      n = 12
      authors = [@author1, @author2]
      0.upto(n-1) do |i|
        post = Post.create! author_id: authors[i%2].id,
                            title: "This is post #{i}",
                            posted_at: Time.now,
                            body: "some text #{i}",
                            points: rand(10)
        case i%3
          when 0
            post.update_attributes! created_at: Time.now-1.days, _state: 2
          when 1
            post.update_attributes! created_at: Time.now-1.days
        end
      end

      new_posts = [
          {author_id: @author1.id, title: 'First new post', posted_at: Time.now, body: 'This is my first client post'}
      ]

      result = TinySync.sync({
        'last_synced' => Time.new-1.hours,
        'entities' => [
          {'name' => 'posts', 'scope' => {author_id: @author1.id},
          'created' => new_posts}
        ]
      })
      puts JSON.pretty_generate(result)

      posts = result[:entities].select_named('posts')
      assert_equal n/6, posts[:created].length
      assert_equal n/6, posts[:updated].length
      assert_equal n/6, posts[:deleted].length

      created_post = Post.where(title: new_posts.first[:title]).first
      assert_equal 0, created_post._state
    end

  end

end