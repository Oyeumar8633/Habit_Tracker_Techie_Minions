class Habit < ApplicationRecord
    has_many :check_ins, dependent: :destroy
    # Mein ab validation dal raha takay meri app me exeec rspec execute hojaye
    validates :name, presence: true
end
