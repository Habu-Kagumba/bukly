class AddBucketToItems < ActiveRecord::Migration
  def change
    add_reference :items, :bucket, index: true, foreign_key: true
  end
end
