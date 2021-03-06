class ItemPricesController < ApplicationController
  before_action :set_item_price, only: [:show, :edit, :update, :destroy]

  def new
  	@item_price = ItemPrice.new
    authorize! :create, @item_price
  end


  def create
  	@item_price = ItemPrice.new(item_price_params)
    @item = @item_price.item
    authorize! :create, @item_price
    if @item_price.save
      respond_to do |format|
        format.html { redirect_to items_path, notice: "Price was added to the system." }
        @item_prices = @item_price.item.item_prices.chronological.paginate(:page => params[:page]).per_page(5)
        #@item = @item_price.item
        format.js 
      end
    else
      render action: 'new'
    end
  end

  private
  def set_item_price
  	@item_price = ItemPrice.find(params[:id])
  end

  def item_price_params
    params.require(:item_price).permit(:item_id, :price, :start_date, :end_date)
  end
end
