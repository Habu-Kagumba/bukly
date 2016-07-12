require "rails_helper"

RSpec.describe StaticController, type: :controller do
  describe "Get the root page" do
    it "should render the root page" do
      get :home

      should render_template("static/home")
      should respond_with(200)
      should route(:get, "/").to(action: :home)
    end
  end
end
