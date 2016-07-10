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

    def self.access_denied
      "Access denied. Invalid credentials"
    end

    def self.token_invalid
      "Access Denied. Invalid token"
    end

    def self.missing_token
      "Access Denied. Missing token"
    end

    def self.expired_sig
      "Authentication failed. Expired token"
    end

    def self.not_auth
      "Not authorized. Please Login"
    end

    def self.logged_in
      "Successfully logged in"
    end

    def self.logged_out
      "Successfully logged out"
    end

    def self.create_user
      "Successfully created user."
    end
  end
end
