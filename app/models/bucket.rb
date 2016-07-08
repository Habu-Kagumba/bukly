class Bucket < ActiveRecord::Base
  has_many :items, dependent: :destroy
  belongs_to :user, foreign_key: :created_by

  validates :name, :created_by,
            presence: true

  scope :paginate, -> (pager) { limit(pager[:limit]).offset(pager[:offset]) }

  scope :search, -> (datum) { where("name ILIKE ?", "%#{datum}%") }
end
