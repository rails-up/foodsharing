FactoryGirl.define do
  factory :donation do
    title "MyString"
    description "MyText"
  end

  factory :invalid_donation, class: 'Donation' do
    title nil
    description nil
  end
end
