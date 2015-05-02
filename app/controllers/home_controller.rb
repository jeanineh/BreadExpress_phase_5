class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
    if logged_in? && current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    end

    if logged_in? && current_user.role?(:shipper)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
    end
   
  end


  def mark_shipped
    @order_item = OrderItem.find(params[:id])
    if @order_item.shipped_on == nil
      @order_item.shipped_on = Date.today
    else
      @order_item.shipped_on = nil
    end
    @order_item.save!
    @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
  end

  def mark_unshipped
    @order_item = OrderItem.find(params[:id])
    if @order_item.shipped_on == nil
      @order_item.shipped_on = Date.today
    else
      @order_item.shipped_on = nil
    end
    @order_item.save!
    @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
  end


  def about
  end

  def privacy
  end

  def contact
  end






end