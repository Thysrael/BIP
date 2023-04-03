module CurrentCart

  private
    # 用 session 中的 cart_id 去查找 cart，如果没有找到，就创建一个新的 cart，并在 session 中存储 cart_id
    def set_cart
      @cart = Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
end
