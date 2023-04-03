class User < ApplicationRecord
  enum role: {
    "Buyer" => 0,
    "Admin" => 1
  }

  validates :name, presence: true, uniqueness: true
  validates :role, presence: true
  validates :role, inclusion: roles.keys
  has_secure_password

  has_many :favor_items, dependent: :destroy
  def add_product(product)
    # 根据 product_id 查找 current_item
    current_item = favor_items.find_by(product: product.id)

    if current_item
      # 查找到了，就数量增加 1，就啥都不干
    else
      # 没查找到，就创建 line_item
      current_item = favor_items.build(product_id: product.id)
    end
    # 返回 current_item
    current_item
  end
end
