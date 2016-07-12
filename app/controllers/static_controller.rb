class StaticController < ApplicationController
  before_action :authenticate_request, except: :home

  def home
    render "static/home"
  end
end
