class puppet_sensu::sensu ($sensu_role="") {
   #Need to know what kind of sensu this is right off the bat, can't wait for a second puppet run which is what would happen if we distributed a fact with this module.
    file { "sensu_role.rb" :
        path    =>  "/usr/lib/ruby/vendor_ruby/facter/sensu_role.rb",
        ensure  =>  present,
        content  =>  template("puppet_sensu/sensu_role.erb"),
    }
    file { "sensu.list" :
        path    => "/etc/apt/sources.list.d/sensu.list",
        ensure  =>  present,
        source  =>  "puppet:///modules/puppet_sensu/sensu.list",
        notify  => Exec["sensu_gpg"]
    }
    exec { "sensu_gpg":
        command =>  "/usr/bin/wget http://repos.sensuapp.org/apt/pubkey.gpg -O /tmp/pubkey.gpg; apt-key add /tmp/pubkey.gpg",
        refreshonly => true,
    }
    package { "sensu":
        ensure  =>  installed,
        require =>  Exec["sensu_gpg"],
    }
    file { "/etc/sensu/config.json":
        ensure  =>  present,
        source  =>  "puppet:///modules/puppet_sensu/config.json",
    }
    file { "/etc/sensu/conf.d/check_memory.json":
        ensure  =>  present,
        owner   =>  "sensu",
        group   =>  "sensu",
        content =>  template("puppet_sensu/check_memory.erb"),
        require =>  Package["sensu"],
    }
    file { "/etc/sensu/conf.d/default_handler.json":
        ensure  =>  present,
        owner   =>  "sensu",
        group   =>  "sensu",
        content =>  template("puppet_sensu/default_handler.erb"),
        require =>  Package["sensu"],
    }
}
