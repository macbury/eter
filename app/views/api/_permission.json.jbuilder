json.permission do
  [:edit, :new, :create, :update, :index, :show, :destroy].each do |permission|
    json.set!(permission, can?(permission, resource)) 
  end
end
