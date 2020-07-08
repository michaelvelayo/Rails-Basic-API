class CreateAnimes < ActiveRecord::Migration[6.0]
  def change
    create_table :animes do |t|
      t.string :english
      t.string :synonyms
      t.string :japanese
      t.text :sumarry
      t.integer :episodes
      t.belongs_to :type
      t.string :aired
      t.timestamps
    end
  end
end
