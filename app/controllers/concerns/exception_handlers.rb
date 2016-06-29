module ExceptionHandlers
  extend ActiveSupport::Concern

  class NoBucketsError < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render_json({ errors: e.message }, "not_found")
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render_json({ errors: e.message }, "unprocessable_entity")
    end

    rescue_from ExceptionHandlers::NoBucketsError do |e|
      render_json(errors: e.message)
    end
  end
end
