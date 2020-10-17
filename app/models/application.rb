class Application < ApplicationRecord
  belongs_to :user
  has_many :application_pets
  has_many :pets, through: :application_pets
  enum status: [:in_progress, :pending, :accepted, :rejected]

  def user_name
    user.name
  end

  def full_address
    "#{user.address}, #{user.city}, #{user.state} #{user.zip}"
  end

  def pet_names
    pets.pluck(:name)
  end
end