# will be added to Docker image

#
=begin
['/var/www/html', 'var/www/temp'].each do |d|
  directory d do
    recursive true
    action :create
  end

end

=end
