class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
    @previous_orders = current_user.customer.orders.chronological.to_a
   
  end

  def about
  end

  def privacy
  end

  def contact
  end






end