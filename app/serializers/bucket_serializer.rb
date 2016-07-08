class BucketSerializer < ActiveModel::Serializer
  include DateUtilities

  attributes :id, :name, :date_created, :date_modified, :created_by
  has_many :items, serializer: ItemSerializer
end
