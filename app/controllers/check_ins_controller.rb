class CheckInsController < ApplicationController
  before_action :set_habit, only: %i[new create]
  before_action :set_check_in, only: %i[show edit update destroy]

  def show
  end

  def new
    @check_in = @habit.check_ins.new
  end

  def edit
  end

  def create
    @check_in = @habit.check_ins.new(check_in_params)
    if @check_in.save
      redirect_to @habit, notice: "Check in was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @check_in.update(check_in_params)
      redirect_to @check_in, notice: "Check in was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    habit = @check_in.habit
    @check_in.destroy!
    redirect_to habit_path(habit), notice: "Check in was successfully destroyed.", status: :see_other
  end

  private

  def set_habit
    @habit = Habit.find(params[:habit_id])
  end

  def set_check_in
    @check_in = CheckIn.find(params.expect(:id))
  end

  def check_in_params
    params.expect(check_in: [:check_on])
  end
end