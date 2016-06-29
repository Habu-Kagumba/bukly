class ResourcesService
  def initialize(bucket_id = nil)
    @bucket_id = bucket_id
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

  def buckets(params)
    all = search_buckets(params)
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

  private

  def repo
    ResourcesRepo.new(@bucket_id)
  end

  def paginate_params(params)
    limit = params[:limit].to_i or 20
    page_limit = ( limit <= 0 or limit > 100 ) ? 20 : limit
    offset = params[:page].to_i || 0
    { limit: page_limit, offset: offset }
  end

  def search_buckets(params)
    datum = params[:q]
    page_params = paginate_params(params)

    repo.search(datum, page_params)
  end
end
