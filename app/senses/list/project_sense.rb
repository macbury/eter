class ProjectSense < BaseSense
  CREATE_PROJECT_ACTION = "create_project_action"
  GOTO_PROJECT_ACTION   = "goto_project_action"
  EDIT_PROJECT_ACTION   = "edit_project_action"

  def process
    @goto_exact_match = false
    propose_to_go_to_projects
    propose_to_edit_project
    if !@goto_exact_match
      propose_to_create_project
    end
  end

  protected

    def propose_to_edit_project
      target = I18n.t("senses.edit_project_action.query").select { |query| context.query =~ /^#{query}.+/i }.first

      if target
        query            = context.query.gsub(/^#{target}/i, "").strip
        projects_to_edit = Project.by_user(context.current_user).by_title(query).all
        projects_to_edit.each do |project|
          next if context.cannot?(:edit, project)

          action             = SenseAction.new(EDIT_PROJECT_ACTION)
          action.put_extra(:title, project.title)
          action.redirect_to(:edit_project, project_id: project.id)
          action.priority    = :normal
          action.description = project.title
          action.priority    = :high if project == context.current_project
          push(action)
        end
      end
    end

    def propose_to_go_to_projects
      projects_go_to = Project.by_user(context.current_user).by_title(context.query).except_project(context.current_project)
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
      push(action) unless context.have_project?
    end

end
