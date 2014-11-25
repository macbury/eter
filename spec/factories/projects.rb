FactoryGirl.define do
  factory :project do
    title { |n| "New project #{n}" }
  end
end
