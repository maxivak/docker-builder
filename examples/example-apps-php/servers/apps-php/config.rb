
add 'build', {
    "image_name" => "apps-php",
    'build_type' => 'chef',

    "base_image" => {
        "name" => "my-nginx-php",
        "repository" => "my-nginx-php",
        "tag" => "latest"

    },

}

add 'install', {
    "host" => {
        'script_type' => 'chef_recipe',
        'script' => 'install_host',
    },
    "node" => {
        'script_type' => 'chef_recipe',
        'script' => 'install',
    }


}


add 'docker', {
    'command' => "/sbin/my_init",
    #"command"=> "",
    'ports' => [
        [8080,80],
    ],
    'volumes' => [
        #['html', '/usr/share/nginx/html'],
        ['html', '/var/www/html'],
        #['app', '/usr/share/nginx/html/app'],
        ['log/nginx', '/var/log/nginx/'],
    ],
    'links' => [
    ]
}



add 'attributes', {
  'nginx' =>{
      "sitename" =>"mysite.local"
  },
  'apps' =>{
      'app1'=>{
          'app_name' => 'app1',
          'app_env' => 'production',
          'app_domain' => 'app1.mmx.gex',
          'app_domain_aliases' => ['app1.mmx.local'],
      },
      'app2'=>{
          'app_name' => 'app2',
          'app_env' => 'production',
          'app_domain' => 'app2.mmx.gex',
          'app_domain_aliases' => ['app2.mmx.local'],
      }
  }


}


