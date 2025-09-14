class PurchaseHistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shopping_list, only: [:new, :create, :edit, :update]
  before_action :set_purchase_history, only: [:edit, :update]


  def index
    # 自分の買い物履歴を取得
    @purchase_histories = current_user.purchase_histories.order(purchased_on: :desc).page(params[:page])
  
    # 年月で絞り込み
    if params[:year_month].present?
      year, month = params[:year_month].split('-')
      start_date = Date.new(year.to_i, month.to_i, 1)
      end_date = start_date.end_of_month
      @purchase_histories = @purchase_histories.where(purchased_on: start_date..end_date)
    end
  
    # 月ごとの合計金額
    @monthly_total_price = @purchase_histories.joins(:shopping_list).sum('shopping_lists.budget')
    @purchase_histories = @purchase_histories.page(params[:page])
  end
  


  def new
    @purchase_history = @shopping_list.purchase_histories.build
  end

  def create
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
  end

  def update
    if @purchase_history.update(purchase_history_params)
      redirect_to after_shopping_shopping_list_path(@shopping_list), notice: "履歴を更新しました"
    else
      render :edit, alert: "更新に失敗しました"
    end
  end

  private

  def set_shopping_list
    @shopping_list = current_user.shopping_lists.find(params[:shopping_list_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to shopping_lists_path, alert: "該当する買い物リストが見つかりません"
  end

  def set_purchase_history
    @purchase_history = @shopping_list.purchase_histories.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to purchase_histories_path, alert: "該当する履歴が見つかりません"
  end

  def purchase_history_params
    params.require(:purchase_history).permit(:purchased_on, :place, :note, :total_price, :receipt_image)
  end
end
