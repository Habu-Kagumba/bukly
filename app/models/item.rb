class Item < ActiveRecord::Base
  belongs_to :bucket

  validates :name,
            presence: true

  validates :done,
            inclusion: { in: [true, false] }
end
