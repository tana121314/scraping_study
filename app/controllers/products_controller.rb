class ProductsController < ApplicationController
  before_action :destroy_all, only: :mercari

  def index
    @products = Product.page(params[:page]).per(Product::PER)
  end

  def mercari
    Product.scraping(params[:name], params[:number])
    redirect_to products_path
  end

  private

  def destroy_all
    @products = Product.all
    @products.destroy_all
  end
end
