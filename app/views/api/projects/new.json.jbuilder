json.project do
  json.extract! @project, :title, :point_scale, :start_date, :iteration_start_day, :iteration_length, :default_velocity, :members_emails
end
json.point_scales Project::POINT_SCALES.keys
json.iteration_length Project::ITERATION_LENGTH_RANGE.to_a
json.iteration_start_day (0..6).to_a
