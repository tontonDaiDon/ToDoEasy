class ShoppingListsController < ApplicationController
  before_action :set_shopping_list, only: %i[
    show edit update destroy
    before_shopping during_shopping after_shopping update_items
  ]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /shopping_lists or /shopping_lists.json
  def index
    @shopping_lists = current_user.shopping_lists.order(created_at: :desc).page(params[:page])
    if params[:year_month].present?
      year, month = params[:year_month].split('-').map!(&:to_i)
      start_date = Date.new(year, month, 1)
      end_date   = start_date.end_of_month
    
      # shopped_on が範囲に入るもの OR shopped_on が nil で created_at が範囲のもの
      @shopping_lists = @shopping_lists.where(
        "(shopped_on BETWEEN :start AND :end) OR (shopped_on IS NULL AND created_at BETWEEN :start_dt AND :end_dt)",
        start: start_date, end: end_date,
        start_dt: start_date.beginning_of_day, end_dt: end_date.end_of_day
      )
    end
    
    @monthly_budget_total = @shopping_lists.sum(:budget)
    @shopping_lists = @shopping_lists.page(params[:page])
  end 

  # GET /shopping_lists/new
  def new
    @shopping_list = ShoppingList.new
  end

  # GET /shopping_lists/1/edit
  def edit
  end

  def create
    @shopping_list = current_user.shopping_lists.new(shopping_list_params)
  
    if @shopping_list.save
      # 作成後に before_shopping ページへ
      redirect_to before_shopping_shopping_list_path(@shopping_list), notice: '買い物リストを作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shopping_lists/1 or /shopping_lists/1.json
  def update
    if @shopping_list.update(shopping_list_params)
      redirect_to shopping_lists_path, notice: 'リストを更新しました'
    else
      render :edit
    end
  end

  # DELETE /shopping_lists/1 or /shopping_lists/1.json
  def destroy
    @shopping_list = ShoppingList.find(params[:id])
    @shopping_list.destroy
    redirect_to shopping_lists_path, notice: 'リストを削除しました'
  end

  def before_shopping
    @items = @shopping_list.items
    @item = @shopping_list.items.build
  end

  def during_shopping
    @items = @shopping_list.items
    @total = @items.select { |item| item.purchased && item.price.present? }
                   .sum { |item| item.price.to_i * (item.quantity || 1) }
    @budget_diff = @shopping_list.budget - @total

    # 割引計算
    if params[:original_price].present? && params[:discount_rate].present?
      original = params[:original_price].to_i
      rate = params[:discount_rate].to_f
      @discount_result = (original * (1 - rate / 100)).floor
    end
  end

  def after_shopping
    @items = @shopping_list.items
    @total = @items.select { |item| item.purchased && item.price.present? }
                   .sum { |item| item.price.to_i * (item.quantity || 1) }
    @budget_diff = @shopping_list.budget - @total

    @purchase_history = @shopping_list.purchase_histories.last
  end

  def update_items
    params[:items]&.each do |id, item_params|
      item = @shopping_list.items.find(id)
      item.update(
        purchased: item_params[:purchased] == "1",
        price: item_params[:price].presence
      )
    end
    redirect_to during_shopping_shopping_list_path(@shopping_list)
  end

  def show
    redirect_to shopping_lists_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_list
      @shopping_list = current_user.shopping_lists.find(params[:id])
    end    

    def record_not_found
      redirect_to shopping_lists_path, alert: '指定のリストが見つかりません。'
    end

    # Only allow a list of trusted parameters through.
    def shopping_list_params
      params.require(:shopping_list).permit(:name, :budget, :shopped_on)
    end
end

