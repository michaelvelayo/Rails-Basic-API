class CreateCharacters < ActiveRecord::Migration[6.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.belongs_to :anime
      t.belongs_to :role
      t.timestamps
    end
  end
end
