class CharacterSerializer < ActiveModel::Serializer
  attributes :name, :role
  belongs_to :anime
  def role
  	object.role.name
  end
end
