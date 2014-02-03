
class Array
  def select_named(name)
    val = self.select{|obj| obj[:name] == name}.first
    if val
      val
    else
      self.select{|obj| obj['name'] == name}.first
    end
  end
end


class Hash
  # recursively converts string keys to symbols
  def sanitize_keys
    self.keys.each do |key|
      if key.instance_of? String
        val = self.delete(key)
        self[key.to_sym] = val
      else
        val = self[key]
      end

      if val.instance_of? Hash
        val.sanitize_keys
      elsif val.instance_of? Array
        val.each do |i|
          i.sanitize_keys if i.instance_of? Hash
        end
      end
    end
  end
end