class Activity < ApplicationRecord
  has_many :prompts, dependent: :destroy

  def add_product(product)
    # 根据 product_id 查找 current_item
    current_item = prompts.find_by(product: product.id)

    if current_item
      # 查找到了，就啥都不干
    else
      # 没查找到，就创建 prompt
      current_item = prompts.build(product_id: product.id)
    end
    # 返回 current_item
    current_item
  end
end
