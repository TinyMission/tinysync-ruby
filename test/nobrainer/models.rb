
require 'active_model'
require 'nobrainer'
require 'tinysync/syncable'

module TinySync::NoBrainerTests

  class Author
    include NoBrainer::Document
    include NoBrainer::Document::Timestamps
    include TinySync::Syncable
    include TinySync::SyncRoot

    field :name
    validates :name, presence: true, uniqueness: true

    field :age, type: Integer

    field :seniority, default: 'junior'
    validates :seniority, inclusion: {in: %w(junior senior)}

    has_many :posts
  end

  class Post
    include NoBrainer::Document
    include NoBrainer::Document::Timestamps
    include TinySync::Syncable
    include TinySync::SyncRoot

    field :title, type: String, index: true
    validates :title, presence: true, uniqueness: true

    field :posted_at, type: Time
    validates :posted_at, presence: true

    field :body

    field :points, type: Integer, default: 0
    validate :points, numericality: {only_integer: true, minimum: -100, maximum: 100}

    has_many :comments
    belongs_to :author, index: true
  end

  class Comment
    include NoBrainer::Document
    include NoBrainer::Document::Timestamps
    include TinySync::Syncable

    field :body, default: 'First Post!'
    validates :body, presence: true

    field :commented_at, type: Time
    validates :commented_at, presence: true

    belongs_to :post, index: true
  end

end