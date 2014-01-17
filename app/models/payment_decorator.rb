# encoding: utf-8
Spree::Payment.class_eval do
  include ValidationLogger
end
