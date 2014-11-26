require 'rspec/expectations'
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
    SenseContext.new(params, current_user, Ability.new(current_user))
  end

  RSpec::Matchers.define :have_action do |expected|
    match do |base_sense|
      base_sense.actions.any? { |sense_action| sense_action.action == expected }
    end
    failure_message do |base_sense|
      action_names = base_sense.actions.map { |sense_action| sense_action.action }.join(", ")
      "expected that actions #{action_names} would have action #{expected}"
    end
  end

end
