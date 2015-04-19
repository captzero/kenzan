class puppet_sensu {
    include puppet_sensu::rabbitmq
    include puppet_sensu::redis
    include puppet_sensu::sensu
    include puppet_sensu::services
}
