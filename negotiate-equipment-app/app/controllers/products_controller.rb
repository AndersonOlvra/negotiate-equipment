class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @search = Product.reverse_chronologically.ransack(params[:q])

    respond_to do |format|
      format.any(:html, :json) { @products = set_page_and_extract_portion_from @search.result }
      format.csv { render csv: @search.result }
    end
  end

  def show
    fresh_when etag: @product
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    @product.save!

    respond_to do |format|
      format.html { redirect_to @product, notice: 'Product was successfully created.' }
      format.json { render :show, status: :created }
    end
  end

  def update
    @product.update!(product_params)
    respond_to do |format|
      format.html { redirect_to @product, notice: 'Product was successfully updated.' }
      format.json { render :show }
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :user_id)
    end
end
