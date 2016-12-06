
add 'build', {
    "image_name" => "nginx",
    'build_type' => 'chef',

    "base_image" => {
        "name" => "nginx",
        "repository" => "nginx",
        "tag" => "1.10"

    },

}

add 'install', {
    "host" => {
        'script_type' => 'chef_recipe',
        'script' => 'install_host',
    },
    "node" => {
        #'script_type' => 'chef_recipe',
        'script_type' => 'shell',
        #'script' => 'install',
    }


}


add 'docker', {
    #'command' => "/sbin/my_init",
    "command"=> "nginx -g 'daemon off;'",
    #"command"=> "",
    'ports' => [
        [8080,80],
    ],
    'volumes' => [
        ['html', '/usr/share/nginx/html'],
        ['log/nginx', '/var/log/nginx/'],
    ],
    'links' => [
    ]
}



add 'attributes', {
  'nginx' =>{
      "sitename" =>"mysite.local"
  },


}


