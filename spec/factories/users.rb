FactoryBot.define do
  factory :user do
    username "raguila8"
    email "email@example.com"
    password "foobar"
  end

  factory :other_user, class: User do
    username "other_user"
    email "other_user@example.com"
    password "foobar"
  end
end
