=begin
## nginx default server
template "/etc/nginx/conf.d/default.conf" do
  source "nginx-sites/default.conf.erb"

  #owner 'root'
  #group 'root'

  mode '0775'
end
=end



### apps on nginx
node.run_state['apps'] = node['apps']

node['apps'].each do |name, opt|
  node.run_state['app_name'] = name
  node.run_state['app'] = node['apps'][name]

  #include_recipe 'apps-php::install_app'

  template "/etc/nginx/conf.d/#{name}.conf" do
    source "nginx-sites/app.conf.erb"

    variables({
                  :app_name => name,
                  :app => node['apps'][name]
              })


    #owner 'root'
    #group 'root'
    mode '0775'
  end



end



#
bash 'reload nginx' do
  code <<-EOH
service nginx reload
  EOH

  ignore_failure true
end


#command '/etc/init.d/nginx reload'

