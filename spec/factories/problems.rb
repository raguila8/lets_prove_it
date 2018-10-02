FactoryBot.define do
  factory :problem do
    title "Prove that 1 + 1 = 2"
    content "This is the problem's content..."
    cached_proofs_count 0
  end

  factory :other_problem, class: Problem do
    title "Other Problem"
    content "This is the other problem's content..."
  end
end
