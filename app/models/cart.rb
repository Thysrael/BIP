class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product)
    # 根据 product_id 查找 current_item
    current_item = line_items.find_by(product: product.id)

    if current_item
      # 查找到了，就数量增加 1
      current_item.quantity += 1
    else
      # 没查找到，就创建 line_item
      current_item = line_items.build(product_id: product.id)
    end
    # 返回 current_item
    current_item
  end

  def total_price
    line_items.to_a.sum {|item| item.total_price}
  end
end
