class DashboardSense < BaseSense
  GOTO_PROJECT_ACTION   = "goto_dashboard_action"

  def process
    target = I18n.t("senses.goto_dashboard_action.query").select { |query| query =~ /^#{context.query}.+/i }.first
    if target && context.have_project?
      goto_dashboard(target)
    end
  end

  protected

  def goto_dashboard(target)
    action = SenseAction.new(GOTO_PROJECT_ACTION)
    action.redirect_to(:projects, {})
    action.priority    = :high
    push(action)
  end

end
