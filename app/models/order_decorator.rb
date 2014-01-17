# encoding: utf-8
Spree::Order.class_eval do
  include ValidationLogger
end
