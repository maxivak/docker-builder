# my vars
KAFKA_HOSTNAME = '10.1.0.12'

#
common({
    'prefix' => "ex-",
    'image_prefix' => 'ex-',
    'dir_data' => '/disk3/data/ex-kafka-zookeeper/',

})

servers({
    'zookeeper'=>{
        'build' => {
            'build_type' => 'none',
            "image_name" => "", # not used


            "base_image" => {
                #"name" => "wurstmeister/zookeeper",
                #"repository" => "wurstmeister/zookeeper",

                #"name" => "jplock/zookeeper",
                #"repository" => "jplock/zookeeper",

                "name" => "zookeeper",
                "repository" => "zookeeper",
                "tag" => "3.4.9"

            },
        },
        'docker'=> {
            #"command"=> "",
            'ports' => [
                [2181,2181],
            ],
            'volumes' => [
            ],
            'links' => [

            ]
        },
        'attributes' => {
        }

    },
    'kafka'=>{
        'build' => {
            'build_type' => 'Dockerfile',
            "image_name" => "kafka",

            "base_image" => {} # not used
        },
        'docker'=> {
            #"command"=> "",
            'ports' => [
                [9092,9092],
            ],
            'volumes' => [
                ["docker.sock", '/var/run/docker.sock']
            ],
            'links' => [
                ['zookeeper', 'zookeeper']
            ],
            'run_env' =>[
                ['KAFKA_ADVERTISED_HOST_NAME', KAFKA_HOSTNAME],
                ['KAFKA_ADVERTISED_PORT', 9092],
                ['KAFKA_CREATE_TOPICS', "test:1:1"],
                ['KAFKA_ZOOKEEPER_CONNECT', 'zookeeper:2181']
            ]
        },
        'attributes' => {
        }
    },


})




base({

})
