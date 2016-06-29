class Bucket < ActiveRecord::Base
  has_many :items, dependent: :destroy

  validates :name,
            presence: true

  scope :paginate, -> (pager) { limit(pager[:limit]).offset(pager[:offset]) }

  scope :search, -> (datum) { where("name ILIKE ?", "%#{datum}%") }
end
