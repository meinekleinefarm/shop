# encoding: utf-8
Spree::Order.class_eval do
  include ValidationLogger

  def total_discount
    adjustments.map(&:amount).select{|amount| amount < 0 }.reduce(:+).to_f
  end
end
