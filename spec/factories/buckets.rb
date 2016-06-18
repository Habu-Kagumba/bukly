FactoryGirl.define do
  factory :bucket do
    name { FFaker::CheesyLingo.title }

    items do
      [].tap do |items|
        2.times { items << create(:item) }
      end
    end
  end
end
