require "rails_helper"

RSpec.describe "CheckIns", type: :request do
  let(:user) do
    User.create!(
      email_address: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  let(:habit) { Habit.create!(name: "Exercise") }

  before do
    post session_path, params: {
      email_address: user.email_address,
      password: "password123"
    }
  end

  let(:check_in) { habit.check_ins.create!(check_on: Date.today) }

describe "GET /check_ins/:id" do
  it "returns success" do
    get check_in_path(check_in)
    expect(response).to have_http_status(:success)
  end
end

describe "GET /check_ins/:id/edit" do
  it "returns success" do
    get edit_check_in_path(check_in)
    expect(response).to have_http_status(:success)
  end
end

describe "PATCH /check_ins/:id" do
  it "updates the check_in" do
    patch check_in_path(check_in), params: { check_in: { check_on: Date.yesterday } }
    expect(check_in.reload.check_on).to eq(Date.yesterday)
    expect(response).to redirect_to(check_in_path(check_in))
  end
end

describe "DELETE /check_ins/:id" do
  it "destroys the check_in" do
    check_in
    expect {
      delete check_in_path(check_in)
    }.to change(CheckIn, :count).by(-1)

    expect(response).to redirect_to(habit_path(habit))
  end
end

  describe "GET /habits/:habit_id/check_ins/new" do
    it "returns success" do
      get new_habit_check_in_path(habit)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /habits/:habit_id/check_ins" do
    it "creates a check_in" do
      expect {
        post habit_check_ins_path(habit), params: { check_in: { check_on: Date.today } }
      }.to change(CheckIn, :count).by(1)

      expect(response).to redirect_to(habit_path(habit))
    end

    it "does not create a check_in with invalid params" do
      expect {
        post habit_check_ins_path(habit), params: { check_in: { check_on: nil } }
      }.not_to change(CheckIn, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end