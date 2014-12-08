json.array!(@projects) do |project|
  json.extract! project, :id, :title, :color_hex
  json.members do
    json.partial! partial: 'api/users/user', collection: project.users, as: :user
  end

end
