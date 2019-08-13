class Member < ApplicationRecord
  has_many :assignments
  has_many :projects, through: :assignments
  has_and_belongs_to_many :lunches
end
