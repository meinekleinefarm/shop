# encoding: utf-8
Spree::TaxCategory.class_eval do
  has_many :products, :dependent => :nullify
end
