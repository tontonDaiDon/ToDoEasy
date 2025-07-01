class ItemsController < ApplicationController
  def create
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
    @item = @shopping_list.items.build(item_params)
    if @item.save
      redirect_to before_shopping_shopping_list_path(@shopping_list), notice: 'アイテムを追加しました。'
    else
      @items = @shopping_list.items
      render 'shopping_lists/before_shopping', status: :unprocessable_entity
    end
  end
    
  def destroy
    @item = Item.find(params[:id])
    @shopping_list = @item.shopping_list
    @item.destroy
    redirect_to shopping_list_path(@shopping_list), notice: 'アイテムを削除しました'
  end

  def edit
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
    @item = @shopping_list.items.find(params[:id])
  end

  def update
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
    @item = @shopping_list.items.find(params[:id])
    if @item.update(item_params)
      redirect_to before_shopping_shopping_list_path(@shopping_list), notice: 'アイテムを更新しました。'
    else
      render :edit, alert: '更新に失敗しました。'
    end
  end

  def new
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
    @item = @shopping_list.items.build
  end

    
  private
    
  def item_params
    params.require(:item).permit(:name, :quantity, :price, :purchased)
  end
end
