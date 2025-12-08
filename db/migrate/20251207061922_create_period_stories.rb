class CreatePeriodStories < ActiveRecord::Migration[7.1]
  def change
    create_table :period_stories do |t|
      t.references :user,          null: false, foreign_key: true
      t.references :ai_generation, null: false, foreign_key: true

      t.string  :title, null: false
      t.text    :body,  null: false

      t.date    :period_start_on, null: false
      t.date    :period_end_on,   null: false

      t.integer :period_type, null: false, default: 0

      t.timestamps
    end
  end
end
