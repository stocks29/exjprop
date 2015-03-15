defprotocol Exjprop.Properties do
  def load(properties)
  def loaded?(properties)
  def get_property!(properties, name)
  def get_property(properties, name)
  def to_map(properties)
end