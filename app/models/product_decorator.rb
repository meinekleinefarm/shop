# encoding: utf-8
Spree::Product.class_eval do
  def category
    taxons.first.self_and_ancestors.map(&:name).join('/')
  end

  def image_url
    images.first.try(:attachment).try(:url)
  end
end
