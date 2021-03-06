class ResourcesRepo
  attr_reader :user, :bucket_id

  def initialize(user, bucket_id = nil)
    @user = user
    @bucket_id = bucket_id
  end

  def find_bucket(id)
    Bucket.where(created_by: user.id).find(id)
  end

  def find_item(id)
    find_bucket(bucket_id).items.find(id)
  end

  def all_buckets
    Bucket.where(created_by: user.id)
  end

  def all_items
    find_bucket(bucket_id).items
  end

  def create_bucket(params)
    Bucket.create!(params.merge(created_by: user.id))
  end

  def create_item(params)
    find_bucket(bucket_id).items.create!(params)
  end

  def update_bucket(id, params)
    find_bucket(id).tap do |bucket|
      bucket.update!(params)
    end
  end

  def update_item(id, params)
    find_item(id).update!(params)
  end

  def destroy_bucket(id)
    find_bucket(id).destroy
  end

  def destroy_item(id)
    find_item(id).destroy
  end

  def search(datum, page_params)
    Bucket.search(datum).paginate(page_params).where(created_by: user.id)
  end
end
