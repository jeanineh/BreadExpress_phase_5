class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
    if logged_in? && current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    end

    if logged_in? && current_user.role?(:shipper) || logged_in? && current_user.role?(:admin)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
    end

    if logged_in? && current_user.role?(:baker)
      @breads_list = create_baking_list_for('bread')
      @muffins_list = create_baking_list_for('muffins')
      @pastries_list = create_baking_list_for('pastries')
    end
   
  end


  def mark_shipped
    @order_item = OrderItem.find(params[:id])
    @order_item.shipped_on = Date.today
    @order_item.save!
    @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
  end

  def mark_unshipped
    @order_item = OrderItem.find(params[:id])
    @order_item.shipped_on = nil
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