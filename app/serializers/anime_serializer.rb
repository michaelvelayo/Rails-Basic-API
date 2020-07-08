class AnimeSerializer < ActiveModel::Serializer
  attributes :english, :synonyms, :japanese, :sumarry, :episodes, :aired, :type
  has_many :genres, :through => :anime_genres, key: :genre
  has_many :characters

  def type
  	object.type.name
  end
end
