namespace :token do
  desc "Delete expired tokens"
  task clean_expired: :environment do
    puts "Deleting expired tokens from InvalidToken table..."
    InvalidToken.all.pluck(:token).each do |token|
      begin
        JsonWebToken.decode(token)
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        InvalidToken.find_by(token: token).destroy
      end
    end
  end
end
