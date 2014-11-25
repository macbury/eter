class SenseContext

  def initialize(params, current_user)
    @current_user = current_user
    @query        = params[:query].strip
    @params       = params
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
      result = sense_class.build_for_context!(self)
      if result.class == Array
        @results += result
      else
        @results << result
      end
    end

    @results.compact!
    @results.sort! { |a,b| b.priority <=> a.priority }
  end

end
