class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  
  def index
  	@all_items = Item.alphabetical.paginate(:page => params[:page]).per_page(9)
  	@inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(9)
  	@active_items = Item.active.alphabetical.paginate(:page => params[:page]).per_page(9)
  end

  def show
    @item_prices = @item.item_prices.chronological.paginate(:page => params[:page]).per_page(5)
  end

  def breads
    @breads = Item.for_category("bread").alphabetical.paginate(:page => params[:page]).per_page(9)
  end

  def muffins
    @muffins = Item.for_category("muffins").alphabetical.paginate(:page => params[:page]).per_page(9)
  end

  def pastries
    @pastries = Item.for_category("pastries").alphabetical.paginate(:page => params[:page]).per_page(9)
  end

  def new
    @item = Item.new
  end

  def create
  	@item = Item.new(item_params)

    if @item.save
      redirect_to @item, notice: "Item was successfully added to the system."
    else
      render action: 'new'
    end
  end

  def update
  	if @item.update(item_params)
      redirect_to @item, notice: "Your item was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
  	@item.destroy
    redirect_to items_url, notice: "This item was removed from the system."
  end

  private
  def set_item
  	@item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active)
  end
end
