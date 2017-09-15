class UrlsController < ApplicationController
  def index
    @urls = Url.all
    @url = Url.new
  end

  def show
    @url = Url.find(params[:id])
  end

  def create
    @url = Url.new(url_params)
    @url.shorten
    if @url.save
        redirect_to @url
    else
        render 'new'
    end
  end

  def destroy
    @url = Url.find(params[:id])
    @url.destroy
    redirect_to urls_path
  end

  def short
    url = Url.find(params[:id])
    redirect_to url.long_url
  end


  private

  def url_params
    params.require(:url).permit(:long_url)
  end

end
