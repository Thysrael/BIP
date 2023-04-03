class AddDiscountToActivity < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :discount, :integer
  end
end
