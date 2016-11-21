# will be added to Docker image

#
['/var/www/html', 'var/www/temp'].each do |d|
  directory d do
    recursive true
    action :create
  end

end


#



execute 'who' do
  command 'echo $(whoami) > /tmp/1.txt'
end

=begin
#include_recipe 'apt'
execute 'apt-get update' do
  command 'apt-get update'
end

['git'].each do |p|
  apt_package p
end
=end

=begin
# clean
execute 'apt-get clean' do
  command 'apt-get clean'
end

execute 'remove temp' do
  command 'rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*'
end


=end
