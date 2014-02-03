require 'tinysync/mini_logger'
require 'tinysync/util'

class TinySync::Syncer

  def initialize(config, wrapper)
    @config = config
    @wrapper = wrapper
    @t_start = Time.now
  end

  def error(message)
    {status: 'error', message: message, elapsed_time: Time.now - @t_start}
  end


  def run(request)
    request.sanitize_keys
    @t_start = Time.now
    puts request.inspect
    unless request.has_key? :last_synced
      return error 'Must provides a last_synced time'
    end
    begin
      if request[:last_synced].instance_of? String
        @last_synced = Time.parse request[:last_synced]
      elsif request[:last_synced].instance_of? Time
        @last_synced = request[:last_synced]
      else
        raise "Don't know how to handle last_synced of type #{request[:last_synced].class.name}"
      end
    rescue Exception => e
      return error "Error parsing last_synced: #{e.message}"
    end

    unless request.has_key? :entities
      return error 'Must provides an array of entities to sync'
    end
    in_entities = request[:entities]

    @logger = MiniLogger.new
    @out_entities = []

    @wrapper.root_models.each do |model|
      entity_name = model.name.split('::').last.tableize
      in_entity = in_entities.select_named entity_name
      unless in_entity
        @logger.warn "Entity #{entity_name} not found. Skipped syncing it."
        next # it's valid for the client to only specify a subset of the root entities, we'll just skip it
      end

      sync_entity entity_name, model, in_entity

    end

    {status: 'success', log: @logger.entries, entities: @out_entities, elapsed_time: Time.now - @t_start}
  end


  private

  def log_errors(record)
    return if record.nil?
    unless record.errors.empty?
      verb = record.persisted? ? 'updating' : 'creating'
      type = record.class.name
      @logger.error_record record.attributes, "#{'Error'.pluralize(record.errors.count)} #{verb} #{type}"
    end
  end

  def sync_entity(name, model, in_entity)
    # get new and updated records from the server
    if in_entity[:scope]
      scope = in_entity[:scope]

      # get new records
      begin
        new_scope = scope.dup
        new_scope[:created_at.gte] = @last_synced
        new_records = model.where(new_scope).raw.to_a
      rescue Exception => e
        @logger.warn "Error getting new records on the server: #{e.message}"
      end

      # get updated records
      begin
        updated_scope = scope.dup
        updated_scope[:created_at.lt] = @last_synced
        updated_scope[:updated_at.gte] = @last_synced
        updated_scope[:sync_state] = 'alive'
        updated_records = model.where(updated_scope).raw.to_a
      rescue Exception => e
        @logger.warn "Error getting updated records on the server: #{e.message}"
      end

      # get dead records
      begin
        dead_scope = scope.dup
        dead_scope[:created_at.lt] = @last_synced
        dead_scope[:updated_at.gte] = @last_synced
        dead_scope[:sync_state] = 'dead'
        dead_records = model.where(dead_scope).raw.to_a
      rescue Exception => e
        @logger.warn "Error getting new records on the server: #{e.message}"
      end

      @out_entities << {name: name, created: new_records,
                        updated: updated_records, deleted: dead_records}
    else
      @logger.warn "Found no scope for entity #{name}, not returning any server records."
    end

    # create the new entries
    if in_entity[:created]
      in_entity[:created].each do |data|
        record = model.create data
        log_errors record
      end
    else
      @logger.warn "Found no created field in the #{name} entity."
    end

    # update the existing entries
    if in_entity[:updated]
      in_entity[:updated].each do |data|
        id = data[:id]
        record = nil
        begin
          record = model.find id
          record.update_attributes data
        rescue Exception => e
          @logger.error "Could not find #{name} with id #{id}"
        end
        log_errors record
      end
    else
      @logger.warn "Found no updated field in the #{name} entity."
    end

    # update deleted entries
    if in_entity[:deleted]
      in_entity[:deleted].each do |data|
        id = data[:id]
        record = nil
        begin
          record = model.find id
          record.update_attributes sync_state: 'deleted'
        rescue Exception => e
          @logger.error "Could not find #{name} with id #{id}"
        end
        log_errors record
      end
    else
      @logger.warn "Found no deleted field in the #{name} entity."
    end
  end

end