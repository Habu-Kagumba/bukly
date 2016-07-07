class AddUserToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :created_by, :integer
  end
end
