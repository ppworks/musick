# Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3-p385@musick'
set :rvm_type, :user
set :rvm_trust_rvmrcs_flag, 1

set :deploy_to, "/shared/www/musick.info"
set :rails_env, :production
role :web, "musick.info"
role :app, "musick.info"
role :db, "musick.info", :primary => true

# unicorn setting
set (:unicorn_config) {"#{current_path}/config/unicorn.rb"}
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

set :repository,  "gitolite@git.ppworks.net:musick.git"
set :scm, :git
set :deploy_via, :remote_cache

set :user, "koshikawa"
ssh_options[:keys] = %w(~/.ssh/sakura_id_rsa)
set :runner, "koshikawa"
set :use_sudo, false

set :bundle_flags, "--quiet"
set :bundle_dir, ""

after 'deploy:update_code' do
  run "rvm rvmrc trust #{current_release}"
  run "rvm rvmrc trust #{current_path}"
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb"
end
  
namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{try_sudo} BUNDLE_GEMFILE=#{current_path}/Gemfile bundle exec unicorn_rails -c #{unicorn_config} -E #{rails_env} -D"
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
end

# Delayed Job
after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"
