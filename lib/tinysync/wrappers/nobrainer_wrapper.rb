require 'nobrainer'
require 'json'
#require 'tinysync/util'

# wrapper for NoBrainer models
class TinySync::NoBrainerWrapper

  def get_type(name, type)
    if type
      type.to_s.downcase
    elsif name.to_s =~ /_at$/
      'time'
    else
      'string'
    end
  end

  def get_schema(config)

    docs = NoBrainer::Document.all

    schema = {
        created_at: Time.now,
        tables: []
    }

    docs.each do |doc|
      puts ''
      table = {
          name: doc.name.split(':').last.tableize,
          fields: []
      }

      # parse the fields
      doc.fields.each_key do |name|
        opts = doc.fields[name]
        type = get_type name, opts[:type]
        field = {name: name.to_s, type: type}

        if opts.has_key? :default
          field[:default] = opts[:default]
        end

        table[:fields] << field
      end

      # parse the associations
      doc.association_metadata.each_key do |name|
        meta = doc.association_metadata[name]
        #puts "  association #{name}: #{meta.inspect}"
      end

      # parse the validators
      doc.validators.each do |validator|
        name = validator.attributes.first.to_s
        field = table[:fields].select_named name
        if field
          if validator.instance_of? ActiveModel::Validations::PresenceValidator
            field[:null] = false
          elsif validator.instance_of? ActiveModel::Validations::InclusionValidator
            field[:in] = validator.options[:in]
          end
        end
      end

      schema[:tables] << table
    end
    puts ''
    #puts "== schema: #{JSON.pretty_generate(schema)}"
    schema
  end


end