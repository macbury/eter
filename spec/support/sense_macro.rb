module SenseMacro

  def sense_context(query, *factories_names)
    factories    = factories_names.map { |name| name.class == Symbol ? FactoryGirl.create(name) : name }
    current_user = factories.find { |f| f.class == User }
    throw "Add user factory!" unless current_user
    params         = factories.inject({}) do |output, factory|
      output[factory.class.to_s.foreign_key.to_sym] = factory.id
      output
    end
    params[:query] = query
    SenseContext.new(params, current_user)
  end

end
