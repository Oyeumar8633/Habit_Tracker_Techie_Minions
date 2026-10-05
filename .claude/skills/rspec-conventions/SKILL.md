---
name: rspec-conventions
description: How this project writes RSpec specs. Use whenever creating or editing files under spec/, or when asked to write tests for a model, request, or feature in this Rails app.
---

# RSpec conventions for this project

- Model specs go in `spec/models`, request specs in `spec/requests`.
- Use `describe` for the class/resource, `it` descriptions as full sentences.
- Prefer request specs over controller specs for HTTP behavior.
- Use `let` for test data; avoid instance variables in specs.
- For create actions, assert both the HTTP response and the database change (`change(...).by(1)`).
- Nested creates use parent path helpers (e.g. `habit_check_ins_path(habit)`).
- When auth is required, sign in in a `before` block with `post session_path`.
- Write the failing example first for new validations, then add the model validation.
