class SearchProjectSense < BaseSense

  def initialize(context, project)
    super(context)
    @project = project
  end

  def priority
    1
  end

  def valid?
    true
  end

  def payload
    { title: @project.title }
  end

  def self.build_for_context!(context)
    @projects = Project.where("title LIKE :name AND id IN (:project_ids)", name: context.query+"%", project_ids: context.current_user.project_ids).limit(5)
    sense     = CreateProjectSense.new(context)
    @projects.map do |project|
      SearchProjectSense.new(context, project)
    end
  end

end
