class ProductsController < ApplicationController
  before_action :destroy_all, only: :search

  def index
    @products = Product.page(params[:page]).per(100)
    # @products = Product.page(params[:page]).per(Product::PER)
  end

  def search
    if params[:service].to_i == 1
      Product.mercari(params[:name], params[:number])
      redirect_to products_path(keyword: params[:name], number: params[:number], service: params[:service])
    elsif params[:service].to_i == 2 then
      Product.yahoo_auction(params[:name], params[:number])
      redirect_to products_path(keyword: params[:name], number: params[:number], service: params[:service])
    end
  end

  private

  def destroy_all
    products = Product.all
    products.destroy_all
  end
end
