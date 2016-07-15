RSpec.shared_examples "response_message" do |type, message, resource|
  it "responds with correct message" do
    expect(json.fetch(type)).
      to eql message(message, resource)
  end

  def message(message, resource = nil)
    if resource
      ExceptionMessages::Messages.send message.to_s, resource
    else
      ExceptionMessages::Messages.send message.to_s
    end
  end
end
