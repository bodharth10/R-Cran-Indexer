class PackagesController < ApplicationController
  def index
    @packages = Package.all

    if params[:q].present?
      @packages = Package.search(params[:q])
    end
  end
end
