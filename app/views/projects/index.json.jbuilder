json.array!(@projects) do |project|
  json.extract! project, :id, :title, :slug
  json.url project_url(project, format: :json)
end
