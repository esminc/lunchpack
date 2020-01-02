class Member < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :projects, through: :assignments
  has_and_belongs_to_many :lunches
  validates :email, uniqueness: true, allow_nil: true
  validates :handle_name, presence: true
  validates :real_name, presence: true
end
