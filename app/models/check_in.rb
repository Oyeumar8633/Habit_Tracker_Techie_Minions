class CheckIn < ApplicationRecord
  belongs_to :habit
  validates :check_on, presence: true
end
