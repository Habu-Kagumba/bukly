FactoryGirl.define do
  factory :bucket do
    name { FFaker::CheesyLingo.title }

    items do
      [].tap do |items|
        2.times { items << create(:item) }
      end
    end

    factory :invalid_bucket do
      name nil
    end

    factory :empty_bucket do
      items []
    end
  end
end
