class UrlsController < ApplicationController
  def index
    @urls =Url.all
  end

  def show
    @url = Url.find(params[:id])
  end
end
