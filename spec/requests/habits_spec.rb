require "rails_helper"

RSpec.describe "Habits", type: :request do
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

  describe "GET /habits" do
    it "returns success" do
      get habits_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /habits/:id" do
    it "returns success" do
      get habit_path(habit)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /habits/new" do
    it "returns success" do
      get new_habit_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /habits" do
    it "creates a habit" do
      expect {
        post habits_path, params: { habit: { name: "Read" } }
      }.to change(Habit, :count).by(1)

      expect(response).to redirect_to(habit_path(Habit.last))
    end

    it "does not create with invalid params" do
      expect {
        post habits_path, params: { habit: { name: "" } }
      }.not_to change(Habit, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /habits/:id" do
    it "updates the habit" do
      patch habit_path(habit), params: { habit: { name: "Run" } }
      expect(habit.reload.name).to eq("Run")
      expect(response).to redirect_to(habit_path(habit))
    end
  end

  describe "DELETE /habits/:id" do
    it "destroys the habit" do
      habit
      expect {
        delete habit_path(habit)
      }.to change(Habit, :count).by(-1)

      expect(response).to redirect_to(habits_path)
    end
  end

  describe "GET /habits.json" do
    it "returns habits as JSON" do
      habit
      get habits_path(format: :json)
  
      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq("application/json")
  
      json = JSON.parse(response.body)
      expect(json.first["name"]).to eq("Exercise")
    end
  end
end