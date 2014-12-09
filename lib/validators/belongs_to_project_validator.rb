class BelongsToProjectValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if record.project && !value.nil?
      user = User.find(value)
      unless Project.by_user(user).where(id: record.project_id).count > 0
        record.errors[attribute] << I18n.t("activerecord.errors.user_not_in_project")
      end
    end
  end
end
