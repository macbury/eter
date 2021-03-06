class SenseAction
  include ActiveModel::Validations
  PRIORITY = { :normal => 0, :low => -1, :high => 1, :very_high => 2 }
  attr_accessor :action, :priority, :payload, :description

  validates :action, :priority, :payload, presence: true
  validates :priority, inclusion: { in: PRIORITY.keys }

  def initialize(action_name=nil)
    self.action   = action_name
    self.payload  = {}
    self.priority = :normal
  end

  def put_extra(key, value)
    self.payload[key] = value
  end

  def get_extra(key)
    payload[key]
  end

  def redirect_to(path, params)
    put_extra(:path, path.to_s.camelize(:lower))
    put_extra(:path_params, params)
  end

  def have_redirect?
    have_extra?(:path) && have_extra?(:path_params)
  end

  def have_extra?(key)
    payload.key?(key)
  end

  def sort_key
    PRIORITY[self.priority] || 0
  end

  def to_h
    { action: self.action, description: description, payload: self.payload }
  end

  def to_json
    to_h.to_json
  end
end
