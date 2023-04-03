class CreatePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :prompts do |t|
      t.references :product, null: false, foreign_key: true
      t.belongs_to :activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
