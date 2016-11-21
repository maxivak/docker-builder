# install PHP app for Nginx

name = node.run_state['app_name']

# dir
dir_base = "/var/www/html/#{name}"
dir_logs = "/var/www/logs/#{name}"

[dir_base, dir_logs].each do |d|
  directory d do
    recursive true
    action :create
  end

end


# nginx server

template "/etc/nginx/conf.d/#{name}.conf" do
  source "nginx-sites/app.conf.erb"


  #owner 'root'
  #group 'root'
  mode '0775'
end
