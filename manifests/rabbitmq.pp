class puppet_sensu::rabbitmq {
    package { "wget": 
        ensure  =>  present,
        notify  =>  [Exec["rabbit_key"],Exec["add_key"],Exec["sensu_gpg"]],
    }
    exec { "rabbit_key":
        command =>  "/usr/bin/wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc -O /tmp/rabbitpublic.asc",
        refreshonly =>  true,
        notify  => Exec["add_key"],
    }
    exec { "add_key":
        command =>  "/usr/bin/apt-key add /tmp/rabbitpublic.asc; apt-get update",
        refreshonly =>  true,
        require => Package["wget"],
    }
    file { "rabbitmq.list":
        ensure  =>  present,
        source  =>  "puppet:///modules/puppet_sensu/rabbitmq.list",
        path    =>  "/etc/apt/sources.list.d/rabbitmq.list",
    }
    package { "erlang-nox":
        ensure  =>  installed,
        require =>  File["rabbitmq.list"],
    }   
    package { "rabbitmq-server":
        ensure  =>  installed,
        require =>  Package["erlang-nox"],
        notify  =>  [Exec["add_vhost"],Exec["add_user"],Exec["set_permissions"]],
    }
    exec { "add_vhost":
        command =>  "/usr/sbin/rabbitmqctl add_vhost /sensu",
        notify  =>  Exec["add_user"],
        refreshonly =>  true,
    }
    exec { "add_user":
        command =>  "/usr/sbin/rabbitmqctl add_user sensu secret",
        notify  => Exec["set_permissions"],
        refreshonly =>  true,
    }
    exec { "set_permissions":
        command => "/usr/sbin/rabbitmqctl set_permissions -p /sensu sensu \".*\" \".*\" \".*\"",
        refreshonly =>  true,
    }
}
