
add 'build', {
    "image_name" => "my5",
    'build_type' => 'chef',

    "base_image" => {
        "name" => "my-base-phusion-1604",
        "repository" => "my-base-phusion-1604",
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
        #[8080,80],
    ],
    'volumes' => [
        #['html', '/var/www/html'],
        #['log/nginx', '/var/log/nginx/'],
    ],
    'links' => [
    ]
}



add 'attributes', {
  'nginx' =>{
      "sitename" =>"mysite.local"
  },


}


