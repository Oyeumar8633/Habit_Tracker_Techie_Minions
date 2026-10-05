class CheckInsController < ApplicationController
  before_action :set_check_in, only: %i[ show edit update destroy ]

  # GET /check_ins/1 or /check_ins/1.json
  def show
  end

  # GET /check_ins/new
  def new
    @habit = Habit.find(params[:habit_id])
    @check_in = @habit.check_ins.new
  end

  # GET /check_ins/1/edit
  def edit
  end

  # POST /check_ins or /check_ins.json
  def create
    @habit = Habit.find(params[:habit_id])
    @check_in = @habit.check_ins.new(check_in_params)

    if @check_in.save
      redirect_to @habit, notice: "Check in was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /check_ins/1 or /check_ins/1.json
  def update
    respond_to do |format|
      if @check_in.update(check_in_params)
        format.html { redirect_to @check_in, notice: "Check in was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @check_in }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @check_in.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /check_ins/1 or /check_ins/1.json
  def destroy
    habit = @check_in.habit
    @check_in.destroy!

    respond_to do |format|
      format.html { redirect_to habit_path(habit), notice: "Check in was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_in
      @check_in = CheckIn.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def check_in_params
      params.expect(check_in: [ :check_on])
    end
end
