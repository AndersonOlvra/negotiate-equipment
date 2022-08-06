class VacationsController < ApplicationController
  before_action :set_vacation, only: %i[ show edit update destroy ]

  def index
    @search = Vacation.reverse_chronologically.ransack(params[:q])

    respond_to do |format|
      format.any(:html, :json) { @vacations = set_page_and_extract_portion_from @search.result }
      format.csv { render csv: @search.result }
    end
  end

  def show
    fresh_when etag: @vacation
  end

  def new
    @vacation = Vacation.new
  end

  def edit
  end

  def create
    @vacation = Vacation.new(vacation_params)
    @vacation.save!

    respond_to do |format|
      format.html { redirect_to @vacation, notice: 'Vacation was successfully created.' }
      format.json { render :show, status: :created }
    end
  end

  def update
    @vacation.update!(vacation_params)
    respond_to do |format|
      format.html { redirect_to @vacation, notice: 'Vacation was successfully updated.' }
      format.json { render :show }
    end
  end

  def destroy
    @vacation.destroy
    respond_to do |format|
      format.html { redirect_to vacations_url, notice: 'Vacation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_vacation
      @vacation = Vacation.find(params[:id])
    end

    def vacation_params
      params.require(:vacation).permit(:start_date, :end_date, :user_id)
    end
end
