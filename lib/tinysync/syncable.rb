require 'active_support/concern'

module TinySync::Syncable

  extend ActiveSupport::Concern

  included do

    field :sync_state

  end

end