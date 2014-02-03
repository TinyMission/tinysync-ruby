require 'active_support/concern'

module TinySync::Syncable

  extend ActiveSupport::Concern

  @@possible_states = %w(alive dead)


  included do

    field :sync_state, default: @@possible_states.first
    validates :sync_state, presence: true, inclusion: {in: @@possible_states}

    def self.is_sync_root
      false
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
