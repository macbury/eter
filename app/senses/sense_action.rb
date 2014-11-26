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

  def sort_key
    PRIORITY[self.priority] || 0
  end

  def to_h
    { action: self.action, description: description, priority: self.sort_key, payload: self.payload }
  end

  def to_json
    to_h.to_json
  end
end
