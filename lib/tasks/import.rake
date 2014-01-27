# encoding: utf-8
require 'csv'
require 'html2markdown'

namespace :import do

  desc 'Import pigs from csv'
  task :pigs => :environment do
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


  # id: 1, title: "Mein kleiner neuer Schweine-Shop", path: "mein-kleiner-neuer-schweine-shop", teaser: nil, posted_at: "2013-10-11 11:22:00", body: "Ja, stimmt, in einem Newsletter war davon die Rede,...", author: nil, live: true, created_at: "2013-10-11 11:25:17", updated_at: "2013-10-21 10:51:18", blog_id: 1>
  desc "Import blog posts from csv"
  task :posts => :environment do
    raise "Usage: 'rake import:pigs FILE=datei.csv'" unless file = ENV['FILE']
    blog = Spree::Blog.find_or_create_by_name_and_permalink('Blog', 'news')
    CSV.foreach(file, :encoding => 'UTF-8', :header_converters => :symbol, :headers => true) do |row|
      post = blog.posts.find_or_initialize_by_id(row[:id])
      images = []
      row.each do |k,v|
        if post.respond_to?("#{k}=".to_sym)
          case k
          when :created_at, :updated_at, :posted_at
            begin
              post.send("#{k}=".to_sym, Time.parse(v))
            rescue Exception => e
              STDERR.puts "ERROR PARSING DATE #{k}: #{v} => #{e.message}"
            end
          when :body
            images = check_for_images(v)
            body_text = HTMLPage.new(:contents => v).markdown
            body_text = body_text.gsub(/__MORE__/, '<!-- more -->')
            body_text = body_text.gsub(/#*?\[?!\[\]\(.+?\)(\]\(.+?\))?/,'') # Remove embeded images
            post.send("#{k}=".to_sym, body_text)


          else
            post.send("#{k}=".to_sym, v)
          end
        end
      end

      post.live = true
      post.save!
      post.update_attribute(:path, row[:path])
      images.each do |image|
        asset = post.images.find_or_initialize_by_attachment_file_name(File.basename(image))
        asset.viewable = post
        asset.attachment = File.open(image)
        asset.save!
      end
    end
  end

  def check_for_images(text)
    matches = text.match(/\"\/media\/(.+?)\"/)
    image_names = matches.try(:captures)
    image_files = image_names.reduce([]) do |memo, image_name|
      image_file = Rails.root.join('public', 'media', image_name)
      memo << image_file if File.exists? image_file
      memo
    end unless image_names.nil?
    image_files || []
  end
end