json.array!(@projects) do |project|
  json.extract! project, :id, :title, :members_ids
  json.url project_url(project, format: :json)
end
