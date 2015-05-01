class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
    if logged_in? && current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    end
   
  end

  def about
  end

  def privacy
  end

  def contact
  end






end