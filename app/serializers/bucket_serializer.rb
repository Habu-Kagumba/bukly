class BucketSerializer < ActiveModel::Serializer
  include DateUtilities

  attributes :id, :name, :date_created, :date_modified
  has_many :items, serializer: ItemSerializer
end
