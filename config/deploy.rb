set :application, "mkf_production"
set :repository,  "git@github.com:meinekleinefarm/shop.git"

set :branch, ENV['BRANCH'] || "master"

set :use_sudo, false

set :scm, :git
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_via, :remote_cache
set :git_shallow_clone, 1

set :default_run_options, :pty => true # or else you'll get "sorry, you must have a tty to run sudo"

set :ssh_options, :keys => [ File.expand_path("~/.ssh/mkf_rsa") ], :forward_agent => true

set :user, 'rails'

after  'deploy:update_code',  'deploy:symlink_configs'

role :web, "144.76.71.176"                          # Your HTTP server, Apache/etc
role :app, "144.76.71.176"                          # This may be the same as your `Web` server
role :db,  "144.76.71.176", :primary => true # This is where Rails migrations will run

set :port, 22022
set :deploy_to, "/var/apps/mkf/production"

set :default_environment, {
  'PATH' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games'
}


# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :unicorn do
  desc "Zero-downtime restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    sudo "/etc/init.d/mkf_production upgrade"
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    sudo "/etc/init.d/mkf_production start"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    sudo "/etc/init.d/mkf_production stop"
  end
  after "deploy:restart", "unicorn:restart"
  after "deploy:start", "unicorn:start"
  after "deploy:stop", "unicorn:stop"
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart do; end

  task :symlink_configs do
    %w(database.yml).each do |file|
      run "ln -nfs #{shared_path}/config/#{file} #{release_path}/config/#{file}"
    end
  end
end


# Precompile assets
load 'deploy/assets'

# have builder check and install gems after each update_code
require 'bundler/capistrano'
set :bundle_without, [:development, :test, :metrics, :deployment]
