class ItemPricesController < ApplicationController
  before_action :set_item_price, only: [:show, :edit, :update, :destroy]

  def new
  	@item_price = ItemPrice.new
  end


  def create
  	@item_price = ItemPrice.new(item_price_params)

    if @item_price.save
      respond_to do |format|
        format.html { redirect_to items_path, notice: "Price was added to the system." }
        @item_prices = @item_price.item.item_prices.chronological.paginate(:page => params[:page]).per_page(10)
        format.js
      end
    else
      render action: 'new'
    end
  end

  def destroy
  	@item_price.destroy
    redirect_to items_url, notice: "This price was removed from the system."
  end

  private
  def set_item_price
  	@item_price = ItemPrice.find(params[:id])
  end

  def item_price_params
    params.require(:item_price).permit(:item_id, :price, :start_date, :end_date)
  end
end
