FactoryGirl.define do
  factory :item do
    name { FFaker::Movie.title }
    done { FFaker::Boolean.random }

    factory :invalid_item do
      name nil
    end

    factory :bucket_item do
      transient do
        bucket_id { create(:empty_bucket).id }
      end

      bucket { FactoryGirl.create(:empty_bucket) }
    end
  end
end
