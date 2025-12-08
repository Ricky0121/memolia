class AddSavedToPeriodStories < ActiveRecord::Migration[7.1]
  def change
    add_column :period_stories, :saved, :boolean, null: false, default: false
    add_index  :period_stories, :saved
  end
end
