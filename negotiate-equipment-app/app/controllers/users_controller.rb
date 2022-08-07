class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :set_user_and_chosen_user, :set_users_products, only: %i[ choose_equipment change_equipment ]

  def index
    @search = User.reverse_chronologically.ransack(params[:q])

    respond_to do |format|
      format.any(:html, :json) { @users = set_page_and_extract_portion_from @search.result }
      format.csv { render csv: @search.result }
    end
  end

  def show
    @users = User.where.not(id: @user.id)
    
    @search = Product.reverse_chronologically.ransack(params[:q])

    fresh_when etag: @user
  end

  def new
    @user = User.new
  end

  def edit
  end

  def choose_equipment
    @search = Product.reverse_chronologically.ransack(params[:q])
    fresh_when etag: @user
  end

  def change_equipment
    return redirect_to user_choose_equipment_path(@user, chosen_user: @chosen_user),
      flash: { 
        error: "The sum of the equipments values must be equal!" 
      } unless check_equipment_price

    @user_equipment.update(user: @chosen_user)
    @chosen_user_equipment.update(user: @user)

    redirect_to user_choose_equipment_path(@user, chosen_user: @chosen_user), notice: 'Equipments successfully changed.'
  end

  def create
    @user = User.new(user_params)
    @user.save!

    respond_to do |format|
      format.html { redirect_to @user, notice: 'User was successfully created.' }
      format.json { render :show, status: :created }
    end
  end

  def update
    @user.update!(user_params)
    respond_to do |format|
      format.html { redirect_to @user, notice: 'User was successfully updated.' }
      format.json { render :show }
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def set_user_and_chosen_user
      @user = User.find(params[:user_id])
      @chosen_user = User.find(params[:chosen_user])
    end

    def set_users_products
      @user_equipment = Product.where(id: params[:user_equipment].keys) if params[:user_equipment].present?
      @chosen_user_equipment = Product.where(id: params[:chosen_user_equipment].keys) if params[:chosen_user_equipment].present?
    end

    def check_equipment_price
      @user_equipment.sum(:price) == @chosen_user_equipment.sum(:price)
    end

    def user_params
      params.require(:user).permit(:name, :nickname, :email, :birthdate, :country)
    end
end
