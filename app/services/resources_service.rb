class ResourcesService
  attr_reader :user, :bucket_id, :req

  def initialize(user, bucket_id = nil, req = nil)
    @bucket_id = bucket_id
    @user = user
    @req = req
  end

  def bucket(bucket_id)
    repo.find_bucket(bucket_id)
  rescue ActiveRecord::RecordNotFound => e
    raise e, ExceptionMessages::Messages.no_resource("Bucket")
  end

  def item(item_id)
    repo.find_item(item_id)
  rescue ActiveRecord::RecordNotFound => e
    raise e, ExceptionMessages::Messages.no_resource("Item")
  end

  def buckets
    all = search_buckets
    raise ExceptionHandlers::NoBucketsError, ExceptionMessages::Messages.
      no_resources("bucketlists") if all.blank?
    all
  end

  def items
    all = repo.all_items
    raise ExceptionHandlers::NoBucketsError,
          ExceptionMessages::Messages.no_resources("items") if all.blank?
    all
  end

  def create_bucket(bucket_params)
    repo.create_bucket(bucket_params)
  rescue ActiveRecord::RecordInvalid
    raise
  end

  def create_item(item_params)
    repo.create_item(item_params)
  rescue ActiveRecord::RecordInvalid
    raise
  end

  def update_bucket(bucket, bucket_params)
    repo.update_bucket(bucket.id, bucket_params)
  rescue ActiveRecord::RecordInvalid
    raise
  end

  def update_item(item_id, update_params)
    repo.update_item(item_id, update_params)
  rescue ActiveRecord::RecordInvalid
    raise
  end

  def destroy_bucket(bucket)
    repo.destroy_bucket(bucket.id)
  end

  def destroy_item(item_id)
    repo.destroy_item(item_id)
  end

  def page_headers
    paginate.set_pagination_headers
  end

  private

  def repo
    ResourcesRepo.new(user, bucket_id)
  end

  def paginate
    PaginationService.new(req, repo.all_buckets.count)
  end

  def search_buckets
    datum = req.query_parameters[:q]
    page_params = paginate.paginate_params

    repo.search(datum, page_params)
  end
end
