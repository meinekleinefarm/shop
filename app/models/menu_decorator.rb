# encoding: utf-8
Spree::Menu.class_eval do
  def attachment_sizes
    hash = {}
    hash.merge!(:mini => '48x48>', :greyscale => {:processors => [:grayscale]}) if image_content?
    hash.merge!(:logo_color => '128x128#', :logo_grey => {:geometry => '128x128>', :processors => [:thumbnail,:grayscale]}) if parent_id.nil?
    hash.merge!(:sidebar => '166x250>') if image_content?
    hash
  end
end
