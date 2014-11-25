class CreateProjectSense < BaseSense

  def valid?
    @context.current_project.nil?
  end

  def payload
    { name: @context.query }
  end

  def self.build_for_context!(context)
    sense = CreateProjectSense.new(context)
    if sense.valid?
      return sense
    else
      return nil
    end
  end

end
