# encoding: utf-8
require 'csv'

namespace :pigs do

  desc 'Import pigs from csv'
  task :import => :environment do
    raise "Usage: 'rake import:verpflegung CSV=datei.csv'" unless file = ENV['FILE']
    CSV.foreach(file, :header_converters => :symbol, :headers => true, :encoding => 'UTF-8') do |row|
      pig = Spree::Schwein.find_or_initialize_by_permalink(row[:permalink])
      row.each do |k,v|
        pig.send("#{k}=".to_sym, v)
        case k
        when :created_at, :updated_at, :date_of_death, :date_of_birth
          pig.send("#{k}=".to_sym, Time.parse(v))
        end
      end
      pig.save!
    end
  end
end