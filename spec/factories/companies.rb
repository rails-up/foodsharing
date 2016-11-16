FactoryGirl.define do
  sequence :name do |n|
    "Company #{n}"
  end

  sequence :phone do |n|
    "123456789#{n}"
  end

  factory :company do
    name
    phone
    address 'Default city, 1st street, 10'
  end

  factory :invalid_company, class: 'Company' do
    name nil
    phone nil
    address nil
  end
end
