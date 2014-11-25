class BaseSense
  REGEXP_SENSE_FILE = /_sense\.rb/i
  def initialize(context)
    @context = context
  end

  def name
    self.class.name.to_s.underscore
  end

  def payload
    throw "Implement payload method in #{self.class}"
  end

  def priority
    0
  end

  def valid?
    throw "Implement valid? method in #{self.class}"
  end

  def to_json
    to_h.to_json
  end

  def to_h
    { name: name, payload: payload, priority: priority }
  end

  def self.build_for_context!(context)
    throw "implement build_for_context! in #{self.name}"
  end

  def self.all
    list = []
    Dir[Rails.root.join("app/senses/list/*.rb").to_s].each do |file_name|
      if file_name.match(REGEXP_SENSE_FILE)
        sense_file = File.basename(file_name,".rb")
        list << sense_file.camelize.constantize
      end
    end

    list
  end

end
