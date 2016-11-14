require "bundler/gem_tasks"
#task :default => :spec

# global
SERVERS =  %w(redis mysql elasticsearch phpmyadmin phpredisadmin apps-ruby nginx-front )


#
require_relative 'lib/docker_builder/server_settings'
require_relative 'lib/docker_builder/manager'



#
desc "Build image"
task :build, [:name] do |task, args|
  #name = args[:name]
  Manager.build_image(name)
  #sh "sh build_#{name}.sh"
end

desc "Destroy image"
task :destroy_image, [:name] do |task, args|
  name = args[:name]
  Manager.destroy_image(name)
end


desc "Rebuild image. Destroy image and build again."
task :rebuild, [:name] do |task, args|
  s = args[:name]
  Rake::Task[:destroy_image].invoke(s)
  Rake::Task[:build].invoke(s)
end




desc "Run container"
task :run, [:name] do |task, args|
  name = args[:name]
  Manager.run_container(name)
end


desc "Start container"
task :start, [:name] do |task, args|
  name = args[:name]
  Manager.start_container(name)
end

desc "Restart container"
task :restart, [:name] do |task, args|
  puts "restart #{args[:name]}"
  name = 'my-'+args[:name]
  sh "docker restart #{name}"
end


desc "Destroy container"
task :destroy, [:name] do |task, args|
  Manager.destroy_container(args[:name])
end

=begin
desc "Destroy container with Chef"
task :destroy_chef, [:name] do |task, args|
  name = "my-"+args[:name]
  sh "cd server-#{args[:name]} && chef-client -z -j config/config.json destroy.rb" rescue nil

  sh "docker rm -f #{name}" rescue nil
  sh "docker rm -f chef-converge.#{name}" rescue nil
end
=end


desc "Remove and run container"
task :rerun, [:name] do |task, args|
  s = args[:name]
  Rake::Task[:destroy].invoke(s)
  Rake::Task[:run].invoke(s)
end


desc "Rebuild image and rerun container"
task :rerun_rebuild, [:name] do |task, args|
  s = args[:name]
  #
  Rake::Task[:destroy].invoke(s)
  Rake::Task[:destroy_image].invoke(s)

  #
  Rake::Task[:build].invoke(s)
  Rake::Task[:run].invoke(s)
end

# Build all
desc "Build all images"
task :build_all do |task, args|
  SERVERS.each do |s|
    Rake::Task["build"].invoke(s)
  end
end




desc 'Run all'
task :run_all do |task, args|
  SERVERS.each do |s|
    Rake::Task["run"].invoke(s)
  end

end


desc 'Start all'
task :start_all do
  SERVERS.each do |s|
    puts "task start #{s}"
    Rake::Task[:start].invoke(s)
    Rake::Task[:start].reenable
  end
end


desc 'Restart all'
task :restart_all do
  SERVERS.each do |s|
    Rake::Task[:restart].invoke(s)
    Rake::Task[:restart].reenable
  end
end


desc 'Exec task, run_test[name,recipe_name]'
task :exec, [:name, :recipe_name] do |task, args|
  Manager.exec_task(args[:name], args[:recipe_name])

end
