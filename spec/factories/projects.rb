FactoryGirl.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }

    factory :project_with_emails_to_invite do
      members_emails { (0..10).inject([]) { |out, index| out << Faker::Internet.email; out }.join(", ") }
    end
  end
end
