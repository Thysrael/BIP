class LineItem < ApplicationRecord
  belongs_to :product
  # optional 表示外键可以为空
  belongs_to :cart, optional: true
  belongs_to :order, optional: true

  def total_price
    product.getDiscountPrice * quantity
  end
end
