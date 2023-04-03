class Product < ApplicationRecord
  # 对属性的检验
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {:greater_than_or_equal_to => 0.01}
  validates :title, uniqueness: true
  validates :image_url, format: {
    :with => %r{\.(gif|jpg|png)}i,
    :message => 'must be a URL for GIF, JPG or PNG image.'
  }

  # 与 line_item 关系
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  has_many :favor_items
  before_destroy :ensure_not_referenced_by_any_favor_item
  has_many :prompts, dependent: :destroy

  def getDiscountPrice
    discount = price
    prompts.each do |prompt|
      discount *= (prompt.activity.discount / 100.0)
    end
    discount
  end

  private
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort
    end
  end

  def ensure_not_referenced_by_any_favor_item
    unless favor_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort
    end
  end
end
