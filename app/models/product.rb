class Product < ApplicationRecord

  PER = 132

  def self.scraping(keyword, number)
    agent = Mechanize.new

    # 100ページあるため取得ページ数を任意で指定
    (1..number.to_i).each do |i|
      page = agent.get("https://www.mercari.com/jp/search/?page=#{i}&keyword=#{keyword}")
      elements = page.search('section.items-box')

      # 1ページ単位での商品情報取得
      elements.each.with_index(((i - 1) * PER) + 1) do |element, i|
        name = element.search('h3.items-box-name').text
        image = element.at('img').get_attribute('data-src')
        url = element.at('a').get_attribute('href')
        price = element.at('div.items-box-price').text
        sold = element.at('div.item-sold-out-badge')
        Product.create(
          product_id: i,
          name: name,
          image_url: image,
          product_url: url,
          price: price,
          is_sold: sold.present? ? false : true
        )
      end
    end
  end
end
