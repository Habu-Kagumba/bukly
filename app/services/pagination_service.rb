class PaginationService
  attr_reader :request, :count

  def initialize(request, count)
    @request = request
    @count = count
  end

  def paginate_params
    offset = (page - 1) * limit
    { limit: limit, offset: offset }
  end

  def set_pagination_headers
    page_links = []
    link_params.each do |k, v|
      new_params = req_params.merge(page: v)
      page_links << "<#{url_without_params}?#{new_params.to_param}>;"\
        " rel=\"#{k}\""
    end
    page_links.join(", ")
  end

  private

  def req_params
    request.query_parameters
  end

  def original_url
    request.original_url
  end

  def url_without_params
    url = original_url.slice(
      0..(original_url.index("?") - 1)
    ) unless req_params.empty?
    url || original_url
  end

  def page
    page = req_params.fetch(:page, 1).to_i
    page == 0 ? 1 : page
  end

  def limit
    limit = req_params.fetch(:limit, 20).to_i
    page_limit = (limit <= 0 || limit > 100) ? 20 : limit
    page_limit
  end

  def link_params
    buckets_size = count == 0 ? 1 : count
    pages = buckets_size.fdiv(limit).ceil
    pager = {}
    pager[:first] = 1
    pager[:last] = pages
    pager[:next] = page + 1 unless page >= pages
    pager[:prev] = page - 1 unless page == 1
    pager
  end
end
