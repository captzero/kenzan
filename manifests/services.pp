class puppet_sensu::services {
    service { "rabbitmq-server":
        ensure  =>  running,
        require =>  [Package["rabbitmq-server"],Service["redis-server"]],
    }
    service { "redis-server":
        ensure  =>  running,
        require => Package["redis-server"],
    }
    service { "sensu-server":
        ensure  => running,
        subscribe   => File["/etc/sensu/config.json"],
        require => [Package["sensu"],Service["redis-server"],Service["rabbitmq-server"]],
    }
    service { "sensu-api":
        ensure  =>  running,
        require =>  [Package["sensu"],Service["redis-server"],Service["rabbitmq-server"],Service["sensu-server"]],
    }
}
