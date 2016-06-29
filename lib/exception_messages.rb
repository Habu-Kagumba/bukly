module ExceptionMessages
  class Messages
    def self.no_resources(resources)
      "No #{resources} found"
    end

    def self.no_resource(resource)
      "#{resource} not found"
    end

    def self.not_found
      "Invalid route, please refer to the API docs for available routes"
    end
  end
end
