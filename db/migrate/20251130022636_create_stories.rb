class CreateStories < ActiveRecord::Migration[7.1]
  def change
    create_table :stories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.references :ai_generation, null: true, foreign_key: true

      t.string :title, null: false
      t.text :body, null: false
      t.date :generated_on, null: false

      t.timestamps
    end
  end
end
