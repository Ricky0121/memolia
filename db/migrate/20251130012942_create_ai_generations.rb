class CreateAiGenerations < ActiveRecord::Migration[7.1]
  def change
    create_table :ai_generations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.string  :model, null: false
      t.text    :prompt, null: false
      t.text    :response
      t.integer :status, null: false, default: 0
      t.text    :error_message

      t.integer :prompt_tokens
      t.integer :completion_tokens
      t.integer :total_tokens

      t.timestamps
    end
  end
end
