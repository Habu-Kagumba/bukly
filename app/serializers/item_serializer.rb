class ItemSerializer < ActiveModel::Serializer
  include DateUtilities

  attributes :id, :name, :done, :date_created, :date_modified
end
