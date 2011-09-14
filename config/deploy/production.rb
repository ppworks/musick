# rvm setting
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.2-p290'
set :rvm_type, :system
set :rvm_bin_path, "/usr/local/bin/"
set :rvm_trust_rvmrcs_flag, 1

set :deploy_to, "/shared/www/musick.info"
set :rails_env, :production
role :web, "musick.info"
role :app, "musick.info"
role :db, "musick.info", :primary => true

# unicorn setting
set (:unicorn_config) {"#{current_path}/config/unicorn.rb"}
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

set :repository,  "gitosis@git.ppworks.net:musick.git"
set :scm, :git



set :user, "koshikawa"
ssh_options[:keys] = %w(~/.ssh/sakura_id_rsa)
set :runner, "koshikawa"
set :use_sudo, false

set :bundle_flags, "--quiet"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{try_sudo} BUNDLE_GEMFILE=#{current_path}/Gemfile bundle exec unicorn_rails -c #{unicorn_config} -E #{rails_env} -D"
  end
  
  task :after_symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb"
  end
  
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end
  
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
  
  task :after_update_code do
    run "rvm rvmrc trust #{current_release}"
    run "rvm rvmrc trust #{current_path}"
  end
end
