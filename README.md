# README

-> THIS README.MD IS ABOUT A RUBY ON RAILS APP CALLED HABIT_TRACKER. THIS APP TRACKS YOUR HABITS AND LOGS THE DATE SO YOU CAN EASILY CHECK THAT LOG OUT AND WHAT HABBIT IT BELONGS TO. 

-> THE STACK I USED WAS RUBY ON RAILS (ruby 3.4, rails 8.1.1)

-> The MODEL I used were:
1) Habit (A Habit has many check_ins)
2) CheckIn (CheckIn belongs to Habit)
3) User/Session; Associations (User has many sessions)

-> The ROUTES philosphy was i made nested routes because nested routes represend "hiearrarchical relationships" where one object can not exist without iother." It has [nested check_ins, root, auth (session and passwords)]

-> How to run this app:
1) bundle install
2) bin/rails db:migrate
3) bin/rails console 
4) User.create!(email_address: "...", password: "...", password_confirmation: "...") # This wiul create a new user in the db with its attributes
5) bin/rails server # To start the server

-> You can also use RSpec to test this
- Run bundle exec rspec

-> SKILLS.md 
1) .claude/skills/rspec-conventions/SKILL.md
2) .claude/skills/habit_tracker_agent

(I made claude create skills file so that whenever i wanna reuse the whole structure of this project that file alone can do that for me. I also made habit-tracker_agent that will make claude do all the work for me in a single prompt. Dont worry i checked that all the content is fine or not :) )


