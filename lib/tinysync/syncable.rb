require 'active_support/concern'

module TinySync::Syncable

  extend ActiveSupport::Concern

  @@state_names = %w(active inactive deleted)


  included do

    field :_state, type: Integer, default: 0
    validates :_state, presence: true, numericality: true

    def self.is_sync_root
      false
    end

    def state_name
      @@state_names[self._state]
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
