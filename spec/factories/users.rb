FactoryGirl.define do
  sequence :full_name do |n|
    "User name #{n}"
  end

  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    full_name
    email
    password '12345678'
    # password_confirmation { |user| user.password }
    password_confirmation(&:password)
    confirmed_at Time.zone.now
  end
end
