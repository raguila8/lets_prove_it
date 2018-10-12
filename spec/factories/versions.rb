FactoryBot.define do
  factory :version do
    title "This is the version's title"
    content "This is the version's content"
    description "This is the reason for creating this new version"
    version_number 1
  end

  factory :other_version, class: Version do
    title "This is the other version's title"
    content "This is the other version's content"
    description "This is the reason for creating this other version"
    version_number 2
  end

end
