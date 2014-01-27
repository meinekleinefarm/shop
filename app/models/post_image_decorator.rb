# encoding: utf-8
Spree::PostImage.class_eval do
  def attachment_sizes
    hash = {}
    hash.merge!( :mini => '100x100>', :small => '420x420#', :medium => '460x345#', :large => '700x700>' ) if image_content?
    hash
  end
end
