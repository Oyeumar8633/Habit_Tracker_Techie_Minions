class CreateCheckIns < ActiveRecord::Migration[8.1]
  def change
    create_table :check_ins do |t|
      t.date :check_on
      t.references :habit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
