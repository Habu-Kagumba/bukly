FactoryGirl.define do
  factory :item do
    name { FFaker::Movie.title }
    done { FFaker::Boolean.random }
  end
end
