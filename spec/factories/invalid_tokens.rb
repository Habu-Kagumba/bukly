FactoryGirl.define do
  factory :invalid_token do
    token { Faker::Bitcoin.address }
  end
end
