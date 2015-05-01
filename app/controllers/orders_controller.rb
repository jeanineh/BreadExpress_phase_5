class OrdersController < ApplicationController
  include BreadExpressHelpers::Cart

  #before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy]
 # authorize_resource
  
  def index
    if logged_in? && !current_user.role?(:customer)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(5)
    else
      @pending_orders = current_user.customer.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(5)
    end 
  end

  def show
    @order_items = @order.order_items.to_a
    if current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    else
      @previous_orders = @order.customer.orders.chronological.to_a
    end
  end

  def new

  end

  def create
    @order = Order.new(order_params)

    if @order.save

      redirect_to @order, notice: "Thank you for ordering from Bread Express."
    else
      render action: 'new'
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: "Your order was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: "This order was removed from the system."
  end

  #other pages
  def breads
    @breads = Item.for_category("bread").alphabetical.paginate(:page => params[:page]).per_page(9)
  end

  def muffins
    @muffins = Item.for_category("muffins").alphabetical.paginate(:page => params[:page]).per_page(9)
  end

  def pastries
    @pastries = Item.for_category("pastries").alphabetical.paginate(:page => params[:page]).per_page(9)
  end

  def menu
  end

  #cart
  def add_to_cart
    redirect_to menu_path, notice: "Item was added successfully to your cart."
  end

  def cart
    @all_cart_items = get_list_of_items_in_cart
  end 

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id)
  end







end