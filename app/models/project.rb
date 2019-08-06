class Project < ApplicationRecord
  has_many :assignment
  has_many :members, through: :assignment
end
