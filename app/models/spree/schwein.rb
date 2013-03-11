module Spree
  class Schwein < ActiveRecord::Base

    paginates_per 24

    attr_accessible :name, :description, :meta_keywords, :meta_description

    has_many :images, :as => :viewable, :order => :position, :dependent => :destroy, :class_name => 'Image'

  end
end