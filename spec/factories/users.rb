FactoryGirl.define do
  factory :user do
    email { |n| "test#{n}@localhost.local" }
    password "admin1234"
    password_confirmation "admin1234"
  end

end
