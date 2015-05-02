class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    if user.role? :admin
      can :manage, :all
    
    elsif user.role? :customer
      can :read, Address do |address|  
        address.customer_id == user.customer.id
      end

      can :edit, Address do |address|  
        address.customer_id == user.customer.id
      end

      can :read, Order do |order|
      	order.customer_id == user.customer.id
      end

      can :destroy, Order do |order|
      	order.customer_id == user.customer.id
      end

      can :create, Address 
      can :create, Order
      can :read, Item
      can :read, ItemPrice
      can :read, OrderItem


    elsif user.role? :shipper
      can :read, Address
      can :read, Item
      can :update, OrderItem
      can :update, Order
      can :read, Customer

    elsif user.role? :baker
      can :read, Item
      can :read, OrderItem
      can :read, Order
    
    else
      can :read, :all
    end






  end
end