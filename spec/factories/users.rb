FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Eug#{n}" }
    sequence(:last_name) { |n| "Niusz#{n}" }
    sequence(:email) { |n| "test#{n}@localhost.local" }
    password "admin1234"
    password_confirmation "admin1234"

    factory :admin do
      factory :admin_with_projects do
        after(:create) do |user, evaluator|
          projects = create_list(:project, 5)

          projects.each do |project|
            user.add_role(:master, project)
          end
        end
      end

      after(:create) do |user, evaluator|
        user.add_role(:admin)
      end
    end

    factory :user_with_projects do
      after(:create) do |user, evaluator|
        projects = create_list(:project, 5)

        projects.each do |project|
          user.add_role(:master, project)
        end
      end
    end
  end


end
