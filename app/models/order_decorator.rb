# encoding: utf-8
Spree::Order.class_eval do
  include ValidationLogger

  def total_discount
    adjustments.map(&:amount).select{|amount| amount < 0 }.reduce(:+).to_f
  end

  def cleanup
    state_changes.delete_all
    shipments.each do |shipment|
      shipment.inventory_units.delete_all
      shipment.adjustment.delete
      shipment.delete
    end
    payments.delete_all
    bill_address.delete if bill_address && !bill_address_still_in_use?
    ship_address.delete if ship_address && !ship_address_still_in_use?
    line_items.delete_all
  end

  def bill_address_still_in_use?
    Spree::Order.where("id <> ?", self.id).where(bill_address_id: self.bill_address_id).exists?
  end

  def ship_address_still_in_use?
    Spree::Order.where("id <> ?", self.id).where(ship_address_id: self.ship_address_id).exists? ||
    Spree::Shipment.where(address_id: self.ship_address_id).exists?
  end
end
