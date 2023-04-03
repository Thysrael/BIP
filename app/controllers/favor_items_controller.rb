class FavorItemsController < ApplicationController
  include CurrentCart
  before_action :set_favor_item, only: %i[ show edit update destroy ]
  before_action :set_user, only: [:create]
  before_action :set_cart
  # GET /favor_items or /favor_items.json
  def index
    @favor_items = FavorItem.all
  end

  # GET /favor_items/1 or /favor_items/1.json
  def show
  end

  # GET /favor_items/new
  def new
    @favor_item = FavorItem.new
  end

  # GET /favor_items/1/edit
  def edit
  end

  # POST /favor_items or /favor_items.json
  def create
    # 根据传入的 product_id 查找 product
    product = Product.find(params[:product_id])
    @favor_item = @user.add_product(product)

    respond_to do |format|
      if @favor_item.save
        format.html { redirect_to store_index_url }
        format.json { render :show, status: :created, location: @favor_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @favor_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /favor_items/1 or /favor_items/1.json
  def update
    respond_to do |format|
      if @favor_item.update(favor_item_params)
        format.html { redirect_to favor_item_url(@favor_item), notice: "Favor item was successfully updated." }
        format.json { render :show, status: :ok, location: @favor_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @favor_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favor_items/1 or /favor_items/1.json
  def destroy
    @favor_item.destroy

    respond_to do |format|
      format.html { redirect_to favor_items_url, notice: "Favor item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favor_item
      @favor_item = FavorItem.find(params[:id])
    end

    def set_user
      @user = User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to store_index_url
    end
    # Only allow a list of trusted parameters through.
    def favor_item_params
      params.require(:favor_item).permit(:product_id, :user_id)
    end
end
