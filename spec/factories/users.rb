FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.safe_email }
    password { FFaker::Internet.password }

    factory :logged_in_user do
      logged_in true
    end
  end
end
