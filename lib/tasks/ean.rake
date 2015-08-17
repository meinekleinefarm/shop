require 'barby/barcode/ean_13'
require 'barby/outputter/png_outputter'

namespace :ean do
  namespace :generate do

    task :numbers do
      (1...1000).each do |extension|
        ean = base + extension
        barcode = Barby::EAN13.new(ean.to_s)
        puts barcode.data_with_checksum
      end
    end

    desc 'Generate EAN Barcodes as PNG'
    task :png do
      (1...1000).each do |extension|
        ean = base + extension
        barcode = Barby::EAN13.new(ean.to_s)
        outputter = Barby::PngOutputter.new(barcode)
        dots_per_cm = 600.0 / 2.54
        outputter.xdim = 10
        #outputter.width =  (3.8 * dots_per_cm).to_i # 3,7cm = 437px
        outputter.height = (2.1 * dots_per_cm).to_i # 1,8cm = 213px
        outputter.margin = (0.2 * dots_per_cm).to_i # 83
        puts outputter.width
        puts outputter.full_width
        File.open("#{barcode.data_with_checksum}.png", 'w') do |file|
          file.write outputter.to_png
        end
      end
    end

    task :svg do
      (1...1000).each do |extension|
        ean = base + extension
        barcode = Barby::EAN13.new(ean.to_s)
        outputter = Barby::SvgOutputter.new(barcode)
        outputter.title = barcode.data_with_checksum
        File.open("#{barcode.data_with_checksum}.svg", 'w') do |file|
          file.write outputter.to_svg
        end
      end
    end

    task :pdf do
      (1...1000).each do |extension|
        ean = base + extension
        barcode = Barby::EAN13.new(ean.to_s)
        outputter = Barby::PrawnOutputter.new(barcode)
        File.open("#{barcode.data_with_checksum}.pdf", 'w') do |file|
          file.write outputter.to_pdf
        end
      end
    end
  end

  def base
    426043703000
  end
end