FactoryBot.define do
  factory :report do
    status "pending"
  end

  factory :random_report, class: Report do
    status "pending"
    reason Faker::Lorem.paragraph
  end
end
