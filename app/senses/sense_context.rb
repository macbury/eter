class SenseContext

  def initialize(params, current_user, current_ability)
    @current_user    = current_user
    @current_ability = current_ability
    @query           = params[:query].strip
    @params          = params
  end

  def can?(*args)
    @current_ability.can?(*args)
  end

  def cannot?(*args)
    @current_ability.cannot?(*args)
  end

  def query
    @query
  end

  def current_user
    @current_user
  end

  def current_project
    @project ||= Project.where(id: @params[:project_id]).first if @params.key?(:project_id)
  end

  def have_project?
    current_project.present?
  end

  def actions
    results
  end

  def results
    @results
  end

  def to_json
    @results.to_json
  end

  def to_h
    @results.map(&:to_h)
  end

  def search
    @results = []
    BaseSense.all.each do |sense_class|
      sense    = sense_class.new(self)
      @results += sense.actions
    end

    @results.compact!
    @results.sort! { |a,b| b.sort_key <=> a.sort_key }
  end

end
