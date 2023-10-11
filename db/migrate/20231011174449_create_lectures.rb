class CreateLectures < ActiveRecord::Migration[7.0]
  def change
    create_table :lectures do |t|
      t.string :title
      t.integer :duration

      t.timestamps
    end
  end
end
