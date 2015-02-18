node default {

  class { 'ruby::gem::bundler': }
  ->

  exec { 'install bundler dependencies':
    command => '/usr/local/bin/bundle install',
    cwd     => '/vagrant',
  }

}
