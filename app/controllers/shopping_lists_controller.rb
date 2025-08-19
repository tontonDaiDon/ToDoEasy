class ShoppingListsController < ApplicationController
  before_action :set_shopping_list, only: %i[
    show edit update destroy
    before_shopping during_shopping after_shopping update_items
  ]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /shopping_lists or /shopping_lists.json
  def index
    @shopping_lists = ShoppingList.order(created_at: :desc)
    if params[:year_month].present?
      year, month = params[:year_month].split('-')
      start_date = Date.new(year.to_i, month.to_i, 1)
      end_date = start_date.end_of_month
      @shopping_lists = @shopping_lists.where(shopped_on: start_date..end_date)
    end

    # 月の予算合計を計算
    @monthly_budget_total = @shopping_lists.sum(:budget)
  end

  # GET /shopping_lists/new
  def new
    @shopping_list = ShoppingList.new
  end

  # GET /shopping_lists/1/edit
  def edit
  end

  # POST /shopping_lists or /shopping_lists.json
  def create
    @shopping_list = ShoppingList.new(shopping_list_params)
      if @shopping_list.save
      redirect_to shopping_lists_path, notice: 'リストが正常に作成されました。'
      else
      render :new
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
      @shopping_list = ShoppingList.find(params[:id])
    end

    def record_not_found
      redirect_to shopping_lists_path, alert: '指定のリストが見つかりません。'
    end

    # Only allow a list of trusted parameters through.
    def shopping_list_params
      params.require(:shopping_list).permit(:name, :budget, :shopped_on)
    end
end