FactoryBot.define do
  factory :comment do
    content "This is the comment's content..."
  end

  factory :other_comment, class: Comment do
    content "This is the other comment's content..."
  end
end
