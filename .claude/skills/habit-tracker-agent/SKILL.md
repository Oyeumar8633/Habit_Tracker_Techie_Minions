---
name: habit-tracker-agent
description: Build, extend, or rebuild the Habit Tracker correctly. Use for scaffolding nested check-ins, adding auth, validations, tests, or extending features. Teaches the exact playbook for models, routing, controllers, views, and testing.
---

# Habit Tracker Agent Playbook

This skill teaches the exact architecture and conventions for building/extending the Habit Tracker Rails app. Use this when asked to: scaffold, nest, rebuild, add auth, add validations, add tests, or extend features.

## 1. App Shape

**Models:**
- `Habit` (name:string)
- `CheckIn` (check_on:date, habit:references)

**Associations (must add manually to model files):**
```ruby
# app/models/habit.rb
class Habit < ApplicationRecord
  has_many :check_ins, dependent: :destroy
  validates :name, presence: true
end

# app/models/check_in.rb
class CheckIn < ApplicationRecord
  belongs_to :habit
  validates :check_on, presence: true
end
```

## 2. Nested Routing (Required)

Never use flat `resources :check_ins`. Always nest new/create under habits.

```ruby
# config/routes.rb
root "habits#index"

resources :habits do
  resources :check_ins, only: [:new, :create]
end

resources :check_ins, only: [:show, :edit, :update, :destroy]
```

**Why:** new/create must know which habit they belong to. Show/edit/update/destroy are standalone because you have the check_in id.

## 3. Controller Rules

### CheckInsController

**new/create actions (nested under habits):**
```ruby
def new
  @habit = Habit.find(params[:habit_id])
  @check_in = @habit.check_ins.new
end

def create
  @habit = Habit.find(params[:habit_id])
  @check_in = @habit.check_ins.new(check_in_params)
  if @check_in.save
    redirect_to @habit, notice: "Check-in recorded."
  else
    render :new, status: :unprocessable_entity
  end
end
```

**show/edit/update/destroy actions (standalone):**
```ruby
before_action :set_check_in, only: [:show, :edit, :update, :destroy]

def show
end

def edit
end

def update
  if @check_in.update(check_in_params)
    redirect_to @check_in
  else
    render :edit, status: :unprocessable_content
  end
end

def destroy
  habit = @check_in.habit
  @check_in.destroy!
  redirect_to habit_path(habit)
end

private

def set_check_in
  @check_in = CheckIn.find(params[:id])
end
```

**Strong params (critical):**
```ruby
def check_in_params
  params.expect(check_in: [:check_on])
end
```

Never include `:habit_id` in strong params. The habit comes from the URL.

**Instance variable rule:** Always use `@habit` (singular), never `@habits`.

## 4. Views

### habits/show.html.erb
- List all check_ins for this habit
- Link to new check_in form
```erb
<div>
  <%= link_to "New check-in", new_habit_check_in_path(@habit) %>
</div>

<div>
  <% @habit.check_ins.each do |check_in| %>
    <div>
      <%= link_to check_in.check_on, check_in_path(check_in) %>
    </div>
  <% end %>
</div>
```

### check_ins/_form.html.erb
- Use conditional path (handles both nested new/create and standalone edit/update)
- No habit_id field on the form
```erb
<%= form_with(model: (@habit ? [@habit, check_in] : check_in)) do |form| %>
  <% if check_in.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(check_in.errors.count, "error") %></h2>
      <ul>
        <% check_in.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div>
    <%= form.label :check_on %>
    <%= form.date_field :check_on %>
  </div>

  <div>
    <%= form.submit %>
  </div>
<% end %>
```

### check_ins/new.html.erb, check_ins/edit.html.erb
- Render the form
- Back link uses `habit_path(@check_in.habit)` or `habit_path(@habit)` depending on context

### Path replacements
- Replace all `check_ins_path` with `habit_path(...)`
- Replace all `check_in_path(check_in)` with `habit_path(check_in.habit)` when listing from habit
- Nested forms/links use: `new_habit_check_in_path(@habit)`, `habit_check_ins_path(@habit)`

