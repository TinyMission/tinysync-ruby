require 'active_support/concern'

module TinySync::Syncable

  extend ActiveSupport::Concern

  @@state_names = %w(alive dead)


  included do

    field :sync_state, type: Integer, default: 0
    validates :sync_state, presence: true, numericality: true

    def self.is_sync_root
      false
    end

    def sync_state_name
      @@state_names[self.sync_state]
    end

  end

end

module TinySync::SyncRoot

  extend ActiveSupport::Concern

  included do

    def self.is_sync_root
      true
    end

  end

end
