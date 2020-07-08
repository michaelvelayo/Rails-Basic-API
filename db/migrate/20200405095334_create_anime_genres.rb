class CreateAnimeGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :anime_genres do |t|
      t.belongs_to :anime
      t.belongs_to :genre
      t.timestamps
    end
  end
end
