class ProjectSense < BaseSense
  CREATE_PROJECT_ACTION = "create_project_action"
  GOTO_PROJECT_ACTION   = "goto_project_action"
  def process
    @goto_exact_match = false
    propose_to_go_to_projects

    if context.have_project?
      propose_to_edit_project
    elsif !@goto_exact_match
      propose_to_create_project
    end
  end

  protected

    def propose_to_edit_project

    end

    def propose_to_go_to_projects
      projects_go_to = context.current_user.projects.by_title(context.query).except_project(context.current_project)
      projects_go_to.each do |project|
        action = SenseAction.new(GOTO_PROJECT_ACTION)
        action.put_extra(:title, project.title)
        action.redirect_to(:project, project_id: project.id)
        action.priority    = :normal
        action.description = project.title

        if context.query.match(/#{Regexp.escape(project.title)}/i)
          @goto_exact_match = true
        end

        push(action)
      end
    end

    def propose_to_create_project
      action = SenseAction.new(CREATE_PROJECT_ACTION)
      action.put_extra(:title, context.query)
      action.priority    = :low
      action.description = context.query
      push(action)
    end

end
