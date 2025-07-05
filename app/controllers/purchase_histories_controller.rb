class PurchaseHistoriesController < ApplicationController
  def create
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
    @purchase_history = @shopping_list.purchase_histories.build(purchase_history_params)
    if @purchase_history.save
      redirect_to after_shopping_shopping_list_path(@shopping_list), notice: "履歴を保存しました"
    else
      render :new, status: :unprocessable_entity
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
    @purchase_histories = PurchaseHistory.all.order(purchased_on: :desc)
  end

  private

  def purchase_history_params
    params.require(:purchase_history).permit(:purchased_on, :place, :note, :total_price, :receipt_image)
  end
end
