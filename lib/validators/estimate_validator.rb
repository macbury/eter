class EstimateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.project
      unless record.project.point_values.include?(value)
        record.errors[attribute] << I18n.t("activerecord.errors.project_estimate")
      end
    end
  end
end
