set :repository,  "."

set :scm, :git

set :user, "koshikawa"
ssh_options[:keys] = %w(~/.ssh/sakura_id_rsa)
set :runner, "koshikawa"

set :bundle_flags, "--quiet"

namespace :deploy do
  desc "Asks the user for the tag to deploy"
  task :before_update_code do
  end
  
  desc "symlink for config files and temporary dirs"
  task :after_symlink, :roles => :app do
#    run "ln -nfs /home/#{user}/config/#{application}/database.yml #{release_path}/config/database.yml"
  end
  
  desc "add restart.txt"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end


set :deploy_to, "/tmp/musick.info"
set :rails_env, "production"

role :app, "musick.info"