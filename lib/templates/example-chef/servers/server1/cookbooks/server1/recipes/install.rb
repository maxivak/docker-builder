
## nginx default server
template "/etc/nginx/conf.d/default.conf" do
  source "nginx-sites/default.conf.erb"

  #owner 'root'
  #group 'root'

  mode '0775'
end


template "/usr/share/nginx/html/index.html" do
  source "index.html.erb"

  #owner 'root'
  #group 'root'

  mode '0775'
end




#
bash 'reload nginx' do
  code <<-EOH
service nginx reload
  EOH

  ignore_failure true
end


#command '/etc/init.d/nginx reload'

