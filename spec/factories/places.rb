FactoryGirl.define do
  factory :place do
    name "Some subway station"
    address "Some address, 1"
    lat 74.3425
    lng 12.5111
    city
  end

  factory :invalid_place, class: 'Place' do
    name nil
    address nil
    lat nil
    lng nil
    city nil
  end
end
