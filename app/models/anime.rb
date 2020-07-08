class Anime < ApplicationRecord
  belongs_to :type
  has_many :anime_genres
  has_many :genres, :through => :anime_genres
  has_many :characters
end
