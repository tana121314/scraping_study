class Product < ApplicationRecord

  # メルカリ
  def self.mercari(keyword, number)
    agent = Mechanize.new

    # 100ページあるため取得ページ数を任意で指定
    (1..number.to_i).each do |i|
      page = agent.get("https://www.mercari.com/jp/search/?page=#{i}&keyword=#{keyword}")
      elements = page.search('section.items-box')

      # 1ページ単位での商品情報取得
      elements.each do |element|
        name = element.search('h3.items-box-name').text
        image = element.at('img').get_attribute('data-src')
        url = element.at('a').get_attribute('href')
        price = element.at('div.items-box-price').text
        sold = element.at('div.item-sold-out-badge')
        Product.create(
          name: name,
          image_url: image,
          product_url: url,
          price: price,
          is_sold: sold.present? ? false : true,
          service: 0
        )
      end
    end
  end

  # ヤフオク
  def self.yahoo_auction(keyword, number)
    agent = Mechanize.new

    # 取得ページ数を任意で指定
    (1..number.to_i).each do |i|
      page = agent.get("https://auctions.yahoo.co.jp/search/search?p=#{keyword}&b=#{((i - 1) * 50) + 1}&n=50")
      elements = page.search('li.Product')

      # 1ページ単位での商品情報取得
      elements.each do |element|
        name = element.search('a.Product__titleLink').text
        image = element.at('img.Product__imageData').get_attribute('src')
        url = element.at('a.Product__imageLink').get_attribute('href')
        price = element.at('span.Product__priceValue').text
        summary_price = element.search('span.Product__priceValue')
        remaining_time = element.at('span.Product__time').text
        bid_number = element.at('span.Product__bid').text
        shipping = element.at('span.Product__icon--freeShipping')
        sold = element.at('span.Product__time')
        attention = element.at('span.Product__icon--attention')

        # 1ページ目に「注目度top3の商品」が3点表示されるため省く
        if attention.blank?
          Product.create(
            name: name,                                                             # 商品名
            image_url: image,                                                       # 画像URL
            product_url: url,                                                       # 商品URL
            price: price,                                                           # 価格
            summary_price: summary_price.length == 1 ? nil : summary_price[1].text, # 即決価格
            remaining_time: remaining_time,                                         # 残り時間
            bid_number: bid_number,                                                 # 入札数
            shipping: shipping.present? ? true : false,                             # 送料無料
            is_sold: 1,                                                             # 売り切れ
            service: 1                                                              # メルカリかヤフオク）
          )
        end
      end
    end
  end
end
