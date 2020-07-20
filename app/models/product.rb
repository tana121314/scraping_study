class Product < ApplicationRecord
  validates :name, presence: true

  def self.scraping(name)
    agent = Mechanize.new
    page = agent.get("https://www.mercari.com/jp/search/?keyword=#{name}")
    elements = page.search('section.items-box')
    elements.each do |element|
      name = element.search('h3.items-box-name')
      image = element.at('img')
      url = element.at('a')
      price = element.at('div.items-box-price')
      sold = element.at('div.item-sold-out-badge')
      Product.create(
        name: name.text,
        image_url: image.get_attribute('data-src'),
        product_url: url.get_attribute('href'),
        price: price.text,
        is_sold: sold.present? ? false : true
      )
    end
  end
end
