class GenreSerializer < ActiveModel::Serializer
  attributes :type

  def type
  	object.name
  end
end
