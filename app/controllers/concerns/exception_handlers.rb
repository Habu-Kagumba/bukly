module ExceptionHandlers
  extend ActiveSupport::Concern

  class NoBucketsError < StandardError; end
  class AccessDeniedError < StandardError; end
  class NotAuthenticatedError < StandardError; end
  class ExpiredSignatureError < StandardError; end

  included do
    rescue_from ExceptionHandlers::AccessDeniedError, with: :access_denied
    rescue_from ExceptionHandlers::NotAuthenticatedError, with: :access_denied
    rescue_from ExceptionHandlers::ExpiredSignatureError, with: :access_denied

    rescue_from ActiveRecord::RecordNotFound do |e|
      render_json({ errors: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render_json({ errors: e.message }, :unprocessable_entity)
    end

    rescue_from ExceptionHandlers::NoBucketsError do |e|
      render_json(errors: e.message)
    end
  end

  private

  def access_denied(e)
    render_json({ errors: e.message }, :unauthorized)
  end
end
