=begin
template '/var/www/html/index.html' do
  source 'index.html.erb'

  #owner 'root'
  #group 'root'
  mode '0775'
end

=end


## nginx default server
template "/etc/nginx/conf.d/default.conf" do
  source "nginx-sites/default.conf.erb"

  mode '0775'
end



# sites
sites = %w[apps phpmyadmin phpredisadmin]

sites.each do |site|
  template "/etc/nginx/conf.d/#{site}.conf" do
    source "nginx-sites/#{site}.conf.erb"

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
