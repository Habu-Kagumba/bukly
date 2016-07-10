class User < ActiveRecord::Base
  has_many :buckets, foreign_key: :created_by
  has_many :invalid_tokens
  before_save do
    self.email = email.downcase
  end

  validates :email,
            uniqueness: { case_sensitive: false },
            presence: true,
            format: { with: /@/ }

  validates :password, presence: true

  has_secure_password
end
