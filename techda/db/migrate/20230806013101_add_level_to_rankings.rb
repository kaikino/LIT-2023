class AddLevelToRankings < ActiveRecord::Migration[7.0]
  def change
    add_column :rankings, :level, :integer
  end
end
