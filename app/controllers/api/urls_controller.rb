class Api::UrlsController < ApplicationController
    before_action :find_url, only: [:show, :redirect]
  
    def create
      url = Url.new(url_params)
      if url.save
        render json: { short_url: url.short_url, original_url: url.original_url }, status: :created
      else
        render json: { errors: url.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def index
      urls = Url.all
      render json: urls, status: :ok
    end
  
    def show
      render json: { original_url: @url.original_url, visits: @url.visits }, status: :ok
    end
  
    def redirect
      @url.increment!(:visits)
      redirect_to @url.original_url
    end
  
    private
  
    def find_url
      @url = Url.find_by!(short_url: params[:short_url])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'URL not found' }, status: :not_found
    end
  
    def url_params
      params.require(:url).permit(:original_url)
    end
  end
  