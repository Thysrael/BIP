class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: %i[ show edit update destroy ]
  skip_before_action :authorize

  # GET /line_items or /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1 or /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items or /line_items.json
  def create
    # 根据传入的 product_id 查找 product
    product = Product.find(params[:product_id])
    # build 方法与 new 方法类似，会创建一个与 @cart 和 product 都相关的 @line_item
    @line_item = @cart.add_product(product)

    # respond_to 是一个方法，其参数为一个 block
    # 我现在的理解是 respond_to 描述的是服务器对于客户端的反应，或者说，这是浏览器上将执行的步骤
    # 这里就是先对于 html 进行一个重定向操作，然后调用 js，最后 json
    respond_to do |format|
      if @line_item.save
        # 跳转的对象不再是 @line_item，而是 store 页面
        format.html { redirect_to store_index_url }
        # 调用 js 脚本
        format.js { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to line_item_url(@line_item), notice: "Line item was successfully updated." }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to line_items_url, notice: "Line item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :cart_id)
    end
end
