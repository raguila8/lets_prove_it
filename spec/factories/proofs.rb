FactoryBot.define do
  factory :proof do
    content "This is the proof's content..."
  end

  factory :other_proof, class: Proof do
    content "This is the other proof's content..."
  end
end
