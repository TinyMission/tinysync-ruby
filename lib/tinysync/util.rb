
class Array
  def select_named(name)
    self.select{|obj| obj[:name] == name}.first
  end
end