require "rails_helper"

RSpec.describe CheckIn, type: :model do
  it "is invalid without check_on" do
    habit = Habit.create!(name: "Exercise")
    check_in = CheckIn.new(check_on: nil, habit: habit)
    expect(check_in).not_to be_valid
  end

  it "is valid with check_on and a habit" do
    habit = Habit.create!(name: "Exercise")
    check_in = CheckIn.new(check_on: Date.today, habit: habit)
    expect(check_in).to be_valid
  end

  it "belongs to a habit" do
    association = CheckIn.reflect_on_association(:habit)
    expect(association.macro).to eq(:belongs_to)
  end
end