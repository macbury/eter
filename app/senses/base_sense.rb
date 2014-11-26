class BaseSense
  REGEXP_SENSE_FILE = /_sense\.rb/i

  def initialize(context)
    log "Processing..."
    @context = context
    @actions = []
    process
  end

  def context
    @context
  end

  def log(msg)
    Rails.logger.debug "[#{self.class}] #{msg}"
  end

  def process
    throw "Implement process method method in #{self.class}"
  end

  def push(action)
    if action.valid?
      @actions << action
    else
      throw Exception.new("Sense action is not valid #{action.class}: #{action.errors.full_messages}")
    end
  end

  def actions
    @actions
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
