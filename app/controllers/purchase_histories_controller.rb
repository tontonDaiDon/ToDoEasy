class PurchaseHistoriesController < ApplicationController
  def create
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
    # 既存の履歴を削除
    @shopping_list.purchase_histories.destroy_all

    @purchase_history = @shopping_list.purchase_histories.build(purchase_history_params)
    if @purchase_history.save
      redirect_to purchase_histories_path, notice: '履歴を記録しました'
    else
      render :new
    end
  end

  def edit
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
    @purchase_history = @shopping_list.purchase_histories.find(params[:id])
  end

  def update
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
    @purchase_history = @shopping_list.purchase_histories.find(params[:id])
    if @purchase_history.update(purchase_history_params)
      redirect_to after_shopping_shopping_list_path(@shopping_list), notice: "履歴を更新しました"
    else
      render :edit, alert: "更新に失敗しました"
    end
  end

  def new
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
    @purchase_history = @shopping_list.purchase_histories.build
  end

  def index
    @purchase_histories = PurchaseHistory.order(purchased_on: :asc)
    if params[:year_month].present?
      year, month = params[:year_month].split('-')
      start_date = Date.new(year.to_i, month.to_i, 1)
      end_date = start_date.end_of_month
      @purchase_histories = @purchase_histories.where(purchased_on: start_date..end_date)
    end

    # 月の合計金額を計算
    @monthly_total_price = @purchase_histories.joins(:shopping_list).sum('shopping_lists.budget')
  end

  private

  def purchase_history_params
    params.require(:purchase_history).permit(:purchased_on, :place, :note, :total_price, :receipt_image)
  end
end
