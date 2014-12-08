FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| Faker::Name.first_name }
    sequence(:last_name) { |n| Faker::Name.last_name }
    sequence(:email) { |n| Faker::Internet.email  }
    password "admin1234"
    password_confirmation "admin1234"

    factory :admin do
      admin true
      factory :admin_with_projects do
        after(:create) do |user, evaluator|
          projects = create_list(:project, 5)

          projects.each do |project|
            user.add_role(:master, project)
          end
        end
      end
    end

    factory :user_with_projects do
      admin false
      after(:create) do |user, evaluator|
        projects = create_list(:project, 5)

        projects.each do |project|
          user.add_role(:master, project)
        end
      end
    end
  end


end
