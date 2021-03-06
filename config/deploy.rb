set :application, 'mkf'
set :repo_url, 'git@github.com:meinekleinefarm/shop.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
set :scm, :git

set :format, :pretty
set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml config/memcached.yml config/airbrake.yml config/application.yml }
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/spree public/assets }

# rbenv settings
set :rbenv_type, :system # :user or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.5'
set :rbenv_custom_path, '/opt/rbenv'

# bundler settings
set :bundle_jobs, 4
# This translates to NOKOGIRI_USE_SYSTEM_LIBRARIES=1 when executed
set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
