class puppet_sensu::redis {
    package { "redis-server":
        ensure  =>  installed,
    }
}
