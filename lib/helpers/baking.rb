module BreadExpressHelpers
  module Baking
    def create_baking_list_for(category)
      # returns a hash of item name and quantity to be baked for a 
      # particular category of items like bread, muffins, etc.
      all_items = Item.for_category(category).alphabetical.map(&:id)
      baking_list = Hash[all_items.map{|id| [id, 0]}]
      unshipped_items = OrderItem.unshipped.map{|oi| [oi.item.id, oi.quantity] if all_items.include?(oi.item.id)}.compact!
      unshipped_items.each{|id, quant| baking_list[id] += quant} unless unshipped_items.nil?
      baking_list.delete_if{|key, value| value == 0}
      return baking_list
    end
  end  
end