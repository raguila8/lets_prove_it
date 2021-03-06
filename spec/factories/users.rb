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

  factory :third_user, class: User do
    username "third_user"
    email "third@foobar.com"
    password "foobar"
  end

  factory :fourth_user, class: User do
    username "fourth_user"
    email "fourth@foobar.com"
    password "foobar"
  end

  factory :new_user, class: User do
    sequence(:username) { |n| "new_user#{n}" }
    sequence(:email) { |n| "new_user#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
  end
end
