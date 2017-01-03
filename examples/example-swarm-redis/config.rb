common({
    'prefix' => "example-",
    'image_prefix' => 'example-',
    'dir_data' => '/disk3/data/my-examples/',

})

servers({
    'redis'=>{

        'build' => {
            "image_name" => "redis",
            'build_type' => 'none',

            "base_image" => {
                "name" => "redis",
                "repository" => "redis",
                "tag" => "3.2.4"

            },

        },

        'install'=> {
        },

    'docker'=> {
        #"command"=> "",
        'ports' => [
            [6379,80],
        ],
        'volumes' => [
        ],
        'links' => [
        ],

        # network
        #"ip"=>"10.1.0.144",
        #"net"=> "pub_net",

        # for swarm
        "swarm_network"=> "pub_net",
        #"swarm_options" => ""
        "swarm_options" => "--replicas=1 --restart-max-attempts=1"
        #"swarm_options" => "-e constraint:node==mmxpc "
    # --net=pub_net --ip=10.1.0.131

    },

    'attributes'=> {
    }

    }, # / redis


})


base({

})
