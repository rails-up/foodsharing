FactoryGirl.define do

  factory :city do
    sequence(:name) { |n| "City #{n}" }
  end
end
