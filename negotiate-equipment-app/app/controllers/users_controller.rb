class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @search = User.reverse_chronologically.ransack(params[:q])

    respond_to do |format|
      format.any(:html, :json) { @users = set_page_and_extract_portion_from @search.result }
      format.csv { render csv: @search.result }
    end
  end

  def show
    @search = Product.reverse_chronologically.ransack(params[:q])

    fresh_when etag: @user
  end

  def new
    @user = User.new
  end

  def edit
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

    def user_params
      params.require(:user).permit(:name, :nickname, :email, :birthdate, :country)
    end
end
