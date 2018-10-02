FactoryBot.define do
  factory :topic do
    name "algebra"
    description "This is a description that describes what algrebra is..."
  end

  factory :other_topic, class: Topic do
    name "other-user"
    description "This is a description that describes the other topic..."
  end
end
