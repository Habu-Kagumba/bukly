FactoryGirl.define do
  factory :item do
    name { Faker::StarWars.character }
    done { Faker::Boolean.boolean }

    factory :bucket_item do
      transient do
        created_by nil
        bucket_id { create(:empty_bucket).id }
      end

      bucket { FactoryGirl.create(:empty_bucket, created_by: created_by) }

      factory :invalid_item do
        name nil
      end
    end
  end
end
