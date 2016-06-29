class ResourcesRepo
  def initialize(bucket_id = nil)
    @bucket_id = bucket_id
  end

  def find_bucket(id)
    Bucket.find(id)
  end

  def find_item(id)
    find_bucket(@bucket_id).items.find(id)
  end

  def all_buckets
    Bucket.all
  end

  def all_items
    find_bucket(@bucket_id).items
  end

  def create_bucket(params)
    Bucket.create!(params)
  end

  def create_item(params)
    find_bucket(@bucket_id).items.create!(params)
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
    Bucket.search(datum).paginate(page_params)
  end
end
