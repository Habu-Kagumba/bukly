module JsonResponse
  extend ActiveSupport::Concern

  included do
    def render_json(data, status = "ok")
      render json: data, status: status.to_sym
    end
  end
end
