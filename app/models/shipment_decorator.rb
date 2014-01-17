# encoding: utf-8
Spree::Shipment.class_eval do
  include ValidationLogger
end
