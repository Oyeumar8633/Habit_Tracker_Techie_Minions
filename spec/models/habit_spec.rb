require "rails_helper"

RSpec.describe Habit, type: :model do
  it "is invalid without a name" do
    habit = Habit.new(name: nil)
    expect(habit).not_to be_valid
  end

  it "is valid with a name" do
    habit = Habit.new(name: "Exercise")
    expect(habit).to be_valid
  end

  it "has many check_ins" do
    association = Habit.reflect_on_association(:check_ins)
    expect(association.macro).to eq(:has_many)
  end
end