## 5. Authentication (Rails 8)

**Setup:**
```bash
bundle add bcrypt
rails generate authentication
```

This generates User model, SessionsController, authentication helpers.

**ApplicationController:**
```ruby
class ApplicationController < ActionController::Base
  include Authentication
end
```

The `include Authentication` adds `require_authentication` as a before_action helper—no need to manually add it unless you want to protect specific controller actions.

**Session routes:**
```ruby
resource :session
resources :passwords, param: :token
```

## 6. Validations + Tests

### Model Validations

**Habit:**
```ruby
validates :name, presence: true
```

**CheckIn:**
```ruby
validates :check_on, presence: true
```

### Testing Approach (RSpec)

**Red → Green:** Write the failing test first, then add the validation.

**Model specs** (spec/models/):
```ruby
# spec/models/check_in_spec.rb
describe CheckIn do
  it "requires check_on" do
    check_in = CheckIn.new(check_on: nil)
    expect(check_in).not_to be_valid
  end
end
```

**Request specs** (spec/requests/):
- Test nested new/create under /habits/:habit_id/check_ins
- Test standalone show/edit/update/destroy
- Assert both HTTP response AND database changes
```ruby
# spec/requests/check_ins_spec.rb
describe "CheckIns" do
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

  describe "POST /habits/:habit_id/check_ins" do
    it "creates a check-in" do
      expect {
        post habit_check_ins_path(habit), params: { check_in: { check_on: Date.today } }
      }.to change(CheckIn, :count).by(1)
      expect(response).to redirect_to(habit_path(habit))
    end

    it "does not create with invalid params" do
      expect {
        post habit_check_ins_path(habit), params: { check_in: { check_on: "" } }
      }.not_to change(CheckIn, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
```

**Auth in request specs:**
```ruby
before do
  post session_path, params: {
    email_address: user.email_address,
    password: "password"
  }
end
```

Follow `.claude/skills/rspec-conventions/SKILL.md` for spec style.

## 7. Agent Behavior Rules

### When User Wants to Learn
- Ask clarifying questions
- Provide a checklist of what to do
- Explain WHY each step matters
- Don't implement; guide them through

### When User Asks to Implement
- Follow this playbook exactly
- Create/edit files without asking permission
- Run migrations
- Run tests at the end
- Remind: `bundle exec rspec spec/` after changes

### Dos
- ✅ Use nested routing for new/create
- ✅ Use `@habit` in controllers
- ✅ Validate presence on both models
- ✅ Write tests before validations
- ✅ Redirect create to `@habit`
- ✅ Use bcrypt + Rails 8 auth generator
- ✅ Keep @habit available in form views

### Don'ts
- ❌ Do not use Devise
- ❌ Do not create a top-level check_ins#index route
- ❌ Do not include :habit_id in strong params
- ❌ Do not leave flat `resources :check_ins` for new/create
- ❌ Do not use `form_with(model: [@habit, @check_in])` without the conditional
- ❌ Do not forget `dependent: :destroy` on Habit.has_many

### After Implementation
Always remind the user to run:
```bash
bundle exec rspec spec/
```

---

## Quick Reference: Paths

| Action | Path Helper | URL Pattern |
|--------|------------|-------------|
| New check-in | `new_habit_check_in_path(habit)` | `/habits/1/check_ins/new` |
| Create check-in | `habit_check_ins_path(habit)` | `POST /habits/1/check_ins` |
| Show check-in | `check_in_path(check_in)` | `/check_ins/1` |
| Edit check-in | `edit_check_in_path(check_in)` | `/check_ins/1/edit` |
| Update check-in | `check_in_path(check_in)` | `PATCH /check_ins/1` |
| Destroy check-in | `check_in_path(check_in)` | `DELETE /check_ins/1` |
| Back to habit | `habit_path(habit)` | `/habits/1` |
