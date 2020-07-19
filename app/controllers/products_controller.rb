class ProductsController < ApplicationController
  before_action :destroy_all, only: :mercari

  def index
    @products = Product.all
  end

  def mercari
    agent = Mechanize.new
    page = agent.get("https://www.mercari.com/jp/search/?keyword=#{params[:name]}")
    # 商品名を取得し、nameカラムに入れる
    @elements = page.search('section.items-box')
    @elements.each do |element|
      @name = element.search('h3.items-box-name')
      @image = element.at('img')
      @price = element.at('div.items-box-price')
      # @sold = element.at('div.item-sold-out-badge')
      # インスタンス作成
      @product = Product.new
      @product.name = @name.text
      @product.image_url = @image.get_attribute('data-src')
      @product.price = @price.text
      @product.save
    end
    redirect_to products_path
  end

  private

  def destroy_all
    @product = Product.all
    @product.destroy_all
  end
end
