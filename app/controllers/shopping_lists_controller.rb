class ShoppingListsController < ApplicationController
  before_action :set_shopping_list, only: %i[ show edit update destroy ]

  # GET /shopping_lists or /shopping_lists.json
  def index
    @shopping_lists = ShoppingList.all
  end

  # GET /shopping_lists/1 or /shopping_lists/1.json
  def show
    @shopping_list = ShoppingList.find(params[:id])
    @items = @shopping_list.items
    @item = @shopping_list.items.build
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
    respond_to do |format|
      if @shopping_list.update(shopping_list_params)
        format.html { redirect_to @shopping_list, notice: "Shopping list was successfully updated." }
        format.json { render :show, status: :ok, location: @shopping_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shopping_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shopping_lists/1 or /shopping_lists/1.json
  def destroy
    @shopping_list.destroy!

    respond_to do |format|
      format.html { redirect_to shopping_lists_path, status: :see_other, notice: "Shopping list was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def before_shopping
    @shopping_list = ShoppingList.find(params[:id])
    @items = @shopping_list.items
    @item = @shopping_list.items.build
  end

  def during_shopping
    @shopping_list = ShoppingList.find(params[:id])
    @items = @shopping_list.items
  end

  def after_shopping
    @shopping_list = ShoppingList.find(params[:id])
    @items = @shopping_list.items
    # 必要に応じて履歴や集計データも取得
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_list
      @shopping_list = ShoppingList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shopping_list_params
      params.require(:shopping_list).permit(:name, :budget)
    end
end

def update_items
  @shopping_list = ShoppingList.find(params[:id])
  params[:items]&.each do |id, item_params|
    item = @shopping_list.items.find(id)
    item.update(
      purchased: item_params[:purchased] == "1",
      price: item_params[:price].presence
    )
  end
  redirect_to during_shopping_shopping_list_path(@shopping_list)
end