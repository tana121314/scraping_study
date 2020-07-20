class ProductsController < ApplicationController
  before_action :destroy_all, only: :mercari

  def index
    @products = Product.all
  end

  def mercari
    Product.scraping(params[:name])
    redirect_to products_path
  end

  private

  def destroy_all
    @products = Product.all
    @products.destroy_all
  end
end
