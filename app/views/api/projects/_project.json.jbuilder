json.extract! project, :id, :title, :color_hex, :updated_at
json.activity 10.times.map { |i| (rand * 10 ).round }
json.members do
  json.partial! partial: 'api/users/user', collection: project.users, as: :user
end

json.permission do
  [:edit, :destroy, :show].each do |permission|
    json.set!(permission, can?(permission, project))
  end
end
