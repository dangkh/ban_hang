class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @products = Product.load_product_by_id params[:search], session[:cart]
    @product_quantity = Array.new
    @products.each do |product|
      @product_quantity.append [product, session[product.id]]
    end
  end

  def create
    @product = Product.find_by id: session_params[:product_id]
    session[:total_price] = 0 if session[:total_price].nil?
    if @product.present?
      quantity = session_params[:quantity].nil? ? 1 : session_params[:quantity].to_i
      if session[:cart].present? && session[:cart].include?(session_params[:product_id])
        flash[:warning] = "That product is exist in your cart"
        redirect_to :back
      else
        if quantity > 0 && quantity <= @product.in_stock
          if session[:cart].present?
            session[:cart] = session[:cart].append session_params[:product_id]
          else
            session[:cart] = [session_params[:product_id]]
          end
          session[session_params[:product_id]] = quantity
          session[:total_price] += @product.price * quantity
          redirect_to :back
        else
          flash[:warning] = t :product_invalid_quantity
          redirect_to :back
        end
      end
    else
      flash[:warning] = t :invalid_product
      redirect_to root_path
    end
  end

  def update
    if params[:status] == Settings.ajax
      @product = Product.find_by id: params[:id]
      respond_to do |format|
        diffirent = (params[:value].to_i - session[params[:id]].to_i) *
          @product.price
        session[:total_price] += diffirent
        session[params[:id]] = params[:value]
        format.json{render json: (Settings.money % diffirent)}
      end
    else
      @product = Product.find_by id: session_params[:product_id]
      session[:total_price] +=
        (session_params[:quantity].to_i - session[@product.id].to_i) * @product.price
      session[session_params[:product_id]] = session_params[:quantity]
      redirect_to :back
    end
  end

  def destroy
    @product = Product.find_by id: params[:id]
    session[:total_price] -= session[@product.id].to_i * @product.price
    session[:cart].reject!{|id| id == params[:id]}
    session[params[:id]] = nil
    session[:total_price] = 0 if session[:total_price].to_i < 0
    redirect_to :back
  end

  private

  def session_params
    params.require(:sessions).permit :product_id, :quantity, :category_id
  end
end
