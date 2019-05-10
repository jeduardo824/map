class CreateRoutes < ActiveRecord::Migration[5.2]
  def change
    create_table :routes do |t|
      t.string :initial_point
      t.string :final_point
      t.integer :distance
      t.references :map, foreign_key: true

      t.timestamps
    end
  end
end
