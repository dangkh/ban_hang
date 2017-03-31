class SuggestionsController < ApplicationController
  before_action :check_current_user
  before_action :load_suggestion, except: [:index, :new, :create]

  def index
    @suggestions = current_user.suggest_products.order created_at: :desc
    @suggestions = Kaminari.paginate_array(@suggestions)
      .page(params[:page]).per Settings.order.per_page
  end

  def show
    @category = Category.find_by id: @suggestion.category_id
    if @category.nil?
      flash[:danger] = t :category_not_found
      redirect_to suggestions_url
    end
  end

  def new
    if current_user.suggest_products.size > Settings.suggestion.size
      flash[:danger] = t :over_suggestion
      redirect_to root_url
    else
      products = Product.take_distinct_category
      category_id = Array.new
      products.each{|product| category_id.append product.category_id}
      @categories = Category.load_category_id(category_id)
        .collect{|category| [category.name, category.id]}
    end
  end

  def edit
    products = Product.take_distinct_category
    category_id = Array.new
    products.each{|product| category_id.append product.category_id}
    @categories = Category.load_category_id(category_id)
      .collect{|category| [category.name, category.id]}
  end

  def create
    if current_user.suggest_products.size > Settings.suggestion.size
      flash[:danger] = t :over_suggestion
      redirect_to suggestions_url
    else
      category = Category.find_by id: params[:category][:id]
      if category.nil?
        flash[:warning] = t :category_invalid
        redirect_to :back
      elsif params[:description].length > Settings.suggestion.leng_description
        flash[:warning] = t :too_long
        redirect_to :back
      else
        current_user.suggest_products.create description: params[:description],
          category_id: category.id, status: Settings.suggestion.inital_status
        flash[:success] = t :suggestion_sent
        redirect_to suggestions_url
      end
    end
  end

  def update
    if @suggestion.update_attributes suggest_params
      flash[:success] = t :suggestion_save
    else
      flash[:success] = t :suggestion_error
    end
    redirect_to suggestions_url
  end

  def destroy
    if @suggestion.destroy
      flash[:success] = t :suggestion_delete_complete
    else
      flash[:danger] = t :suggestion_fail_delete
    end
    redirect_to suggestions_url
  end

  private

  def load_suggestion
    @suggestion = SuggestProduct.find_by id: params[:id]
  end

  def check_current_user
    if !current_user.present? || current_user.admin?
      flash[:warning] = t :login_please_as_user
      redirect_to root_url
    end
  end

  def suggest_params
    params.require(:suggest_product).permit :category_id, :description
  end
end
