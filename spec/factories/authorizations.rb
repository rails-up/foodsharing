FactoryGirl.define do
  factory :authorization do
    user
    provider "vkontakte"
    uid "abcd"
  end
end
