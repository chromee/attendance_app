class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :soukai_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
