class PetSerializer < ActiveModel::Serializer
  type :pet
  attributes :id, :name, :dob
end
