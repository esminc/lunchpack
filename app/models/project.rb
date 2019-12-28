class Project < ApplicationRecord
  has_many :assignment, dependent: :destroy
  has_many :members, through: :assignment

  validates :name, presence: true
end
