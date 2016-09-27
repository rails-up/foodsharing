FactoryGirl.define do
  sequence :title do |n|
    "Donation title test #{n}"
  end

  sequence :description do |n|
    "Donation description test #{n}"
  end

  factory :donation do
    title
    description
  end

  factory :invalid_donation, class: 'Donation' do
    title nil
    description nil
  end
end
