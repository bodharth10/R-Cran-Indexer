class PackagesController < ApplicationController
  def index
    @packages = Package.order(:name).page params[:page]

    if params[:q].present?
      @packages = Package.search(params[:q]).order(:name).page params[:page]
    end  
  end
end
