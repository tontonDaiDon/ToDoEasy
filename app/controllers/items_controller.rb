class ItemsController < ApplicationController
  def create
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
    @item = @shopping_list.items.build(item_params)
    if @item.save
      redirect_to shopping_list_path(@shopping_list), notice: 'アイテムを追加しました'
    else
      redirect_to shopping_list_path(@shopping_list), alert: '追加に失敗しました'
      end
    end
    
    def destroy
      @item = Item.find(params[:id])
      @shopping_list = @item.shopping_list
      @item.destroy
      redirect_to shopping_list_path(@shopping_list), notice: 'アイテムを削除しました'
    end

    
  private
    
  def item_params
    params.require(:item).permit(:name, :price, :quantity)
  end
end
