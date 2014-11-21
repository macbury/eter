module FormHelper

  def veritical_center_panel(title, &block)
    render partial: "shared/vertical_center_panel", locals: { panel_title: title, block: block }
  end

end
