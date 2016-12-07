puts "cookbooks from server: #{cookbook_path}"

cookbook_path cookbook_path+[
    '/work/chef-repo/cookbooks-common',
    '/work/chef-repo/cookbooks',
]
