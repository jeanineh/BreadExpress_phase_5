class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :check_login, only: [:show, :index, :edit, :update, :destroy]
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  #authorize_resource
  
  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    authorize! :index, @active_customers
    authorize! :index, @inactive_customers
  end

  def show
    @previous_orders = @customer.orders.chronological
    @customer_addresses = @customer.addresses
    authorize! :show, @customer
  end

  def new
    if logged_in? && current_user.role?(:admin)
      @customer = Customer.new
      @customer.user = User.new
    elsif logged_in?
      redirect_to home_path, notice: "Please log out to create a new account."
    else
      @customer = Customer.new
      @customer.user = User.new
    end
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
    # should have a user associated with customer, but just in case...
    @customer.user = current_user
    authorize! :edit, @customer
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      if logged_in?
        redirect_to @customer, notice: "#{@customer.proper_name} was added to the system."
      else 
        redirect_to login_path, notice: "Signed up successfully! Please log in to start ordering."
      end
    else
      @customer.user = User.new
      render action: 'new'
    end
  end

  def update
    # just in case customer trying to hack the http request...
   # reset_username_param unless current_user.role? :admin
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    #reset_role_param unless current_user.role? :admin
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, user_attributes: [:id, :username, :password, :password_confirmation, :role, :active])
  end

  def reset_role_param
    params[:customer][:user_attributes][:role] = "customer"
  end

  def reset_username_param
    params[:customer][:user_attributes][:username] = @customer.user.username
  end
end